using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NLog;
using services.Models;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json.Linq;
using services.Resources;
using System.Text.RegularExpressions;

namespace services.Controllers
{
    public class TableController : CDMSController
    {

        [HttpGet]
        public dynamic GetTableData(int Id)
        {
            logger.Debug("Inside GetTableData...");
            logger.Debug("DatasetId = " + Id);

            var db = ServicesContext.Current;

            var dataset = db.Datasets.Find(Id);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + Id);

            var data_table = dataset.Datastore.TablePrefix;

            var sql = @"select * from " + data_table;
            logger.Debug(sql);
            DataTable data = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(data);
                }
            }

            return data;
        }


        [HttpPost]
        public dynamic SaveTableData(JObject jsonData)
        {
            logger.Debug("Inside SaveTableData ");

            var db = ServicesContext.Current;

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();

            Dataset dataset = db.Datasets.Find(json.DatasetId.ToObject<int>());
            if (dataset == null)
                throw new Exception("Configuration Error.");

            Project project = db.Projects.Find(dataset.ProjectId);
            if (project == null)
                throw new Exception("Configuration Error");

            if (!project.isOwnerOrEditor(me))
                throw new Exception("Authorization error.");

            int RecordId = json.TableData.Id.ToObject<int>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                TableDataHelper helper = new TableDataHelper(dataset, dataset.Datastore.TablePrefix, json.TableData);

                var query = (RecordId == 0) ? helper.getInsertQuery() : helper.getUpdateQuery();
                logger.Debug(" Table Data -- incoming query: " + query);

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (RecordId == 0) {
                        //do an insert and get the new id
                        var result = cmd.ExecuteScalar();
                        RecordId = Convert.ToInt32(result.ToString());
                    }
                    else 
                    {
                        //do an update
                        cmd.ExecuteNonQuery(); 
                    }
                }

            }

            //return the new/existing record
            return GetTableRow(dataset.Id, RecordId);
        }


        public dynamic GetTableRow(int DatasetId, int Id)
        {
            var db = ServicesContext.Current;

            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + Id);

            var data_table = dataset.Datastore.TablePrefix;

            var sql = @"select * from " + data_table + " WHERE ID = " + Id;

            logger.Debug(sql);

            DataTable data = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(data);
                }
            }

            return data;
        }

    }
}