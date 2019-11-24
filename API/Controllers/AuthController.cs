using AspNet.Security.OpenIdConnect.Extensions;
using AspNet.Security.OpenIdConnect.Primitives;
using AspNet.Security.OpenIdConnect.Server;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using OpenIddict.Abstractions;
using OpenIddict.Core;
using OpenIddict.EntityFrameworkCore.Models;
using System.Linq;
using System.Threading.Tasks;
using API.Models;

namespace OCCTest.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly OpenIddictApplicationManager<OpenIddictApplication> applicationManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly UserManager<ApplicationUser> userManager;
        private readonly RoleManager<IdentityRole> roleManager;

        public AuthController(
            OpenIddictApplicationManager<OpenIddictApplication> applicationManager,
            SignInManager<ApplicationUser> signInManager,
            UserManager<ApplicationUser> userManager,
            RoleManager<IdentityRole> roleManager)
        {
            this.applicationManager = applicationManager;
            this.signInManager = signInManager;
            this.userManager = userManager;
            this.roleManager = roleManager;
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> Token(OpenIdConnectRequest requestModel)
        {
            if (!requestModel.IsPasswordGrantType())
            {
                // Return bad request if the request is not for password grant type
                return BadRequest(new OpenIdConnectResponse
                {
                    Error = OpenIdConnectConstants.Errors.UnsupportedGrantType,
                    ErrorDescription = "The specified grant type is not supported."
                });
            }

            var user = await userManager.FindByNameAsync(requestModel.Username);

            if (user == null)
            {
                // Return bad request if the user doesn't exist
                return BadRequest(new OpenIdConnectResponse
                {
                    Error = OpenIdConnectConstants.Errors.InvalidGrant,
                    ErrorDescription = "Invalid username or password"
                });
            }

            await userManager.AddToRoleAsync(user, "Volunteer");

            // Check that the user can sign in and is not locked out.
            // If two-factor authentication is supported, it would also be appropriate to check that 2FA is enabled for the user
            if (!await signInManager.CanSignInAsync(user) || (userManager.SupportsUserLockout && await userManager.IsLockedOutAsync(user)))
            {
                // Return bad request is the user can't sign in
                return BadRequest(new OpenIdConnectResponse
                {
                    Error = OpenIdConnectConstants.Errors.InvalidGrant,
                    ErrorDescription = "The specified user cannot sign in."
                });
            }

            if (!await userManager.CheckPasswordAsync(user, requestModel.Password))
            {
                // Return bad request if the password is invalid
                return BadRequest(new OpenIdConnectResponse
                {
                    Error = OpenIdConnectConstants.Errors.InvalidGrant,
                    ErrorDescription = "Invalid username or password"
                });
            }

            // The user is now validated, so reset lockout counts, if necessary
            if (userManager.SupportsUserLockout)
            {
                await userManager.ResetAccessFailedCountAsync(user);
            }

            // Create the principal
            var principal = await signInManager.CreateUserPrincipalAsync(user);

            // Claims will not be associated with specific destinations by default, so we must indicate whether they should
            // be included or not in access and identity tokens.
            foreach (var claim in principal.Claims)
            {
                // For this sample, just include all claims in all token types.
                // In reality, claims' destinations would probably differ by token type and depending on the scopes requested.
                claim.SetDestinations(OpenIdConnectConstants.Destinations.AccessToken, OpenIdConnectConstants.Destinations.IdentityToken);
            }

            // Create a new authentication ticket for the user's principal
            var ticket = new AuthenticationTicket(
                principal,
                new AuthenticationProperties(),
                OpenIdConnectServerDefaults.AuthenticationScheme);

            // Include resources and scopes, as appropriate
            var scope = new[]
            {
                OpenIdConnectConstants.Scopes.OpenId,
                OpenIdConnectConstants.Scopes.Email,
                OpenIdConnectConstants.Scopes.Profile,
                OpenIdConnectConstants.Scopes.OfflineAccess,
                OpenIddictConstants.Scopes.Roles
            }.Intersect(requestModel.GetScopes());

            ticket.SetScopes(scope);

            // Sign in the user
            return SignIn(ticket.Principal, ticket.Properties, ticket.AuthenticationScheme);
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> Register(RegisterViewModel newUser)
        {
            ApplicationUser user = new ApplicationUser
            {
                UserName = newUser.Email,
                FirstName = newUser.FirstName,
                LastName = newUser.LastName,
                Email = newUser.Email
            };

            if (!await roleManager.RoleExistsAsync("Volunteer"))
            {
                await roleManager.CreateAsync(new IdentityRole { Name = "Volunteer" });
            }

            IdentityResult result = await userManager.CreateAsync(user, newUser.Password);

            if (result.Succeeded)
            {
                user = await userManager.FindByNameAsync(user.UserName);

                await userManager.AddToRoleAsync(user, "Volunteer");
            }
            else
            {
                foreach (var error in result.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }

                return BadRequest(ModelState);
            }

            return Ok();
        }
    }
}