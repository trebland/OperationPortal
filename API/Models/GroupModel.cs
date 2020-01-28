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
        public int MemberCount { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
    }

    public class GroupSignupViewModel
    {
        public DateTime date { get; set; }
        public GroupModel group { get; set; }
    }
}
