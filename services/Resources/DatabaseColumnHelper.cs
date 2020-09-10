using NLog;
using services.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace services.Resources
{
    public static class DatabaseColumnHelper
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();

        public static void removeFieldFromDatabase(Field in_field){
            logger.Debug("Inside DatabaseColumnHelper.cs, removeFieldToDatabase...");
            logger.Debug("in_field.DbColumnName = " + in_field.DbColumnName);

            var db = ServicesContext.Current;

            Datastore datastore = db.Datastores.Find(in_field.DatastoreId);

            var tableName = datastore.TablePrefix;

            //logger.Debug("datastore.TableType = " + datastore.TableType);
            if (datastore.TableType != "Single")
                tableName += (in_field.FieldRoleId == 1) ? "_Header" : "_Detail";

            var query = "ALTER TABLE " + tableName + " DROP COLUMN IF EXISTS " + in_field.DbColumnName;

            logger.Debug("query = " + query);

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + query);
                        throw new Exception("Failed to execute column drop query!");
                    }
                }
            }

        }

        public static void addFieldToDatabase(Field in_field){
            //logger.Debug("Inside DatabaseColumnHelper.cs, addFieldToDatabase...");
            //logger.Debug("in_field.DbColumnName = " + in_field.DbColumnName);
            
            var db = ServicesContext.Current;

            Datastore datastore = db.Datastores.Find(in_field.DatastoreId);

            var tableName = datastore.TablePrefix;

            //logger.Debug("datastore.TableType = " + datastore.TableType);
            if(datastore.TableType != "Single")
                tableName += (in_field.FieldRoleId == 1) ? "_Header" : "_Detail";

            var query = "ALTER TABLE " + tableName + " ADD " + in_field.DbColumnName + " ";
            query += getSQLFieldType(in_field.DataType, in_field.ControlType) + " NULL";

            logger.Debug("query = " + query);

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        logger.Debug("Problem executing: " + query);
                        throw new Exception("Failed to execute column create query!");
                    }
                }
            }
        }

        private static string getSQLFieldType(string in_datatype, string in_control){
            string retval = null;

            switch (in_datatype)
            {
                case "string":
                    if (in_control == "textarea")
                        retval = "VARCHAR(max)";
                    else
                        retval = "VARCHAR(255)";
                    break;
                case "int":
                    retval = "INT";
                    break;
                case "date":
                case "datetime":
                    retval = "DATETIME";
                    break;
                case "float":
                    retval = "FLOAT";
                    break;

            }

            return retval;
        }
    }
}