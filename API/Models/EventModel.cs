using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class EventModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public DateTime Date { get; set; }
        public String Description { get; set; }
        public List<AttendeeModel> People { get; set; }
    }

    public class EventViewModel
    {
        public int eventId { get; set; }
    }

    public class EventSignupModel
    {
        public int VolunteerId { get; set; }
        public int EventId { get; set; }
    }

    public class AttendeeModel
    {
        public int VolunteerId { get; set; }
        public int EventId { get; set; }
        public string Name { get; set; }
    }
}
