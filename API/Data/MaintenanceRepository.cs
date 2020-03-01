using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using API.Models;
using Npgsql;

namespace API.Data
{
    public class MaintenanceRepository
    {
        private readonly string connString;

        public MaintenanceRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Inserts an inventory recquisition
        /// </summary>
        /// <param name="name">The name of the thing needed</param>
        /// <param name="count">How many of the thing are needed</param>
        /// <param name="addedBy">The name of the person who added the recquisition</param>
        public void CreateMaintenanceForm(int busId, string text, string addedBy)
        {
            string sql = "INSERT INTO Maintenance (BusId, Text, Resolved, AddedBy) VALUES (@busId, @text, false, @addedBy)";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@busId", NpgsqlTypes.NpgsqlDbType.Integer).Value = busId;
                    cmd.Parameters.Add("@text", NpgsqlTypes.NpgsqlDbType.Varchar).Value = text;
                    cmd.Parameters.Add("@addedby", NpgsqlTypes.NpgsqlDbType.Varchar).Value = addedBy;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Updates an inventory item
        /// </summary>
        /// <param name="id">The item's id</param>
        /// <param name="name">The name of the item</param>
        /// <param name="count">The count requested</param>
        /// <param name="resolved">Whether the request has been fulfilled</param>
        public void UpdateMaintenanceForm(int id, string text, bool resolved)
        {
            string sql = "UPDATE Maintenance SET text = @text, resolved = @resolved WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@text", NpgsqlTypes.NpgsqlDbType.Varchar).Value = text;
                    cmd.Parameters.Add("@resolved", NpgsqlTypes.NpgsqlDbType.Boolean).Value = resolved;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        public List<MaintenanceModel> GetMaintenanceForms(bool resolved, int busId)
        {
            List<MaintenanceModel> list = new List<MaintenanceModel>();
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            string sql = "SELECT * FROM Maintenance WHERE resolved = @resolved";

            if (busId != 0)
            {
                sql += " AND busId = @busId";
            }

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@resolved", NpgsqlTypes.NpgsqlDbType.Boolean).Value = resolved;
                    if (busId != 0)
                    {
                        cmd.Parameters.Add("@busId", NpgsqlTypes.NpgsqlDbType.Integer).Value = busId;
                    }

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach(DataRow dr in dt.Rows)
            {
                list.Add(new MaintenanceModel
                {
                    Id = (int)dr["id"],
                    Text = dr["text"].ToString(),
                    Resolved = (bool)dr["resolved"],
                    AddedBy = dr["AddedBy"].ToString()
                });
            }

            return list;
        }

        public MaintenanceModel GetMaintenanceForm(int id)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            string sql = "SELECT * FROM Maintenance WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count == 0)
            {
                return null;
            }

            DataRow dr = dt.Rows[0];

            return new MaintenanceModel
            {
                Id = (int)dr["id"],
                Text = dr["text"].ToString(),
                Resolved = (bool)dr["resolved"],
                AddedBy = dr["AddedBy"].ToString()
            };
        }
    }
}
