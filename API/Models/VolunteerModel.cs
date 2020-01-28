using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class VolunteerModel
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Role { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public bool Orientation { get; set; }
        public string[] Trainings { get; set; }
        public string Affiliation { get; set; }
        public string Referral { get; set; }
        public string[] Languages { get; set; }
        public string[] ClassesInterested { get; set; }
        public string[] AgesInterested { get; set; }
        public bool Newsletter { get; set; }
        public bool ContactWhenShort { get; set; }
        public Pair Bus { get; set; }
        public Pair Class { get; set; }
    }
    public class Pair
    {
        public int? Id { get; set; }
        public string Name { get; set; }
    }
}
