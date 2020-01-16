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
        public int Grade { get; set; }
        public int Class { get; set; }
        public int Bus { get; set; }
        public string Birthday { get; set; }
        public string PictureUrl { get; set; }
        public bool WaiverReceived { get; set; }
        public DateTime? SuspendedStart { get; set; }
        public DateTime? SuspendedEnd { get; set; }
        public List<int> Relatives { get; set; } // IDs of relatives
        public List<DateTime> DatesAttended { get; set; }
        public List<Note> Notes { get; set; }
    }

    public class Note
    {
        public string Comments { get; set; }
        public DateTime Date { get; set; }
        public string Author { get; set; }
    }
}