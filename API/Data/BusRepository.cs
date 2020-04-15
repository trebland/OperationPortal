using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using API.Models;
using Npgsql;

namespace API.Data
{
    public class BusRepository
    {
        private readonly string connString;
        
        public BusRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Get the list of buses
        /// </summary>
        /// <returns>A list of BusModel objects</returns>
        public List<BusModel> GetBusList(bool details = false)
        {
            NpgsqlDataAdapter da;
            List<BusModel> buses = new List<BusModel>();
            DataTable dt = new DataTable();
            string sql = "SELECT B.*, V.PreferredName, V.LastName, V.Picture FROM Bus AS B LEFT OUTER JOIN Volunteers AS V ON B.driverId = V.id";

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
                if (details)
                {
                    buses.Add(new BusModel
                    {
                        Id = (int)dr["id"],
                        DriverId = dr["DriverId"] == DBNull.Value ? 0 : (int)dr["DriverId"],
                        DriverName = dr["DriverId"] == DBNull.Value ? "" : dr["preferredName"].ToString() + " " + dr["lastName"].ToString(),
                        DriverPicture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"],
                        Name = dr["name"].ToString(),
                        Route = dr["route"].ToString(),
                        LastOilChange = dr["lastoilchange"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lastoilchange"]),
                        LastTireChange = dr["lasttirechange"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lasttirechange"]),
                        LastMaintenance = dr["lastmaintenance"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lastmaintenance"])
                    });
                }
                else
                {
                    buses.Add(new BusModel
                    {
                        Id = (int)dr["id"],
                        Name = dr["name"].ToString()
                    });
                }
            }

            return buses;
        }

        public void UpdateBus(int id, DateTime LastMaintenance, DateTime LastOilChange, DateTime LastTireChange)
        {
            string sql = "UPDATE Bus SET LastMaintenance = @maint, LastOilChange = @oil, LastTireChange = @tire WHERE id = @id";

            // Connect to the database
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create the sql command
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    // Add the id parameter
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    // Make the query
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        public BusModel GetBus(int id)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = "SELECT B.*, V.PreferredName, V.LastName, V.Picture FROM Bus AS B LEFT OUTER JOIN Volunteers AS V ON B.driverId = V.id WHERE B.id = @id LIMIT 1";

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

            return new BusModel { 
                Id = (int)dr["id"],
                DriverId = dr["DriverId"] == DBNull.Value ? 0 : (int)dr["DriverId"],
                DriverName = dr["DriverId"] == DBNull.Value ? "" : dr["preferredName"].ToString() + " " + dr["lastName"].ToString(),
                DriverPicture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"],
                Name = dr["name"].ToString(),
                Route = dr["route"].ToString(),
                LastOilChange = dr["lastoilchange"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lastoilchange"]),
                LastTireChange = dr["lasttirechange"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lasttirechange"]),
                LastMaintenance = dr["lastmaintenance"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lastmaintenance"])
            };
        }


        /// <summary>
        /// Updates a bus' name and route description
        /// </summary>
        /// <param name="id">The id of the bus</param>
        /// <param name="name">The bus' new name.</param>
        /// <param name="route">The new description of the bus' route.</param>
        public void UpdateBusRoute(int id, string name, string route)
        {
            string sql = "UPDATE BUS SET name = @name, route = @route WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = name;
                    cmd.Parameters.Add("@route", NpgsqlTypes.NpgsqlDbType.Varchar).Value = route;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

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
        public void CreateBus(string name, string route)
        {
            string sql = "INSERT INTO BUS (name, route) VALUES (@name, @route)";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar, 300).Value = name;
                    cmd.Parameters.Add("@route", NpgsqlTypes.NpgsqlDbType.Varchar).Value = route;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }
        
        /// <summary>
        /// Assigns a driver to a bus
        /// </summary>
        /// <param name="busId">The id of the bus</param>
        /// <param name="driverId">The id of the driver</param>
        public void AssignDriver (int busId, int driverId)
        {
            string sql = "UPDATE Bus SET driverId = @driverId WHERE id = @busId";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@driverId", NpgsqlTypes.NpgsqlDbType.Integer).Value = driverId;
                    cmd.Parameters.Add("@busId", NpgsqlTypes.NpgsqlDbType.Integer).Value = busId;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }
    }
}
