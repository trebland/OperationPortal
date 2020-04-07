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

        /// <summary>
        /// Gets the information for the calendar overview for a specific month
        /// </summary>
        /// <param name="monthModel">Should contain a month and year.  If either is blank, they will default to the current month or year, respectively</param>
        /// <returns>A list of groups and a list of events</returns>
        [AllowAnonymous]
        [Route("~/api/calendar")]
        [HttpGet]
        public async Task<IActionResult> Get(int month, int year)
        {
            List<EventModel> events;
            List<GroupModel> groups;
            List<DateTime> scheduledDates = null;
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);
            //int month;
            //int year;

            var user = await userManager.GetUserAsync(User);

            // If a month was not specified, use the current month
            if (month == 0 || month > 12)
            {
                month = DateTime.Now.Month;
            }
            if (year == 0)
            {
                year = DateTime.Now.Year;
            }

            try
            {
                events = repo.GetEvents(month, year);
                groups = repo.GetGroups(month, year);
                if (user != null && (User.IsInRole(UserHelpers.UserRoles.Volunteer.ToString()) || User.IsInRole(UserHelpers.UserRoles.VolunteerCaptain.ToString()))){
                    scheduledDates = repo.GetScheduledDates(user.VolunteerId, month, year);
                }
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new {
                Groups = groups,
                Events = events,
                ScheduledDates = scheduledDates,
                Error = ""
            });
        }

        /// <summary>
        /// Gets detailed calendar information for a specific date
        /// </summary>
        /// <param name="date">The date to get details for</param>
        /// <returns>
        /// A list of events, a list of groups, whether the user is scheduled to volunteer, a list of absences, and a list of scheduled volunteers.
        /// Depending on the user's level of permissions, some of the above may be null or less detailed
        /// </returns>
        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> Details(DateModel date)
        {
            List<EventModel> events = null;
            List<GroupModel> groups = null;
            List<VolunteerModel> volunteers = null;
            List<VolunteerModel> absences = null;
            List<VolunteerJobModel> jobs = null;
            AttendanceModel attendance;
            DateTime dateTime = date.Date;
            CalendarRepository calendarRepo = new CalendarRepository(configModel.ConnectionString);
            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);
            bool staff;
            bool busDriver;
            bool volunteer;
            bool scheduled = false;
            bool isSaturday = (dateTime.DayOfWeek == DayOfWeek.Saturday);
            var user = await userManager.GetUserAsync(User);

            // Check if the user is in the volunteer role, as all other roles are considered to be present unless specified otherwise
            volunteer = (user != null && User.IsInRole(UserHelpers.UserRoles.Volunteer.ToString()));

            // Check if the user is in the staff or bus driver roles, as those must be treated differently
            staff = (user != null && User.IsInRole(UserHelpers.UserRoles.Staff.ToString()));
            busDriver = (user != null && User.IsInRole(UserHelpers.UserRoles.Staff.ToString()));

            // All roles except volunteers are considered scheduled by default
            if (user != null && !volunteer)
            {
                scheduled = true;
            }

            // Get the events occurring on this date, if any.  We only want to get the list of attendees if the user is a staff user
            events = calendarRepo.GetEvents(dateTime, staff);
            // If it isn't a saturday, events are all we need to check.
            if (!isSaturday)
            {
                return new JsonResult(new
                {
                    Error = "",
                    Events = events,
                    Groups = groups,
                    People = volunteers,
                    Scheduled = scheduled,
                    Jobs = jobs
                });
            }

            // Get any groups volunteering on this date.  Again, we only get details if the user is staff.
            groups = calendarRepo.GetGroups(dateTime, staff);

            //  If the user is not logged in, we have all of the information already and can simply return.
            if (user == null)
            {
                return new JsonResult(new
                {
                    Error = "",
                    Events = events,
                    Groups = groups,
                    People = volunteers,
                    Scheduled = scheduled,
                    Jobs = jobs
                });
            }

            if (volunteerRepo.AreVolunteerJobsEnabled())
            {
                try
                {
                    jobs = volunteerRepo.GetVolunteerJobs(dateTime, staff);
                }
                catch (Exception e)
                {
                    return Utilities.ErrorJson(e.Message);
                }
            }
            else
            {
                jobs = null;
            }

            // If the user is a volunteer, check if they are scheduled on this day.  Bus drivers, volunteer captains, and staff are considered scheduled by default
            if (volunteer)
            {
                attendance = calendarRepo.GetSingleAttendance(user.VolunteerId, dateTime);
                if (attendance != null && attendance.Scheduled)
                {
                    scheduled = true;
                }
                else
                {
                    scheduled = false;
                }
            }
            else
            {
                attendance = calendarRepo.GetSingleAttendance(user.VolunteerId, dateTime);
                if (attendance != null && !attendance.Scheduled)
                {
                    scheduled = false;
                }
                else
                {
                    scheduled = true;
                }
            }

            // If the user is not staff, we now want to return
            if (!staff)
            {
                return new JsonResult(new
                {
                    Error = "",
                    Events = events,
                    Groups = groups,
                    People = volunteers,
                    Scheduled = scheduled,
                    Jobs = jobs
                });
            }

            // If the user is staff, get the list of volunteers who will be attending and people who have said they will not be attending, and the jobs that have people signed up for them
            try
            {
                volunteers = volunteerRepo.GetScheduledVolunteers(dateTime);
                absences = volunteerRepo.GetAbsences(dateTime);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                Events = events,
                Groups = groups,
                People = volunteers,
                Absences = absences,
                Scheduled = scheduled,
                Jobs = jobs
            });
        }

        /// <summary>
        /// Allows a user to sign up to indicate they will be at OCC on a specified date
        /// </summary>
        /// <param name="date">The day the user is attending</param>
        /// <returns>An error message, if an error occurs.  Otherwise, a blank string.</returns>
        [Route("~/api/calendar/signup/single")]
        [HttpPost]
        public async Task<IActionResult> SignupSingle(DateModel date)
        {
            var user = await userManager.GetUserAsync(User);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);
            AttendanceModel attendance = repo.GetSingleAttendance(user.VolunteerId, date.Date);

            if (date.Date.DayOfWeek != DayOfWeek.Saturday)
            {
                return Utilities.ErrorJson("Provided date was not a Saturday");
            }

            if (attendance != null && attendance.Scheduled)
            {
                return Utilities.ErrorJson("You are already scheduled on this date");
            }

            if (attendance == null)
            {
                try
                {
                    repo.InsertAttendance(new AttendanceModel
                    {
                        VolunteerId = user.VolunteerId,
                        DayAttended = date.Date,
                        Scheduled = true,
                        Attended = false,
                    });
                }
                catch (Exception e)
                {
                    return Utilities.ErrorJson(e.Message);
                }
            }
            else
            {
                try
                {
                    repo.UpdateScheduled(attendance.Id, true);
                }
                catch (Exception e)
                {
                    return Utilities.ErrorJson(e.Message);
                }
            }

            return new JsonResult(new
            {
                Error = ""
            });
        }

        /// <summary>
        /// Allows a user to indicate they will not be present on a day they had previously signed up for.
        /// </summary>
        /// <param name="date">The date the user will not be present</param>
        /// <returns>An error message, if one occurred.  Otherwise, a blank string.</returns>
        [Route("~/api/calendar/cancellation/single")]
        [HttpPost]
        public async Task<IActionResult> CancelSingle(DateModel date)
        {
            var user = await userManager.GetUserAsync(User);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);
            VolunteerRepository volunteerRepo = new VolunteerRepository(configModel.ConnectionString);
            AttendanceModel attendance = repo.GetSingleAttendance(user.VolunteerId, date.Date);
            VolunteerModel profile;

            if (date.Date.DayOfWeek != DayOfWeek.Saturday)
            {
                return Utilities.ErrorJson("Provided date was not a Saturday");
            }

            if (User.IsInRole(UserHelpers.UserRoles.BusDriver.ToString()))
            {
                try
                {
                    profile = volunteerRepo.GetVolunteer(user.VolunteerId);
                    await EmailHelpers.SendEmail("thomas.anchor@knights.ucf.edu", "Bus Driver Cancellation",
                        $"A bus driver ({profile.FirstName} {profile.LastName}) has been marked as not attending on {date.Date.ToString("dd/MM/yyyy")}.  Please update bus assignments accordingly.",
                        configModel.EmailOptions);
                }
                catch (Exception e)
                {
                    return Utilities.ErrorJson(e.Message);
                }
            }
            // If the user is a volunteer, has not previously scheduled themselves for this day, and is not a class teacher, no need to hit the DB,
            // Since volunteers are assumed to not be present until they indicate otherwise
            else if (User.IsInRole(UserHelpers.UserRoles.Volunteer.ToString()) && (attendance == null || !attendance.Scheduled) && !volunteerRepo.VolunteerIsClassTeacher(user.VolunteerId))
            {
                return Utilities.ErrorJson("You are not currently scheduled on this date");
            }

            try
            {
                if (attendance != null)
                {
                    repo.UpdateScheduled(attendance.Id, false);
                }
                else
                {
                    repo.InsertAttendance(new AttendanceModel
                    {
                        VolunteerId = user.VolunteerId,
                        DayAttended = date.Date,
                        Scheduled = false,
                        Attended = false,
                    });
                }
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

        /// <summary>
        /// Allows staff to sign up a group (a youth group, school group, etc.) up to volunteer on a Saturday
        /// </summary>
        /// <param name="vm">
        /// A viewmodel consisting of two main parts: a DateTime (called date) and a GroupModel object.
        /// The GroupModel must have a name, count, leadername, email, and phone.
        /// The DateTime cannot be DateTime.MinValue (the default if one is not provided)
        /// </param>
        /// <returns>An error message, or a blank string if no error occurred</returns>
        [Route("~/api/calendar/signup/group")]
        [HttpPost]
        public async Task<IActionResult> SignupGroup(GroupSignupViewModel vm)
        {
            var user = await userManager.GetUserAsync(User);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Verify that all of the inputs are valid
            // Note that I check if the date is equal to DateTime.MinValue, not null, as DateTime cannot be null in C#
            if (String.IsNullOrEmpty(vm.Group.Name) || String.IsNullOrEmpty(vm.Group.LeaderName) || String.IsNullOrEmpty(vm.Group.Email)
                || String.IsNullOrEmpty(vm.Group.Phone) || vm.Date == DateTime.MinValue)
            {
                return Utilities.ErrorJson("Name, Leader Name, Email, Phone, and Date are all required.");
            }

            // Check that there are not 0 (or fewer, in the case of fake inputs) volunteers in the group
            if (vm.Group.Count <= 0)
            {
                return Utilities.ErrorJson("Groups must not have no volunteers");
            }

            // Verify that the specified date is a saturday
            if (vm.Date.DayOfWeek != DayOfWeek.Saturday)
            {
                return Utilities.ErrorJson("Date provided should be for a Saturday");
            }

            // Insert the group into the database
            try
            {
                repo.CreateGroup(vm.Date, vm.Group);
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

        /// <summary>
        /// Allows staff to delete the record of a group (a youth group, school group, etc.) having signed up to volunteer on a Saturday
        /// </summary>
        /// <param name="vm">
        /// A viewmodel consisting of two main parts: a DateTime (called date) and a group id.
        /// The DateTime cannot be DateTime.MinValue (the default if one is not provided)
        /// </param>
        /// <returns>An error message, or a blank string if no error occurred</returns>
        [Route("~/api/calendar/cancellation/group")]
        [HttpPost]
        public async Task<IActionResult> CancelGroup(GroupCancelViewModel vm)
        {
            var user = await userManager.GetUserAsync(User);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Check that all inputs were provided
            if (vm.Date == DateTime.MinValue)
            {
                return Utilities.ErrorJson("Must provide a date");
            }
            if (vm.GroupId == 0)
            {
                return Utilities.ErrorJson("Must provide a group ID");
            }

            // Check if the group is actually signed up on this date
            if (!repo.CheckGroupSignup(vm.Date, vm.GroupId))
            {
                return Utilities.ErrorJson("This group is not signed up on this date.");
            }

            // Delete the record of having signed up from the database
            try
            {
                repo.DeleteGroupSignup(vm.Date, vm.GroupId);
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

        /// <summary>
        /// Allows OCC staff to create a new event, which users can sign up to attend
        /// </summary>
        /// <param name="newEvent">An EventModel object containing the information about the new event.  MUST include name and date, description is optional</param>
        /// <returns>An error message if an error occured, or an empty string otherwise.</returns>
        [Route("~/api/calendar/event-creation")]
        [HttpPost]
        public async Task<IActionResult> EventCreation(EventModel newEvent)
        {
            var user = await userManager.GetUserAsync(User);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate that the required fields (name and date) are filled out.
            // Note that in C#, DateTimes are never null, so instead of checking for null, we check for DateTime.MinValue, which is the 
            // default value that ASP.NET's model binding will provide if the date is not included in the API call.
            if (newEvent.Date == DateTime.MinValue || String.IsNullOrEmpty(newEvent.Name))
            {
                return Utilities.ErrorJson("The event must have both a name and a date");
            }


            // Insert the new event into the database
            try
            {
                repo.CreateEvent(newEvent.Name, newEvent.Date, String.IsNullOrEmpty(newEvent.Description) ? "" : newEvent.Description);
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

        /// <summary>
        /// Allows OCC staff to edit the details (date, description, and/or name) of an event
        /// </summary>
        /// <param name="eventModel">An EventModel object.  MUST contain a valid event id, a name, and a date.  Description is optional.</param>
        /// <returns>An error message, or if no error occurred, a blank string.</returns>
        [Route("~/api/calendar/event-edit")]
        [HttpPost]
        public async Task<IActionResult> EventEdit(EventModel eventModel)
        {
            var user = await userManager.GetUserAsync(User);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);
            EventModel dbEvent;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate that the required fields (name and date) are filled out.
            // Note that in C#, DateTimes are never null, so instead of checking for null, we check for DateTime.MinValue, which is the 
            // default value that ASP.NET's model binding will provide if the date is not included in the API call.
            if (eventModel.Date == DateTime.MinValue || String.IsNullOrEmpty(eventModel.Name))
            {
                return Utilities.ErrorJson("The event must have both a name and a date");
            }
            if (eventModel.Id == 0)
            {
                return Utilities.ErrorJson("Must specify an event to edit");
            }

            // If the description is null, set it to an empty string instead just to avoid nulls in the database
            if (String.IsNullOrEmpty(eventModel.Description))
            {
                eventModel.Description = "";
            }

            // Get the existing event in the database
            dbEvent = repo.GetEvent(eventModel.Id);

            // Check that the event to be edited actually exists
            if (dbEvent == null)
            {
                return Utilities.ErrorJson("Specified event does not exist");
            }

            // Update the event in the database
            try
            {
                repo.UpdateEvent(eventModel);
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

        /// <summary>
        /// Allows volunteers, volunteer captains, and bus drivers to sign up for events
        /// </summary>
        /// <param name="eventId">The id of the event being signed up for</param>
        /// <returns></returns>
        [Route("~/api/calendar/signup/event")]
        [HttpPost]
        public async Task<IActionResult> SignupEvent(EventViewModel eventViewModel)
        {
            int eventId = eventViewModel.eventId;
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository volRepo = new VolunteerRepository(configModel.ConnectionString);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);
            VolunteerModel volunteer;
            EventModel eventModel;
            EventSignupModel signup;

            // Ensure that ONLY volunteer, volunteer captain, and bus driver accounts have access to this API endpoint
            if (user == null || 
                !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Volunteer.ToString()) || 
                await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
                await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString())))
            {
                return Utilities.ErrorJson("Event signup is available only to volunteers, volunteer captains, and bus drivers");
            }

            volunteer = volRepo.GetVolunteer(user.VolunteerId);

            if (volunteer == null)
            {
                return Utilities.ErrorJson("Unable to find volunteer profile");
            }

            eventModel = repo.GetEvent(eventId);

            // Verify that the specified event exists
            if (eventModel == null)
            {
                return Utilities.ErrorJson("Specified event does not exist.");
            }

            // Check if there is already a record of this user having signed up 
            signup = repo.GetEventSignup(eventId, volunteer.Id);

            if (signup == null)
            {
                // If there is no record of the user signing up, insert a new record into the database
                try
                {
                    repo.CreateEventSignup(eventId, volunteer.Id);
                }
                catch(Exception e)
                {
                    return Utilities.ErrorJson(e.Message);
                }
            }
            else
            {
                // Otherwise the user is already signed up, so we want to tell them
                return Utilities.ErrorJson("You are already signed up for this event");
            }

            return new JsonResult(new
            {
                Error = ""
            });
        }

        /// <summary>
        /// Allows volunteers, volunteer captains, and bus drivers to indicate they will not be attending an event they had 
        /// previously signed up for.
        /// </summary>
        /// <param name="eventId">The id of the event the user is no longer attending</param>
        /// <returns></returns>
        [Route("~/api/calendar/cancellation/event")]
        [HttpPost]
        public async Task<IActionResult> CancelEvent(EventViewModel eventViewModel)
        {
            int eventId = eventViewModel.eventId;
            var user = await userManager.GetUserAsync(User);
            VolunteerRepository volRepo = new VolunteerRepository(configModel.ConnectionString);
            CalendarRepository repo = new CalendarRepository(configModel.ConnectionString);
            VolunteerModel volunteer;
            EventModel eventModel;
            EventSignupModel signup;

            // Ensure that ONLY volunteer, volunteer captain, and bus driver accounts have access to this API endpoint
            if (user == null ||
                !(await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Volunteer.ToString()) ||
                await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.VolunteerCaptain.ToString()) ||
                await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.BusDriver.ToString())))
            {
                return Utilities.ErrorJson("Event signup is available only to volunteers, volunteer captains, and bus drivers");
            }

            volunteer = volRepo.GetVolunteer(user.VolunteerId);

            if (volunteer == null)
            {
                return Utilities.ErrorJson("Unable to find volunteer profile");
            }

            eventModel = repo.GetEvent(eventId);

            // Verify that the specified event exists
            if (eventModel == null)
            {
                return Utilities.ErrorJson("Specified event does not exist.");
            }

            // Check if there is already a record of this user having signed up 
            signup = repo.GetEventSignup(eventId, volunteer.Id);

            if (signup == null)
            {
                // If no record exists of the user signing up, or they have already cancelled, then let them know
                return Utilities.ErrorJson("You are not signed up for this event");
            }
            else
            {
                // Otherwise, update the record to indicate non-attendance
                repo.DeleteEventSignup(eventId, volunteer.Id);
            }

            return new JsonResult(new
            {
                Error = ""
            });
        }
    }
}