using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class InventoryModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Count { get; set; }
        public bool Resolved { get; set; }
        public string AddedBy { get; set; }
    }
}
