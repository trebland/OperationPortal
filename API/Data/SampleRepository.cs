using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Npgsql;

namespace API.Data
{
    public class SampleRepository
    {
        public static string connString = "host=opdbtest.ck8x95nv7fio.us-east-2.rds.amazonaws.com;port=5432;Database=postgres;UserID=postgres;Password=OperationPortal;";
        public static bool PostgresTest()
        {
            try
            {
                using (NpgsqlConnection con = new NpgsqlConnection(connString))
                {
                    con.Open();

                    con.Close();
                }
            } 
            catch (Exception)
            {
                return false;
            }

            return true;
        }
    }
}
