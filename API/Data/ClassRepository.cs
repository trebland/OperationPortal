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
using API.Helpers;

namespace API.Data
{
    public class ClassRepository
    {
        private readonly string connString;
        public ClassRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Gets the list of all classes in the database
        /// </summary>
        /// <param name="includeDetail">Determines whether or not to include detail such as number of students and teacher name</param>
        /// <returns>A list of ClassModel objects representing classes, each containing the name and id of a class</returns>
        public List<ClassModel> GetClasses(bool includeDetail = false)
        {
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT CL.*, V.PreferredName, V.LastName 
                           FROM Class_List AS CL LEFT OUTER JOIN 
                           Volunteers AS V ON V.Id = CL.TeacherId";

            List<ClassModel> classes = new List<ClassModel>();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
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
                if (includeDetail)
                {
                    classes.Add(new ClassModel
                    {
                        Id = (int)dr["id"],
                        Name = dr["description"].ToString(),
                        NumStudents = (int)dr["numstudents"],
                        TeacherId = dr["teacherid"] == DBNull.Value ? 0 : (int)dr["TeacherId"],
                        TeacherName = dr["teacherid"] == DBNull.Value ? "N/A" : dr["preferredname"].ToString() + " " + dr["lastname"].ToString()
                    });
                }
                else
                {
                    classes.Add(new ClassModel
                    {
                        Id = (int)dr["id"],
                        Name = dr["description"].ToString()
                    });
                }
            }

            return classes;
        }


        /// <summary>
        /// Gets a specific class from the database
        /// </summary>
        /// <param name="id">The id of the class</param>
        /// <returns>A ClassModel object</returns>
        public ClassModel GetClass(int id)
        {
            DataTable dt = new DataTable();
            DataRow dr;
            NpgsqlDataAdapter da;
            string sql = @"SELECT CL.*, V.PreferredName, V.LastName 
                           FROM Class_List AS CL LEFT OUTER JOIN 
                           Volunteers AS V ON V.Id = CL.TeacherId 
                           WHERE CL.id = @id";

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

            if (dt.Rows.Count != 1)
            {
                return null;
            }

            dr = dt.Rows[0];


            return new ClassModel
            {
                Id = (int)dr["id"],
                Name = dr["description"].ToString(),
                NumStudents = (int)dr["numstudents"],
                TeacherId = dr["teacherid"] == DBNull.Value ? 0 : (int)dr["TeacherId"],
                TeacherName = dr["teacherid"] == DBNull.Value ? "N/A" : dr["preferredname"].ToString() + " " + dr["lastname"].ToString()
            };
        }

        /// <summary>
        /// Inserts a new class
        /// </summary>
        /// <param name="name">The name of the class</param>
        /// <param name="teacherId">The id of the volunteer who will teach the class</param>
        public void CreateClass(string name, int teacherId)
        {
            string sql = "INSERT INTO Class_List (Description, NumStudents, TeacherId) VALUES (@name, 0, @tid)";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = name;
                    cmd.Parameters.Add("@tid", NpgsqlTypes.NpgsqlDbType.Integer).Value = teacherId;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Edits the name of a class
        /// </summary>
        /// <param name="name">The name of the class</param>
        /// <param name="id">The id of the class</param>
        public void UpdateClass(int id, string name)
        {
            string sql = "UPDATE Class_List SET Description = @name WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@name", NpgsqlTypes.NpgsqlDbType.Varchar).Value = name;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Deletes a class
        /// </summary>
        /// <param name="id">The id of the class</param>
        public void DeleteClass(int id)
        {
            string sql = "DELETE FROM Class_List WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = id;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// Changes the teacher assigned to a class
        /// </summary>
        /// <param name="ClassId">The id of the class</param>
        /// <param name="TeacherId">The id of the teacher</param>
        public void AssignTeacher(int ClassId, int TeacherId)
        {
            string sql = "UPDATE Class_List SET TeacherId = @tid WHERE id = @id";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@tid", NpgsqlTypes.NpgsqlDbType.Integer).Value = TeacherId;
                    cmd.Parameters.Add("@id", NpgsqlTypes.NpgsqlDbType.Integer).Value = ClassId;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }
    }
}
