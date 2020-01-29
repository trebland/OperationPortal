using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class GroupModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string LeaderName { get; set; }
        public int Count { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
    }

    public class GroupSignupViewModel
    {
        public DateTime Date { get; set; }
        public GroupModel Group { get; set; }
    }

    public class GroupCancelViewModel
    {
        public DateTime Date { get; set; }
        public int GroupId { get; set; }
    }
}
