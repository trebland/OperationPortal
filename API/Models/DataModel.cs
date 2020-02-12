using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class DataModel
    {
        public DataModel(String Group, int Count)
        {
            this.Group = Group;
            this.Count = Count;
        }
        public string Group { get; set; }
        public int Count { get; set; }
    }

}
