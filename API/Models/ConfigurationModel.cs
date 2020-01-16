using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class ConfigurationModel
    {
        public string ConnectionString { get; set; }
        public bool DebugMode { get; set; }
    }
}
