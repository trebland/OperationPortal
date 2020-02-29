using System;

namespace API.Models
{
    public class PostNoteModel
    {
        public string Author { get; set; }
        public int ChildId { get; set; }
        public string Content { get; set; }
        public string Priority { get; set; }
    }
}