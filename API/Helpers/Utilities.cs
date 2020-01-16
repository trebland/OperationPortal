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
        /// Generates a JSON message returning an error and nothing else
        /// </summary>
        /// <param name="ErrorMessage">The error message to be sent in the JSON</param>
        /// <returns>JSON-encoded error message</returns>
        public static JsonResult ErrorJson(string ErrorMessage)
        {
            return new JsonResult(new
            {
                Error = ErrorMessage
            });
        }

        /// <summary>
        /// Normalizes a string by ensuring the first letter is capitalized and the rest are lower case
        /// </summary>
        /// <param name="str">The string to be normalized</param>
        /// <returns>The normalized string</returns>
        public static string NormalizeString(string str)
        {
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
