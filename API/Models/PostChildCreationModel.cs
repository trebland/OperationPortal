using System;

namespace API.Models
{
    public class PostChildCreationModel
    {
        public string ContactNumber { get; set; }
        public string ParentName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PreferredName { get; set; }
        public int BusId { get; set; }
        public string Birthday { get; set; }
        public byte[] Picture { get; set; }
        public string Gender { get; set; }
    }
}