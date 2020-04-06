using System;
using System.Collections.Generic;
using System.IO;
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
        public string Birthday { get; set; }
        public bool ParentalWaiver { get; set; }
        public Pair Bus { get; set; }
        public Pair Class { get; set; }
        public byte[] Picture { get; set; }
        public string PreferredName { get; set; }
        public bool BusWaiver { get; set; }
        public bool HaircutWaiver { get; set; }
        public bool ParentalEmailOptIn { get; set; }
        public string ParentName { get; set; }
        public string ContactNumber { get; set; }
        public string OrangeShirt { get; set; }
        public bool WaiverReceived { get; set; }
        public DateTime? SuspendedStart { get; set; }
        public DateTime? SuspendedEnd { get; set; }
        public bool IsSuspended { get; set; }
        public bool IsCheckedIn { get; set; }
        public DateTime LastDateAttended { get; set; }
    }
}