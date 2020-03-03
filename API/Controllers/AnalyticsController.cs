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
    [Route("api/analytics/[action]")]
    public class AnalyticsController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public AnalyticsController(
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

        [Route("~/api/analytics/children-total")]
        [HttpGet]
        public async Task<IActionResult> ChildrenTotal()
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            try
            {
                AnalyticsRepository repo = new AnalyticsRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    TotalChildren = repo.GetChildrenTotal()
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

        [Route("~/api/analytics/children-age")]
        [HttpGet]
        public async Task<IActionResult> ChildrenByAge()
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            try
            {
                AnalyticsRepository repo = new AnalyticsRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    ChildrenByAge = repo.GetChildrenByAge()
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

        [Route("~/api/analytics/children-gender")]
        [HttpGet]
        public async Task<IActionResult> ChildrenByGender()
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            try
            {
                AnalyticsRepository repo = new AnalyticsRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    ChildrenByGender = repo.GetChildrenByGender()
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

        [Route("~/api/analytics/children-bus")]
        [HttpGet]
        public async Task<IActionResult> ChildrenByBus()
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            try
            {
                AnalyticsRepository repo = new AnalyticsRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    ChildrenByBus = repo.GetChildrenByBus()
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

        [Route("~/api/analytics/volunteers-new")]
        [HttpGet]
        public async Task<IActionResult> VolunteersNew([FromQuery]DateModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Date == DateTime.MinValue)
            {
                return Utilities.GenerateMissingInputMessage("date");
            }

            try
            {
                AnalyticsRepository repo = new AnalyticsRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Count = repo.GetNumNewVolunteers(model)
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

        [Route("~/api/analytics/volunteers-returning")]
        [HttpGet]
        public async Task<IActionResult> VolunteersReturning([FromQuery]DateModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Date == DateTime.MinValue)
            {
                return Utilities.GenerateMissingInputMessage("date");
            }

            try
            {
                AnalyticsRepository repo = new AnalyticsRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Count = repo.GetNumReturningVolunteers(model)
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

        [Route("~/api/analytics/volunteers-blue-shirt")]
        [HttpGet]
        public async Task<IActionResult> VolunteersBlueShirt([FromQuery]DateModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }
            
            if (model.Date == DateTime.MinValue)
            {
                return Utilities.GenerateMissingInputMessage("date");
            }

            try
            {
                AnalyticsRepository repo = new AnalyticsRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Count = repo.GetNumBlueShirtVolunteers(model)
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
    }
}