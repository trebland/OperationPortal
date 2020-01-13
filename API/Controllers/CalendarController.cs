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
    [Route("api/[controller]/[action]")]
    public class CalendarController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public CalendarController(
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

        [AllowAnonymous]
        [Route("~/api/calendar")]
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new {
                Error = ""
            });
        }

        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> Details(DateTime date)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/signup/single")]
        [HttpPost]
        public async Task<IActionResult> SignupSingle(DateTime date)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/cancellation/single")]
        [HttpPost]
        public async Task<IActionResult> CancelSingle(DateTime date)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/signup/group")]
        [HttpPost]
        public async Task<IActionResult> SignupGroup(DateTime date, GroupModel group)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/cancellation/group")]
        [HttpPost]
        public async Task<IActionResult> CancelGroup(DateTime date, int groupId)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/event-creation")]
        [HttpPost]
        public async Task<IActionResult> EventCreation(DateTime date, string name, string description)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/event-edit")]
        [HttpPost]
        public async Task<IActionResult> EventEdit(int Id, DateTime date, string name, string description)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/signup/event")]
        [HttpPost]
        public async Task<IActionResult> SignupEvent(int eventId)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }

        [Route("~/api/calendar/cancellation/event")]
        [HttpPost]
        public async Task<IActionResult> CancelEvent(int eventId)
        {
            var user = await userManager.GetUserAsync(User);
            return new JsonResult(new
            {
                Error = ""
            });
        }
    }
}