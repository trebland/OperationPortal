using System;

namespace API.Models
{
    public class NoteModel
    {
        public NoteModel (int NoteId, string Content, string Author)
        {
            this.NoteId = NoteId;
            this.Content = Content;
            this.Author = Author;
        }

        public int NoteId { get; set; }
        public string Content { get; set; }
        public string Author { get; set; }
    }
}