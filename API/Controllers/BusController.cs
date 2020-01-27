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
    [Route("api/[action]")]
    public class BusController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public BusController(
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
        /// Gets the list of all buses
        /// </summary>
        /// <returns>An error message, or if no error, a blank string and an array of buses</returns>
        [Route("~/api/bus-list")]
        [HttpGet]
        public async Task<IActionResult> BusList()
        {
            var user = await userManager.GetUserAsync(User);
            BusRepository busRepo = new BusRepository(configModel.ConnectionString);
            List<BusModel> buses;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            try
            {
                buses = busRepo.GetBusList();
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                Buses = buses
            });
        }

        /// <summary>
        /// Updates the route of a 
        /// </summary>
        /// <param name="bus">A JSON-formatted object representing the bus.  Must contain an id field and a route field, where id is the bus' id and route is the new route definition</param>
        /// <returns>An error message, or an empty string if no error occurred</returns>
        [Route("~/api/route-edit")]
        [HttpPost]
        public async Task<IActionResult> RouteEdit(BusModel bus)
        {
            var user = await userManager.GetUserAsync(User);
            BusRepository busRepo = new BusRepository(configModel.ConnectionString);
            BusModel dbBus;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Get the bus to ensure that it is valid
            dbBus = busRepo.GetBus(bus.Id);
            if (bus.Id == 0 || bus == null)
            {
                return Utilities.ErrorJson("Invalid id");
            }

            busRepo.UpdateBusRoute(bus.Id, bus.Route);

            return new JsonResult(new
            {
                Error = ""
            });
        }

        /// <summary>
        /// Creates a new bus in the database.  Accessible only to staff
        /// </summary>
        /// <param name="bus">A JSON object representing the bus.  Should have at least a name, may have a route.  Other fields are ignored.</param>
        /// <returns>sAn error message, or a blank string if no error occurred.</returns>
        [HttpPost]
        [Route("~/api/bus-creation")]
        public async Task<IActionResult> BusCreation(BusModel bus)
        {
            var user = await userManager.GetUserAsync(User);
            BusRepository busRepo = new BusRepository(configModel.ConnectionString);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            if (string.IsNullOrEmpty(bus.Name))
            {
                return Utilities.ErrorJson("Bus name cannot be empty");
            }
            if (bus.Name.Length > 300)
            {
                return Utilities.ErrorJson("Bus name is too long (limit 300 characters)");
            }

            try
            {
                busRepo.CreateBus(bus.Name, bus.Route);
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
    }
}