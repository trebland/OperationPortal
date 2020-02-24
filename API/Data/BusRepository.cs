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
        public List<BusModel> GetBusList()
        {
            NpgsqlDataAdapter da;
            List<BusModel> buses = new List<BusModel>();
            DataTable dt = new DataTable();
            string sql = "SELECT * FROM Bus";

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
                buses.Add(new BusModel
                {
                    Id = (int)dr["id"],
                    Name = dr["name"].ToString(),
                    Route = dr["route"].ToString(),
                    LastOilChange = dr["lastoilchange"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lastoilchange"]),
                    LastTireChange = dr["lasttirechange"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lasttirechange"]),
                    LastMaintenance = dr["lastmaintenance"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lastmaintenance"])
                });
            }

            return buses;
        }

        public BusModel GetBus(int id)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            DataRow dr;
            string sql = "SELECT * FROM Bus WHERE id = @id LIMIT 1";

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
                Name = dr["name"].ToString(),
                Route = dr["route"].ToString(),
                LastOilChange = dr["lastoilchange"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lastoilchange"]),
                LastTireChange = dr["lasttirechange"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lasttirechange"]),
                LastMaintenance = dr["lastmaintenance"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["lastmaintenance"])
            };
        }
        

        /// <summary>
        /// Updates a bus' route description
        /// </summary>
        /// <param name="id">The id of the bus</param>
        /// <param name="route">The new description of the bus' route.</param>
        public void UpdateBusRoute(int id, string route)
        {
            string sql = "UPDATE BUS SET route = @route WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
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
    }
}
