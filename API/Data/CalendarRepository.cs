using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using Npgsql;
using API.Models;

namespace API.Data
{
    public class CalendarRepository
    {
        private readonly string connString;

        public CalendarRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Gets a record (if one exists) of a user having signed up/attended 
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer's profile</param>
        /// <param name="date">The date to be checked</param>
        /// <returns>An AttendanceModel object, or null if none exists</returns>
        public AttendanceModel GetSingleAttendance(int volunteerId, DateTime date)
        {
            AttendanceModel signup;
            DataTable dt = new DataTable();
            DataRow dr;
            NpgsqlDataAdapter da;
            string sql = "SELECT * FROM Volunteer_Attendance WHERE VolunteerId = @vid AND DayAttended = @date LIMIT 1";

            // Connect to the database
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create the PostgresQL command
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    // Add the vid and date parameters.  We use a parameterized query here to defend against SQL injection attacks
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date.Date;
                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            // Check to make sure a row was returned.  Because of the LIMIT 1 there 
            // will never be more than one result - only 1 or 0.
            if (dt.Rows.Count != 1)
            {
                return null;
            }

            // We want to use the one remaining row to create the SignupModel object, then return it.
            dr = dt.Rows[0];
            signup = new AttendanceModel
            {
                Id = (int)dr["id"],
                VolunteerId = (int)dr["VolunteerId"],
                DayAttended = Convert.ToDateTime(dr["DayAttended"]),
                Scheduled = (bool)dr["Scheduled"],
                Attended = (bool)dr["Attended"]
            };

            return signup;
        }

        /// <summary>
        /// Creates a record in the database indicating a user's (planned or actual) attendance on a specified date
        /// </summary>
        /// <param name="attendance">An AttendanceModel object with the user's volunteer id, the date, whether they are scheduled, and whether or not they attended</param>
        public void InsertAttendance(AttendanceModel attendance)
        {
            string sql = @"INSERT INTO Volunteer_Attendance (VolunteerId, DayAttended, Scheduled, Attended) 
                           VALUES (@vid, @date, @scheduled, @attended)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = attendance.VolunteerId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = attendance.DayAttended;
                    cmd.Parameters.Add("@scheduled", NpgsqlTypes.NpgsqlDbType.Bit).Value = attendance.Scheduled;
                    cmd.Parameters.Add("@attended", NpgsqlTypes.NpgsqlDbType.Bit).Value = attendance.Attended;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Updates whether or not a user is scheduled to attend on a specfied day
        /// </summary>
        /// <param name="id">The id of the record in the Volunteer_Attendance table</param>
        /// <param name="scheduled">Whether or not the user is scheduled</param>
        public void UpdateScheduled (int id, bool scheduled)
        {
            string sql = @"UPDATE Volunteer_Attendance SET Scheduled = @sched WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;
                    cmd.Parameters.Add("@sched", NpgsqlTypes.NpgsqlDbType.Bit).Value = scheduled;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Inserts a new event into the database
        /// </summary>
        /// <param name="name">The name of the new event</param>
        /// <param name="date">The date the new event is being held</param>
        /// <param name="desc">The description of the new event</param>
        public void CreateEvent(string name, DateTime date, string desc)
        {
            string sql = @"INSERT INTO events (name, dayheld, description) 
                           VALUES (@name, @date, @desc)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = name;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                    cmd.Parameters.Add("@desc", NpgsqlTypes.NpgsqlDbType.Varchar).Value = desc;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Gets a specific event from the database by id
        /// </summary>
        /// <param name="id">The id of the event to be retrieved</param>
        /// <returns>An EventModel object representing the event</returns>
        public EventModel GetEvent(int id)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = "SELECT * FROM events WHERE id = @id LIMIT 1";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;
                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            // Check to make sure a row was returned.  Because of the LIMIT 1 there 
            // will never be more than one result - only 1 or 0.
            if (dt.Rows.Count != 1)
            {
                return null;
            }

            // We want to use the one remaining row to create the EventModel object, then return it.
            dr = dt.Rows[0];
            return new EventModel
            {
                Id = (int)dr["id"],
                Date = Convert.ToDateTime(dr["dayheld"]),
                Name = dr["name"].ToString(),
                Description = dr["description"].ToString()
            };
        }

        /// <summary>
        /// Updates an existing event in the database.
        /// </summary>
        /// <param name="eventModel">The EventModel representation of the new state of the event.  Should include id, name, date, and description</param>
        public void UpdateEvent(EventModel eventModel)
        {
            string sql = @"UPDATE events SET name = @name, dayheld = @date, description = @desc WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = eventModel.Id;
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = eventModel.Name;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = eventModel.Date;
                    cmd.Parameters.Add("@desc", NpgsqlTypes.NpgsqlDbType.Varchar).Value = eventModel.Description;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        public EventSignupModel GetEventSignup(int eventId, int VolunteerId)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = "SELECT * FROM event_signup WHERE eventid = @eid AND volunteerid = @vid LIMIT 1";


            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@eid", NpgsqlTypes.NpgsqlDbType.Integer).Value = eventId;
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = VolunteerId;
                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            // Check to make sure a row was returned.  Because of the LIMIT 1 there 
            // will never be more than one result - only 1 or 0.
            if (dt.Rows.Count != 1)
            {
                return null;
            }

            // We want to use the one remaining row to create the EventModel object, then return it.
            dr = dt.Rows[0];
            return new EventSignupModel
            {
                EventId = (int)dr["eventid"],
                VolunteerId = (int)dr["volunteerid"]
            };
        }

        public void CreateEventSignup(int eventId, int VolunteerId)
        {
            string sql = @"INSERT INTO event_signup (eventid, volunteerid) 
                           VALUES (@eid, @vid)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@eid", NpgsqlTypes.NpgsqlDbType.Integer).Value = eventId;
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = VolunteerId;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        public void DeleteEventSignup (int eventId, int VolunteerId)
        {
            string sql = @"DELETE FROM event_signup WHERE eventid = @eid AND volunteerid = @vid";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@eid", NpgsqlTypes.NpgsqlDbType.Integer).Value = eventId;
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = VolunteerId;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }
    }
}
