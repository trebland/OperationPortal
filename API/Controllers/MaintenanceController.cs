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
using System;
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
    public class MaintenanceController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public MaintenanceController(
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
        /// Allows creating a maintenance form
        /// </summary>
        /// <param name="maintenance">A MaintenanceModel object.  Must include bus id and text</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/maintenance-forms-creation")]
        public async Task<ActionResult> MaintenanceFormsCreation(MaintenanceModel maintenance)
        {
            BusModel bus;
            MaintenanceRepository repo = new MaintenanceRepository(configModel.ConnectionString);
            BusRepository busRepo = new BusRepository(configModel.ConnectionString);
            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);
            var user = await userManager.GetUserAsync(User);
            VolunteerModel profile;

            if (user == null || !User.IsInRole(UserHelpers.UserRoles.BusDriver.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            bus = busRepo.GetBus(maintenance.BusId);

            if (bus == null)
            {
                return Utilities.ErrorJson("Invalid bus id");
            }

            if (String.IsNullOrEmpty(maintenance.Text))
            {
                return Utilities.ErrorJson("Text cannot be empty");
            }

            profile = volunteerRepo.GetVolunteer(user.VolunteerId);

            repo.CreateMaintenanceForm(maintenance.BusId, maintenance.Text, profile.PreferredName + " " + profile.LastName);

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Allows updating a maintenance form
        /// </summary>
        /// <param name="maintenance">A MaintenanceModel object that must include id, text, and resolved</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/maintenance-forms-edit")]
        public async Task<ActionResult> MaintenanceFormsEdit(MaintenanceModel maintenance)
        {
            MaintenanceModel dbModel = null;
            MaintenanceRepository repo = new MaintenanceRepository(configModel.ConnectionString);
            var user = await userManager.GetUserAsync(User);

            if (user == null 
                || !(User.IsInRole(UserHelpers.UserRoles.BusDriver.ToString()) || User.IsInRole(UserHelpers.UserRoles.BusMaintenance.ToString()) 
                || User.IsInRole(UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            dbModel = repo.GetMaintenanceForm(maintenance.Id);

            if (dbModel == null)
            {
                return Utilities.ErrorJson("Invalid id");
            }

            if (String.IsNullOrEmpty(maintenance.Text))
            {
                return Utilities.ErrorJson("Text cannot be empty");
            }

            repo.UpdateMaintenanceForm(maintenance.Id, maintenance.Text, maintenance.Resolved);

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Allows getting current maintenance forms
        /// </summary>
        /// <param name="busId">Allows filtering to a specific bus.  Not filtered by default</param>
        /// <param name="resolved">Allows looking at resolved forms.  Set to false by default</param>
        /// <returns>A list of MaintenaceModel objects, or an error message if an error occurs</returns>
        [HttpGet]
        [Route("~/api/maintenance-forms")]
        public async Task<ActionResult> MaintenanceForms(int busId = 0, bool resolved = false)
        {
            List<MaintenanceModel> maintenanceForms = null;
            MaintenanceRepository repo = new MaintenanceRepository(configModel.ConnectionString);
            var user = await userManager.GetUserAsync(User);

            if (user == null
                || !(User.IsInRole(UserHelpers.UserRoles.BusDriver.ToString()) || User.IsInRole(UserHelpers.UserRoles.BusMaintenance.ToString())
                || User.IsInRole(UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            maintenanceForms = repo.GetMaintenanceForms(resolved, busId);

            return new JsonResult(new
            {
                Error = "",
                MaintenanceForms = maintenanceForms
            });
        }
    }
}