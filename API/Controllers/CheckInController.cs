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
using Microsoft.Extensions.Options;
using System;

namespace API.Controllers
{
    [Authorize(AuthenticationSchemes = OpenIddictValidationDefaults.AuthenticationScheme)]
    [ApiController]
    [Route("api/check-in/[action]")]
    public class CheckInController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly RoleManager<IdentityRole> roleManager;
        private readonly ConfigurationModel configModel;

        public CheckInController(
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

        [Route("~/api/check-in/child")]
        [HttpPost]
        [AllowAnonymous]
        public IActionResult CheckInChild(int childId)
        {
            try
            {
                CheckInRepository repo = new CheckInRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    numVisits = repo.CheckInChild(childId)
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

        [Route("~/api/check-in/volunteer")]
        [HttpPost]
        [AllowAnonymous]
        public IActionResult CheckInVolunteer(int volunteerId, int? classId, int? busId, bool viewRoster, bool viewNotes)
        {
            try
            {
                CheckInRepository repo = new CheckInRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    numVisits = repo.CheckInVolunteer(volunteerId, classId, busId, viewRoster, viewNotes)
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