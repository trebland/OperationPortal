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
using Newtonsoft.Json.Linq;
using API.Models;
using API.Data;
using API.Helpers;

namespace API.Controllers
{
    [Authorize(AuthenticationSchemes = OpenIddictValidationDefaults.AuthenticationScheme)]
    [ApiController]
    [Route("api/[action]")]
    public class VolunteerController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly RoleManager<IdentityRole> roleManager;
        private readonly ConfigurationModel configModel;

        // This constructor ensures that the controller can access the user accounts, roles, and configuration values
        public VolunteerController(
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

        /// <summary>
        /// Gets a list of all registered volunteers
        /// </summary>
        /// <returns>All registered volunteers</returns>
        [Route("~/api/volunteer-list")]
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> VolunteerList()
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            List<VolunteerModel> volunteers;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            try
            {
                volunteers = repo.GetVolunteers();
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(configModel.DebugMode ? e.Message : "An error occurred while accessing the database.");
            }

            return new JsonResult(new
            {
                Error = "",
                Volunteers = volunteers
            });
        }

        // TODO: Work out exactly what will and will not be editable
        /// <summary>
        /// Allows for editing a volunteer's profile
        /// </summary>
        /// <param name="volunteer">A VolunteerModel object containing the updated information.  Will be rejected if this is not the current user</param>
        /// <returns>An indication of any errors that occurred</returns>
        [Route("~/api/volunteer-profile-edit")]
        [HttpPost]
        public async Task<IActionResult> VolunteerProfileEdit(VolunteerModel volunteer) 
        {
            //TODO: discuss making email immutable
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel currentModel = repo.GetVolunteer(volunteer.Id);
            
            // Return with an error if there is no volunteer model to update or if the profile being updated is not that of the logged-in user
            if (currentModel == null)
            {
                return Utilities.ErrorJson("Profile does not exist");
            }
            if (currentModel.Email != user.UserName)
            {
                return Utilities.ErrorJson("Not authorized to edit this profile");
            }

            return Utilities.ErrorJson("");
        }

        /// <summary>
        /// Allows for updating the role a user has on the site.  Accessible only to staff.
        /// </summary>
        /// <param name="data">
        /// Must be a JSON object consisting of "id" and "role".  This form is used because it isn't possible to have multiple simple type (e.g. an int
        /// and a string) parameters for a POST action in ASP.NET.
        /// id is the id of the volunteer whose role is being updated
        /// role is the name of the role they are being given.  This is validated against a list of valid roles, maintained here in the code.
        /// </param>
        /// <returns></returns>
        [Route("~/api/role-edit")]
        [HttpPost]
        public async Task<IActionResult> RoleEdit( [FromBody]JObject data)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel volunteer;
            UserHelpers.UserRoles userRole;
            int id;
            string role;

            try
            {
                id = data["id"].ToObject<int>();
                role = data["role"].ToString();
            }
            catch (Exception)
            {
                return Utilities.ErrorJson("Invalid input");
            }

            volunteer = repo.GetVolunteer(id);

            if (id == 0 || String.IsNullOrEmpty(role))
            {
                return Utilities.ErrorJson("Required parameter missing");
            }

            var user = await userManager.GetUserAsync(User);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Ensure the role passed in is valid
            try
            {
                userRole = (UserHelpers.UserRoles)Enum.Parse(typeof(UserHelpers.UserRoles), Utilities.NormalizeString(role));
            }
            catch(ArgumentException)
            {
                return Utilities.ErrorJson("Not a valid role");
            }

            // Get the user account of the person whose role is being updated
            var volunteerAccount = await userManager.FindByNameAsync(volunteer.Email);
            if (volunteerAccount == null)
            {
                return Utilities.ErrorJson("Error updating user account, please try again.");
            }

            if (await userManager.IsInRoleAsync(volunteerAccount, userRole.ToString()))
            {
                //return Utilities.ErrorJson("User is already in role " + userRole.ToString());
            }

            // If the role does not yet exist (e.g. no users with it have been added to the database), create it
            // The only reason I am comfortable doing this is because I check the input against the enum up above, 
            // so people cannot create arbitrary roles
            if (!(await roleManager.RoleExistsAsync(userRole.ToString())))
            {
                await roleManager.CreateAsync(new IdentityRole { Name = userRole.ToString() });
            }

            // Remove the user account's other roles and add the new one
            await userManager.RemoveFromRolesAsync(volunteerAccount, await userManager.GetRolesAsync(volunteerAccount));
            await userManager.AddToRoleAsync(volunteerAccount, userRole.ToString());
            // Update the role in the user's volunteer profile in the DB.  This one isn't as important, since it doesn't affect permissions
            repo.UpdateUserRole(volunteer.Id, (int)userRole);

            return Utilities.ErrorJson("");
        }

        [Route("~/api/volunteer-attendance-check")]
        [HttpGet]
        [AllowAnonymous]
        public IActionResult CheckAttendance(int volunteerId)
        {
            try
            {
                VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    DaysAttended = repo.GetAttendanceDates(volunteerId)
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

        [Route("~/api/volunteers-for-day")]
        [HttpGet]
        [AllowAnonymous]
        public IActionResult VolunteersForDay(DateTime day, bool checkedIn, bool signedUp)
        {
            try
            {
                VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Volunteers = repo.GetDaysVolunteers(day, checkedIn, signedUp)
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

        // I was using this temporarily while I hadn't finished updating the register action to work with the DB.  It's no longer necessary,
        // so I'll remove it once I've had the chance to test the register action a bit more heavily.
        //[Route("~/api/volunteer-create-temp")]
        //[HttpPost]
        //public async Task<IActionResult> VolunteerCreateTemp()
        //{
        //    var user = await userManager.GetUserAsync(User);
        //    VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);

        //    try
        //    {
        //        repo.CreateVolunteer(new VolunteerModel
        //        {
        //            FirstName = user.FirstName,
        //            LastName = user.LastName,
        //            Email = user.UserName
        //        });
        //    }
        //    catch (Exception e)
        //    {
        //        return new JsonResult(new
        //        {
        //            Error = e.Message
        //        });
        //    }

        //    return new JsonResult(new
        //    {
        //        Error = ""
        //    });
        //}
    }
}