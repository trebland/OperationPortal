using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using Npgsql;
using API.Models;
using API.Helpers;
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
        /// Inserts a guest volunteer into the database
        /// </summary>
        /// <param name="guest">A GuestModel object containing the information to be inserted</param>
        public void CreateGuestVolunteer(GuestVolunteerModel guest)
        {
            string sql = @"INSERT INTO Guest_Volunteers (FirstName, LastName, Email, Affiliation, Date) 
                           VALUES (@fname, @lname, @email, @affiliation, @date) ";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@fname", NpgsqlTypes.NpgsqlDbType.Varchar).Value = guest.FirstName;
                    cmd.Parameters.Add("@lname", NpgsqlTypes.NpgsqlDbType.Varchar).Value = guest.LastName;
                    cmd.Parameters.Add("@email", NpgsqlTypes.NpgsqlDbType.Varchar).Value = guest.Email;
                    cmd.Parameters.Add("@affiliation", NpgsqlTypes.NpgsqlDbType.Varchar).Value = guest.Affiliation;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = guest.Date;


                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        public List<GuestVolunteerModel> GetGuestVolunteers(DateTime date)
        {
            string sql = "SELECT * FROM Guest_Volunteers WHERE Date = @date";
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            List<GuestVolunteerModel> list = new List<GuestVolunteerModel>();

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    da = new NpgsqlDataAdapter(cmd);

                    // Make the query
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                list.Add(new GuestVolunteerModel
                {
                    Id = (int)dr["id"],
                    FirstName = dr["FirstName"].ToString(),
                    LastName = dr["LastName"].ToString(),
                    Email = dr["Email"].ToString(),
                    Affiliation = dr["Affiliation"].ToString(),
                    Date = Convert.ToDateTime(dr["Date"])
                });
            }

            return list;
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
                PreferredName = dr["preferredName"].ToString(),
                WeeksAttended = (int)dr["weekendsAttended"],
                Role = ((UserHelpers.UserRoles)dr["role"]).ToString(),
                Orientation = dr["orientation"] == DBNull.Value ? false : (bool)dr["orientation"],
                Affiliation = dr["affiliation"].ToString(),
                Referral = dr["Referral"].ToString(),
                Newsletter = dr["newsletter"] == DBNull.Value ? false : (bool)dr["newsletter"],
                ContactWhenShort = dr["contactWhenShort"] == DBNull.Value ? false : (bool)dr["contactWhenShort"],
                Phone = dr["phone"].ToString(),
                Email = dr["email"].ToString(),
                BackgroundCheck = dr["backgroundcheck"] == DBNull.Value ? false : (bool)dr["backgroundcheck"],
                BlueShirt = dr["blueshirt"] == DBNull.Value ? false : (bool)dr["blueshirt"],
                NameTag = dr["nametag"] == DBNull.Value ? false : (bool)dr["nametag"],
                PersonalInterviewCompleted = dr["personalinterviewcompleted"] == DBNull.Value ? false : (bool)dr["personalinterviewcompleted"],
                YearStarted = (int)dr["yearstarted"],
                CanEditInventory = (bool)dr["caneditinventory"],
                Birthday = dr["birthday"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["birthday"]),
                Picture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"],
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
                    PreferredName = dr["preferredName"].ToString(),
                    WeeksAttended = (int)dr["weekendsAttended"],
                    Role = ((UserHelpers.UserRoles)dr["role"]).ToString(),
                    Orientation = dr["orientation"] == DBNull.Value ? false : (bool)dr["orientation"],
                    Affiliation = dr["affiliation"].ToString(),
                    Referral = dr["Referral"].ToString(),
                    Newsletter = dr["newsletter"] == DBNull.Value ? false : (bool)dr["newsletter"],
                    ContactWhenShort = dr["contactWhenShort"] == DBNull.Value ? false : (bool)dr["contactWhenShort"],
                    Phone = dr["phone"].ToString(),
                    Email = dr["email"].ToString(),
                    BackgroundCheck = dr["backgroundcheck"] == DBNull.Value ? false : (bool)dr["backgroundcheck"],
                    BlueShirt = dr["blueshirt"] == DBNull.Value ? false : (bool)dr["blueshirt"],
                    NameTag = dr["nametag"] == DBNull.Value ? false : (bool)dr["nametag"],
                    PersonalInterviewCompleted = dr["personalinterviewcompleted"] == DBNull.Value ? false : (bool)dr["personalinterviewcompleted"],
                    YearStarted = (int)dr["yearstarted"],
                    CanEditInventory = dr["caneditinventory"] == null ? false : (bool)dr["caneditinventory"],
                    Birthday = dr["birthday"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["birthday"]),
                    Picture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"],
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
        /// <param name="allRoles">Whether or not to return ALL who are scheduled.  By default, will only return those of the volunteer role</param>
        /// <returns>A list of VolunteerModel objects</returns>
        public List<VolunteerModel> GetScheduledVolunteers(DateTime date, bool allRoles = false)
        {
            List<VolunteerModel> volunteers = new List<VolunteerModel>();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT V.* 
                           FROM Volunteers AS V INNER JOIN 
                           Volunteer_Attendance AS VA ON VA.volunteerId = V.id 
                           WHERE VA.dayattended = @date AND VA.scheduled = CAST(1 as bit) AND (V.Role = @volRole OR @allRoles = 1)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create and run Postgres command.
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                    cmd.Parameters.Add("@volRole", NpgsqlTypes.NpgsqlDbType.Integer).Value = (int)UserHelpers.UserRoles.Volunteer;
                    cmd.Parameters.Add("@allRoles", NpgsqlTypes.NpgsqlDbType.Integer).Value = allRoles ? 1 : 0;

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
                    PreferredName = dr["preferredName"].ToString(),
                    WeeksAttended = (int)dr["weekendsAttended"],
                    Role = ((UserHelpers.UserRoles)dr["role"]).ToString(),
                    Orientation = dr["orientation"] == DBNull.Value ? false : (bool)dr["orientation"],
                    Affiliation = dr["affiliation"].ToString(),
                    Referral = dr["Referral"].ToString(),
                    Newsletter = dr["newsletter"] == DBNull.Value ? false : (bool)dr["newsletter"],
                    ContactWhenShort = dr["contactWhenShort"] == DBNull.Value ? false : (bool)dr["contactWhenShort"],
                    Phone = dr["phone"].ToString(),
                    Email = dr["email"].ToString(),
                    BackgroundCheck = dr["backgroundcheck"] == DBNull.Value ? false : (bool)dr["backgroundcheck"],
                    BlueShirt = dr["blueshirt"] == DBNull.Value ? false : (bool)dr["blueshirt"],
                    NameTag = dr["nametag"] == DBNull.Value ? false : (bool)dr["nametag"],
                    PersonalInterviewCompleted = dr["personalinterviewcompleted"] == DBNull.Value ? false : (bool)dr["personalinterviewcompleted"],
                    YearStarted = (int)dr["yearstarted"],
                    CanEditInventory = (bool)dr["caneditinventory"],
                    Birthday = dr["birthday"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["birthday"]),
                    Picture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"],
                    Trainings = GetVolunteerTrainings((int)dr["id"]).ToArray(),
                    Languages = GetVolunteerLanguages((int)dr["id"]).ToArray()
                });
            }

            return volunteers;
        }


        /// <summary>
        /// Checks if a user is registered as the teacher for some class
        /// </summary>
        /// <param name="id">The id of the volunteer to check</param>
        /// <returns>True or false</returns>
        public bool VolunteerIsClassTeacher(int id)
        {
            string sql = "SELECT id FROM Class_List WHERE TeacherId = @tid";
            object result;

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create and run Postgres command.
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@tid", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    con.Open();
                    result = cmd.ExecuteScalar();
                    con.Close();
                }
            }

            if (result == null || (int)result == 0)
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Gets the list of those whose role is above volunteer who have said they will not be present on a given day
        /// </summary>
        /// <param name="date">The date to check signups for</param>
        /// <returns>A list of VolunteerModel objects</returns>
        public List<VolunteerModel> GetAbsences(DateTime date)
        {
            List<VolunteerModel> volunteers = new List<VolunteerModel>();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT V.* 
                           FROM Volunteers AS V INNER JOIN 
                           Volunteer_Attendance AS VA ON VA.volunteerId = V.id 
                           WHERE VA.dayattended = @date AND VA.scheduled = CAST(0 as bit) AND V.Role <> @volRole
                           UNION 
                           SELECT V.* 
                           FROM Volunteers AS V INNER JOIN 
                           Volunteer_Attendance AS VA ON VA.volunteerId = V.id INNER JOIN 
                           Class_List AS CL ON CL.teacherId = V.id 
                           WHERE VA.dayattended = @date AND VA.scheduled = CAST(0 as bit)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create and run Postgres command.
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                    cmd.Parameters.Add("@volRole", NpgsqlTypes.NpgsqlDbType.Integer).Value = (int)UserHelpers.UserRoles.Volunteer;

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
                    PreferredName = dr["preferredName"].ToString(),
                    WeeksAttended = (int)dr["weekendsAttended"],
                    Role = ((UserHelpers.UserRoles)dr["role"]).ToString(),
                    Orientation = dr["orientation"] == DBNull.Value ? false : (bool)dr["orientation"],
                    Affiliation = dr["affiliation"].ToString(),
                    Referral = dr["Referral"].ToString(),
                    Newsletter = dr["newsletter"] == DBNull.Value ? false : (bool)dr["newsletter"],
                    ContactWhenShort = dr["contactWhenShort"] == DBNull.Value ? false : (bool)dr["contactWhenShort"],
                    Phone = dr["phone"].ToString(),
                    Email = dr["email"].ToString(),
                    BackgroundCheck = dr["backgroundcheck"] == DBNull.Value ? false : (bool)dr["backgroundcheck"],
                    BlueShirt = dr["blueshirt"] == DBNull.Value ? false : (bool)dr["blueshirt"],
                    NameTag = dr["nametag"] == DBNull.Value ? false : (bool)dr["nametag"],
                    PersonalInterviewCompleted = dr["personalinterviewcompleted"] == DBNull.Value ? false : (bool)dr["personalinterviewcompleted"],
                    YearStarted = (int)dr["yearstarted"],
                    CanEditInventory = (bool)dr["caneditinventory"],
                    Birthday = dr["birthday"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["birthday"]),
                    Picture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"],
                    Trainings = GetVolunteerTrainings((int)dr["id"]).ToArray(),
                    Languages = GetVolunteerLanguages((int)dr["id"]).ToArray()
                });
            }

            return volunteers;
        }

        #region Training database access

        /// <summary>
        /// Creates a training that volunteers can be marked as having completed
        /// </summary>
        /// <param name="name">The name of the training</param>
        public void CreateTraining (string name)
        {
            string sql = "INSERT INTO Training (TrainingType, Name) VALUES (1, @name)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = name;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Edit the name of a training
        /// </summary>
        /// <param name="id">The id of the training to edit</param>
        /// <param name="name">The name of the training</param>
        public void EditTraining (int id, string name)
        {
            string sql = "UPDATE Training SET Name = @name WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = name;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Delete a training and all records of those who have completed it
        /// </summary>
        /// <param name="id">The id of the training to delete</param>
        public void DeleteTraining(int id)
        {
            string sql = "DELETE FROM Trainings_Completed WHERE trainingId = @id; DELETE FROM Training WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Gets the list of all trainings in the database
        /// </summary>
        /// <returns>A list of VolunteerTrainingModel objects</returns>
        public List<VolunteerTrainingModel> GetTrainings()
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<VolunteerTrainingModel> trainings = new List<VolunteerTrainingModel>();
            string sql = "SELECT id, Name FROM Training";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    da = new NpgsqlDataAdapter(cmd);

                    // Make the query
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach(DataRow dr in dt.Rows)
            {
                trainings.Add(new VolunteerTrainingModel
                {
                    Id = (int)dr["id"],
                    Name = dr["Name"].ToString()
                });
            }

            return trainings;
        }

        /// <summary>
        /// Gets a specific TrainingModel object
        /// </summary>
        /// <returns>A list of VolunteerTrainingModel objects</returns>
        public VolunteerTrainingModel GetTraining(int id)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = "SELECT id, Name FROM Training WHERE id = @id LIMIT 1";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;
                    da = new NpgsqlDataAdapter(cmd);

                    // Make the query
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count == 0)
            {
                return null;
            }

            dr = dt.Rows[0];

            return new VolunteerTrainingModel
            {
                Id = (int)dr["id"],
                Name = dr["Name"].ToString()
            };
        }

        /// <summary>
        /// Adds a record that a volunteer has completed a specific training
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer</param>
        /// <param name="trainingId">The id of the training</param>
        public void AddTrainingCompleted (int volunteerId, int trainingId)
        {
            string sql = "INSERT INTO Trainings_Completed (volunteerId, trainingId) VALUES (@vid, @tid)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@tid", NpgsqlTypes.NpgsqlDbType.Integer).Value = trainingId;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Removes a record that a volunteer has completed a specific training
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer</param>
        /// <param name="trainingId">The id of the training</param>
        public void RemoveTrainingCompleted (int volunteerId, int trainingId)
        {
            string sql = "DELETE FROM Trainings_Completed WHERE volunteerId = @vid AND trainingId = @tid";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@tid", NpgsqlTypes.NpgsqlDbType.Integer).Value = trainingId;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Gets the list of trainings a given volunteer has completed
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer whose trainings are being queried</param>
        /// <returns>A list of training names</returns>
        public List<VolunteerTrainingModel> GetVolunteerTrainings(int volunteerId)
        {
            List<VolunteerTrainingModel> trainings = new List<VolunteerTrainingModel>();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT T.id, T.name FROM Training AS T 
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
                trainings.Add(new VolunteerTrainingModel {
                    Id = (int)dr["id"],
                    Name = dr["name"].ToString()
                });
            }

            return trainings;
        }

        #endregion

        #region Volunteer job database access

        /// <summary>
        /// Checks if volunteer jobs have been enabled in the database
        /// </summary>
        /// <returns>True or false</returns>
        public bool AreVolunteerJobsEnabled()
        {
            string sql = "SELECT JobsEnabled FROM Settings LIMIT 1";
            object result;

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    // Make the query
                    con.Open();
                    result = cmd.ExecuteScalar();
                    con.Close();
                }
            }

            if (result == null)
            {
                throw new Exception("JobsEnabled has not been set in the database.  Please ensure app settings have been properly set.");
            }

            return (bool)result;
        }

        /// <summary>
        /// Toggles whether or not volunteer jobs are enabled in the database
        /// </summary>
        public void ToggleVolunteerJobs()
        {
            string sql = "UPDATE Settings SET JobsEnabled = NOT JobsEnabled";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Creates a job that volunteers can sign up for specifically
        /// </summary>
        /// <param name="job">A VolunteerJobModel object with the name, min, and max</param>
        public void CreateVolunteerJob(VolunteerJobModel job)
        {
            string sql = "INSERT INTO Volunteer_Jobs (Name, Min, Max) VALUES (@name, @min, @max)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = job.Name;
                    cmd.Parameters.Add("@min", NpgsqlTypes.NpgsqlDbType.Integer).Value = job.Min;
                    cmd.Parameters.Add("@max", NpgsqlTypes.NpgsqlDbType.Integer).Value = job.Max;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Edits a job that volunteers can sign up for specifically
        /// </summary>
        /// <param name="job">A VolunteerJobModel object with the id, name, min, and max</param>
        public void UpdateVolunteerJob(VolunteerJobModel job)
        {
            string sql = "UPDATE Volunteer_Jobs SET Name = @name, Min = @min, Max = @max WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = job.Name;
                    cmd.Parameters.Add("@min", NpgsqlTypes.NpgsqlDbType.Integer).Value = job.Min;
                    cmd.Parameters.Add("@max", NpgsqlTypes.NpgsqlDbType.Integer).Value = job.Max;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = job.Id;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Deletes a job so it cannot be signed up for
        /// </summary>
        /// <param name="job">A VolunteerJobModel object with the id of the job to delete</param>
        public void DeleteVolunteerJob(VolunteerJobModel job)
        {
            string sql = "DELETE FROM Volunteer_Jobs_Assignment WHERE VolunteerJobId = @id; DELETE FROM Volunteer_Jobs  WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = job.Id;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Gets the list of all jobs in the database
        /// </summary>
        /// <param name="date">A date to check the signup count for.  If the date is the min value of DateTime, no count will be provided</param>
        /// <returns>A list of VolunteerJobModel objects</returns>
        public List<VolunteerJobModel> GetVolunteerJobs(DateTime date, bool includeNames = false)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<VolunteerJobModel> jobs = new List<VolunteerJobModel>();
            string sql = "SELECT id, Name, Min, Max FROM Volunteer_Jobs";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    da = new NpgsqlDataAdapter(cmd);

                    // Make the query
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {

                if (date != DateTime.MinValue)
                {
                    jobs.Add(new VolunteerJobModel
                    {
                        Id = (int)dr["id"],
                        Name = dr["Name"].ToString(),
                        Min = (int)dr["Min"],
                        Max = (int)dr["Max"],
                        CurrentNumber = GetJobSignupCount((int)dr["id"], date),
                        Volunteers = includeNames ? GetJobVolunteerNames((int)dr["id"], date) : null
                    });
                }
                else
                {
                    jobs.Add(new VolunteerJobModel
                    {
                        Id = (int)dr["id"],
                        Name = dr["Name"].ToString(),
                        Min = (int)dr["Min"],
                        Max = (int)dr["Max"]
                    });
                }
                
            }

            return jobs;
        }

        /// <summary>
        /// Gets a specific job
        /// </summary>
        /// <param name="id">The id of the job to retrieve</param>
        /// <param name="date">A date to get the count for.  If the date is the minimum value of DateTime, no count will be retrieved</param>
        /// <returns>A list of VolunteerJobModel objects</returns>
        public VolunteerJobModel GetVolunteerJob(int id, DateTime date)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = "SELECT id, Name, Min, Max FROM Volunteer_Jobs WHERE id = @id LIMIT 1";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;
                    da = new NpgsqlDataAdapter(cmd);

                    // Make the query
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count == 0)
            {
                return null;
            }

            dr = dt.Rows[0];

            if (date == DateTime.MinValue)
            {
                return new VolunteerJobModel
                {
                    Id = (int)dr["id"],
                    Name = dr["Name"].ToString(),
                    Min = (int)dr["Min"],
                    Max = (int)dr["Max"]
                };
            }
            else
            {
                return new VolunteerJobModel
                {
                    Id = (int)dr["id"],
                    Name = dr["Name"].ToString(),
                    Min = (int)dr["Min"],
                    Max = (int)dr["Max"],
                    CurrentNumber = GetJobSignupCount(id, date)
                };
            }
        }

        /// <summary>
        /// Checks if a user is signed up for a specific job on a specific date
        /// </summary>
        /// <param name="jobId">The id of the job</param>
        /// <param name="volunteerId">The id of the volunteer</param>
        /// <param name="date">The date</param>
        /// <returns>True or false</returns>
        public bool CheckSignedUpForJob (int jobId, int volunteerId, DateTime date)
        {
            int count;
            string sql = "SELECT COUNT(*) FROM Volunteer_Jobs_Assignment WHERE VolunteerJobId = @jid AND VolunteerId = @vid AND Date = @date";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@jid", NpgsqlTypes.NpgsqlDbType.Integer).Value = jobId;
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    // Make the query
                    con.Open();
                    count = Convert.ToInt32(cmd.ExecuteScalar());
                    con.Close();
                }
            }

            return count > 0;
        }

        /// <summary>
        /// Get the names and ids of volunteers who have signed up for a job in a date.  Does not get the full volunteer profile
        /// </summary>
        /// <param name="jobId">The id of the job</param>
        /// <param name="date">The date</param>
        /// <returns>A list of VolunteerModels containing only id, preferred name, and last name</returns>
        public List<VolunteerModel> GetJobVolunteerNames(int jobId, DateTime date)
        {
            List<VolunteerModel> list = new List<VolunteerModel>();
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            string sql = @"SELECT V.id, V.PreferredName, V.LastName
                           FROM Volunteers AS V INNER JOIN 
                           Volunteer_Jobs_Assignment AS JA ON JA.volunteerid = V.id INNER JOIN 
                           Volunteer_Jobs AS J on JA.volunteerjobid = J.id 
                           WHERE J.id = @jid AND Date = @date";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@jid", NpgsqlTypes.NpgsqlDbType.Integer).Value = jobId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    da = new NpgsqlDataAdapter(cmd);
                    // Make the query
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                list.Add(new VolunteerModel
                {
                    Id = (int)dr["id"],
                    PreferredName = dr["PreferredName"].ToString(),
                    LastName = dr["LastName"].ToString()
                });
            }

            return list;
        }

        /// <summary>
        /// Gets the number of volunteers signed up for a specific job
        /// </summary>
        /// <param name="jobId">The id of the job</param>
        /// <param name="date">The date to check</param>
        /// <returns>An integer with the number signed up</returns>
        public int GetJobSignupCount (int jobId, DateTime date)
        {
            int count;
            string sql = "SELECT COUNT(*) FROM Volunteer_Jobs_Assignment WHERE VolunteerJobId = @jid AND Date = @date";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@jid", NpgsqlTypes.NpgsqlDbType.Integer).Value = jobId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    // Make the query
                    con.Open();
                    count = Convert.ToInt32(cmd.ExecuteScalar());
                    con.Close();
                }
            }

            return count;
        }

        /// <summary>
        /// Signs a user up for a job on a specific date
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer</param>
        /// <param name="jobId">The id of the job</param>
        /// <param name="date">The date</param>
        public void AddVolunteerJobAssignment(int volunteerId, int jobId, DateTime date)
        {
            string sql = "INSERT INTO Volunteer_Jobs_Assignment (volunteerid, volunteerjobid, date) VALUES (@vid, @jid, @date)";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@jid", NpgsqlTypes.NpgsqlDbType.Integer).Value = jobId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Cancels a user having signed up for a job on a date
        /// </summary>
        /// <param name="volunteerId">The id of the volunteer</param>
        /// <param name="jobId">The id of the job</param>
        /// <param name="date">The date</param>
        public void RemoveVolunteerJobAssignment(int volunteerId, int jobId, DateTime date)
        {
            string sql = "DELETE FROM Volunteer_Jobs_Assignment WHERE volunteerid = @vid AND volunteerjobid = @jid AND date = @date";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@vid", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@jid", NpgsqlTypes.NpgsqlDbType.Integer).Value = jobId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        #endregion

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
        public int CreateVolunteer(VolunteerModel volunteer)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = @"INSERT INTO Volunteers (firstName, lastName, preferredName, email, role, weekendsAttended, orientation, affiliation, referral, newsletter,contactWhenShort, phone, backgroundCheck, blueShirt, nametag, personalInterviewCompleted, yearStarted, CanEditInventory, Picture) 
                           VALUES (@firstName, @lastName, @prefName, @email, 1, 0, CAST(0 as bit), '', '', CAST(0 as bit), CAST(0 as bit), '', false, false, false, false, @year, false, @picture ) 
                           RETURNING id";

            // Connect to DB
            using(NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand (sql, con))
                {
                    cmd.Parameters.Add("@firstName", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = volunteer.FirstName;
                    cmd.Parameters.Add("@lastName", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = volunteer.LastName;
                    cmd.Parameters.Add("@prefName", NpgsqlTypes.NpgsqlDbType.Varchar).Value = volunteer.PreferredName;
                    cmd.Parameters.Add("@email", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = volunteer.Email;
                    cmd.Parameters.Add("@year", NpgsqlTypes.NpgsqlDbType.Integer).Value = DateTime.Now.Year;
                    if (volunteer.Picture == null)
                    {
                        cmd.Parameters.Add("@picture", NpgsqlTypes.NpgsqlDbType.Bytea).Value = DBNull.Value;
                    }
                    else
                    {
                        cmd.Parameters.Add("@picture", NpgsqlTypes.NpgsqlDbType.Bytea).Value = volunteer.Picture;
                    }

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count != 1)
            {
                return 0;
            }

            dr = dt.Rows[0];
            return (int)dr["id"];
        }

        /// <summary>
        /// Allows for updating a volunteer's profile information.  DOES NOT update email or any of the administrative records about them
        /// </summary>
        /// <param name="v">A VolunteerModel object.  Should contain id, first name, last name, preferred name, affiliation, referral, newsletter, phone, birthday, picture, and contactwhenshort</param>
        public void UpdateVolunteerProfile(VolunteerModel v)
        {
            string sql = @"UPDATE Volunteers 
                           SET FirstName = @fname, 
                                LastName = @lname, 
                                PreferredName = @pname,
                                Phone = @phone, 
                                Referral = @referral, 
                                Affiliation = @affiliation,
                                Newsletter = @newsletter, 
                                ContactWhenShort = @contact,
                                Birthday = @birthday,
                                Picture = @picture
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
                    cmd.Parameters.Add("@pname", NpgsqlTypes.NpgsqlDbType.Varchar).Value = v.PreferredName;
                    cmd.Parameters.Add("@phone", NpgsqlTypes.NpgsqlDbType.Varchar).Value = v.Phone;
                    cmd.Parameters.Add("@referral", NpgsqlTypes.NpgsqlDbType.Varchar).Value = v.Referral;
                    cmd.Parameters.Add("@affiliation", NpgsqlTypes.NpgsqlDbType.Varchar).Value = v.Affiliation;
                    cmd.Parameters.Add("@newsletter", NpgsqlTypes.NpgsqlDbType.Bit).Value = v.Newsletter;
                    cmd.Parameters.Add("@contact", NpgsqlTypes.NpgsqlDbType.Bit).Value = v.ContactWhenShort;
                    cmd.Parameters.Add("@birthday", NpgsqlTypes.NpgsqlDbType.Date).Value = v.Birthday;
                    cmd.Parameters.Add("@picture", NpgsqlTypes.NpgsqlDbType.Bytea).Value = v.Picture;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            return;
        }

        /// <summary>
        /// Allows for updating the administrative records for a volunteer.  Does not update trainings, which are separate
        /// </summary>
        /// <param name="v">A VolunteerModel object.  Should contain id, Orientation, BlueShirt, Nametag, PersonalInterviewCompleted, and YearStarted</param>
        public void UpdateVolunteerRecords(VolunteerModel v)
        {
            string sql = @"UPDATE Volunteers 
                           SET orientation = @orientation,
                               backgroundcheck = @background,
                               blueshirt = @shirt,
                               nametag = @nametag,
                               personalinterviewcompleted = @interview,
                               yearstarted = @year,
                               canEditInventory = @inventory
                           WHERE id = @id";

            // Connect to DB
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create command and add parameters - again, using parameters to make sure SQL Injection can't occur
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = v.Id;
                    cmd.Parameters.Add("@orientation", NpgsqlTypes.NpgsqlDbType.Bit).Value = v.Orientation;
                    cmd.Parameters.Add("@background", NpgsqlTypes.NpgsqlDbType.Boolean).Value = v.BackgroundCheck;
                    cmd.Parameters.Add("@shirt", NpgsqlTypes.NpgsqlDbType.Boolean).Value = v.BlueShirt;
                    cmd.Parameters.Add("@nametag", NpgsqlTypes.NpgsqlDbType.Boolean).Value = v.NameTag;
                    cmd.Parameters.Add("@interview", NpgsqlTypes.NpgsqlDbType.Boolean).Value = v.PersonalInterviewCompleted;
                    cmd.Parameters.Add("@year", NpgsqlTypes.NpgsqlDbType.Integer).Value = v.YearStarted;
                    cmd.Parameters.Add("@inventory", NpgsqlTypes.NpgsqlDbType.Boolean).Value = v.CanEditInventory;

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
                string sql = @"SELECT v.*
                               FROM Volunteers v
                               LEFT JOIN Volunteer_Attendance va
                               ON va.volunteerid = v.id
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
                volunteers.Add(new VolunteerModel
                {
                    Id = (int)dr["id"],
                    FirstName = dr["firstName"].ToString(),
                    PreferredName = dr["preferredName"].ToString(),
                    LastName = dr["lastName"].ToString(),
                    WeeksAttended = (int)dr["weekendsAttended"],
                    Role = ((UserHelpers.UserRoles)dr["role"]).ToString(),
                    Orientation = dr["orientation"] == DBNull.Value ? false : (bool)dr["orientation"],
                    Trainings = GetVolunteerTrainings((int)dr["id"]).ToArray(),
                    Affiliation = dr["affiliation"].ToString(),
                    Referral = dr["Referral"].ToString(),
                    Languages = GetVolunteerLanguages((int)dr["id"]).ToArray(),
                    Newsletter = dr["newsletter"] == DBNull.Value ? false : (bool)dr["newsletter"],
                    ContactWhenShort = dr["contactWhenShort"] == DBNull.Value ? false : (bool)dr["contactWhenShort"],
                    Phone = dr["phone"].ToString(),
                    Email = dr["email"].ToString(),
                    BlueShirt = dr["blueshirt"] == DBNull.Value ? false : (bool)dr["blueshirt"],
                    NameTag = dr["nametag"] == DBNull.Value ? false : (bool)dr["nametag"],
                    PersonalInterviewCompleted = dr["personalinterviewcompleted"] == DBNull.Value ? false : (bool)dr["personalinterviewcompleted"],
                    BackgroundCheck = dr["backgroundcheck"] == DBNull.Value ? false : (bool)dr["backgroundcheck"],
                    YearStarted = (int)dr["yearstarted"],
                    CanEditInventory = (bool)dr["caneditinventory"],
                    Picture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"],
                    Birthday = dr["birthday"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["birthday"])
                });
            }

            return volunteers;
        }

        /// <summary>
        /// Gets all of the names and birthdays of volunteers with a birthday in the given month
        /// </summary>
        /// <param name="month">The number of the month in question</param>
        /// <returns>A list of BirthdayModel objects</returns>
        public List<BirthdayModel> GetBirthdays(int month)
        {
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = "SELECT firstname, lastname, birthday from volunteers where EXTRACT(month from birthday) = @month";
            List<BirthdayModel> birthdays = new List<BirthdayModel>();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@month", NpgsqlTypes.NpgsqlDbType.Integer).Value = month;

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                birthdays.Add(new BirthdayModel
                {
                    Name = dr["firstname"].ToString() + " " + dr["lastname"].ToString(),
                    Date = Convert.ToDateTime(dr["birthday"])
                });
            }

            return birthdays;
        }

        /// <summary>
        /// Gets a list of all users with the bus driver role
        /// </summary>
        /// <returns>A list of VolunteerModels with only the name and id filled out</returns>
        public List<VolunteerModel> GetBusDrivers()
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<VolunteerModel> drivers = new List<VolunteerModel>();
            string sql = $"SELECT id, firstname, preferredname, lastname FROM volunteers WHERE role = {(int)UserHelpers.UserRoles.BusDriver}";

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
                drivers.Add(new VolunteerModel
                {
                    Id = (int)dr["id"],
                    FirstName = dr["firstname"].ToString(),
                    PreferredName = dr["preferredname"].ToString(),
                    LastName = dr["lastname"].ToString()
                });
            }

            return drivers;
        }

        /// <summary>
        /// Searches for volunteers by last name, first name, or preferred name
        /// </summary>
        /// <param name="searchString">The string to search for</param>
        /// <returns>A list of VolunteerModel objects with id, last name, preferred name, and first name filled out</returns>
        public List<VolunteerModel> SearchVolunteers(string searchString)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            List<VolunteerModel> volunteers = new List<VolunteerModel>();
            string sql = @"SELECT id, firstname, preferredname, lastname FROM volunteers 
                           WHERE UPPER(firstname) LIKE '%' || @search || '%' OR UPPER(preferredname) LIKE '%' || @search || '%' OR UPPER(lastname) LIKE '%' || @search || '%' 
                           ORDER BY lastname, preferredname, firstname";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@search", NpgsqlTypes.NpgsqlDbType.Varchar).Value = searchString.ToUpper();

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                volunteers.Add(new VolunteerModel
                {
                    Id = (int)dr["id"],
                    FirstName = dr["firstname"].ToString(),
                    PreferredName = dr["preferredname"].ToString(),
                    LastName = dr["lastname"].ToString()
                });
            }

            return volunteers;
        }
    }
}
