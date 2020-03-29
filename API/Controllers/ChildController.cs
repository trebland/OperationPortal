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
        public async Task<ActionResult> Roster([FromQuery]GetRosterModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Volunteer.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);
            // Volunteers must be teachers to have roster access
            if (User.IsInRole(UserHelpers.UserRoles.Volunteer.ToString()) && !volunteerRepo.VolunteerIsClassTeacher(user.VolunteerId))
            {
               return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || (model.Busid == 0 && model.Classid == 0))
            {
                return Utilities.ErrorJson("Bus id or class id is required to retrieve a roster.");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                List<ChildModel> BusRoster = null;
                List<ChildModel> ClassRoster = null;

                if (model.Busid != 0)
                {
                    BusRoster = repo.GetChildrenBus(model.Busid);
                }

                if (model.Classid != 0)
                {
                    ClassRoster = repo.GetChildrenClass(model.Classid);
                }

                List<ChildModel> IntersectionRoster = repo.GetIntersection(BusRoster, ClassRoster);

                return new JsonResult(new
                {
                    BusRoster,
                    ClassRoster,
                    IntersectionRoster
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
        // Required input: contact number, parent name, child first name
        public async Task<IActionResult> CreateChild(PostChildCreationModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            List<String> missingParameters = new List<String>();
            if (model.FirstName == null)
            {
                missingParameters.Add("first name");
            }

            if (model.ParentName == null)
            {
                missingParameters.Add("parent name");
            }

            if (model.ContactNumber == null)
            {
                missingParameters.Add("contact number");
            }

            if (missingParameters.Count != 0)
            {
                return Utilities.GenerateMissingInputMessage(missingParameters);
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                return new JsonResult(new
                {
                    Message = repo.CreateChild(model)
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
        public async Task<IActionResult> EditChild(PostChildEditModel child)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (child == null || child.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                PostChildEditModel updatedChild = repo.EditChild(child);
                return new JsonResult(new PostChildEditModel
                {
                    Id = updatedChild.Id,
                    // Fields that can be updated:
                    FirstName = updatedChild.FirstName,
                    LastName = updatedChild.LastName,
                    PreferredName = updatedChild.LastName,
                    ContactNumber = updatedChild.ContactNumber,
                    ParentName = updatedChild.ParentName,
                    BusId = updatedChild.BusId,
                    Birthday = updatedChild.Birthday,
                    Gender = updatedChild.Gender,
                    Grade = updatedChild.Grade,
                    ParentalWaiver = updatedChild.ParentalWaiver,
                    ClassId = updatedChild.ClassId,
                    Picture = updatedChild.Picture,
                    BusWaiver = updatedChild.BusWaiver,
                    HaircutWaiver = updatedChild.HaircutWaiver,
                    ParentalEmailOptIn = updatedChild.ParentalEmailOptIn,
                    OrangeShirtStatus = updatedChild.OrangeShirtStatus
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

        [Route("~/api/child")]
        [HttpGet]
        public async Task<IActionResult> Child([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                PostChildEditModel child = repo.GetChild(model.Id);
                return new JsonResult(new PostChildEditModel
                {
                    Id = child.Id,
                    FirstName = child.FirstName,
                    LastName = child.LastName,
                    PreferredName = child.LastName,
                    ContactNumber = child.ContactNumber,
                    ParentName = child.ParentName,
                    BusId = child.BusId,
                    Birthday = child.Birthday,
                    Gender = child.Gender,
                    Grade = child.Grade,
                    ParentalWaiver = child.ParentalWaiver,
                    ClassId = child.ClassId,
                    Picture = child.Picture,
                    BusWaiver = child.BusWaiver,
                    HaircutWaiver = child.HaircutWaiver,
                    ParentalEmailOptIn = child.ParentalEmailOptIn,
                    OrangeShirtStatus = child.OrangeShirtStatus,
                    StartDate = child.StartDate
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

        [Route("~/api/child")]
        [HttpDelete]
        public async Task<IActionResult> ChildDeletion([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Message = repo.DeleteChild(model.Id)
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

        [Route("~/api/waiver")]
        [HttpPost]
        public async Task<IActionResult> UpdateWaiver(PostWaiverModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                repo.UpdateWaiver(model.Id, model.Received);

                String Message = "The child was recorded as " + (model.Received ? "" : "not ") + "having turned in the waiver.";
                return new JsonResult(new
                {
                    Message
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

        [Route("~/api/child-attendance-check")]
        [HttpGet]
        public async Task<IActionResult> CheckAttendance([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null || !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    DaysAttended = repo.GetAttendanceDates(model.Id)
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

        [Route("~/api/suspend")]
        [HttpPost]
        public async Task<IActionResult> Suspend(PostSuspendModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            List<String> missingParameters = new List<String>();
            if (model.Id == 0)
            {
                missingParameters.Add("child id");
            }

            if (model.Start == DateTime.MinValue)
            {
                missingParameters.Add("start time");
            }

            if (model.End == DateTime.MinValue)
            {
                missingParameters.Add("end time");
            }

            if (missingParameters.Count != 0)
            {
                return Utilities.GenerateMissingInputMessage(missingParameters);
            }

            String timeframeMsg = Utilities.ValidateTimeframe(model.Start, model.End);
            if (!timeframeMsg.Equals(""))
            {
                return Utilities.ErrorJson(timeframeMsg);
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);


                return new JsonResult(new
                {
                    Message = repo.Suspend(model.Id, model.Start, model.End)
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

        [Route("~/api/suspensions")]
        [HttpGet]
        public async Task<IActionResult> Suspensions()
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Suspensions = repo.ViewSuspensions()
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

        [Route("~/api/child-current-suspension")]
        [HttpGet]
        public async Task<IActionResult> CheckChildSuspension([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    IsSuspended = repo.IsSuspended(model.Id)
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

        [Route("~/api/note")]
        [HttpPost]
        public async Task<IActionResult> Note(PostNoteModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            List<String> missingParameters = new List<String>();
            if (model.Author.Equals(""))
            {
                missingParameters.Add("author name");
            }

            if (model.ChildId == 0)
            {
                missingParameters.Add("child id");
            }

            if (model.Content.Equals(""))
            {
                missingParameters.Add("content");
            }

            if (model.Priority.Equals(""))
            {
                missingParameters.Add("priority");
            }

            if (model.Date.Equals(""))
            {
                missingParameters.Add("date");
            }

            if (missingParameters.Count > 0)
            {
                Utilities.GenerateMissingInputMessage(missingParameters);
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);
                // Email which class the child is in, which bus they are in, the priority level, and who wrote this note
                String childName = repo.GetName(model.ChildId);
                String className = repo.GetClassName(model.ChildId);
                String busName = repo.GetBusName(model.ChildId);

                String message = "A new note has been added about " + childName + " with the priority level " +
                    model.Priority + ". The child is in the class " + className + " and on the bus " + busName + ". The" +
                    " note was written by " + model.Author + ".";

                String subject = "New note: " + childName + " in class " + className + " - " + model.Priority + ".";


                // TODO: Change to occ's email
                // await EmailHelpers.SendEmail("jackienvdmmmm@knights.ucf.edu", subject, message, configModel.EmailOptions);

                repo.AddNote(model.Author, model.ChildId, model.Content, model.Date);

                return new JsonResult(new
                {
                    Error = ""
                });
            }
            catch (Exception exc)
            {
                return new JsonResult(new
                {
                    Error = exc.Message
                });
            }
        }

        [Route("~/api/note-edit")]
        [HttpPost]
        public async Task<IActionResult> NoteEdit(PostNoteEditModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Note = repo.EditNote(model.Id, model.Content)
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

        [Route("~/api/notes")]
        [HttpGet]
        public async Task<IActionResult> Notes([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Notes = repo.GetNotes(model.Id)
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

        [Route("~/api/note")]
        [HttpDelete]
        public async Task<IActionResult> NoteDeletion([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("note id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Message = repo.DeleteNote(model.Id)
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

        [Route("~/api/relation")]
        [HttpPost]
        public async Task<IActionResult> Relation(RelationModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            List<String> missingParameters = new List<String>();
            int missingIds = 0;
            if (model.ChildId1 == 0)
            {
                missingIds++;
            }

            if (model.ChildId2 == 0)
            {
                missingIds++;
            }

            if (model.Relation == null)
            {
                missingParameters.Add("relationship");
            }

            if (missingIds > 0)
            {
                missingParameters.Add(missingIds + " more child id" + (missingIds == 2 ? "s" : ""));
            }

            if (missingParameters.Count > 0)
            {
                return Utilities.GenerateMissingInputMessage(missingParameters);
            }

            if (model.ChildId1 == model.ChildId2)
            {
                return new JsonResult(new
                {
                    Error = "Children ids cannot be the same."
                });
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Message = repo.AddRelation(model)
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

        [Route("~/api/relations")]
        [HttpGet]
        public async Task<IActionResult> Relations([FromQuery] IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model == null || model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("child id");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Relatives = repo.GetRelations(model)
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

        [Route("~/api/relation")]
        [HttpDelete]
        public async Task<IActionResult> Relation(DeleteRelationModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.ChildId1 == 0 && model.ChildId2 == 0)
            {
                return Utilities.GenerateMissingInputMessage("2 more child ids are required.");
            }

            if (model.ChildId1 == 0 || model.ChildId2 == 0)
            {
                return Utilities.GenerateMissingInputMessage("1 more child id is required.");
            }

            try
            {
                ChildRepository repo = new ChildRepository(configModel.ConnectionString);

                return new JsonResult(new
                {
                    Message = repo.DeleteRelation(model)
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

        /// <summary>
        /// Gets the list of children's birthdays in the provided month.  Only accessible to staff.
        /// </summary>
        /// <param name="month">The month to check.  If a value of 0 is provided (the default), it will check the current month.</param>
        /// <returns>A list of BirthdayModel objects, each containing a name and a birthday</returns>
        [HttpGet]
        [Route("~/api/birthdays/child")]
        public async Task<IActionResult> ChildBirthdays(int month = 0)
        {
            var user = await userManager.GetUserAsync(User);
            ChildRepository repo = new ChildRepository(configModel.ConnectionString);
            List<BirthdayModel> birthdays = null;

            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            if (month < 0 || month > 12)
            {
                return Utilities.ErrorJson("Invalid month");
            }

            // Query the database
            try
            {
                if (month == 0)
                {
                    birthdays = repo.GetBirthdays(DateTime.Now.Month);
                }
                else
                {
                    birthdays = repo.GetBirthdays(month);
                }
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                Birthdays = birthdays
            });
        }
    }
}