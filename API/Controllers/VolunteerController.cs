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

        [Route("~/api/volunteer-list")]
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> VolunteerList()
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            List<VolunteerModel> volunteers;

            //if (!await userManager.IsInRoleAsync(user, "staff"))
            //{
            //    return new UnauthorizedResult();
            //}

            volunteers = repo.GetVolunteers();

            return new JsonResult(new
            {
                Error = "",
                Volunteers = volunteers
            });
        }

        [Route("~/api/volunteer-profile-edit")]
        [HttpPost]
        public async Task<IActionResult> VolunteerProfileEdit(VolunteerModel volunteer) 
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/volunteer-create-temp")]
        [HttpPost]
        public async Task<IActionResult> VolunteerCreateTemp()
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);

            try
            {
                repo.CreateVolunteer(new VolunteerModel
                {
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    Email = user.UserName
                });
            }
            catch (Exception e)
            {
                return new JsonResult(new
                {
                    Error = e.Message
                });
            }

            return new JsonResult(new
            {
                Error = ""
            });
        }
    }
}