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

namespace API.Controllers
{
    [Authorize(AuthenticationSchemes = OpenIddictValidationDefaults.AuthenticationScheme)]
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class SampleController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;

        public SampleController(
            OpenIddictApplicationManager<OpenIddictApplication> applicationManager,
            SignInManager<ApplicationUser> signInManager,
            UserManager<ApplicationUser> userManager)
        {
            this.applicationManager = applicationManager;
            this.signInManager = signInManager;
            this.userManager = userManager;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var user = await userManager.GetUserAsync(User);
            string roles = string.Join(", ", await userManager.GetRolesAsync(user));

            return new JsonResult(new
            {
                Email = user.Email,
                FirstName = user.FirstName,
                LastName = user.LastName,
                VolunteerId = user.VolunteerId,
                Roles = await userManager.GetRolesAsync(user)
            });
        }

        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> GetAnon()
        {
            List<string> roles = new List<string>();
            roles.Add("Volunteer");

            return new JsonResult(new
            {
                Email = "test@occ.com",
                FirstName = "test",
                LastName = "test",
                VolunteerId = 0,
                Roles = roles
            }); ;
        }

        [HttpGet]
        [AllowAnonymous]
        public IActionResult TestCon()
        {
            if (SampleRepository.PostgresTest())
            {
                return new JsonResult (new { error = "" });
            }

            return new JsonResult(new { error = "Could not access database" });
        }

        [HttpGet]
        [AllowAnonymous]
        public IActionResult TestHTTPS()
        {
            if (HttpContext.Request.IsHttps)
            {
                return new JsonResult(new { error = "" });
            }

            return new JsonResult(new { error = "Request was not https" });
        }
    }
}