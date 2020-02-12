using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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

        /// <param name="missing">List of required parameters missing from the arguments that were passed</param>
        /// <returns>JsonResult with Error field that lists all of the missing fields</returns>
        public static JsonResult GenerateMissingInputMessage(List<String> missing)
        {
            if (missing.Count == 1)
            {
                return GenerateMissingInputMessage(missing[0]);
            }

            StringBuilder sb = new StringBuilder(missing[0]);
            if (missing.Count == 2)
            {
                sb.Append(" and " + missing[1]);
            } 
            
            else
            {
                for (int i = 1; i < missing.Count - 1; i++)
                {
                    sb.Append(", " + missing[i]);
                }

                sb.Append(", and " + missing[missing.Count - 1]);
            }

            String missingParameters = sb.ToString();

            // Sentence case
            missingParameters = char.ToUpper(missingParameters[0]) + missingParameters.Substring(1).ToLower();

            return new JsonResult(new
            {
                Error = missingParameters + " are required."
            });
        }

        public static JsonResult GenerateMissingInputMessage(String missing)
        {
            // Sentence case
            missing = char.ToUpper(missing[0]) + missing.Substring(1).ToLower();

            return new JsonResult(new
            {
                Error = missing + " is required."
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

        public static string ValidateTimeframe(DateTime start, DateTime end)
        {
            if (start > end)
            {
                return "Start time occurs after end time.";
            }

            // Valid timeframe
            return "";
        }

    }
}
