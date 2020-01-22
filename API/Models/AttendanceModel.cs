using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class AttendanceModel
    {
        public int Id { get; set; }
        public int VolunteerId { get; set; }
        public DateTime DayAttended { get; set; }
        public bool Scheduled { get; set; }
        public bool Attended { get; set; }
    }

    // A helper class used to be able to pull a date in from a JSON request more easily due to quirks of MVC's model binding
    public class DateModel
    {
        public DateTime Date { get; set; }
    }
}
