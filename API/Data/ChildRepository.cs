using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using Npgsql;
using API.Models;
using System.Data;

namespace API.Data
{
    public class ChildRepository
    {
        private readonly string connString; 
        public ChildRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Get a list of children by bus
        /// </summary>
        /// <param name="busid">Bus id</param>
        /// <returns>A List of ChildModels belonging to busid</returns>
        public List<ChildModel> GetChildrenBus(int busid)
        {
            // Connect to DB
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create and run Postgres command.
                string sql = "SELECT * FROM Child WHERE busid = @busid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@busid", NpgsqlTypes.NpgsqlDbType.Integer).Value = busid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }
            return GetChildModels(dt);
        }

        /// <summary>
        /// Get a list of children by class
        /// </summary>
        /// <param name="classid">Class id</param>
        /// <returns>A List of ChildModels belonging to classid</returns>
        public List<ChildModel> GetChildrenClass(int classid)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = "SELECT * FROM Child WHERE classid = @classid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@classid", NpgsqlTypes.NpgsqlDbType.Integer).Value = classid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }
            return GetChildModels(dt);
        }
        /// <summary>
        /// Create child models from a given data table
        /// </summary>
        /// <param name="dt">Data table matching specific criteria</param>
        /// <returns>List of ChildModels formed from the given data table</returns>
        private List<ChildModel> GetChildModels(DataTable dt)
        {
            // For each resulting row, create a ChildModel object and then add it to the list.
            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(new ChildModel
                {
                    Id = (int)dr["id"],
                    FirstName = dr["firstName"].ToString(),
                    LastName = dr["lastName"].ToString(),
                    Grade = (int)dr["grade"],
                    Class = (int)dr["classid"],
                    Bus = (int)dr["busid"],
                    Birthday = dr["birthday"].ToString(),
                    WaiverReceived = (bool)dr["waiver"],
                    DatesAttended = GetAttendanceDates((int)dr["id"])
                    //TODO:
                    //PictureUrl
                    //suspensions
                    //relatives
                    //notes
                }) ;
            }

            return children;
        }

    /// <summary>
    /// Given a child id, retrieves a list of DateTimes the child has been marked for attendance
    /// </summary>
    /// <param name="childid"></param>
    /// <returns>List of DateTimes associated with the child's attendance</returns>
        private List<DateTime> GetAttendanceDates(int childid)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = "SELECT * FROM Child_Attendance WHERE childid = @childid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }
            List<DateTime> dates = new List<DateTime>();
            foreach (DataRow dr in dt.Rows)
            {
                dates.Add((DateTime)dr["dayattended"]);
            }

            return dates;
        }
        /// <summary>
        /// Marks a child as present for the day
        /// </summary>
        /// <param name="childid">Child id being marked present</param>
        /// <returns>Total number of times the child has been in attendance</returns>
        public int CheckInChild(int childid)
        {
            int numVisits = 0;
            DateTime now = DateTime.UtcNow;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                DataTable dt = new DataTable();
                
                // Retrieve all the days the child has been in attendance, ordered by most recent first
                string sql = "SELECT * FROM Child_Attendance WHERE childid = @childid ORDER BY dayattended DESC";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                    NpgsqlDataAdapter  da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                numVisits = dt.Rows.Count;

                // Record child's attendance, checking if the child has previously been marked for the day
                if (dt.Rows.Count == 0 || string.Compare(dt.Rows[0]["dayattended"].ToString(), now.Date.ToString()) != 0)
                {
                    sql = @"INSERT INTO Child_Attendance (childid, dayattended)
                            VALUES (@childid, @now)";
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                        cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                        cmd.ExecuteNonQuery();
                    }

                    // Add today's visit to the total
                    numVisits++;
                }
                
                con.Close();
            }

            return numVisits;
        }
    }
}
