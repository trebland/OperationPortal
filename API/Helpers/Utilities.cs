using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Helpers
{
    public class Utilities
    {
        /// <summary>
        /// Generates a JSON message returning an error with a BAD REQUEST code and nothing else
        /// </summary>
        /// <param name="ErrorMessage">The error message to be sent in the JSON</param>
        /// <returns>JSON-encoded error message</returns>
        public static ActionResult ErrorJson(string ErrorMessage)
        {
            return new BadRequestObjectResult(new
            {
                Error = ErrorMessage
            });
        }

        /// <summary>
        /// Generates a JSON message with an empty error message and nothing else
        /// </summary>
        /// <returns>JSON-encoded error message</returns>
        public static JsonResult NoErrorJson()
        {
            return new JsonResult(new
            {
                Error = ""
            });
        }

        /// <summary>
        /// Normalizes a string by ensuring the first letter is capitalized and the rest are lower case
        /// </summary>
        /// <param name="str">The string to be normalized</param>
        /// <returns>The normalized string</returns>
        public static string NormalizeString(string str)
        {
            // Special cases for roles that require extra normalization, since there isn't really a way to programmatically determine where to capitalize mid-string
            if (str.ToLower() == UserHelpers.UserRoles.BusDriver.ToString().ToLower())
            {
                return UserHelpers.UserRoles.BusDriver.ToString();
            }
            if (str.ToLower() == UserHelpers.UserRoles.VolunteerCaptain.ToString().ToLower())
            {
                return UserHelpers.UserRoles.VolunteerCaptain.ToString();
            }

            if (String.IsNullOrEmpty(str))
            {
                return String.Empty;
            }

            if (str.Length < 2)
            {
                return str.ToUpper();
            }

            return (Char.ToUpper(str[0]) + str.Substring(1).ToLower());
        }
    }
}
