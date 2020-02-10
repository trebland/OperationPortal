using System;

namespace API.Models
{
    public class GetVolunteersForDayModel
    {
        public DateTime Day { get; set; }
        public bool SignedUp { get; set; }
        public bool CheckedIn { get; set; }
    }
}