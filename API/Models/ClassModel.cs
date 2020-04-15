using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace API.Models
{
    public class ClassModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int NumStudents { get; set; }
        public int TeacherId { get; set; }
        public string TeacherName { get; set; }
        public byte[] TeacherPicture { get; set; }
        public string Location { get; set; }
    }
}
