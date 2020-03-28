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
    public class ClassController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly ConfigurationModel configModel;

        public ClassController(
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
        /// Gets the details about a particular class
        /// </summary>
        /// <param name="vm">A ClassModel that serves as a viewmodel.  Must have an "id" field with the class' id</param>
        /// <returns>An error string, if applicable, or the class in JSON form</returns>
        [Route("~/api/class-info")]
        [HttpGet]
        public async Task<IActionResult> ClassInfo(int id)
        {
            var user = await userManager.GetUserAsync(User);
            ClassRepository repo = new ClassRepository(configModel.ConnectionString);
            ClassModel classModel;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            if (id == 0)
            {
                return Utilities.ErrorJson("Must include a class id");
            }

            classModel = repo.GetClass(id);

            if (classModel == null)
            {
                return Utilities.ErrorJson("That class does not exist");
            }

            return new JsonResult(new
            {
                Class = classModel,
                Error = ""
            });
        }

        /// <summary>
        /// Lists all classes stored in the system
        /// </summary>
        /// <returns>If an error occurred, an error message.  Otherwise, a blank error message and a JSON-formatted array of classes.</returns>
        [Route("~/api/class-list")]
        [HttpGet]
        public async Task<IActionResult> ClassList()
        {
            var user = await userManager.GetUserAsync(User);
            ClassRepository repo = new ClassRepository(configModel.ConnectionString);
            List<ClassModel> classes;

            bool staff = await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString());

            try
            {
                classes = repo.GetClasses(staff);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return new JsonResult(new
            {
                Error = "",
                Classes = classes
            });
        }

        /// <summary>
        /// Creates a new class
        /// </summary>
        /// <param name="newClass">A ClassModel object with a teacherid and a name</param>
        /// <returns>An error message, if applicable</returns>
        [HttpPost]
        [Route("~/api/class-creation")]
        public async Task<IActionResult> ClassCreation(ClassModel newClass)
        {
            var user = await userManager.GetUserAsync(User);
            ClassRepository repo = new ClassRepository(configModel.ConnectionString);
            VolunteerRepository vRepo = new VolunteerRepository(configModel.ConnectionString);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate that a name was provided
            if (String.IsNullOrEmpty(newClass.Name))
            {
                return Utilities.ErrorJson("Name is required");
            }

            // Validate that a valid teacher ID was provided
            if (newClass.TeacherId == 0 || vRepo.GetVolunteer(newClass.TeacherId) == null)
            {
                return Utilities.ErrorJson("Must include a valid teacher Id");
            }

            // Send to the database
            try
            {
                repo.CreateClass(newClass.Name, newClass.Location == null ? "" : newClass.Location, newClass.TeacherId);
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Creates a new class
        /// </summary>
        /// <param name="model">A ClassModel object with an id and a name</param>
        /// <returns>An error message, if applicable</returns>
        [HttpPost]
        [Route("~/api/class-edit")]
        public async Task<IActionResult> ClassEdit(ClassModel model)
        {
            var user = await userManager.GetUserAsync(User);
            ClassRepository repo = new ClassRepository(configModel.ConnectionString);
            ClassModel dbClass;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Validate that a name was provided
            if (String.IsNullOrEmpty(model.Name))
            {
                return Utilities.ErrorJson("Name is required");
            }

            // Verify that a valid class id was provided
            dbClass = repo.GetClass(model.Id);
            if (dbClass == null)
            {
                return Utilities.ErrorJson("Invalid class id");
            }

            // Send to the database
            try
            {
                repo.UpdateClass(model.Id, model.Name, model.Location == null ? "" : model.Location);
            }
            catch (Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Deletes a class
        /// </summary>
        /// <param name="model">A ClassModel object with the id of the class to be deleted</param>
        /// <returns>An error message, if applicable</returns>
        [HttpPost]
        [Route("~/api/class-delete")]
        public async Task<IActionResult> ClassDelete(ClassModel model)
        {
            var user = await userManager.GetUserAsync(User);
            ClassRepository repo = new ClassRepository(configModel.ConnectionString);
            ClassModel dbClass;

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Verify that a valid class id was provided
            dbClass = repo.GetClass(model.Id);
            if (dbClass == null)
            {
                return Utilities.ErrorJson("Invalid class id");
            }

            try
            {
                repo.DeleteClass(model.Id);
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }

        /// <summary>
        /// Updates the teacher assigned to teach a class
        /// </summary>
        /// <param name="model">A ClassModel object with id and teacherId</param>
        /// <returns>An error string, if applicable</returns>
        [HttpPost]
        [Route("~/api/class-teacher-assignment")]
        public async Task<IActionResult> ClassTeacherAssignment(ClassModel model)
        {
            var user = await userManager.GetUserAsync(User);
            ClassRepository repo = new ClassRepository(configModel.ConnectionString);
            VolunteerRepository vRepo = new VolunteerRepository(configModel.ConnectionString);

            // Ensure that ONLY staff accounts have access to this API endpoint
            if (user == null || !await userManager.IsInRoleAsync(user, UserHelpers.UserRoles.Staff.ToString()))
            {
                return Utilities.ErrorJson("Not authorized");
            }

            // Make sure the provided class and volunteer ids are valid
            if (model.Id == 0 || repo.GetClass(model.Id) == null)
            {
                return Utilities.ErrorJson("Must include a valid class ID");
            }
            if (model.TeacherId == 0 || vRepo.GetVolunteer(model.TeacherId) == null)
            {
                return Utilities.ErrorJson("Must include a valid volunteer id as TeacherId");
            }

            // Update in the database
            try
            {
                repo.AssignTeacher(model.Id, model.TeacherId);
            }
            catch(Exception e)
            {
                return Utilities.ErrorJson(e.Message);
            }

            return Utilities.NoErrorJson();
        }
    }
}
