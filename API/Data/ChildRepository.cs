using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using Npgsql;
using API.Models;
using System.Data;
using System.Text;

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

        /// <summary>
        /// Creates a new child ID
        /// </summary>
        /// <returns>int of the new child ID</returns>
        public int CreateChildId()
        {
            // Start IDs at 1
            int nextId = 1;

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                string sql = @"SELECT * FROM Child
                             ORDER BY id DESC
                             LIMIT 1";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                // If there is a previous ID, make the next ID 1 higher than the previous highest
                if (dt.Rows.Count > 0)
                {
                    nextId += (int)dt.Rows[0]["id"];
                }

                // Default bus and class to 1 to fulfill non-null constraint
                sql = @"INSERT INTO Child (id, busid, classid)
                        VALUES (@nextId, 1, 1)";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@nextId", NpgsqlTypes.NpgsqlDbType.Integer).Value = nextId;
                    cmd.ExecuteNonQuery();
                }

                con.Close();
            }

            return nextId;
        }

        /// <summary>
        /// Updates information corresponding to child.Id in the database
        /// </summary>
        /// <param name="child">ChildModel with fields to be updated in the database</param>
        /// <returns>ChildModel of the merged information</returns>
        public ChildModel EditChild(ChildModel child)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                string sql = @"SELECT * FROM Child
                             WHERE id = @childid";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Id;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                // This ID does not exist
                if (dt.Rows.Count == 0)
                {
                    return new ChildModel();
                }

                // Update parameters that are not null
                StringBuilder parameters = new StringBuilder();
                bool[] updated = new bool[dt.Columns.Count];
                int parm = 0;
                if (child.FirstName != null)
                {
                    parameters.Append($"firstname = @p{parm},");
                    updated[parm] = true;
                }
                parm++;
                
                if (child.LastName != null)
                {
                    parameters.Append($"lastname = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Gender != null)
                {
                    parameters.Append($"gender = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Grade != null)
                {
                    parameters.Append($"grade = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Birthday != null)
                {
                    parameters.Append($"birthday = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Bus != null)
                {
                    parameters.Append($"busid = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Class != null)
                {
                    parameters.Append($"classid = @p{parm},");
                    updated[parm] = true;
                }

                if (parameters.Length == 0) // All fields null - no changes made
                {
                    return GetChildModels(dt)[0];
                }

                parameters.Length = parameters.Length - 1; // Remove last comma

                sql = "UPDATE Child SET " + parameters.ToString() + " WHERE id = @childId";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    parm = -1;
                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = child.FirstName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = child.LastName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar, 6).Value = child.Gender;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Grade;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Date).Value = DateTime.Parse(child.Birthday).Date;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Bus;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Class;
                    }

                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Id;
                    cmd.ExecuteNonQuery();
                }

                // Retrieve row that has been updated
                sql = @"SELECT * FROM Child
                        WHERE id = @childid";

                dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Id;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                con.Close();

                return GetChildModels(dt)[0];
            }
        }

        /// <summary>
        /// Given a child id and a boolean, updates whether or not the child's waiver has been received
        /// </summary>
        public void UpdateWaiver(int childId, bool received)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"UPDATE Child SET waiver = @received
                             WHERE id = @childId";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    cmd.Parameters.Add("@received", NpgsqlTypes.NpgsqlDbType.Bit).Value = received;
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// The childId is marked suspended for the given start/end dates
        /// </summary>
        /// <returns>If there is an issue with the given time frame, an error message is returned</returns>
        public String Suspend(int childId, DateTime start, DateTime end)
        {
            if (start > end)
            {
                return "Start time occurs after end time.";
            }

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();

                // Check if child is already suspended for any date in given time range
                string sql = @"SELECT childid, startdate, enddate from Child_Suspensions
                               WHERE childid = @childid
                               AND startdate <= @enddate AND enddate >= @startdate";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    cmd.Parameters.Add("@startdate", NpgsqlTypes.NpgsqlDbType.Date).Value = start.Date;
                    cmd.Parameters.Add("@enddate", NpgsqlTypes.NpgsqlDbType.Date).Value = end.Date;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                if (dt.Rows.Count > 0)
                {
                    return "The child is already suspended for at least one of these dates.";
                }


                sql = @"INSERT INTO Child_Suspensions (childid, startdate, enddate)
                        VALUES (@childid, @startdate, @enddate)";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    cmd.Parameters.Add("@startdate", NpgsqlTypes.NpgsqlDbType.Date).Value = start.Date;
                    cmd.Parameters.Add("@enddate", NpgsqlTypes.NpgsqlDbType.Date).Value = end.Date;
                    cmd.ExecuteNonQuery();
                }
                con.Close();
            }

            return null;
        }

        /// <summary>
        /// View active suspensions
        /// </summary>
        /// <returns>List of ChildModel objects that are currently marked as suspended</returns>
        public List<ChildModel> ViewSuspensions()
        {
            DateTime now = DateTime.UtcNow;
            DataTable dt = new DataTable();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // TODO: select pictureUrl
                string sql = @"SELECT s.childid, s.startdate, s.enddate,
                                      c.firstname, c.lastname
                               FROM Child_Suspensions s
                               RIGHT JOIN Child c
                               ON s.childid = c.id
                               WHERE s.startdate <= @now
                               AND s.enddate >= @now";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            return GetSuspendedChildModels(dt);
        }

        /// <summary>
        /// Create child models from a given data table
        /// </summary>
        /// <param name="dt">Data table matching specific criteria</param>
        /// <returns>List of ChildModels formed from the given data table</returns>
        private List<ChildModel> GetSuspendedChildModels(DataTable dt)
        {
            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(new ChildModel
                {
                    Id = (int)dr["childid"],
                    FirstName = dr["firstName"].ToString(),
                    LastName = dr["lastName"].ToString(),
                    SuspendedStart = ((DateTime)dr["startdate"]),
                    SuspendedEnd = ((DateTime)dr["enddate"])
                    //TODO:
                    //PictureUrl
                });
            }

            return children;
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
                    Gender = dr["gender"].ToString(),
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
                });
            }

            return children;
        }

        /// <summary>
        /// Given a child id, retrieves a list of DateTimes the child has been marked for attendance
        /// </summary>
        /// <param name="childid"></param>
        /// <returns>List of DateTimes associated with the child's attendance</returns>
        public List<DateTime> GetAttendanceDates(int childid)
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
    }
}
