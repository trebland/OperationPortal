using System;

namespace API.Models
{
    public class RelativeModel : IdModel
    {
        public RelativeModel(int Id, string Relation)
        {
            this.Id = Id;
            this.Relation = Relation;
        }

        public string Relation { get; set; }
    }
}