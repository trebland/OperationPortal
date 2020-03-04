using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using API.Models;
using Npgsql;

namespace API.Data
{
    public class InventoryRepository
    {
        private readonly string connString;

        public InventoryRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Inserts an inventory recquisition
        /// </summary>
        /// <param name="name">The name of the thing needed</param>
        /// <param name="count">How many of the thing are needed</param>
        /// <param name="addedBy">The name of the person who added the recquisition</param>
        public void CreateInventory(string name, int count, string addedBy)
        {
            string sql = "INSERT INTO Inventory (Name, Count, Resolved, AddedBy) VALUES (@name, @count, false, @addedBy)";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = name;
                    cmd.Parameters.Add("@count", NpgsqlTypes.NpgsqlDbType.Integer).Value = count;
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
        public void UpdateInventory(int id, string name, int count, bool resolved)
        {
            string sql = "UPDATE Inventory SET name = @name, count = @count, resolved = @resolved WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = name;
                    cmd.Parameters.Add("@count", NpgsqlTypes.NpgsqlDbType.Integer).Value = count;
                    cmd.Parameters.Add("@resolved", NpgsqlTypes.NpgsqlDbType.Boolean).Value = resolved;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        public List<InventoryModel> GetInventory(bool resolved)
        {
            List<InventoryModel> list = new List<InventoryModel>();
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            string sql = "SELECT * FROM Inventory WHERE resolved = @resolved";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@resolved", NpgsqlTypes.NpgsqlDbType.Boolean).Value = resolved;

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach(DataRow dr in dt.Rows)
            {
                list.Add(new InventoryModel
                {
                    Id = (int)dr["id"],
                    Name = dr["name"].ToString(),
                    Count = (int)dr["count"],
                    Resolved = (bool)dr["resolved"],
                    AddedBy = dr["AddedBy"].ToString()
                });
            }

            return list;
        }

        public InventoryModel GetInventoryItem(int id)
        {
            NpgsqlDataAdapter da;
            DataTable dt = new DataTable();
            string sql = "SELECT * FROM Inventory WHERE id = @id";

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

            return new InventoryModel
            {
                Id = (int)dr["id"],
                Name = dr["name"].ToString(),
                Count = (int)dr["count"],
                Resolved = (bool)dr["resolved"],
                AddedBy = dr["AddedBy"].ToString()
            };
        }
    }
}
