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
        public async Task<IActionResult> AnnouncementCreation(AnnouncementModel announcement) // TODO: put in parameter list
        {
            var user = await userManager.GetUserAsync(User);
            AnnouncementRepository ancRepo = new AnnouncementRepository(configModel.ConnectionString);
            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel volunteer;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Get the current user's volunteer profile so we can get their name
            volunteer = volunteerRepo.GetVolunteer(user.VolunteerId);

            if (String.IsNullOrEmpty(announcement.Title))
            {
                return Utilities.ErrorJson("Title field cannot be empty");
            }
            if (announcement.StartDate == DateTime.MinValue || announcement.EndDate == DateTime.MinValue)
            {
                return Utilities.ErrorJson("Start and end date must be provided");
            }
            if (announcement.StartDate > announcement.EndDate)
            {
                return Utilities.ErrorJson("Start date must be no later than end date");
            }

            try
            {
                ancRepo.CreateAnnouncement(new AnnouncementModel
                {
                    Title = announcement.Title,
                    Message = announcement.Message,
                    Author = volunteer.FirstName + " " + volunteer.LastName,
                    LastUpdateBy = volunteer.FirstName + " " + volunteer.LastName,
                    StartDate = announcement.StartDate,
                    EndDate = announcement.EndDate
                });
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

        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> Announcements()
        {
            var user = await userManager.GetUserAsync(User);
            AnnouncementRepository repo = new AnnouncementRepository(configModel.ConnectionString);
            List<AnnouncementModel> announcements;

            try
            {
                announcements = repo.GetAnnouncementList();
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                Announcements = announcements
            });
        }

        [Route("~/api/announcement-edit")]
        [HttpPost]
        public async Task<IActionResult> AnnouncementEdit(AnnouncementModel announcement)
        {
            var user = await userManager.GetUserAsync(User);
            AnnouncementRepository repo = new AnnouncementRepository(configModel.ConnectionString);
            AnnouncementModel dbAnc;
            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel volunteer;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            if (String.IsNullOrEmpty(announcement.Title))
            {
                return Utilities.ErrorJson("Title field cannot be empty");
            }
            if (announcement.StartDate == DateTime.MinValue || announcement.EndDate == DateTime.MinValue)
            {
                return Utilities.ErrorJson("Start and end date must be provided");
            }
            if (announcement.StartDate > announcement.EndDate)
            {
                return Utilities.ErrorJson("Start date must be no later than end date");
            }

            dbAnc = repo.GetAnnouncement(announcement.Id);

            if (dbAnc == null)
            {
                return Utilities.ErrorJson("Not a valid announcement");
            }

            volunteer = volunteerRepo.GetVolunteer(user.VolunteerId);

            announcement.LastUpdateBy = volunteer.FirstName + " " + volunteer.LastName;

            try
            {
                repo.UpdateAnnouncement(announcement);
            }
            catch(Exception e)
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