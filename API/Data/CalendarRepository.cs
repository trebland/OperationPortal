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
                    cmd.Parameters.Add("@scheduled", NpgsqlTypes.NpgsqlDbType.Boolean).Value = attendance.Scheduled;
                    cmd.Parameters.Add("@attended", NpgsqlTypes.NpgsqlDbType.Boolean).Value = attendance.Attended;

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
                    cmd.Parameters.Add("@sched", NpgsqlTypes.NpgsqlDbType.Boolean).Value = scheduled;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        public List<DateTime> GetScheduledDates (int volunteerId, int month, int year)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<DateTime> dates = new List<DateTime>();
            string sql = @"SELECT dayattended FROM volunteer_attendance 
                           WHERE scheduled = true AND volunteerId = @vid 
                           AND date_part('month', dayattended) = @month AND date_part('year', dayattended) = @year";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@month", NpgsqlTypes.NpgsqlDbType.Integer).Value = month;
                    cmd.Parameters.Add("@year", NpgsqlTypes.NpgsqlDbType.Integer).Value = year;

                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                dates.Add(Convert.ToDateTime(dr["dayattended"]));
            }

            return dates;
        }

        public List<DateTime> GetAbsenceDates(int volunteerId, int month, int year)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<DateTime> dates = new List<DateTime>();
            string sql = @"SELECT dayattended FROM volunteer_attendance 
                           WHERE scheduled = false AND volunteerId = @vid 
                           AND date_part('month', dayattended) = @month AND date_part('year', dayattended) = @year";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@month", NpgsqlTypes.NpgsqlDbType.Integer).Value = month;
                    cmd.Parameters.Add("@year", NpgsqlTypes.NpgsqlDbType.Integer).Value = year;

                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                dates.Add(Convert.ToDateTime(dr["dayattended"]));
            }

            return dates;
        }

        /// <summary>
        /// Gets the names of groups that are signed up to volunteer in a particular month
        /// </summary>
        /// <param name="month">The number of the month (1-12) in question</param>
        /// <returns>A list of GroupModel objects.  Will only contain the names and dates for each group</returns>
        public List<GroupModel> GetGroups(int month, int year)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<GroupModel> groups = new List<GroupModel>();
            string sql = "SELECT v.Name, v.Date FROM volunteer_groups AS V WHERE date_part ('month', v.date) = @month AND date_part ('year', v.date) = @year";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@month", NpgsqlTypes.NpgsqlDbType.Integer).Value = month;
                    cmd.Parameters.Add("@year", NpgsqlTypes.NpgsqlDbType.Integer).Value = year;
                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach(DataRow dr in dt.Rows)
            {
                groups.Add(new GroupModel
                {
                    Name = dr["name"].ToString(),
                    Date = Convert.ToDateTime(dr["date"])
                });
            }

            return groups;
        }

        /// <summary>
        /// Gets the names of groups that are signed up to volunteer on a particular date
        /// </summary>
        /// <param name="date">The date to check</param>
        /// <param name="details">Whether or not to return details of the group (contact info, etc.)</param>
        /// <returns>A list of GroupModel objects.  Will only contain the names and dates for each group if details is false</returns>
        public List<GroupModel> GetGroups(DateTime date, bool details)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            GroupModel group;
            List<GroupModel> groups = new List<GroupModel>();
            string sql = "SELECT * FROM volunteer_groups AS V WHERE date = @date";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                if (details)
                {
                    group = new GroupModel
                    {
                        Id = (int)dr["id"],
                        Name = dr["name"].ToString(),
                        Date = Convert.ToDateTime(dr["Date"]),
                        LeaderName = dr["leadername"].ToString(),
                        Phone = dr["phone"].ToString(),
                        Email = dr["email"].ToString(),
                        Count = (int)dr["count"]
                    };
                }
                else
                {
                    group = new GroupModel
                    {
                        Name = dr["name"].ToString(),
                        Date = Convert.ToDateTime(dr["date"])
                    };
                }

                groups.Add(group);
            }

            return groups;
        }

        /// <summary>
        /// Inserts a new group record into the database
        /// </summary>
        /// <param name="date">The date the group is signed up to volunteer</param>
        /// <param name="group">A GroupModel object representing the group</param>
        public void CreateGroup (DateTime date, GroupModel group)
        {
            string sql = @"INSERT INTO volunteer_groups (name, count, phone, email, date, leadername) 
                           VALUES (@name, @count, @phone, @email, @date, @leader)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = group.Name;
                    cmd.Parameters.Add("@count", NpgsqlTypes.NpgsqlDbType.Integer).Value = group.Count;
                    cmd.Parameters.Add("@phone", NpgsqlTypes.NpgsqlDbType.Varchar).Value = group.Phone;
                    cmd.Parameters.Add("@email", NpgsqlTypes.NpgsqlDbType.Varchar).Value = group.Email;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date.Date;
                    cmd.Parameters.Add("@leader", NpgsqlTypes.NpgsqlDbType.Varchar).Value = group.LeaderName;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Checks if a group is signed up to volunteer on a specific date
        /// </summary>
        /// <param name="date">The date to be checked</param>
        /// <param name="groupId">The id of the group in question</param>
        /// <returns>True if the group is signed up, false otherwise</returns>
        public bool CheckGroupSignup (DateTime date, int groupId)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            string sql = "SELECT * FROM volunteer_groups WHERE Date = @date AND id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = groupId;

                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count > 0)
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// Deletes the record of a group having been signed up on a particular day
        /// </summary>
        /// <param name="date">The Date to delete the record from</param>
        /// <param name="groupId">The id of the group that is no longer signed up</param>
        public void DeleteGroupSignup(DateTime date, int groupId)
        {
            string sql = "DELETE FROM volunteer_groups WHERE Date = @date AND id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = groupId;

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
        /// Gets the list of all events in a given month
        /// </summary>
        /// <param name="month">The number of the month (1-12) for which events should be retrieved</param>
        /// <param name="people">A boolean indicating whether the people attending the events should be included</param>
        /// <returns>A list of EventModel objects</returns>
        public List<EventModel> GetEvents(int month, int year, bool people = false)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<EventModel> events = new List<EventModel>();
            EventModel eventModel;
            string sql = "SELECT * FROM events WHERE date_part ('month', dayheld) = @month AND date_part ('year', dayheld) = @year";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@month", NpgsqlTypes.NpgsqlDbType.Integer).Value = month; 
                    cmd.Parameters.Add("@year", NpgsqlTypes.NpgsqlDbType.Integer).Value = year;

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach(DataRow dr in dt.Rows)
            {
                eventModel = new EventModel
                {
                    Id = (int)dr["id"],
                    Name = dr["name"].ToString(),
                    Description = dr["description"].ToString(),
                    Date = Convert.ToDateTime(dr["dayheld"]),
                    People = null
                };

                // Get the people who have attended each event, if necessary
                // By default, skip this for speed's sake
                if (people)
                {
                    eventModel.People = GetEventAttendees(eventModel.Id);
                }

                events.Add(eventModel);
            }

            return events;
        }

        /// <summary>
        /// Gets the list of all events on a given date
        /// </summary>
        /// <param name="date">The date to get the events that occur on</param>
        /// <param name="people">A boolean indicating whether the people attending the events should be included</param>
        /// <returns>A list of EventModel objects</returns>
        public List<EventModel> GetEvents(DateTime date, bool people = false)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<EventModel> events = new List<EventModel>();
            EventModel eventModel;
            string sql = "SELECT * FROM events WHERE dayheld = @date";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                eventModel = new EventModel
                {
                    Id = (int)dr["id"],
                    Name = dr["name"].ToString(),
                    Description = dr["description"].ToString(),
                    Date = Convert.ToDateTime(dr["dayheld"]),
                    People = null
                };

                // Get the people who have attended each event, if necessary
                // By default, skip this for speed's sake
                if (people)
                {
                    eventModel.People = GetEventAttendees(eventModel.Id);
                }

                events.Add(eventModel);
            }

            return events;
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
        /// Gets the list of people attending a specific event
        /// </summary>
        /// <param name="eventId">The id of the event</param>
        /// <returns>A list of AttendeeModel objects, each with an EventId, VolunteerId, and Name</returns>
        public List<AttendeeModel> GetEventAttendees (int eventId)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<AttendeeModel> attendees = new List<AttendeeModel>();
            string sql = @"SELECT v.id, v.firstname, v.lastname 
                           FROM event_signup AS e INNER JOIN 
                           volunteers AS v ON v.id = e.volunteerid 
                           WHERE e.eventId = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = eventId;
                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                attendees.Add(new AttendeeModel
                {
                    EventId = eventId,
                    VolunteerId = (int)dr["id"],
                    Name = dr["firstname"].ToString() + " " + dr["lastname"].ToString()
                });
            }

            return attendees;
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


        /// <summary>
        /// Gets the record (if one exists) of a user having signed up for a particular event
        /// </summary>
        /// <param name="eventId">The id of the event</param>
        /// <param name="VolunteerId">The id of the volunteer in question</param>
        /// <returns>
        /// An EventSignupModel with the ids of the volunteer and event.  Since both of those are known prior to calling, 
        /// the primary value here is in whether or not it returns null.
        /// </returns>
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

        /// <summary>
        /// Adds a record indicating a volunteer will be attending an event
        /// </summary>
        /// <param name="eventId">The id of the event</param>
        /// <param name="VolunteerId">The id of the volunteer</param>
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

        /// <summary>
        /// Deletes the record that a specific volunteer will be attending a specific event
        /// </summary>
        /// <param name="eventId">The id of the event</param>
        /// <param name="VolunteerId">The id of the volunteer</param>
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
