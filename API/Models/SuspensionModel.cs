using System;

namespace API.Models
{
    public class SuspensionModel
    {
        public SuspensionModel(DateTime start, DateTime end)
        {
            SuspendedStart = start;
            SuspendedEnd = end;
        }

        public DateTime SuspendedStart { get; set; }
        public DateTime SuspendedEnd { get; set; }
    }
}