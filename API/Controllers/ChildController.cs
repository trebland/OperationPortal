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
        [AllowAnonymous]
        public IActionResult Roster(int busId, int classId, DateTime date)
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    BusRoster = repo.GetChildrenBus(busId),
                    ClassRoster = repo.GetChildrenClass(classId)
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
        [AllowAnonymous]
        public IActionResult CreateChild()
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    NextId = repo.CreateChildId()
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
        [AllowAnonymous]
        // Pass in JSON object
        public IActionResult EditChild(ChildModel child)
        {
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
                    Class = updatedChild.Class
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
        public IActionResult UpdateWaiver(int childId, bool received)
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                repo.UpdateWaiver(childId, received);
                
                return new JsonResult(new
                {
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
        [AllowAnonymous]
        public IActionResult CheckAttendance(int childId)
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    DaysAttended = repo.GetAttendanceDates(childId)
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
        [AllowAnonymous]
        public IActionResult Suspend(int childId, DateTime start, DateTime end)
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Error = repo.Suspend(childId, start, end)
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
        [AllowAnonymous]
        public IActionResult Suspensions()
        {
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
        [AllowAnonymous]
        public IActionResult CheckChildSuspension(int childId)
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    IsSuspended = repo.IsSuspended(childId)
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
        public IActionResult Notes(int childId, string notes)
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Notes = repo.EditNotes(childId, notes)
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
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                classes = classes
            });
        }
    }
}