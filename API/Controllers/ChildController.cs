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
using System;
using Microsoft.Extensions.Options;

namespace API.Controllers
{
    [Authorize(AuthenticationSchemes = OpenIddictValidationDefaults.AuthenticationScheme)]
    [ApiController]
    [Route("api/[action]")]
    public class ChildController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public ChildController(
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

        [Route("~/api/roster")]
        [HttpGet]
        [AllowAnonymous]
        public IActionResult Roster(int busId, int classId, DateTime date)
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    BusRoster = repo.GetChildrenBus(busId),
                    ClassRoster = repo.GetChildrenClass(classId)
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

        [Route("~/api/child-creation")]
        [HttpPost]
        [AllowAnonymous]
        public IActionResult CreateChild()
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    NextId = repo.CreateChildId()
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

        [Route("~/api/child-edit")]
        [HttpPost]
        [AllowAnonymous]
        // Pass in JSON object
        public IActionResult EditChild(ChildModel child)
        {
            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                ChildModel updatedChild = repo.EditChild(child);
                return new JsonResult(new ChildModel
                {
                    Id = updatedChild.Id,
                    // Fields that can be updated:
                    FirstName = updatedChild.FirstName,
                    LastName = updatedChild.LastName,
                    Gender = updatedChild.Gender,
                    Grade = updatedChild.Grade,
                    Birthday = updatedChild.Birthday,
                    WaiverReceived = updatedChild.WaiverReceived,
                    Bus = updatedChild.Bus,
                    Class = updatedChild.Class
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