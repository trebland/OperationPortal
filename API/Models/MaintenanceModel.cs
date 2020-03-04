using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class MaintenanceModel
    {
        public int Id { get; set; }
        public int BusId { get; set; }
        public string Text { get; set; }
        public bool Resolved { get; set; }
        public string AddedBy { get; set; }
    }
}
