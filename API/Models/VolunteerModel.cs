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
        public string PreferredName { get; set; }
        public int WeeksAttended { get; set; }
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
        public bool BackgroundCheck { get; set; }
        public bool BlueShirt { get; set; }
        public bool NameTag { get; set; }
        public bool PersonalInterviewCompleted { get; set; }
        public int YearStarted { get; set; }
        public DateTime Birthday { get; set; }
        public byte[] Picture { get; set; }
        public Pair Bus { get; set; }
        public Pair Class { get; set; }
    }
    public class Pair
    {
        public int? Id { get; set; }
        public string Name { get; set; }
    }

    public class GuestVolunteerModel
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Affiliation { get; set; }
        public DateTime Date { get; set; }
    }

    public class VolunteerJobModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Min { get; set; }
        public int Max { get; set; }
        public int CurrentNumber { get; set; }
        public List<VolunteerModel> Volunteers { get; set; }
    }

    public class JobAssignmentViewModel
    {
        public int Id { get; set; }
        public int VolunteerId { get; set; }
        public int JobId { get; set; }
        public DateTime Date { get; set; }
    }

    public class VolunteerTrainingModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

    public class TrainingCompletedViewModel
    {
        public int VolunteerId { get; set; }
        public int TrainingId { get; set; }
    }
}
