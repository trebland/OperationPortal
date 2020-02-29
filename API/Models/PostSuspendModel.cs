using System;

namespace API.Models
{
    public class PostSuspendModel : IdModel
    {
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
    }
}