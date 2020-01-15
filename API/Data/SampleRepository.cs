using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using Npgsql;
using API.Models;

namespace API.Data
{
    public class SampleRepository
    {
        private readonly string connString;

        public SampleRepository(string connString)
        {
            this.connString = connString;
        }
        
        public bool PostgresTest()
        {
            try
            {
                using (NpgsqlConnection con = new NpgsqlConnection(connString))
                {
                    con.Open();
                    
                    con.Close();
                }
            } 
            catch (Exception e)
            {
                return false;
            }

            return true;
        }
    }
}
