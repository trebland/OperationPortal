using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using Npgsql;
using API.Models;
using System.Data;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace API.Data
{
    public class AnalyticsRepository
    {
        private readonly string connString;
        public AnalyticsRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Returns the number of children who have ever attended OCC
        /// </summary>
        public int GetChildrenTotal()
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT COUNT(*)
                              FROM Child";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            return (int)(long)dt.Rows[0]["count"];
        }

        /// <summary>
        /// Returns the number of children who have ever attended OCC, grouped by age
        /// </summary>
        public List<DataModel> GetChildrenByAge()
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT EXTRACT(YEAR FROM age(birthday)), COUNT(*)
                              FROM Child
                              GROUP BY EXTRACT(YEAR FROM age(birthday))
                              ORDER BY date_part ASC";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<DataModel> numChildrenPerAge = new List<DataModel>();

            foreach (DataRow dr in dt.Rows)
            {
                numChildrenPerAge.Add(new DataModel(DBNull.Value.Equals(dr["date_part"]) ? "Unknown" : ((double)dr["date_part"]).ToString(), (int)(long)dr["count"]));
            }

            return numChildrenPerAge;
        }

        /// <summary>
        /// Returns the number of children who have ever attended OCC, grouped by gender
        /// </summary>
        public List<DataModel> GetChildrenByGender()
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT gender, COUNT(*)
                              FROM Child
                              GROUP BY gender";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<DataModel> numChildrenPerGender = new List<DataModel>();

            foreach (DataRow dr in dt.Rows)
            {
                numChildrenPerGender.Add(new DataModel(DBNull.Value.Equals(dr["gender"]) ? "Unknown" : dr["gender"].ToString(), (int)(long)dr["count"]));
            }

            return numChildrenPerGender;
        }

        /// <summary>
        /// Returns the number of children who have ever attended OCC, grouped by bus
        /// </summary>
        public List<DataModel> GetChildrenByBus()
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT busid, COUNT(*)
                              FROM Child
                              GROUP BY busid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<DataModel> numChildrenPerBus = new List<DataModel>();

            foreach (DataRow dr in dt.Rows)
            {
                numChildrenPerBus.Add(new DataModel(DBNull.Value.Equals(dr["busid"]) ? "Unknown" : ((int)dr["busid"]).ToString(), (int)(long)dr["count"]));
            }

            return numChildrenPerBus;
        }

        /// <summary>
        /// Returns the number of new volunteers who were present on a given day
        /// </summary>
        public int GetNumNewVolunteers(DateModel date)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT COUNT(volunteerid)
                               FROM Volunteer_Attendance va
                               WHERE attended = CAST(1 AS bit)
                               AND dayattended = @date
                               AND 0 = 
	                               (SELECT COUNT(*) FROM Volunteer_Attendance 
	                                WHERE volunteerid = va.volunteerid 
	                                AND dayattended <> va.dayattended
	                                AND attended = CAST(1 as bit))";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    cmd.Parameters.Add($"@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date.Date;
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            return (int)(long)dt.Rows[0]["count"];
        }

        /// <summary>
        /// Returns the number of returning volunteers who were present on a given day
        /// </summary>
        public int GetNumReturningVolunteers(DateModel date)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT COUNT(volunteerid)
                               FROM Volunteer_Attendance va
                               WHERE attended = CAST(1 AS bit)
                               AND dayattended = @date
                               AND 0 <> 
	                               (SELECT COUNT(*) FROM Volunteer_Attendance 
	                                WHERE volunteerid = va.volunteerid 
	                                AND dayattended <> va.dayattended
	                                AND attended = CAST(1 as bit))";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    cmd.Parameters.Add($"@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date.Date;
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            return (int)(long)dt.Rows[0]["count"];
        }

        /// <summary>
        /// Returns the number of "blue shirt" volunteers who were present on a given day
        /// </summary>
        public int GetNumBlueShirtVolunteers(DateModel date)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT COUNT(va.volunteerid)
                               FROM Volunteer_Attendance va
                               LEFT JOIN Volunteers v
                               ON va.volunteerid = v.id
                               WHERE v.blueshirt
                               AND dayattended = @date";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    cmd.Parameters.Add($"@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date.Date;
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            return (int)(long)dt.Rows[0]["count"];
        }
    }
}
