using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class BusModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Route { get; set; }
        public DateTime LastOilChange { get; set; }
        public DateTime LastTireChange { get; set; }
        public DateTime LastMaintenance { get; set; }
        public List<MaintenanceForm> MaintenanceForms { get; set; }
    }

    public class MaintenanceForm
    {
        public int Id { get; set; }
        public string Comments { get; set; }
    }
}
