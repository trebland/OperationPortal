using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class BusModel
    {
        public int Id { get; set; }
        public int DriverId { get; set; }
        public string DriverName { get; set; }
        public byte[] DriverPicture { get; set; }
        public string Name { get; set; }
        public string Route { get; set; }
        public DateTime LastOilChange { get; set; }
        public DateTime LastTireChange { get; set; }
        public DateTime LastMaintenance { get; set; }
    }
}
