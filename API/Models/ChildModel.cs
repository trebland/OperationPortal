using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class ChildModel
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Gender { get; set; }
        public int? Grade { get; set; }
        public Pair Class { get; set; }
        public Pair Bus { get; set; }
        public string Birthday { get; set; }
        public string PictureUrl { get; set; }
        public bool WaiverReceived { get; set; }
        public DateTime? SuspendedStart { get; set; }
        public DateTime? SuspendedEnd { get; set; }
        public List<int> Relatives { get; set; } // IDs of relatives
        public List<DateTime> DatesAttended { get; set; }
        public string Notes { get; set; }
        public bool IsSuspended { get; set; }
    }
}