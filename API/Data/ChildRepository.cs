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
using java.io;
using API.Helpers;

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
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT c.*,
                                      cl.description,
                                      b.name AS busname
                              FROM Child c
                              LEFT JOIN Class_List cl
                              ON c.classid = cl.id
                              LEFT JOIN Bus b
                              ON c.busid = b.id
                              WHERE c.busid = @busid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@busid", NpgsqlTypes.NpgsqlDbType.Integer).Value = busid;
                    cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = DateTime.Now;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(GetBasicChildModel(new ChildModel(), dr));
            }

            return children;
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
                string sql = @"SELECT c.*,
                                      cl.description,
                                      b.name AS busname
                              FROM Child c
                              LEFT JOIN Class_List cl
                              ON c.classid = cl.id
                              LEFT JOIN Bus b
                              ON c.busid = b.id
                              WHERE c.classid = @classid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@classid", NpgsqlTypes.NpgsqlDbType.Integer).Value = classid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(GetBasicChildModel(new ChildModel(), dr));
            }

            return children;
        }

        /// <summary>
        /// Creates a new child with first name, parent name, contact number, and any extra information
        /// </summary>
        /// <returns>Success message</returns>
        public String CreateChild(PostChildCreationModel child)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                String sql = @"SELECT count(*)
                               FROM information_schema.columns
                               WHERE table_name = 'child'";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                int numColumns = (int)(long)dt.Rows[0]["count"];
                // Update parameters that are not null
                // First name, parent name, and contact number have been checked in the controller
                StringBuilder columns = new StringBuilder();
                bool[] updated = new bool[numColumns];
                int parm = 0;

                if (child.ContactNumber != null)
                {
                    columns.Append($"@contactnumber,");
                    updated[parm] = true;
                }
                parm++;

                if (child.ParentName != null)
                {
                    columns.Append($"@parentname,");
                    updated[parm] = true;
                }
                parm++;

                if (child.FirstName != null)
                {
                    columns.Append($"@firstname,");
                    updated[parm] = true;
                }
                parm++;

                if (child.LastName != null)
                {
                    columns.Append($"@lastname,");
                    updated[parm] = true;
                }
                parm++;

                if (child.PreferredName != null)
                {
                    columns.Append($"@preferredname,");
                    updated[parm] = true;
                }
                parm++;

                if (child.BusId != 0)
                {
                    columns.Append($"@busid,");
                    updated[parm] = true;
                }
                parm++;

                if (child.Birthday != null)
                {
                    columns.Append($"@birthday,");
                    updated[parm] = true;
                }
                parm++;

                /*
                Postman:
                string fname = "test.jpg";
                FileStream fs = new FileStream(fname, FileMode.Open, FileAccess.Read);
                BinaryReader br = new BinaryReader(fs);
                byte[] barray = br.ReadBytes((int)fs.Length);
                child.Picture = barray;
                */
                if (child.Picture != null)
                {
                    columns.Append($"@picture,");
                    updated[parm] = true;
                }
                parm++;

                if (child.Gender != null)
                {
                    columns.Append($"@gender,");
                    updated[parm] = true;
                }

                columns.Length = columns.Length - 1;
                sql = @"INSERT INTO Child (" + Regex.Replace(columns.ToString(), "@" , "")  + @") 
                        VALUES (" + columns.ToString() + ")";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    parm = -1;
                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@contactnumber", NpgsqlTypes.NpgsqlDbType.Varchar).Value = child.ContactNumber;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@parentname", NpgsqlTypes.NpgsqlDbType.Varchar).Value = child.ParentName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@firstname", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = child.FirstName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@lastname", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = child.LastName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@preferredname", NpgsqlTypes.NpgsqlDbType.Varchar).Value = child.PreferredName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@busid", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.BusId;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@birthday", NpgsqlTypes.NpgsqlDbType.Date).Value = DateTime.Parse(child.Birthday).Date;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@picture", NpgsqlTypes.NpgsqlDbType.Bytea).Value = child.Picture;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@gender", NpgsqlTypes.NpgsqlDbType.Varchar, 6).Value = child.Gender;
                    }

                    cmd.ExecuteNonQuery();
                }

                con.Close();
            }

            return "Child has been added.";
        }

        /// <summary>
        /// Updates information corresponding to child.Id in the database
        /// </summary>
        /// <param name="child">PostChildEditModel with fields to be updated in the database</param>
        /// <returns>PostChildEditModel of the merged information</returns>
        public PostChildEditModel EditChild(PostChildEditModel child)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                string sql = @"SELECT *
                               FROM Child
                               WHERE id = @childid";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Id;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                // This ID does not exist
                if (dt.Rows.Count == 0)
                {
                    return new PostChildEditModel();
                }

                // Update parameters that are not null
                StringBuilder parameters = new StringBuilder();
                bool[] updated = new bool[dt.Columns.Count];
                int parm = 0;

                if (child.FirstName != null)
                {
                    parameters.Append($"firstname = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.LastName != null)
                {
                    parameters.Append($"lastname = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.PreferredName != null)
                {
                    parameters.Append($"preferredname = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.ContactNumber != null)
                {
                    parameters.Append($"contactnumber = @p{parm},");
                    updated[parm] = true;
                }
                parm++;
                if (child.ContactEmail != null)
                {
                    parameters.Append($"contactemail = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.ParentName != null)
                {
                    parameters.Append($"parentname = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.BusId != 0)
                {
                    parameters.Append($"busid = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Birthday != null)
                {
                    parameters.Append($"birthday = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Gender != null)
                {
                    parameters.Append($"gender = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Grade != 0)
                {
                    parameters.Append($"grade = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.ParentalWaiver != null)
                {
                    parameters.Append($"parentalwaiver = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.ClassId != 0)
                {
                    parameters.Append($"classid = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.Picture != null)
                {
                    parameters.Append($"picture = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.BusWaiver != null)
                {
                    parameters.Append($"buswaiver = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.HaircutWaiver != null)
                {
                    parameters.Append($"haircutpermission = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.ParentalEmailOptIn != null)
                {
                    parameters.Append($"parentalemailoptin = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                if (child.OrangeShirtStatus != 0)
                {
                    parameters.Append($"orangeshirt = @p{parm},");
                    updated[parm] = true;
                }
                parm++;

                // For testing with Postman
                /*string fname = "test.jfif";
                FileStream fs = new FileStream(fname, FileMode.Open, FileAccess.Read);
                BinaryReader br = new BinaryReader(fs);
                byte[] barray = br.ReadBytes((int)fs.Length);
                */
                if (parameters.Length == 0) // All fields null - no changes made
                {
                    return GetChildEditModel(dt.Rows[0]);
                }

                parameters.Length = parameters.Length - 1; // Remove last comma

                sql = "UPDATE Child SET " + parameters.ToString() + " WHERE id = @childId";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    parm = -1;
                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = child.FirstName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar, 60).Value = child.LastName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar).Value = child.PreferredName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar).Value = child.ContactNumber;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar).Value = child.ContactEmail;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar).Value = child.ParentName;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.BusId;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Date).Value = DateTime.Parse(child.Birthday).Date;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Varchar, 6).Value = Utilities.NormalizeString(child.Gender);
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Grade;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Bit).Value = child.ParentalWaiver;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.ClassId;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Bytea).Value = child.Picture;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Bit).Value = child.BusWaiver;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Bit).Value = child.HaircutWaiver;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Bit).Value = child.ParentalEmailOptIn;
                    }

                    if (updated[++parm])
                    {
                        cmd.Parameters.Add($"@p{parm}", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.OrangeShirtStatus;
                    }

                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Id;
                    cmd.ExecuteNonQuery();
                }

                // Retrieve row that has been updated and bus/class name
                sql = @"SELECT *
                        FROM Child
                        WHERE id = @childid";

                dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = child.Id;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                con.Close();

                return GetChildEditModel(dt.Rows[0]);
            }
        }

        public PostChildEditModel GetChild(int childId)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT *
                               FROM Child
                               WHERE id = @childId";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count == 0)
            {
                return new PostChildEditModel();
            }

            return GetChildEditModel(dt.Rows[0]);
        }

        /// <summary>
        /// Returns list of all children in the database
        /// </summary>
        public List<ChildModel> GetChildren()
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT c.*,
                                      cl.description,
                                      b.name AS busname
                              FROM Child c
                              LEFT JOIN Class_List cl
                              ON c.classid = cl.id
                              LEFT JOIN Bus b
                              ON c.busid = b.id
                              WHERE c.busid = @busid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(GetBasicChildModel(new ChildModel(), dr));
            }

            return children;
        }

        public string DeleteChild(int childId)
        {
            int columnRemoved = 0;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"DELETE 
                               FROM Child
                               WHERE id = @childId";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    columnRemoved = cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            return columnRemoved == 1 ? "The child has been removed." : "This child does not exist.";
        }

        /// <summary>
        /// Saves a note about a child and sends an email indicating a note has been added
        /// </summary>
        /// <param name="author">Writer of the note</param>
        /// <param name="childId">Child the note is about</param>
        /// <returns></returns>
        public void AddNote(string author, int childId, string content, DateTime date)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"INSERT INTO Notes (childid, content, author, datewritten)
                        VALUES (@childid, @content, @author, @date)";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    cmd.Parameters.Add("@content", NpgsqlTypes.NpgsqlDbType.Varchar, 300).Value = content;
                    cmd.Parameters.Add("@author", NpgsqlTypes.NpgsqlDbType.Varchar, 300).Value = author;
                    cmd.Parameters.Add("@date", NpgsqlTypes.NpgsqlDbType.Date).Value = date;
                    cmd.ExecuteNonQuery();
                    con.Close();
                }            
            }
        }

        public string EditNote(int noteId, String editedNotes)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"UPDATE Notes SET content = @editedNotes
                             WHERE id = @noteId";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@noteId", NpgsqlTypes.NpgsqlDbType.Integer).Value = noteId;
                    cmd.Parameters.Add("@editedNotes", NpgsqlTypes.NpgsqlDbType.Varchar, 300).Value = editedNotes;
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            return editedNotes;
        }

        public List<NoteModel> GetNotes(int childId)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT id, content, author, datewritten
                               FROM Notes 
                               WHERE childid = @childId";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<NoteModel> notes = new List<NoteModel>();
            foreach (DataRow dr in dt.Rows)
            {
                notes.Add(new NoteModel((int)dr["id"], dr["content"].ToString(), dr["author"].ToString(), (DateTime)dr["datewritten"]));
            }

            return notes;
        }

        public string DeleteNote(int noteId)
        {
            int columnRemoved = 0;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"DELETE 
                               FROM Notes
                               WHERE id = @noteId";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@noteId", NpgsqlTypes.NpgsqlDbType.Integer).Value = noteId;
                    columnRemoved = cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            return columnRemoved == 1 ? "The note has been removed." : "This note does not exist.";
        }

        /// <summary>
        /// Given two child IDs and a relationship between the two, adds this relationship to the database where
        /// childid1 is the childid and childid2 is the relativeid
        /// If the children already have a relationship, the relation is updated to what is passed
        /// </summary>

        public string AddRelation(RelationModel model)
        {
            // Check if pre-existing relationship exists
            bool haveRelation = false;
            string sql = @"SELECT *
                           FROM Relatives
                           WHERE (childid = @childid1
                           OR childid = @childid2)";
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childid1", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.ChildId1;
                    cmd.Parameters.Add("@childid2", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.ChildId2;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            // Update existing relationship
            if (dt.Rows.Count == 1)
            {
                haveRelation = true;
                sql = @"UPDATE Relatives 
                        SET relation = @relation
                        WHERE (childid = @childid1 AND relativeid = @childid2)
                        OR (childid = @childid2 AND relativeid = @childid1)";

                using (NpgsqlConnection con = new NpgsqlConnection(connString))
                {
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        con.Open();
                        cmd.Parameters.Add("@childid1", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.ChildId1;
                        cmd.Parameters.Add("@childid2", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.ChildId2;
                        cmd.Parameters.Add("@relation", NpgsqlTypes.NpgsqlDbType.Varchar).Value = Utilities.NormalizeString(model.Relation);
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }

            // Add new relationship
            else
            {
                using (NpgsqlConnection con = new NpgsqlConnection(connString))
                {
                    sql = @"INSERT INTO Relatives (relativeid, relation, childid)
                               VALUES (@childid1, @relation, @childid2)";

                    con.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@childid1", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.ChildId1;
                        cmd.Parameters.Add("@childid2", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.ChildId2;
                        cmd.Parameters.Add("@relation", NpgsqlTypes.NpgsqlDbType.Varchar).Value = Utilities.NormalizeString(model.Relation);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            return haveRelation ? "The relationship has been changed." : "The relationship has been added.";
        }

        /// <summary>
        /// Retrieves a list of RelativeModels associated with the given child id
        /// </summary>
        public List<RelativeModel> GetRelations(IdModel model)
        {
            // Check if pre-existing relationship exists
            List<RelativeModel> relatives = new List<RelativeModel>();
            string sql = @"SELECT relativeid, relation, childid
                           FROM Relatives
                           WHERE (childid = @childid
                           OR relativeid = @childid)";
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.Id;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows) {
                // Don't know which column the relative is stored in, so check both
                int relativeId = (int)dr["childid"];
                if (relativeId == model.Id)
                {
                    relativeId = (int)dr["relativeid"];
                }

                relatives.Add(new RelativeModel(relativeId, dr["relation"].ToString()));
            }

            return relatives;
        }

        public string DeleteRelation(DeleteRelationModel model)
        {
            int columnRemoved = 0;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"DELETE 
                               FROM Relatives
                               WHERE (childid = @childid1 AND relativeid = @childid2)
                               OR (childid = @childid2 AND relativeid = @childid1)";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childid1", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.ChildId1;
                    cmd.Parameters.Add("@childid2", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.ChildId2;
                    columnRemoved = cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            return columnRemoved == 1 ? "The relationship has been removed." : "This relationship does not exist.";
        }

        /// <summary>
        /// Given a child id and a boolean, updates whether or not the child's waiver has been received
        /// </summary>
        public void UpdateWaiver(int childId, bool received)
        {
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"UPDATE Child SET waiver = @received
                             WHERE id = @childId";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    cmd.Parameters.Add("@received", NpgsqlTypes.NpgsqlDbType.Bit).Value = received;
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        /// <summary>
        /// The childId is marked suspended for the given start/end dates
        /// </summary>
        public string Suspend(int childId, DateTime start, DateTime end)
        { 
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();

                // Check if child is already suspended for any date in given time range
                string sql = @"SELECT childid, startdate, enddate from Child_Suspensions
                               WHERE childid = @childid
                               AND startdate <= @enddate AND enddate >= @startdate";

                DataTable dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    cmd.Parameters.Add("@startdate", NpgsqlTypes.NpgsqlDbType.Date).Value = start.Date;
                    cmd.Parameters.Add("@enddate", NpgsqlTypes.NpgsqlDbType.Date).Value = end.Date;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                if (dt.Rows.Count > 0)
                {
                    return "The child is already suspended for at least one of these dates.";
                }

                sql = @"INSERT INTO Child_Suspensions (childid, startdate, enddate)
                        VALUES (@childid, @startdate, @enddate)";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    cmd.Parameters.Add("@startdate", NpgsqlTypes.NpgsqlDbType.Date).Value = start.Date;
                    cmd.Parameters.Add("@enddate", NpgsqlTypes.NpgsqlDbType.Date).Value = end.Date;
                    cmd.ExecuteNonQuery();
                }
                con.Close();
            }

            return "The child has been suspended for the given time frame.";
        }

        /// <summary>
        /// View active suspensions
        /// </summary>
        /// <returns>List of ChildModel objects that are currently marked as suspended</returns>
        public List<ChildModel> ViewSuspensions()
        {
            DateTime now = DateTime.Now;
            DataTable dt = new DataTable();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT s.childid, s.startdate, s.enddate,
                                      c.*,
                                      cl.description,
                                      b.name AS busname
                               FROM Child_Suspensions s
                               RIGHT JOIN Child c
                               ON s.childid = c.id
                               LEFT JOIN Class_List cl
                               ON c.classid = cl.id
                               LEFT JOIN Bus b
                               ON c.busid = b.id
                               WHERE s.startdate <= @now
                               AND s.enddate >= @now
                               AND c.busid = @busid";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(GetBasicChildModel(new ChildModel(), dr));
            }

            return children;
        }

        /// <summary>
        /// Given a child ID, check if the child is currently suspended
        /// </summary>
        public bool IsSuspended(int childId)
        {
            DateTime now = DateTime.Now;
            DataTable dt = new DataTable();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT startdate, enddate, childId
                               FROM Child_Suspensions
                               WHERE startdate <= @now
                               AND enddate >= @now
                               AND childid = @childId";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            return dt.Rows.Count != 0 ? true : false;
        }

        /// <summary>
        /// Given a child ID, return current suspension timeframe, if any
        /// </summary>
        public DateTime[] GetSuspension(int childId)
        {
            DateTime now = DateTime.Now;
            DataTable dt = new DataTable();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT startdate, enddate, childId
                               FROM Child_Suspensions
                               WHERE startdate <= @now
                               AND enddate >= @now
                               AND childid = @childId";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            // Not suspended
            if (dt.Rows.Count == 0)
            {
                return null;
            }

            return new DateTime[2] { (DateTime)dt.Rows[0]["startdate"], (DateTime)dt.Rows[0]["enddate"] };
        }

        /// <summary>
        /// Given a child ID, returns all suspensions, if any
        /// </summary>
        public List<SuspensionModel> GetSuspensionHistoryForChild(IdModel model)
        {
            DateTime now = DateTime.Now;
            DataTable dt = new DataTable();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT startdate, enddate
                               FROM Child_Suspensions
                               WHERE childid = @childId";

                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    con.Open();
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = model.Id;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<SuspensionModel> suspensions = new List<SuspensionModel>();
            foreach (DataRow dr in dt.Rows)
            {
                suspensions.Add(new SuspensionModel((DateTime)dr["startdate"], (DateTime)dr["enddate"]));
            }

            return suspensions;
        }

        /// <summary>
        /// Create child models from a given data table
        /// </summary>
        /// <param name="dt">Data table matching specific criteria</param>
        /// <returns>List of ChildModels formed from the given data table</returns>
        private List<ChildModel> GetSuspendedChildModels(DataTable dt)
        {
            List<ChildModel> children = new List<ChildModel>();
            foreach (DataRow dr in dt.Rows)
            {
                children.Add(new ChildModel
                {
                    Id = (int)dr["childid"],
                    FirstName = dr["firstName"].ToString(),
                    LastName = dr["lastName"].ToString(),
                    SuspendedStart = ((DateTime)dr["startdate"]),
                    SuspendedEnd = ((DateTime)dr["enddate"]),
                    Picture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"]
                });
            }

            return children;
        }

        private ChildModel GetFullChildModel(DataRow dr)
        {
            ChildModel child = GetBasicChildModel(new ChildModel(), dr);
            child.WaiverReceived = dr["waiver"] == System.DBNull.Value ? false : (bool)dr["waiver"];

            return child;
        }

        /// <summary>
        /// Fills out basic information from a given data row to a given child model
        /// </summary>
        private ChildModel GetBasicChildModel(ChildModel child, DataRow dr)
        {
            int? classId = null;
            if (!DBNull.Value.Equals(dr["classid"]))
            {
                classId = (int)dr["classid"];
            }

            int? busId = null;
            if (!DBNull.Value.Equals(dr["busid"]))
            {
                busId = (int)dr["busid"];
            }

            int? grade = null;
            if (!DBNull.Value.Equals(dr["grade"]))
            {
                grade = (int)dr["grade"];
            }
            child.Id = (int)dr["id"];
            child.FirstName = dr["firstname"].ToString();
            child.LastName = dr["lastname"].ToString();
            child.Gender = dr["gender"].ToString();
            child.Birthday = dr["birthday"].ToString();
            child.Picture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"];
            child.PreferredName = dr["preferredname"].ToString();
            child.ParentName = dr["parentname"].ToString();
            child.ContactNumber = dr["contactnumber"].ToString();
            child.ContactEmail = dr["contactemail"].ToString();
            child.Grade = grade;
            child.Class = new Pair
            {
                Id = classId,
                Name = dr["description"].ToString()
            };
            child.Bus = new Pair
            {
                Id = busId,
                Name = dr["busname"].ToString()
            };

            // Child was already found to be suspended
            if (dr.Table.Columns.Contains("startdate"))
            {
                child.SuspendedStart = DBNull.Value.Equals(dr["startdate"]) ? DateTime.MinValue : ((DateTime)dr["startdate"]);
                child.SuspendedEnd = DBNull.Value.Equals(dr["enddate"]) ? DateTime.MinValue : ((DateTime)dr["enddate"]);
                child.IsSuspended = true;
            } 
            
            // Check if child was suspended
            else
            {
                DateTime[] suspension = GetSuspension((int)dr["id"]);
                if (suspension == null)
                {
                    child.SuspendedStart = DateTime.MinValue;
                    child.SuspendedEnd = DateTime.MinValue;
                } 
                
                else
                {
                    child.SuspendedStart = suspension[0];
                    child.SuspendedEnd = suspension[1];
                    child.IsSuspended = true;
                }
            }
            
            child.IsCheckedIn = IsCheckedIn((int)dr["id"]);
            child.LastDateAttended = GetLastDateAttended((int)dr["id"]);

            return child;
        }

        public bool IsCheckedIn(int childid)
        {
            DateTime now = DateTime.Now;
            bool checkedIn = false;
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

                if (dt.Rows.Count != 0 && string.Compare(dt.Rows[0]["dayattended"].ToString(), now.Date.ToString()) == 0)
                {
                    checkedIn = true;
                }

                con.Close();
            }

            return checkedIn;
        }

        private PostChildEditModel GetChildEditModel(DataRow dr)
        {
            PostChildEditModel child = new PostChildEditModel();
            child.Id = (int)dr["id"];
            child.FirstName = dr["firstname"].ToString();
            child.LastName = dr["lastname"].ToString();
            child.PreferredName = dr["preferredname"].ToString();
            child.ContactNumber = dr["contactnumber"].ToString();
            child.ContactEmail = dr["contactemail"].ToString();
            child.ParentName = dr["parentname"].ToString();
            child.BusId = DBNull.Value.Equals(dr["busid"]) ? 0 : (int)dr["busid"];
            child.Birthday = dr["birthday"].ToString();
            child.Gender = dr["gender"].ToString();
            child.ParentalWaiver = DBNull.Value.Equals(dr["parentalwaiver"]) ? false : (bool)dr["parentalwaiver"];
            child.ClassId = DBNull.Value.Equals(dr["classid"]) ? 0 : (int)dr["classid"];
            child.Picture = DBNull.Value.Equals(dr["picture"]) ? null : (byte[])dr["picture"];
            child.BusWaiver = DBNull.Value.Equals(dr["buswaiver"]) ? false : (bool)dr["buswaiver"];
            child.HaircutWaiver = DBNull.Value.Equals(dr["haircutpermission"]) ? false : (bool)dr["haircutpermission"];
            child.ParentalEmailOptIn = DBNull.Value.Equals(dr["parentalemailoptin"]) ? false : (bool)dr["parentalemailoptin"];
            child.OrangeShirtStatus = DBNull.Value.Equals(dr["orangeshirt"]) ? 0 : (int)dr["orangeshirt"];
            child.StartDate = GetStartDate((int)dr["id"]);

            return child;
        }

        private DateTime GetStartDate(int childid)
        {
            DateTime date = DateTime.MinValue;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                DataTable dt = new DataTable();

                // Retrieve all the days the child has been in attendance, ordered by oldest first
                string sql = @"SELECT dayattended
                               FROM Child_Attendance 
                               WHERE childid = @childid 
                               ORDER BY dayattended ASC";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                if (dt.Rows.Count != 0)
                {
                    date = (DateTime)dt.Rows[0]["dayattended"];
                }

                con.Close();
            }

            return date;
        }

        /// <summary>
        /// Given a child id, retrieves a list of DateTimes the child has been marked for attendance
        /// </summary>
        /// <param name="childid"></param>
        /// <returns>List of DateTimes associated with the child's attendance</returns>
        public List<DateTime> GetAttendanceDates(int childid)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = "SELECT * FROM Child_Attendance WHERE childid = @childid";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            List<DateTime> dates = new List<DateTime>();
            foreach (DataRow dr in dt.Rows)
            {
                dates.Add((DateTime)dr["dayattended"]);
            }

            return dates;
        }

        /// <summary>
        /// Given a child id, retrieves the most recent DateTime the child has been marked for attendance
        /// </summary>
        /// <param name="childid"></param>
        public DateTime GetLastDateAttended(int childid)
        {
            DataTable dt = new DataTable();
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                string sql = @"SELECT * 
                               FROM Child_Attendance 
                               WHERE childid = @childid
                               ORDER BY dayattended DESC";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }
            if (dt.Rows.Count == 0)
            {
                return DateTime.MinValue;
            }

            return (DateTime)dt.Rows[0]["dayattended"];
        }

        /// <summary>
        /// Takes in two ChildModel lists and returns a list of ChildModels that appears in both
        /// </summary>
        public List<ChildModel> GetIntersection(List<ChildModel> list1, List<ChildModel> list2)
        {
            if (list1 == null || list2 == null)
            {
                return null;
            }

            HashSet<int> list1Ids = new HashSet<int>();
            foreach (ChildModel child in list1)
            {
                list1Ids.Add(child.Id);
            }

            List<ChildModel> inBoth = new List<ChildModel>();
            foreach (ChildModel child in list2)
            {
                if (list1Ids.Contains(child.Id))
                {
                    inBoth.Add(child);
                }
            }

            return inBoth;
        }

        /// <summary>
        /// Gets all of the names and birthdays of children with a birthday in the given month
        /// </summary>
        /// <param name="month">The number of the month in question</param>
        /// <returns>A list of BirthdayModel objects</returns>
        public List<BirthdayModel> GetBirthdays(int month)
        {
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = "SELECT firstname, lastname, birthday from child where EXTRACT(month from birthday) = @month";
            List<BirthdayModel> birthdays = new List<BirthdayModel>();

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@month", NpgsqlTypes.NpgsqlDbType.Integer).Value = month;

                    da = new NpgsqlDataAdapter(cmd);

                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                birthdays.Add(new BirthdayModel
                {
                    Name = dr["firstname"].ToString() + " " + dr["lastname"].ToString(),
                    Date = Convert.ToDateTime(dr["birthday"])
                });
            }

            return birthdays;
        }

        public String GetBusName(int childId)
        {
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT b.name
                           FROM Bus b
                           LEFT JOIN Child c
                           ON c.busid = b.id
                           WHERE c.id = @childId";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count == 0)
            {
                return "NO BUS";
            }

            return dt.Rows[0]["name"].ToString();
        }

        public String GetClassName(int childId)
        {
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT cl.description
                           FROM Class_List cl
                           LEFT JOIN Child c
                           ON c.classid = cl.id
                           WHERE c.id = @childId";

            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childId", NpgsqlTypes.NpgsqlDbType.Integer).Value = childId;
                    da = new NpgsqlDataAdapter(cmd);
                    con.Open();
                    da.Fill(dt);
                    con.Close();
                }
            }

            if (dt.Rows.Count == 0)
            {
                return "NO CLASS";
            }

            return dt.Rows[0]["description"].ToString();
        }

        public String GetName(int id)
        {
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da;
            string sql = @"SELECT firstname, lastname 
                           FROM Child 
                           WHERE id = @id";

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

            return dt.Rows[0]["firstname"].ToString() + " " + dt.Rows[0]["lastname"].ToString();
        }
    }
}
