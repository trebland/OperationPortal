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

namespace API.Controllers
{
    [Authorize(AuthenticationSchemes = OpenIddictValidationDefaults.AuthenticationScheme)]
    [ApiController]
    [Route("api/[action]")]
    public class AnnouncementController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        // This constructor ensures that the controller can access the user accounts, roles, and configuration values
        public AnnouncementController(
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

        [Route("~/api/announcement-creation")]
        [HttpPost]
        public async Task<IActionResult> AnnouncementCreation(AnnouncementModel announcement, bool active) // TODO: put in parameter list
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> Announcements()
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/announcement-edit")]
        [HttpPost]
        public async Task<IActionResult> AnnouncementEdit(AnnouncementModel announcement)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }
    }
}