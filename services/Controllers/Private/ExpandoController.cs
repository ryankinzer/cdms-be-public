using services.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Configuration;
using System.Dynamic;
//using Dapper;

using Newtonsoft.Json.Linq;
//using Dapper.Contrib.Extensions;

//This is an experiment toward a "soft" back-end persistence model instead of entity framework.

namespace services.Controllers.Private
{
    public class ExpandoController : CDMSController
    {

        [HttpGet]
        public dynamic GetDatastoreEntity(int DatastoreId, int EntityId)
        {

            var db = ServicesContext.Current;

            Datastore datastore = db.Datastores.Find(DatastoreId);

            string sql = "SELECT * FROM " + datastore.TablePrefix + " WHERE ID = " + EntityId;

            Dictionary<String,Object> expando = new Dictionary<String,Object>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    using (var reader = cmd.ExecuteReader())
                    {

                        reader.Read();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            expando[reader.GetName(i)] = reader.GetValue(i);
                        }

                    }

                }
            }

            return expando;

        }

        [HttpGet]
        public dynamic GetDatastoreRows(int DatastoreId)
        {

            var db = ServicesContext.Current;

            Datastore datastore = db.Datastores.Find(DatastoreId);

            string sql = "SELECT * FROM " + datastore.TablePrefix;

            DataTable results = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(results);
                }
            }

            return results;

        }

/*
        [HttpGet]
        public dynamic GetExpando(int DatastoreId, int EntityId)
        {

            var db = ServicesContext.Current;

            Datastore datastore = db.Datastores.Find(DatastoreId);

            Dictionary<String, Object> expando = new Dictionary<String, Object>();
            expando.Add("@Id", EntityId);

            string sql = "SELECT * FROM " + datastore.TablePrefix + " WHERE ID = " + EntityId;

            dynamic results;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    results = con.Query<dynamic>(sql, expando);
                }
            }

            return results;

        }


        [HttpPost]
        public dynamic SaveExpando(JObject jsonData)
        {
            logger.Debug("save expando go");
            dynamic json = jsonData;
            int DatastoreId = json.DatastoreId.ToObject<int>();
            logger.Debug("Datastoreid = " + DatastoreId);

            var db = ServicesContext.Current;

            Datastore datastore = db.Datastores.Find(DatastoreId);
            dynamic tablename = datastore.TablePrefix;

            logger.Debug("table = " + tablename);

            Dictionary<String, Object> expando = new Dictionary<String, Object>();

            foreach (JProperty field in json.SaveEntity)
            {
                expando.Add(field.Name, field.Value);
            }

            SqlMapperExtensions.TableNameMapper = (type) => { return tablename; };
            
            dynamic results;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                results = con.Insert<dynamic>(expando);

            }
            
            return "yep";

        }
*/


    }
}



        