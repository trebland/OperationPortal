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
        /// Get a list of children with data "match" in "column"
        /// </summary>
        /// <param name="column">The name of the column being looked at</param>
        /// <param name="match">If the column has this as its data, the child is added to the list</param>
        /// <returns>A List of ChildModels fitting the criteria</returns>
        public List<ChildModel> GetChildren(string column, object match)
        {
            List<ChildModel> children = new List<ChildModel>();
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = "SELECT * FROM Child WHERE " + column + " = " + match;

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

            // For each resulting row, create a ChildModel object and then add it to the list.
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
