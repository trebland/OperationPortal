using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using API.Models;
using Npgsql;

namespace API.Data
{
    public class AnnouncementRepository
    {
        private readonly string connString;
        
        public AnnouncementRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Get the list of announcements
        /// </summary>
        /// <parameter name="activeOnly">Determines whether inactive announcements should be shown as well as active ones</parameter>
        /// <returns>A list of AnnouncementModel objects</returns>
        public List<AnnouncementModel> GetAnnouncementList(bool activeOnly = true)
        {
            NpgsqlDataAdapter da;
            List<AnnouncementModel> announcements = new List<AnnouncementModel>();
            DataTable dt = new DataTable();
            string sql = "SELECT * FROM Announcements";
            if (activeOnly)
            {
                sql += " WHERE startdate <= CURRENT_DATE AND enddate >= CURRENT_DATE";
            }

            // Connect to the database
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create the sql command
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
                announcements.Add(new AnnouncementModel
                {
                    Id = (int)dr["id"],
                    Title = dr["title"].ToString(),
                    Message = dr["message"].ToString(),
                    Author = dr["author"].ToString(),
                    LastUpdateBy = dr["lastupdatedby"].ToString(),
                    StartDate = Convert.ToDateTime(dr["startdate"]).Date,
                    EndDate = Convert.ToDateTime(dr["enddate"]).Date
                });
            }

            return announcements;
        }

        /// <summary>
        /// Gets the specified announcement
        /// </summary>
        /// <param name="id">The id of the announcement to be returned</param>
        /// <returns>An AnnouncementModel object representing the announcement</returns>
        public AnnouncementModel GetAnnouncement(int id)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = "SELECT * FROM Announcements WHERE id = @id LIMIT 1";

            // Connect to the database
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create the sql command
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    // Add the id parameter
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    // Make the query
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

            return new AnnouncementModel { 
                Id = (int)dr["id"],
                Title = dr["title"].ToString(),
                Message = dr["message"].ToString(),
                Author = dr["author"].ToString(),
                LastUpdateBy = dr["lastupdatedby"].ToString(),
                StartDate = Convert.ToDateTime(dr["startdate"]),
                EndDate =  Convert.ToDateTime(dr["enddate"])
            };
        }
        

        /// <summary>
        /// Updates an announcement's title, message, start date, and/or end date
        /// </summary>
        /// <param name="anc">An AnnouncementModel object with the announcement to be updated</param>
        public void UpdateAnnouncement(AnnouncementModel anc)
        {
            string sql = "UPDATE Announcements SET title = @title, message = @message, startdate = @startDate, enddate = @endDate, lastupdatedby = @lastUpdateBy WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@title", NpgsqlTypes.NpgsqlDbType.Varchar).Value = anc.Title;
                    cmd.Parameters.Add("@message", NpgsqlTypes.NpgsqlDbType.Varchar).Value = anc.Message;
                    cmd.Parameters.Add("@lastUpdateBy", NpgsqlTypes.NpgsqlDbType.Varchar).Value = anc.LastUpdateBy;
                    cmd.Parameters.Add("@startDate", NpgsqlTypes.NpgsqlDbType.Date).Value = anc.StartDate;
                    cmd.Parameters.Add("@endDate", NpgsqlTypes.NpgsqlDbType.Date).Value = anc.EndDate;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = anc.Id;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Inserts a new record representing a bus into the database
        /// </summary>
        /// <param name="name">The name of the bus</param>
        /// <param name="route">The description of the bus' route</param>
        public void CreateAnnouncement(AnnouncementModel anc)
        {
            string sql = @"INSERT INTO Announcements (title, message, author, lastupdatedby, startdate, enddate) 
                           VALUES (@title, @message, @author, @author, @start, @end)";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@title", NpgsqlTypes.NpgsqlDbType.Varchar).Value = anc.Title;
                    cmd.Parameters.Add("@message", NpgsqlTypes.NpgsqlDbType.Varchar).Value = anc.Message;
                    cmd.Parameters.Add("@author", NpgsqlTypes.NpgsqlDbType.Varchar).Value = anc.Author;
                    cmd.Parameters.Add("@start", NpgsqlTypes.NpgsqlDbType.Date).Value = anc.StartDate;
                    cmd.Parameters.Add("@end", NpgsqlTypes.NpgsqlDbType.Date).Value = anc.EndDate;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }
    }
}
