using System;

namespace API.Models
{
    public class PostSuspendChildModel : IdModel
    {
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
    }
}