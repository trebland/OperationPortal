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
using API.Helpers;
using System;
using Microsoft.Extensions.Options;

namespace API.Controllers
{
    [Authorize(AuthenticationSchemes = OpenIddictValidationDefaults.AuthenticationScheme)]
    [ApiController]
    [Route("api/[action]")]
    public class ChildController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public ChildController(
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

        [Route("~/api/roster")]
        [HttpGet]
        public async Task<IActionResult> Roster([FromQuery]GetRosterModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Busid == 0 && model.Classid == 0)
            {
                return Utilities.ErrorJson("Bus id or class id is required to retrieve a roster.");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                List<ChildModel> BusRoster = null;
                List<ChildModel> ClassRoster = null;

                if (model.Busid != 0)
                {
                    BusRoster = repo.GetChildrenBus(model.Busid);
                }

                if (model.Classid != 0)
                {
                    ClassRoster = repo.GetChildrenClass(model.Classid);
                }

                List<ChildModel> IntersectionRoster = repo.GetIntersection(BusRoster, ClassRoster);

                return new JsonResult(new
                {
                    BusRoster,
                    ClassRoster,
                    IntersectionRoster
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

        [Route("~/api/child-creation")]
        [HttpPost]
        // Required input: first name, last name, bus, class
        public async Task<IActionResult> CreateChild(ChildModel child)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            List<String> missingParameters = new List<String>();
            if (child.FirstName == null)
            {
                missingParameters.Add("first name");
            }

            if (child.LastName == null)
            {
                missingParameters.Add("last name");
            }

            if (child.Bus == null || child.Bus.Id == null)
            {
                missingParameters.Add("bus id");
            }

            if (child.Class == null || child.Class.Id == null)
            {
                missingParameters.Add("class id");
            }

            if (missingParameters.Count != 0)
            {
                return Utilities.GenerateMissingInputMessage(missingParameters);
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    Message = repo.CreateChild(child)
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

        [Route("~/api/child-edit")]
        [HttpPost]
        public async Task<IActionResult> EditChild(ChildModel child)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (child == null || child.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                ChildModel updatedChild = repo.EditChild(child);
                return new JsonResult(new ChildModel
                {
                    Id = updatedChild.Id,
                    // Fields that can be updated:
                    FirstName = updatedChild.FirstName,
                    LastName = updatedChild.LastName,
                    Gender = updatedChild.Gender,
                    Grade = updatedChild.Grade,
                    Birthday = updatedChild.Birthday,
                    Bus = updatedChild.Bus,
                    Class = updatedChild.Class,
                    Picture = updatedChild.Picture
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

        [Route("~/api/child")]
        [HttpGet]
        public async Task<IActionResult> Child([FromQuery]IdModel model)
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

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                ChildModel child = repo.GetChild(model.Id);
                return new JsonResult(new ChildModel
                {
                    Id = child.Id,
                    FirstName = child.FirstName,
                    LastName = child.LastName,
                    Gender = child.Gender,
                    Grade = child.Grade,
                    Birthday = child.Birthday,
                    Bus = child.Bus,
                    Class = child.Class,
                    //Picture = child.Picture
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

        [Route("~/api/waiver")]
        [HttpPost]
        [AllowAnonymous]
        public IActionResult UpdateWaiver(PostWaiverModel model)
        {
            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                repo.UpdateWaiver(model.Id, model.Received);

                String Message = "The child was recorded as " + (model.Received ? "" : "not ") + "having turned in the waiver.";
                return new JsonResult(new
                {
                    Message
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

        [Route("~/api/child-attendance-check")]
        [HttpGet]
        public async Task<IActionResult> CheckAttendance([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null || !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    DaysAttended = repo.GetAttendanceDates(model.Id)
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

        [Route("~/api/suspend")]
        [HttpPost]
        public async Task<IActionResult> Suspend(PostSuspendChildModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            List<String> missingParameters = new List<String>();
            if (model.Id == 0)
            {
                missingParameters.Add("child id");
            }

            if (model.Start == DateTime.MinValue)
            {
                missingParameters.Add("start time");
            }

            if (model.End == DateTime.MinValue)
            {
                missingParameters.Add("end time");
            }

            if (missingParameters.Count != 0)
            {
                return Utilities.GenerateMissingInputMessage(missingParameters);
            }

            String timeframeMsg = Utilities.ValidateTimeframe(model.Start, model.End);
            if (!timeframeMsg.Equals(""))
            {
                return Utilities.ErrorJson(timeframeMsg);
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);


                return new JsonResult(new
                {
                    Message = repo.Suspend(model.Id, model.Start, model.End)
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

        [Route("~/api/suspensions")]
        [HttpGet]
        public async Task<IActionResult> Suspensions()
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Suspensions = repo.ViewSuspensions()
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

        [Route("~/api/child-current-suspension")]
        [HttpGet]
        public async Task<IActionResult> CheckChildSuspension([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    IsSuspended = repo.IsSuspended(model.Id)
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

        [Route("~/api/notes-edit")]
        [HttpPost]
        [AllowAnonymous]
        public IActionResult Notes(PostNotesEditModel model)
        {
            if (model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Notes = repo.EditNotes(model.Id, model.Notes)
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

        /// <summary>
        /// Lists all classes stored in the system
        /// </summary>
        /// <returns>If an error occurred, an error message.  Otherwise, a blank error message and a JSON-formatted array of classes.</returns>
        [Route("~/api/class-list")]
        [HttpGet]
        public async Task<IActionResult> ClassList()
        {
            var user = await userManager.GetUserAsync(User);
            ChildRepository repo = new ChildRepository(configModel.ConnectionString);
            List<ClassModel> classes;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            try
            {
                classes = repo.GetClasses();
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                classes = classes
            });
        }

        /// <summary>
        /// Gets the list of children's birthdays in the provided month.  Only accessible to staff.
        /// </summary>
        /// <param name="month">The month to check.  If a value of 0 is provided (the default), it will check the current month.</param>
        /// <returns>A list of BirthdayModel objects, each containing a name and a birthday</returns>
        [HttpGet]
        [Route("~/api/birthdays/child")]
        public async Task<IActionResult> ChildBirthdays(int month = 0)
        {
            var user = await userManager.GetUserAsync(User);
            ChildRepository repo = new ChildRepository(configModel.ConnectionString);
            List<BirthdayModel> birthdays = null;

            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            if (month < 0 || month > 12)
            {
                return Utilities.ErrorJson("Invalid month");
            }

            //TODO: database connectivity
            try
            {
                if (month == 0)
                {
                    //birthdays = repo.GetBirthdays(DateTime.Now.Month);
                }
                else
                {
                    //birthdays = repo.GetBirthdays(month);
                }
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                Birthdays = birthdays
            });
        }
    }
}