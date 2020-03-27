using AspNet.Security.OpenIdConnect.Extensions;
using AspNet.Security.OpenIdConnect.Primitives;
using AspNet.Security.OpenIdConnect.Server;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using OpenIddict.Validation;
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
    [Route("api/[action]")]
    public class InventoryController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public InventoryController(
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

        /// <summary>
        /// Creates a new inventory requisition
        /// </summary>
        /// <param name="model">An InventoryModel object that must include name and count</param>
        /// <returns>An error message if an error occurred, or an empty string otherwise.</returns>
        [HttpPost]
        [Route("~/api/inventory-create")]
        public async Task<IActionResult> InventoryCreate(InventoryModel model)
        {
            InventoryRepository repo = new InventoryRepository(configModel.ConnectionString);
            bool authorized = false;
            var user = await userManager.GetUserAsync(User);
            VolunteerModel profile;
            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);

            profile = volunteerRepo.GetVolunteer(user.VolunteerId);

            // Verify that the user has permissions to create an inventory item
            if (User.IsInRole(UserHelpers.UserRoles.Staff.ToString()) || User.IsInRole(UserHelpers.UserRoles.VolunteerCaptain.ToString()) || profile.CanEditInventory) 
            {
                authorized = true;
            }
            else
            {
                authorized = false;
            }

            if (!authorized)
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Verify the input was valid
            if (string.IsNullOrEmpty(model.Name))
            {
                return Utilities.ErrorJson("Name must be included");
            }

            if (model.Count < 0)
            {
                return Utilities.ErrorJson("Count must be a non-negative integer");
            }

            // Send to database
            repo.CreateInventory(model.Name, model.Count, profile.PreferredName + " " + profile.LastName);

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Edits an inventory requisition
        /// </summary>
        /// <param name="model">An InventoryModel object that must include name, count, and resolved</param>
        /// <returns>An error message if an error occurred, or an empty string otherwise.</returns>
        [HttpPost]
        [Route("~/api/inventory-edit")]
        public async Task<IActionResult> InventoryEdit(InventoryModel model)
        {
            InventoryRepository repo = new InventoryRepository(configModel.ConnectionString);
            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);
            InventoryModel dbModel = null;
            bool authorized = false;
            var user = await userManager.GetUserAsync(User);
            VolunteerModel profile = volunteerRepo.GetVolunteer(user.VolunteerId);

            // Verify the user has permissions to edit inventory
            if (User.IsInRole(UserHelpers.UserRoles.Staff.ToString()) || User.IsInRole(UserHelpers.UserRoles.VolunteerCaptain.ToString()) || profile.CanEditInventory) 
            {
                authorized = true;
            }
            else
            {
                authorized = false;
            }

            if (!authorized)
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Check that the inputs are all valid
            if (string.IsNullOrEmpty(model.Name))
            {
                return Utilities.ErrorJson("Name must be included");
            }

            if (model.Count < 0)
            {
                return Utilities.ErrorJson("Count must be a non-negative integer");
            }

            dbModel = repo.GetInventoryItem(model.Id);
            if (dbModel == null)
            {
                return Utilities.ErrorJson("Invalid id");
            }
            
            // Send to database
            repo.UpdateInventory(model.Id, model.Name, model.Count, model.Resolved);

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Gets the inventory requisitions in the database
        /// </summary>
        /// <param name="resolved">Determines whether to show requisitions that have been resolved.  False by default</param>
        /// <returns>An error string, or if there was no error, an empty string and a list of InventoryModel objects</returns>
        [HttpGet]
        public async Task<IActionResult> Inventory(bool resolved = false)
        {
            InventoryRepository repo = new InventoryRepository(configModel.ConnectionString);
            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);
            List<InventoryModel> items = null;
            bool authorized = false;
            var user = await userManager.GetUserAsync(User);
            VolunteerModel profile = volunteerRepo.GetVolunteer(user.VolunteerId);

            // Verify the user has permissions to edit inventory
            if (User.IsInRole(UserHelpers.UserRoles.Staff.ToString()) || User.IsInRole(UserHelpers.UserRoles.VolunteerCaptain.ToString()) || profile.CanEditInventory) 
            {
                authorized = true;
            }
            else
            {
                authorized = false;
            }

            if (!authorized)
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Get the appropriate inventory items
            items = repo.GetInventory(resolved);

            return new JsonResult(new
            {
                Error = "",
                Items = items
            });
        }
    }
}