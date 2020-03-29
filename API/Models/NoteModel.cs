using System;

namespace API.Models
{
    public class NoteModel
    {
        public NoteModel (int NoteId, string Content, string Author, DateTime Date)
        {
            this.NoteId = NoteId;
            this.Content = Content;
            this.Author = Author;
            this.Date = Date;
        }

        public int NoteId { get; set; }
        public string Content { get; set; }
        public string Author { get; set; }
        public DateTime Date { get; set; }
    }
}