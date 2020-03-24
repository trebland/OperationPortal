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
using Newtonsoft.Json.Linq;
using API.Models;
using API.Data;
using API.Helpers;

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

        /// <summary>
        /// Gets a list of all registered volunteers
        /// </summary>
        /// <returns>All registered volunteers</returns>
        [Route("~/api/volunteer-list")]
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> VolunteerList()
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            List<VolunteerModel> volunteers;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            try
            {
                volunteers = repo.GetVolunteers();
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(configModel.DebugMode ? e.Message : "An error occurred while accessing the database.");
            }

            return new JsonResult(new
            {
                Error = "",
                Volunteers = volunteers
            });
        }

        /// <summary>
        /// Allows for editing a volunteer's profile.  DOES NOT edit email or staff-only information (orientation, training, background check, etc.).
        /// </summary>
        /// <param name="volunteer">A VolunteerModel object containing the updated information.  Will be rejected if this is not the current user</param>
        /// <returns>An indication of any errors that occurred and the updated profile</returns>
        [Route("~/api/volunteer-profile-edit")]
        [HttpPost]
        public async Task<IActionResult> VolunteerProfileEdit(VolunteerModel volunteer) 
        {
            //TODO: discuss making email immutable
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel currentModel = repo.GetVolunteer(volunteer.Id);
            
            // Return with an error if there is no volunteer model to update or if the profile being updated is not that of the logged-in user
            if (currentModel == null)
            {
                return Utilities.ErrorJson("Profile does not exist");
            }
            if (currentModel.Email != user.UserName)
            {
                return Utilities.ErrorJson("Not authorized to edit this profile");
            }

            // Update the volunteer's languages, if any were provided
            if (volunteer.Languages != null && volunteer.Languages.Length != 0)
            {
                try
                {
                    repo.UpdateLanguages(volunteer.Id, volunteer.Languages);
                }
                catch(Exception e)
                {
                    return Utilities.ErrorJson(e.Message);
                }
            }

            // Update the volunteer's profile
            try
            {
                repo.UpdateVolunteerProfile(volunteer);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            // We want to make sure we return the most up-to-date information
            return new JsonResult(new
            {
                Volunteer = repo.GetVolunteer(volunteer.Id),
                Error = ""
            });
        }

        /// <summary>
        /// Allows for updating the administrative records for a volunteer.  Does not update trainings, which are separate
        /// </summary>
        /// <param name="v">A VolunteerModel object.  Should contain id, Orientation, BlueShirt, Nametag, PersonalInterviewCompleted, and YearStarted</param>
        /// <returns>An indication of any errors that occurred and the updated profile</returns>
        [Route("~/api/volunteer-records-edit")]
        [HttpPost]
        public async Task<IActionResult> VolunteerRecordsEdit(VolunteerModel volunteer)
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel currentModel = repo.GetVolunteer(volunteer.Id);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Return with an error if there is no volunteer model to update 
            if (currentModel == null)
            {
                return Utilities.ErrorJson("Profile does not exist");
            }

            // Update the volunteer's profile
            try
            {
                repo.UpdateVolunteerRecords(volunteer);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            // We want to make sure we return the most up-to-date information
            return new JsonResult(new
            {
                Volunteer = repo.GetVolunteer(volunteer.Id),
                Error = ""
            });
        }

        /// <summary>
        /// Allows for updating the role a user has on the site.  Accessible only to staff.
        /// </summary>
        /// <param name="data">
        /// Must be a JSON object consisting of "id" and "role".  This form is used because it isn't possible to have multiple simple type (e.g. an int
        /// and a string) parameters for a POST action in ASP.NET.
        /// id is the id of the volunteer whose role is being updated
        /// role is the name of the role they are being given.  This is validated against a list of valid roles, maintained here in the code.
        /// </param>
        /// <returns>An error string, or a blank string if no error occurs</returns>
        [Route("~/api/role-edit")]
        [HttpPost]
        public async Task<IActionResult> RoleEdit( [FromBody]JObject data)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerModel volunteer;
            UserHelpers.UserRoles userRole;
            int id;
            string role;

            try
            {
                id = data["id"].ToObject<int>();
                role = data["role"].ToString();
            }
            catch (Exception)
            {
                return Utilities.ErrorJson("Invalid input");
            }

            volunteer = repo.GetVolunteer(id);

            if (id == 0 || String.IsNullOrEmpty(role))
            {
                return Utilities.ErrorJson("Required parameter missing");
            }

            var user = await userManager.GetUserAsync(User);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Ensure the role passed in is valid
            try
            {
                userRole = (UserHelpers.UserRoles)Enum.Parse(typeof(UserHelpers.UserRoles), Utilities.NormalizeString(role));
            }
            catch(ArgumentException)
            {
                return Utilities.ErrorJson("Not a valid role");
            }

            // Get the user account of the person whose role is being updated
            var volunteerAccount = await userManager.FindByNameAsync(volunteer.Email);
            if (volunteerAccount == null)
            {
                return Utilities.ErrorJson("Error updating user account, please try again.");
            }

            if (await userManager.IsInRoleAsync(volunteerAccount, userRole.ToString()))
            {
                //return Utilities.ErrorJson("User is already in role " + userRole.ToString());
            }

            // If the role does not yet exist (e.g. no users with it have been added to the database), create it
            // The only reason I am comfortable doing this is because I check the input against the enum up above, 
            // so people cannot create arbitrary roles
            if (!(await roleManager.RoleExistsAsync(userRole.ToString())))
            {
                await roleManager.CreateAsync(new IdentityRole { Name = userRole.ToString() });
            }

            // Remove the user account's other roles and add the new one
            await userManager.RemoveFromRolesAsync(volunteerAccount, await userManager.GetRolesAsync(volunteerAccount));
            await userManager.AddToRoleAsync(volunteerAccount, userRole.ToString());
            // Update the role in the user's volunteer profile in the DB.  This one isn't as important, since it doesn't affect permissions
            repo.UpdateUserRole(volunteer.Id, (int)userRole);

            return Utilities.NoErrorJson();
        }

        [Route("~/api/volunteer-attendance-check")]
        [HttpGet]
        public async Task<IActionResult> CheckAttendance([FromQuery]IdModel model)
        {
            var user = await userManager.GetUserAsync(User);
            if (user == null || !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Id == 0)
            {
                return Utilities.GenerateMissingInputMessage("volunteer id");
            }

            try
            {
                VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);

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

        //TODO: Uncomment logic for getting guest volunteers as well
        [Route("~/api/volunteers-for-day")]
        [HttpGet]
        public async Task<IActionResult> VolunteersForDay([FromQuery]GetVolunteersForDayModel model)
        {
            var user = await userManager.GetUserAsync(User);
            List<GuestVolunteerModel> guests = null;

            if (user == null ||
               !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
               await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString())))
            {
                return Utilities.ErrorJson("Not authorized.");
            }

            if (model.Day == DateTime.MinValue)
            {
                return Utilities.GenerateMissingInputMessage("date");
            }

            try
            {
                VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);

                if (model.CheckedIn)
                {
                    // guests = repo.GetGuestVolunteers(model.Day);
                }

                return new JsonResult(new
                {
                    Volunteers = repo.GetDaysVolunteers(model.Day, model.CheckedIn, model.SignedUp),
                    Guests = guests
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
        /// Allows creating a guest volunteer whose attendance is recorded without them having to download the app and make an account
        /// </summary>
        /// <param name="guest">A GuestVolunteerModel object.  Must contain a first name, last name, and valid email address</param>
        /// <returns>An error message, or a blank string if no error occurs</returns>
        [HttpPost]
        [Route("~/api/guest-volunteer")]
        public async Task<IActionResult> GuestVolunteer(GuestVolunteerModel guest)
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Unauthorized");
            }

            // Validate inputs
            if (String.IsNullOrEmpty(guest.FirstName))
            {
                return Utilities.ErrorJson("First name is required");
            }

            if (String.IsNullOrEmpty(guest.LastName))
            {
                return Utilities.ErrorJson("Last name is required");
            }

            if (String.IsNullOrEmpty(guest.Email) || !UserHelpers.IsValidEmail(guest.Email))
            {
                return Utilities.ErrorJson("A valid email address is required");
            }

            // Add to database
            try
            {
                // TODO: Add db integration
                //repo.CreateGuestVolunteer(guest);
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        #region Volunteer training actions

        /// <summary>
        /// Creates a training volunteers can have completed
        /// </summary>
        /// <param name="training">A VolunteerTrainingModel object with a name</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-training-creation")]
        public async Task<IActionResult> VolunteerTrainingCreation(VolunteerTrainingModel training)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            var user = await userManager.GetUserAsync(User);

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate inputs
            if (String.IsNullOrEmpty(training.Name))
            {
                return Utilities.ErrorJson("Name is required");
            }

            try
            {
                repo.CreateTraining(training.Name);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Edits the name of a training
        /// </summary>
        /// <param name="training">A VolunteerTrainingModel object with an id and name</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-training-edit")]
        public async Task<IActionResult> VolunteerTrainingEdit (VolunteerTrainingModel training)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerTrainingModel dbTraining;
            var user = await userManager.GetUserAsync(User);

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate inputs
            dbTraining = repo.GetTraining(training.Id);
            if (dbTraining == null)
            {
                return Utilities.ErrorJson("Invalid id");
            }

            // If there has been no change, we can just return
            if (dbTraining.Name == training.Name)
            {
                return Utilities.NoErrorJson();
            }

            if (String.IsNullOrEmpty(training.Name))
            {
                return Utilities.ErrorJson("Name is required");
            }

            try
            {
                repo.EditTraining(training.Id, training.Name);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Deletes a training
        /// </summary>
        /// <param name="training">A VolunteerTrainingModel object with an id</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-training-delete")]
        public async Task<IActionResult> VolunteerTrainingDelete(VolunteerTrainingModel training)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerTrainingModel dbTraining;
            var user = await userManager.GetUserAsync(User);

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate inputs
            dbTraining = repo.GetTraining(training.Id);
            if (dbTraining == null)
            {
                return Utilities.ErrorJson("Invalid id");
            }

            try
            {
                repo.DeleteTraining(training.Id);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Gets the list of trainings available to be completed
        /// </summary>
        /// <returns>An error message, if applicable, and a list of VolunteerTrainingModel objects</returns>
        [HttpGet]
        [Route("~/api/volunteer-trainings")]
        public async Task<IActionResult> VolunteerTrainings()
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            List<VolunteerTrainingModel> trainings;
            var user = await userManager.GetUserAsync(User);

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            try
            {
                trainings = repo.GetTrainings();
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                Trainings = trainings
            });
        }

        /// <summary>
        /// Marks a user as having completed a training
        /// </summary>
        /// <param name="vm">A view model with a training id and volunteer id</param>
        /// <returns>An error message if applicable, or a blank string if no error occured</returns>
        [HttpPost]
        [Route("~/api/volunteer-training-complete")]
        public async Task<IActionResult> VolunteerTrainingComplete(TrainingCompletedViewModel vm)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerTrainingModel training;
            VolunteerModel profile;
            var user = await userManager.GetUserAsync(User);

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate inputs
            training = repo.GetTraining(vm.TrainingId);
            if (training == null)
            {
                return Utilities.ErrorJson("Invalid training id");
            }

            profile = repo.GetVolunteer(vm.VolunteerId);
            if (profile == null)
            {
                return Utilities.ErrorJson("Invalid volunteer id");
            }

            try
            {
                repo.AddTrainingCompleted(vm.VolunteerId, vm.TrainingId);
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Removes the record of a user as having completed a training
        /// </summary>
        /// <param name="vm">A view model with a training id and volunteer id</param>
        /// <returns>An error message if applicable, or a blank string if no error occured</returns>
        [HttpPost]
        [Route("~/api/volunteer-training-incomplete")]
        public async Task<IActionResult> VolunteerTrainingInomplete(TrainingCompletedViewModel vm)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerTrainingModel training;
            VolunteerModel profile;
            var user = await userManager.GetUserAsync(User);

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate inputs
            training = repo.GetTraining(vm.TrainingId);
            if (training == null)
            {
                return Utilities.ErrorJson("Invalid training id");
            }

            profile = repo.GetVolunteer(vm.VolunteerId);
            if (profile == null)
            {
                return Utilities.ErrorJson("Invalid volunteer id");
            }

            try
            {
                repo.RemoveTrainingCompleted(vm.VolunteerId, vm.TrainingId);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }
        #endregion

        #region Volunteer Job actions

        /// <summary>
        /// Creates a job volunteers can sign up for
        /// </summary>
        /// <param name="job">A VolunteerJobModel object with a name, min, and max</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-jobs-creation")]
        public async Task<IActionResult> VolunteerJobsCreation(VolunteerJobModel job)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            var user = await userManager.GetUserAsync(User);

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate inputs
            if (String.IsNullOrEmpty(job.Name))
            {
                return Utilities.ErrorJson("Name is required");
            }
            if (job.Min < 0)
            {
                return Utilities.ErrorJson("Minimum number of volunteers for ajob must be non-negative");
            }
            if (job.Max <= 0)
            {
                return Utilities.ErrorJson("Maximum number of volunteers for a job must be positive");
            }
            if (job.Max < job.Min)
            {
                return Utilities.ErrorJson("Maximum number of volunteers for a job cannot be less than the minimum number of volunteers");
            }

            try
            {
                repo.CreateVolunteerJob(job);
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Allows editing the stored data about a job volunteers can sign up for
        /// </summary>
        /// <param name="job">A VolunteerJobModel object, which must have a valid id, name, min, and max</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-jobs-edit")]
        public async Task<IActionResult> VolunteerJobsEdit(VolunteerJobModel job)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            var user = await userManager.GetUserAsync(User);
            VolunteerJobModel dbJob = null;

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            dbJob = repo.GetVolunteerJob(job.Id, DateTime.MinValue);

            // Get job from database to check that it exists
            if (dbJob == null)
            {
                return Utilities.ErrorJson("Invalid id");
            }

            // Validate inputs
            if (String.IsNullOrEmpty(job.Name))
            {
                return Utilities.ErrorJson("Name is required");
            }
            if (job.Min < 0)
            {
                return Utilities.ErrorJson("Minimum number of volunteers for ajob must be non-negative");
            }
            if (job.Max <= 0)
            {
                return Utilities.ErrorJson("Maximum number of volunteers for a job must be positive");
            }
            if (job.Max < job.Min)
            {
                return Utilities.ErrorJson("Maximum number of volunteers for a job cannot be less than the minimum number of volunteers");
            }

            try
            {
                repo.UpdateVolunteerJob(job);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Deletes the specified job.
        /// </summary>
        /// <param name="job">A VolunteerJobModel object, which must have a valid id</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-jobs-delete")]
        public async Task<IActionResult> VolunteerJobsDelete(VolunteerJobModel job)
        {
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            var user = await userManager.GetUserAsync(User);
            VolunteerJobModel dbJob = null;

            // Verify the user is a staff member
            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            dbJob = repo.GetVolunteerJob(job.Id, DateTime.MinValue);

            // Get job from database to check it exists
            if (dbJob == null)
            {
                return Utilities.ErrorJson("Invalid id");
            }

            try
            {
                repo.DeleteVolunteerJob(job);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Gets a list of all jobs available for volunteers to sign up for
        /// </summary>
        /// <param name="date">If a date is provided, the information provided will include how many people are signed up for a given job.  
        /// If the date is the minimum value of DateTime (the default if one is not provided), this information will not be provided.</param>
        /// <returns>An error message if an error occurred, or a blank string and a list of VolunteerJobModel objects otherwise</returns>
        [HttpGet]
        [Route("~/api/volunteer-jobs")]
        public async Task<IActionResult> VolunteerJobs(DateTime date)
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            List<VolunteerJobModel> jobs = null;

            try
            {
                jobs = repo.GetVolunteerJobs(date);

                return new JsonResult(new
                {
                    Error = "",
                    Jobs = jobs
                });
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }
        }

        /// <summary>
        /// Assigns a volunteer to a specific job.  Must be done by staff or the volunteer in question.
        /// </summary>
        /// <param name="vm">A viewmodel with a VolunteerId, JobId, and Date</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-jobs-assignment")]
        public async Task<IActionResult> VolunteerJobAssignment(JobAssignmentViewModel vm)
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerJobModel job;

            // This endpoint should only be accessible if the user is a staff member or if the user is trying to sign themselves up for a job
            if (user.VolunteerId != vm.VolunteerId && !User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Unauthorized");
            }

            if (vm.Date == DateTime.MinValue)
            {
                return Utilities.ErrorJson("Must specify a date");
            }

            if (vm.Date.DayOfWeek != DayOfWeek.Saturday)
            {
                return Utilities.ErrorJson("Jobs can only be signed up for for Saturdays");
            }

            // The first check is so we can skip a call to the database if the user is signing up for a job on their own - clearly the user id is valid in that case
            if (vm.VolunteerId != user.VolunteerId && repo.GetVolunteer(vm.VolunteerId) == null)
            {
                return Utilities.ErrorJson("Invalid volunteer id");
            }

            try
            {
                job = repo.GetVolunteerJob(vm.JobId, vm.Date);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }
            
            if (job == null)
            {
                return Utilities.ErrorJson("Invalid volunteer job id");
            }

            if (repo.CheckSignedUpForJob(vm.JobId, vm.VolunteerId, vm.Date))
            {
                return Utilities.ErrorJson("Already signed up");
            }

            if (job.CurrentNumber >= job.Max)
            {
                return Utilities.ErrorJson("Too many people are already signed up for this job");
            }

            try
            {
                repo.AddVolunteerJobAssignment(vm.VolunteerId, vm.JobId, vm.Date);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Removes a volunteer from having been assigned to a specific job.  Must be done by staff or the volunteer in question.
        /// </summary>
        /// <param name="vm">A viewmodel with a VolunteerId, JobId, and Date</param>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-jobs-removal")]
        public async Task<IActionResult> VolunteerJobRemoval(JobAssignmentViewModel vm)
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            VolunteerJobModel job;

            // This endpoint should only be accessible if the user is a staff member or if the user is trying to remove a job they have signed themselves up for
            if (user.VolunteerId != vm.VolunteerId && !User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Unauthorized");
            }

            // The first check is so we can skip a call to the database if the user is signing up for a job on their own - clearly the user id is valid in that case
            if (vm.VolunteerId != user.VolunteerId && repo.GetVolunteer(vm.VolunteerId) == null)
            {
                return Utilities.ErrorJson("Invalid volunteer id");
            }

            if (vm.Date == DateTime.MinValue)
            {
                return Utilities.ErrorJson("Must specify a date");
            }

            job = repo.GetVolunteerJob(vm.JobId, vm.Date);
            if (job == null)
            {
                return Utilities.ErrorJson("Invalid volunteer job id");
            }

            if(!repo.CheckSignedUpForJob(vm.JobId, vm.VolunteerId, vm.Date))
            {
                return Utilities.ErrorJson("Not currently signed up for this job");
            }

            if (job.CurrentNumber == job.Min)
            {
                await EmailHelpers.SendEmail("thomas.anchor@knights.ucf.edu", $"{vm.Date} - {job.Name} may be understaffed", 
                    $"A cancellation has left {job.Name} with fewer than its minimum of {job.Min} volunteers signed up.", configModel.EmailOptions);
            }

            try
            {
                repo.RemoveVolunteerJobAssignment(vm.VolunteerId, vm.JobId, vm.Date);
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Checks whether or not volunteers signing up for specific jobs is enabled
        /// </summary>
        /// <returns>A JSON object with a boolean value and an error code, if one occurred</returns>
        [HttpGet]
        [Route("~/api/volunteer-jobs-enabled")]
        public async Task<IActionResult> VolunteerJobsEnabled()
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            bool enabled = false;

            try
            {
                 enabled = repo.AreVolunteerJobsEnabled();
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                Enabled = enabled
            });
        }

        /// <summary>
        /// Toggles whether or not volunteers signing up for specific jobs is enabled
        /// </summary>
        /// <returns>An error message if an error occurred, or a blank string otherwise</returns>
        [HttpPost]
        [Route("~/api/volunteer-jobs-toggle")]
        public async Task<IActionResult> VolunteerJobsToggle()
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);

            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Unauthorized");
            }

            try
            {
                repo.ToggleVolunteerJobs();
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        #endregion

        /// <summary>
        /// Gets the list of children's birthdays in the provided month.  Only accessible to staff.
        /// </summary>
        /// <param name="month">The month to check.  If a value of 0 is provided (the default), it will check the current month.</param>
        /// <returns>A list of BirthdayModel objects, each containing a name and a birthday</returns>
        [HttpGet]
        [Route("~/api/birthdays/volunteer")]
        public async Task<IActionResult> VolunteerBirthdays(int month = 0)
        {
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository repo = new VolunteerRepository(configModel.ConnectionString);
            List<BirthdayModel> birthdays;

            if (!User.IsInRole(UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            if (month < 0 || month > 12)
            {
                return Utilities.ErrorJson("Invalid month");
            }

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
            catch(Exception e)
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