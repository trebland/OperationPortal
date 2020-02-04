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
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT c.*,
                                      cl.description,
                                      b.name AS busname
                              FROM Child c
                              LEFT JOIN Class_List cl
                              ON c.classid = cl.id
                              LEFT JOIN Bus b
                              ON c.busid = b.id
                              WHERE c.busid = @busid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@busid", NpgsqlTypes.NpgsqlDbType.Integer).Value = busid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(GetBasicChildModel(new ChildModel(), dr));
            }

            return children;
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
                string sql = @"SELECT c.*,
                                      cl.description,
                                      b.name AS busname
                              FROM Child c
                              LEFT JOIN Class_List cl
                              ON c.classid = cl.id
                              LEFT JOIN Bus b
                              ON c.busid = b.id
                              WHERE c.classid = @classid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@classid", NpgsqlTypes.NpgsqlDbType.Integer).Value = classid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(GetBasicChildModel(new ChildModel(), dr));
            }

            return children;
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
                string sql = @"SELECT c.*,
                               cl.description,
                               b.name AS busname
                        FROM Child c
                        LEFT JOIN Class_List cl
                        ON c.classid = cl.id
                        LEFT JOIN Bus b
                        ON c.busid = b.id
                        WHERE c.busid = @busid";

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

                if (child.Bus != null && child.Bus.Id != null)
                {
                    parameters.Append($"busid = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Class != null && child.Class.Id != null)
                {
                    parameters.Append($"classid = @p{parm},");
                    updated[parm] = true;
                }

                if (parameters.Length == 0) // All fields null - no changes made
                {
                    return GetFullChildModel(dt.Rows[0]);
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
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Bus.Id;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Class.Id;
                    }

                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Id;
                    cmd.ExecuteNonQuery();
                }

                // Retrieve row that has been updated and bus/class name
                sql = @"SELECT c.*,
                               cl.description,
                               b.name AS busname
                        FROM Child c
                        LEFT JOIN Class_List cl
                        ON c.classid = cl.id
                        LEFT JOIN Bus b
                        ON c.busid = b.id
                        WHERE c.busid = @busid";

                dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Id;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                con.Close();

                return GetFullChildModel(dt.Rows[0]);
            }
        }

        public String EditNotes(int childId, String editedNotes)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"UPDATE Child SET notes = @editedNotes
                             WHERE id = @childId";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    cmd.Parameters.Add("@editedNotes", NpgsqlTypes.NpgsqlDbType.Varchar, 300).Value = editedNotes;
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            return editedNotes;
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
        /// Given a child ID, check if the child is currently suspended
        /// </summary>
        public bool IsSuspended(int childId)
        {
            DateTime now = DateTime.UtcNow;
            DataTable dt = new DataTable();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT startdate, enddate, childId
                               FROM Child_Suspensions
                               WHERE startdate <= @now
                               AND enddate >= @now
                               AND childid = @childId";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            return dt.Rows.Count != 0 ? true : false;
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
        /// Fills out all the information from a row retrieved from the Child table to the 
        /// given child model
        /// </summary>
        private ChildModel GetFullChildModel(DataRow dr)
        {
            ChildModel child = GetBasicChildModel(new ChildModel(), dr);
            child.Notes = dr["notes"].ToString();
            child.WaiverReceived = (bool)dr["waiver"];

            return child;
        }

        /// <summary>
        /// Fills out basic information from a given data row to a given child model
        /// </summary>
        private ChildModel GetBasicChildModel(ChildModel child, DataRow dr)
        {
            int? classId = null;
            if (!DBNull.Value.Equals(dr["classid"]))
            {
                classId = (int)dr["classid"];
            }

            int? busId = null;
            if (!DBNull.Value.Equals(dr["busid"]))
            {
                busId = (int)dr["busid"];
            }

            int? grade = null;
            if (!DBNull.Value.Equals(dr["grade"]))
            {
                grade = (int)dr["grade"];
            }
            child.Id = (int)dr["id"];
            child.FirstName = dr["firstname"].ToString();
            child.LastName = dr["lastname"].ToString();
            child.Gender = dr["gender"].ToString();
            child.Grade = grade;
            child.Class = new Pair
            {
                Id = classId,
                Name = dr["description"].ToString()
            };
            child.Bus = new Pair
            {
                Id = busId,
                Name = dr["busname"].ToString()
            };
            child.Birthday = dr["birthday"].ToString();
            child.IsSuspended = IsSuspended((int)dr["id"]);
            //TODO:
            //PictureUrl

            return child;
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

        /// <summary>
        /// Gets the list of all classes in the database
        /// </summary>
        /// <returns>A list of ClassModel objects representing classes, each containing the name and id of a class</returns>
        public List<ClassModel> GetClasses()
        {
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = "SELECT * FROM class_list";
            List<ClassModel> classes = new List<ClassModel>();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {   
                    da = new NpgsqlDataAdapter(cmd);
                    
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                classes.Add(new ClassModel
                {
                    Id = (int)dr["id"],
                    Name = dr["description"].ToString()
                });
            }

            return classes;
        }
    }
}
