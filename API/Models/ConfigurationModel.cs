using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class ConfigurationModel
    {
        public string ConnectionString { get; set; }

        public string Environment { get; set; }
        public bool DebugMode { get; set; }
        public EmailConfig EmailOptions { get; set; }
    }

    public class EmailConfig
    {
        public string Server { get; set; }
        public string Name { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
    }
}
