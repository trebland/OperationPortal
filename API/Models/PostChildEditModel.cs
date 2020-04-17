using System;

namespace API.Models
{
    public class PostChildEditModel : IdModel
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PreferredName { get; set; }
        public string ContactNumber { get; set; }
        public string ContactEmail { get; set; }
        public string ParentName { get; set; }
        public int BusId { get; set; }
        public string Birthday { get; set; }
        public string Gender { get; set; }
        public int Grade { get; set; }
        public bool? ParentalWaiver { get; set; }
        public int ClassId { get; set; }
        public byte[] Picture { get; set; }
        public bool? BusWaiver { get; set; }
        public bool? HaircutWaiver { get; set; }
        public bool? ParentalEmailOptIn { get; set; }
        public int OrangeShirtStatus { get; set; }
        public DateTime StartDate { get; set; }
        public bool IsSuspended { get; set; }
        public bool IsCheckedIn { get; set; }
    }
}