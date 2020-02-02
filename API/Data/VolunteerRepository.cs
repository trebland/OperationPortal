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
    public class VolunteerRepository
    {
        private readonly string connString;

        public VolunteerRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Gets a specific volunteer by id
        /// </summary>
        /// <param name="id">The volunteer's id</param>
        /// <returns>A VolunteerModel object</returns>
        public VolunteerModel GetVolunteer(int id)
        {
            VolunteerModel volunteer;
            DataTable dt = new DataTable();
            DataRow dr;
            NpgsqlDataAdapter da;
            string sql = "SELECT * FROM Volunteers WHERE id = @id";

            // Connect to the database
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create the PostgresQL command
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    // Add the id parameter.  We use a parameterized query here to defend against SQL injection attacks
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;
                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            // Check to make sure a row was returned.  Because of the TOP 1 and PRIMARY KEY constraint on the id field in the DB, there 
            // will never be more than one result - only 1 or 0.
            if (dt.Rows.Count != 1)
            {
                return null;
            }

            // We want to use the one remaining row to create the VolunteerModel object, then return it.
            dr = dt.Rows[0];
            volunteer = new VolunteerModel
            {
                Id = (int)dr["id"],
                FirstName = dr["firstName"].ToString(),
                LastName = dr["lastName"].ToString(),
                Orientation = dr["orientation"] == DBNull.Value ? false : (bool)dr["orientation"],
                Affiliation = dr["affiliation"].ToString(),
                Referral = dr["Referral"].ToString(),
                Newsletter = dr["newsletter"] == DBNull.Value ? false : (bool)dr["newsletter"],
                ContactWhenShort = dr["contactWhenShort"] == DBNull.Value ? false : (bool)dr["contactWhenShort"],
                Phone = dr["phone"].ToString(),
                Email = dr["email"].ToString(),
                Trainings = GetVolunteerTrainings((int)dr["id"]).ToArray(),
                Languages = GetVolunteerLanguages((int)dr["id"]).ToArray()
            };

            return volunteer;
        }
        
        /// <summary>
        /// Gets the list of volunteers that are registered with the system
        /// </summary>
        /// <returns>A list of VolunteerModel objects</returns>
        public List<VolunteerModel> GetVolunteers()
        {
            List<VolunteerModel> volunteers = new List<VolunteerModel>();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = "SELECT * FROM Volunteers";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create and run Postgres command.
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            // For each resulting row, create a VolunteerModel object and then add it to the list.
            foreach (DataRow dr in dt.Rows)
            {
                volunteers.Add(new VolunteerModel
                {
                    Id = (int)dr["id"],
                    FirstName = dr["firstName"].ToString(),
                    LastName = dr["lastName"].ToString(),
                    Orientation = dr["orientation"] == DBNull.Value ? false : (bool)dr["orientation"],
                    Affiliation = dr["affiliation"].ToString(),
                    Referral = dr["Referral"].ToString(),
                    Newsletter = dr["newsletter"] == DBNull.Value ? false : (bool)dr["newsletter"],
                    ContactWhenShort = dr["contactWhenShort"] == DBNull.Value ? false : (bool)dr["contactWhenShort"],
                    Phone = dr["phone"].ToString(),
                    Email = dr["email"].ToString(),
                    Trainings = GetVolunteerTrainings((int)dr["id"]).ToArray(),
                    Languages = GetVolunteerLanguages((int)dr["id"]).ToArray()
                }) ;
            }

            return volunteers;
        }

        /// <summary>
        /// Gets the list of volunteers scheduled to volunteer on a specific date
        /// </summary>
        /// <param name="date">The date to check signups for</param>
        /// <returns>A list of VolunteerModel objects</returns>
        public List<VolunteerModel> GetScheduledVolunteers(DateTime date)
        {
            List<VolunteerModel> volunteers = new List<VolunteerModel>();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT V.* 
                           FROM Volunteers AS V INNER JOIN 
                           Volunteer_Attendance AS VA ON VA.volunteerId = V.id 
                           WHERE VA.dayattended = @date AND VA.scheduled = CAST(1 as bit)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create and run Postgres command.
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            // For each resulting row, create a VolunteerModel object and then add it to the list.
            foreach (DataRow dr in dt.Rows)
            {
                volunteers.Add(new VolunteerModel
                {
                    Id = (int)dr["id"],
                    FirstName = dr["firstName"].ToString(),
                    LastName = dr["lastName"].ToString(),
                    Orientation = dr["orientation"] == DBNull.Value ? false : (bool)dr["orientation"],
                    Affiliation = dr["affiliation"].ToString(),
                    Referral = dr["Referral"].ToString(),
                    Newsletter = dr["newsletter"] == DBNull.Value ? false : (bool)dr["newsletter"],
                    ContactWhenShort = dr["contactWhenShort"] == DBNull.Value ? false : (bool)dr["contactWhenShort"],
                    Phone = dr["phone"].ToString(),
                    Email = dr["email"].ToString(),
                    Trainings = GetVolunteerTrainings((int)dr["id"]).ToArray(),
                    Languages = GetVolunteerLanguages((int)dr["id"]).ToArray()
                });
            }

            return volunteers;
        }

        /// <summary>
        /// Gets the list of trainings a given volunteer has completed
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer whose trainings are being queried</param>
        /// <returns>A list of training names</returns>
        public List<string> GetVolunteerTrainings(int volunteerId)
        {
            List<string> trainings = new List<string>();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT name FROM Training AS T 
                           INNER JOIN Trainings_Completed AS TC ON T.id = TC.trainingID 
                           INNER JOIN Volunteers AS V ON V.id = TC.volunteerID 
                           WHERE V.id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach(DataRow dr in dt.Rows)
            {
                trainings.Add(dr["name"].ToString());
            }

            return trainings;
        }

        /// <summary>
        /// Gets the list of languages a volunteer reports knowing
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer whose languages are being queried</param>
        /// <returns>A list of language names</returns>
        public List<string> GetVolunteerLanguages(int volunteerId)
        {
            List<string> languages = new List<string>();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT languagename FROM Languages_Known WHERE volunteerID = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                languages.Add(dr["languagename"].ToString());
            }

            return languages;
        }

        /// <summary>
        /// Creates a volunteer's profile in the database
        /// </summary>
        /// <param name="volunteer">A VolunteerModel object with the basic info to be inserted into the database</param>
        /// <returns>A VolunteerModel representing the volunteer inserted into the database</returns>
        public VolunteerModel CreateVolunteer(VolunteerModel volunteer)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = @"INSERT INTO Volunteers (firstName, lastName, email, role, weekendsAttended, orientation, affiliation, referral, newsletter,contactWhenShort, phone) 
                           VALUES (@firstName, @lastName, @email, 1, 0, CAST(0 as bit), '', '', CAST(0 as bit), CAST(0 as bit), '') 
                           RETURNING id";

            // Connect to DB
            using(NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand (sql, con))
                {
                    cmd.Parameters.Add("@firstName", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = volunteer.FirstName;
                    cmd.Parameters.Add("@lastName", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = volunteer.LastName;
                    cmd.Parameters.Add("@email", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = volunteer.Email;

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count != 1)
            {
                return null;
            }

            dr = dt.Rows[0];
            return GetVolunteer((int)dr["id"]);
        }

        /// <summary>
        /// Allows for updating a volunteer's profile information.  DOES NOT update email
        /// </summary>
        /// <param name="v">A VolunteerModel object.  Should contain id, first name, last name, affiliation, referral, newsletter, phone, and contactwhenshort</param>
        public void UpdateVolunteer(VolunteerModel v)
        {
            string sql = @"UPDATE Volunteers 
                           SET FirstName = @fname, LastName = @lname, Phone = @phone, Referral = @referral, Newsletter = @newsletter, ContactWhenShort = @contact 
                           WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = v.Id;
                    cmd.Parameters.Add("@fname", NpgsqlTypes.NpgsqlDbType.Varchar).Value = v.FirstName;
                    cmd.Parameters.Add("@lname", NpgsqlTypes.NpgsqlDbType.Varchar).Value = v.LastName;
                    cmd.Parameters.Add("@phone", NpgsqlTypes.NpgsqlDbType.Varchar).Value = v.Phone;
                    cmd.Parameters.Add("@referral", NpgsqlTypes.NpgsqlDbType.Varchar).Value = v.Referral;
                    cmd.Parameters.Add("@newsletter", NpgsqlTypes.NpgsqlDbType.Bit).Value = v.Newsletter;
                    cmd.Parameters.Add("@contact", NpgsqlTypes.NpgsqlDbType.Bit).Value = v.ContactWhenShort;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            return;
        }

        /// <summary>
        /// Kill-and-Fills the list of languages a volunteer knows
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer whose languages are being updated</param>
        /// <param name="Languages">The list of languages the volunteer has identified themselves as speaking</param>
        public void UpdateLanguages(int volunteerId, IEnumerable<string> languages)
        {
            string deleteSql = "DELETE FROM languages_known WHERE volunteerid = @vid";
            string insertSql = "INSERT INTO languages_known (volunteerid, languagename) VALUES (@vid, @lang)";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Delete previously existing data
                using (NpgsqlCommand deleteCmd = new NpgsqlCommand(deleteSql, con))
                {
                    deleteCmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;

                    con.Open();
                    deleteCmd.ExecuteNonQuery();
                    con.Close();
                }

                // Add new ones
                using (NpgsqlCommand insertCmd = new NpgsqlCommand(insertSql, con))
                {
                    insertCmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    insertCmd.Parameters.Add("@lang", NpgsqlTypes.NpgsqlDbType.Varchar);

                    con.Open();
                    foreach(string lang in languages)
                    {
                        insertCmd.Parameters["@lang"].Value = lang;
                        insertCmd.ExecuteNonQuery();
                    }
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Deletes a volunteer's profile from the database
        /// </summary>
        /// <param name="id">The id of the volunteer profile to be deleted</param>
        public void DeleteVolunteer(int id)
        {
            string sql = "DELETE FROM Volunteers WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Updates the role a user is recorded as having in the database.
        /// Note that this WILL NOT grant increased permissions, as permissions are handled through ASP.NET identity roles.
        /// This is merely for viewing.
        /// </summary>
        /// <param name="id">The id of the users whose role should be updated</param>
        /// <param name="role">The number associated with the role.  Can be found in UserHelpers.UserRoles.  This is NOT validated, because it doesn't actually affect anything.</param>
        public void UpdateUserRole(int id, int role)
        {
            string sql = "UPDATE Volunteers SET role = @role WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;
                    cmd.Parameters.Add("@role", NpgsqlTypes.NpgsqlDbType.Integer).Value = role;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Given a volunteer id, retrieves a list of DateTimes the volunteer has been marked for attendance
        /// </summary>
        /// <returns>List of DateTimes associated with the volunteer's attendance</returns>
        public List<DateTime> GetAttendanceDates(int volunteerId)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT * FROM Volunteer_Attendance
                              WHERE volunteerid = @volunteerId 
                              AND attended = CAST(1 as bit)";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
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
        /// For a given day, retrieves a list of volunteers who have checked in or signed up (or both)
        /// </summary>
        /// <param name="checkedIn">A volunteer was marked in attendance for this day</param>
        /// <param name="signedUp"> A volunteer was on the schedule for this day</param>
        /// <returns>List of volunteer models with the following fields retrieved:
        ///  First name, last name, list of trainings completed, class id and name, bus id and name</returns>
        public List<VolunteerModel> GetDaysVolunteers(DateTime day, bool checkedIn, bool signedUp)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT va.volunteerid,
                                      v.firstname, v.lastname,
                                      cl.id as classid, cl.description,
                                      b.id as busid, b.name as busname
                               FROM Volunteer_Attendance va
                               LEFT JOIN Volunteers v
                               ON va.volunteerid = v.id
                               LEFT JOIN Class_List cl
                               ON va.volunteerid = cl.teacherid
                               LEFT JOIN Bus b
                               ON va.volunteerid = b.driverid

                               WHERE dayattended = @day
                               AND attended = @checkedIn
                               AND scheduled = @signedUp";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@checkedIn", NpgsqlTypes.NpgsqlDbType.Bit).Value = checkedIn;
                    cmd.Parameters.Add("@signedUp", NpgsqlTypes.NpgsqlDbType.Bit).Value = signedUp;
                    cmd.Parameters.Add("@day", NpgsqlTypes.NpgsqlDbType.Date).Value = day;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<VolunteerModel> volunteers = new List<VolunteerModel>();
            foreach (DataRow dr in dt.Rows)
            {
                // Not all volunteers have a class and bus id, so check if the DB values are null
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

                volunteers.Add(new VolunteerModel
                {
                    //Id = (int)dr["volunteerid"],
                    FirstName = dr["firstName"].ToString(),
                    LastName = dr["lastName"].ToString(),
                    Class = new Pair
                    {
                        Id = classId,
                        Name = dr["description"].ToString()
                    },
                    Bus = new Pair
                    {
                        Id = busId,
                        Name = dr["busname"].ToString()
                    },
                    Trainings = GetVolunteerTrainings((int)dr["volunteerid"]).ToArray(),
                });
            }

            return volunteers;
        }
    }
}
