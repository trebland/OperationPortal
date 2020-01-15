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
    public class ChildRepository
    {
        private readonly string connString; 
        public ChildRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Get a list of children by bus
        /// </summary>
        /// <param name="busid">Bus id</param>
        /// <returns>A List of ChildModels belonging to busid</returns>
        public List<ChildModel> GetChildrenBus(int busid)
        {
            // Connect to DB
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                // Create and run Postgres command.
                string sql = "SELECT * FROM Child WHERE busid = @busid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@busid", NpgsqlTypes.NpgsqlDbType.Integer).Value = busid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }
            return GetChildModels(dt);
        }

        /// <summary>
        /// Get a list of children by class
        /// </summary>
        /// <param name="classid">Class id</param>
        /// <returns>A List of ChildModels belonging to classid</returns>
        public List<ChildModel> GetChildrenClass(int classid)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = "SELECT * FROM Child WHERE classid = @classid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@classid", NpgsqlTypes.NpgsqlDbType.Integer).Value = classid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }
            return GetChildModels(dt);
        }

        private static List<ChildModel> GetChildModels(DataTable dt)
        {
            // For each resulting row, create a ChildModel object and then add it to the list.
            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(new ChildModel
                {
                    Id = (int)dr["id"],
                    FirstName = dr["firstName"].ToString(),
                    LastName = dr["lastName"].ToString(),
                    Grade = (int)dr["grade"],
                    Class = (int)dr["classid"],
                    Bus = (int)dr["busid"],
                    Birthday = dr["birthday"].ToString(),
                    WaiverReceived = (bool)dr["waiver"]
                    //TODO:
                    //PictureUrl
                    //suspensions
                    //relatives
                    //notes
                    //attendance
                });
            }

            return children;
        }
    }
}
