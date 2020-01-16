﻿using System;
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
    }
}
