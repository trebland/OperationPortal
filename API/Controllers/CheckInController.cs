using AspNet.Security.OpenIdConnect.Extensions;
using AspNet.Security.OpenIdConnect.Primitives;
using AspNet.Security.OpenIdConnect.Server;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using OpenIddict.Validation;
using System.Collections.Generic;
using System.Threading.Tasks;
using OpenIddict.Abstractions;
using OpenIddict.Core;
using OpenIddict.EntityFrameworkCore.Models;
using API.Models;
using API.Data;
using Microsoft.Extensions.Options;
using System;
using API.Helpers;

namespace API.Controllers
{
    [Authorize(AuthenticationSchemes = OpenIddictValidationDefaults.AuthenticationScheme)]
    [ApiController]
    [Route("api/check-in/[action]")]
    public class CheckInController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly RoleManager<IdentityRole> roleManager;
        private readonly ConfigurationModel configModel;

        public CheckInController(
            OpenIddictApplicationManager<OpenIddictApplication> applicationManager,
            SignInManager<ApplicationUser> signInManager,
            UserManager<ApplicationUser> userManager,
            RoleManager<IdentityRole> roleManager,
            IOptions<ConfigurationModel> configModel)
        {
            this.applicationManager = applicationManager;
            this.signInManager = signInManager;
            this.userManager = userManager;
            this.roleManager = roleManager;
            this.configModel = configModel.Value;
        }

        [Route("~/api/check-in/child")]
        [HttpPost]
        public async Task<IActionResult> CheckInChild(IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
                !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
                await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
                await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            ChildRepository childRepo = new ChildRepository(configModel.ConnectionString);
            if (childRepo.IsSuspended(model.Id))
            {
                return new JsonResult(new
                {
                    Error = "Child is suspended."
                });
            }

            try
            {
                CheckInRepository repo = new CheckInRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    NumVisits = repo.CheckInChild(model.Id)
                });
            }
            catch (Exception exc)
            {
                return new JsonResult(new
                {
                    Error = exc.Message,
                });
            }
        }

        [Route("~/api/check-in/volunteer")]
        [HttpPost]
        public async Task<IActionResult> CheckInVolunteer(IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
                !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("volunteer id");
            }

            try
            {
                CheckInRepository repo = new CheckInRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    NumVisits = repo.CheckInVolunteer(model.Id)
                });
            }
            catch (Exception exc)
            {
                return new JsonResult(new
                {
                    Error = exc.Message,
                });
            }
        }

        [Route("~/api/check-in/bus-driver")]
        [HttpPost]
        public async Task<IActionResult> CheckInBusDriver(DriverCheckInModel model)
        {
            var user = await userManager.GetUserAsync(User);
            CheckInRepository repo = new CheckInRepository(configModel.ConnectionString);
            VolunteerRepository volRepo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel profile;

            if (user == null ||
                !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("bus driver id");
            }

            if (model.Date == DateTime.MinValue)
            {
                return Utilities.GenerateMissingInputMessage("date");
            }

            if (model.Date.DayOfWeek != DayOfWeek.Saturday)
            {
                return Utilities.ErrorJson("Drivers can only be checked in for Saturdays");
            }

            if (DateTime.Today.Date.AddDays(7) < model.Date)
            {
                return Utilities.ErrorJson("Date is too far in the future.  Bus drivers can only be checked in for the next Saturday");
            }

            try
            {
                profile = volRepo.GetVolunteer(model.Id);

                if (profile == null || profile.Role != UserHelpers.UserRoles.BusDriver.ToString())
                {
                    return Utilities.ErrorJson("Not a valid bus driver");
                }

                repo.CheckInBusDriver(model.Id, model.Date);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();

        }

        [Route("~/api/check-in/bus-driver-cancel")]
        [HttpPost]
        public async Task<IActionResult> CancelBusDriver(DriverCheckInModel model)
        {
            var user = await userManager.GetUserAsync(User);
            CheckInRepository repo = new CheckInRepository(configModel.ConnectionString);
            CalendarRepository calRepo = new CalendarRepository(configModel.ConnectionString);
            AttendanceModel attendance;
            VolunteerRepository volRepo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel profile;

            if (user == null ||
                !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("bus driver id");
            }

            if (model.Date == DateTime.MinValue)
            {
                return Utilities.GenerateMissingInputMessage("date");
            }

            if (model.Date.DayOfWeek != DayOfWeek.Saturday)
            {
                return Utilities.ErrorJson("Drivers can only be checked in for Saturdays");
            }

            if (DateTime.Today.Date > model.Date)
            {
                return Utilities.ErrorJson("Can not cancel check in in the past");
            }

            try
            {
                profile = volRepo.GetVolunteer(model.Id);

                if (profile == null || profile.Role != UserHelpers.UserRoles.BusDriver.ToString())
                {
                    return Utilities.ErrorJson("Not a valid bus driver");
                }

                attendance = calRepo.GetSingleAttendance(model.Id, model.Date);

                if (attendance == null || !attendance.Attended)
                {
                    return Utilities.ErrorJson("Not currently checked in");
                }

                repo.CancelBusDriver(model.Id, model.Date);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();

        }
    }
}