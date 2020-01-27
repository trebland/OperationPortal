using AspNet.Security.OpenIdConnect.Extensions;
using AspNet.Security.OpenIdConnect.Primitives;
using AspNet.Security.OpenIdConnect.Server;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using OpenIddict.Validation;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using OpenIddict.Abstractions;
using OpenIddict.Core;
using OpenIddict.EntityFrameworkCore.Models;
using API.Models;
using API.Data;
using API.Helpers;

namespace API.Controllers
{
    [Authorize(AuthenticationSchemes = OpenIddictValidationDefaults.AuthenticationScheme)]
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class CalendarController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public CalendarController(
            OpenIddictApplicationManager<OpenIddictApplication> applicationManager,
            SignInManager<ApplicationUser> signInManager,
            UserManager<ApplicationUser> userManager,
            IOptions<ConfigurationModel> configModel)
        {
            this.applicationManager = applicationManager;
            this.signInManager = signInManager;
            this.userManager = userManager;
            this.configModel = configModel.Value;
        }

        [AllowAnonymous]
        [Route("~/api/calendar")]
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new {
                Error = ""
            });
        }

        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> Details(DateModel date)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        /// <summary>
        /// Allows a user to sign up to indicate they will be at OCC on a specified date
        /// </summary>
        /// <param name="date">The day the user is attending</param>
        /// <returns>An error message, if an error occurs.  Otherwise, a blank string.</returns>
        [Route("~/api/calendar/signup/single")]
        [HttpPost]
        public async Task<IActionResult> SignupSingle(DateModel date)
        {
            var user = await userManager.GetUserAsync(User);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);
            AttendanceModel attendance = repo.GetSingleAttendance(user.VolunteerId, date.Date);

            if (date.Date.DayOfWeek != DayOfWeek.Saturday)
            {
                return Utilities.ErrorJson("Provided date was not a Saturday");
            }

            if (attendance != null && attendance.Scheduled)
            {
                return Utilities.ErrorJson("You are already scheduled on this date");
            }

            if (attendance == null)
            {
                try
                {
                    repo.InsertAttendance(new AttendanceModel
                    {
                        VolunteerId = user.VolunteerId,
                        DayAttended = date.Date,
                        Scheduled = true,
                        Attended = false,
                    });
                }
                catch (Exception e)
                {
                    return Utilities.ErrorJson(e.Message);
                }
            }
            else
            {
                try
                {
                    repo.UpdateScheduled(attendance.Id, true);
                }
                catch (Exception e)
                {
                    return Utilities.ErrorJson(e.Message);
                }
            }

            return new JsonResult(new
            {
                Error = ""
            });
        }

        /// <summary>
        /// Allows a user to indicate they will not be present on a day they had previously signed up for.
        /// </summary>
        /// <param name="date">The date the user will not be present</param>
        /// <returns>An error message, if one occurred.  Otherwise, a blank string.</returns>
        [Route("~/api/calendar/cancellation/single")]
        [HttpPost]
        public async Task<IActionResult> CancelSingle(DateModel date)
        {
            var user = await userManager.GetUserAsync(User);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);
            AttendanceModel attendance = repo.GetSingleAttendance(user.VolunteerId, date.Date);

            if (date.Date.DayOfWeek != DayOfWeek.Saturday)
            {
                return Utilities.ErrorJson("Provided date was not a Saturday");
            }

            if ((attendance != null && !attendance.Scheduled) || attendance == null)
            {
                return Utilities.ErrorJson("You are not currently scheduled on this date");
            }

            try
            {
                repo.UpdateScheduled(attendance.Id, false);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/signup/group")]
        [HttpPost]
        public async Task<IActionResult> SignupGroup(DateTime date, GroupModel group)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/cancellation/group")]
        [HttpPost]
        public async Task<IActionResult> CancelGroup(DateTime date, int groupId)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/event-creation")]
        [HttpPost]
        public async Task<IActionResult> EventCreation(DateTime date, string name, string description)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/event-edit")]
        [HttpPost]
        public async Task<IActionResult> EventEdit(int Id, DateTime date, string name, string description)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/signup/event")]
        [HttpPost]
        public async Task<IActionResult> SignupEvent(int eventId)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/cancellation/event")]
        [HttpPost]
        public async Task<IActionResult> CancelEvent(int eventId)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }
    }
}