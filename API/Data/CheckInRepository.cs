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
    public class CheckInRepository
    {
        private readonly string connString;
        public CheckInRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Marks a child as present for the day
        /// </summary>
        /// <param name="childid">Child id being marked present</param>
        /// <returns>Total number of times the child has been in attendance</returns>
        public int CheckInChild(int childid)
        {
            int numVisits = 0;
            DateTime now = DateTime.Now;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                DataTable dt = new DataTable();

                // Retrieve all the days the child has been in attendance, ordered by most recent first
                string sql = "SELECT * FROM Child_Attendance WHERE childid = @childid ORDER BY dayattended DESC";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
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
        /// Marks a volunteer as present for the day
        /// </summary>
        /// <returns>Total number of times the volunteer has been in attendance</returns>
        public int CheckInVolunteer(int volunteerId)
        {
            int numVisits = 0;
            DateTime now = DateTime.Now;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                DataTable dt = new DataTable();

                // See if volunteer is scheduled for this date
                string sql = @"SELECT dayattended, attended FROM Volunteer_Attendance 
                               WHERE volunteerid = @volunteerId 
                               AND dayattended = @now";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                // Volunteer wasn't scheduled for this day, add to table as checked in and unscheduled
                if (dt.Rows.Count == 0)
                {
                    sql = @"INSERT INTO Volunteer_Attendance (volunteerid, dayattended, scheduled, attended)
                            VALUES (@volunteerId, @now, CAST(0 as bit), CAST(1 as bit))";
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                        cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                        cmd.ExecuteNonQuery();
                    }
                }

                // Volunteer was scheduled and is checking in now
                else if (DBNull.Value.Equals(dt.Rows[0]["attended"]) || !(bool)dt.Rows[0]["attended"])
                {
                    sql = @"UPDATE Volunteer_Attendance 
                            SET attended = CAST(1 as bit)
                            WHERE volunteerid = @volunteerId
                            AND dayattended = @now";
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                        cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                        cmd.ExecuteNonQuery();
                    }
                }

                // Find total number of visits
                sql = @"SELECT COUNT(*)
                        FROM Volunteer_Attendance
                        WHERE volunteerid = @volunteerId";
                dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                numVisits = (int)(long)dt.Rows[0]["count"];

                con.Close();
            }

            return numVisits;
        }

        /// <summary>
        /// Marks a bus driver as present for the given day
        /// </summary>
        public void CheckInBusDriver(int driverId, DateTime date)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                DataTable dt = new DataTable();

                // See if volunteer is scheduled for this date
                string sql = @"SELECT dayattended, attended FROM Volunteer_Attendance 
                               WHERE volunteerid = @driverId 
                               AND dayattended = @date";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@driverId", NpgsqlTypes.NpgsqlDbType.Integer).Value = driverId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                // Driver wasn't scheduled for this day, add to table as checked in and scheduled
                if (dt.Rows.Count == 0)
                {
                    sql = @"INSERT INTO Volunteer_Attendance (volunteerid, dayattended, scheduled, attended)
                            VALUES (@driverId, @date, CAST(1 as bit), CAST(1 as bit))";
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@driverId", NpgsqlTypes.NpgsqlDbType.Integer).Value = driverId;
                        cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                        cmd.ExecuteNonQuery();
                    }
                }

                // Volunteer was scheduled and is checking in now
                else if (DBNull.Value.Equals(dt.Rows[0]["attended"]) || !(bool)dt.Rows[0]["attended"])
                {
                    sql = @"UPDATE Volunteer_Attendance 
                            SET scheduled = CAST(1 as bit), attended = CAST(1 as bit)
                            WHERE volunteerid = @driverId
                            AND dayattended = @date";
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@driverId", NpgsqlTypes.NpgsqlDbType.Integer).Value = driverId;
                        cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                        cmd.ExecuteNonQuery();
                    }
                }

                con.Close();
            }
        }

        /// <summary>
        /// Revokes a bus driver being marked present for the given day
        /// </summary>
        public void CancelBusDriver(int driverId, DateTime date)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                
                string sql = @"UPDATE Volunteer_Attendance 
                        SET scheduled = CAST(0 as bit), attended = CAST(0 as bit)
                        WHERE volunteerid = @driverId
                        AND dayattended = @date";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@driverId", NpgsqlTypes.NpgsqlDbType.Integer).Value = driverId;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

            }
        }
    }
}