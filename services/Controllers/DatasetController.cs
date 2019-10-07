using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
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
    /* 
     * Handles all dataset related api calls
     */
    [System.Web.Http.Authorize]
    public class DatasetController : CDMSController
    {

        public dynamic GetDatasetsList() 
        {
            string query = @"
select d.Id, d.DatastoreId, d.ProjectId, d.CreateDateTime, d.Name, d.Description, d.Config, p.Name as ProjectName, ds.Name as DatastoreName
from datasets d
join projects p on d.ProjectId = p.Id and p.ProjectTypeId not in (select id from ProjectTypes where Name = 'System')
join datastores ds on d.DatastoreId = ds.Id
";

            //limit the user if they are external users to only the projects they are allowed 
            User me = AuthorizationManager.getCurrentUser();
            if(!String.IsNullOrEmpty(me.Roles) && me.Roles.Contains("ExternalUser")){

                IList<string> authorized_projects = new List<string> { };

                Regex regex = new Regex(@"Project_(\d+)");

                foreach (Match match in regex.Matches(me.Roles))
                {
                    logger.Debug("Limiting external user to project: " + match.Groups[1].Value);
                    authorized_projects.Add(match.Groups[1].Value);
                }

                query += " WHERE p.Id in (" + string.Join(",", authorized_projects) + ")";

                logger.Debug("Final SQL: " + query);
            }

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }

            return dt;
        }

        public IEnumerable<Dataset> GetDatasets()
        {
            var db = ServicesContext.Current;

            var datasets = db.Datasets.Include(d => d.DefaultRowQAStatus);
            return datasets.AsEnumerable();
        }

        // GET /api/v1/dataset/getdataset/5
        public Dataset GetDataset(int id)
        {
            var db = ServicesContext.Current;

            Dataset dataset = db.Datasets.Find(id);
            if (dataset == null)
            {
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotFound));
            }

            //limit the user if they are external users to only the projects they are allowed 
            User me = AuthorizationManager.getCurrentUser();
            if (!String.IsNullOrEmpty(me.Roles) && me.Roles.Contains("ExternalUser"))
            {

                IList<string> authorized_projects = new List<string> { };

                Regex regex = new Regex(@"Project_(\d+)");

                foreach (Match match in regex.Matches(me.Roles))
                {
                    logger.Debug("Limiting external user to project: " + match.Groups[1].Value);
                    authorized_projects.Add(match.Groups[1].Value);
                }

                if (!authorized_projects.Contains(dataset.ProjectId.ToString()))
                {
                    throw new Exception("Authorization error: user is external and not authorized for this dataset.");
                }

            }

            return dataset;
        }

        // POST /api/v1/dataset/updatedataset
        [HttpPost]
        public HttpResponseMessage UpdateDataset(JObject jsonData)
        {
            var db = ServicesContext.Current;

            dynamic json = jsonData;

            Dataset ds = db.Datasets.Find(json.dataset.Id.ToObject<int>());

            ds.Name = json.dataset.Name;
            ds.Description = json.dataset.Description;
            ds.DefaultActivityQAStatusId = json.dataset.DefaultActivityQAStatusId.ToObject<int>();
            ds.DefaultRowQAStatusId = json.dataset.DefaultRowQAStatusId.ToObject<int>();
            ds.Config = json.dataset.Config;


            db.Entry(ds).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
            }

            return Request.CreateResponse(HttpStatusCode.OK, ds);
        }

        public HttpResponseMessage PostDataset(Dataset dataset)
        {
            var db = ServicesContext.Current;

            if (ModelState.IsValid)
            {
                db.Datasets.Add(dataset);
                db.SaveChanges();

                HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, dataset);
                response.Headers.Location = new Uri(Url.Link("DefaultApi", new { id = dataset.Id }));
                return response;
            }
            else
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ModelState);
            }
        }

        public HttpResponseMessage DeleteDataset(int id)
        {
            var db = ServicesContext.Current;

            Dataset dataset = db.Datasets.Find(id);
            if (dataset == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }

            db.Datasets.Remove(dataset);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
            }

            return Request.CreateResponse(HttpStatusCode.OK, dataset);
        }

        protected override void Dispose(bool disposing)
        {
            var db = ServicesContext.Current;

            db.Dispose();
            base.Dispose(disposing);
        }


        [HttpGet]
        public dynamic GetTableData(int Id){
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
        
        // GET /api/v1/dataset/getheadersdatafordataset/5
        public DataTable GetHeadersDataForDataset(int id)
        {
            logger.Debug("Inside DatasetController.cs, GetHeadersDataForDataset...");
            var db = ServicesContext.Current;
            Dataset dataset = db.Datasets.Find(id);
            if (dataset == null)
            {
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotFound));
            }

            string query = "SELECT h.* FROM " + dataset.Datastore.TablePrefix + "_Header_VW h JOIN Activities a on a.Id = h.ActivityId WHERE a.DatasetId = " + dataset.Id;
            //logger.Debug("query = " + query);

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }

            return dt;
        }

        //api/v1/dataset/adddatasettoproject
        [HttpPost]
        public HttpResponseMessage AddDatasetToProject(JObject jsonData)
        {
            logger.Debug("Here we are adding a dataset to a project!");
            var db = ServicesContext.Current;

            dynamic json = jsonData;
            int DatastoreId = json.DatastoreId.ToObject<int>();
            Datastore ds = db.Datastores.Find(DatastoreId);

            int ProjectId = json.ProjectId.ToObject<int>();
            Project p = db.Projects.Find(ProjectId);

            logger.Debug("We have a datastore to save: " + ds.Name + " for Project: " + p.Name);

            //CREATE A TRANSACTION!

            Dataset new_ds = new Dataset();
            new_ds.ProjectId = p.Id;
            new_ds.Name = p.Name + "-"+ds.Name;
            new_ds.DefaultRowQAStatusId = 1;
            new_ds.StatusId = 1;
            new_ds.CreateDateTime = DateTime.Now;
            new_ds.DefaultActivityQAStatusId = 6;
            new_ds.DatastoreId = ds.Id;
            new_ds.Config = null;

            //TODO: this should be configured somewhere not hardcoded... ***

            // Non-WaterTemp datasets get these. 
            QAStatus qa1 = db.QAStatuses.Find(5);
            QAStatus qa2 = db.QAStatuses.Find(6);
            QAStatus qa3 = db.QAStatuses.Find(1); // Default rowQA

            // For WaterTemp, if necessary.
            // WaterTemp datasets get more RowQA statuses.
            QAStatus rqa2 = null;
            QAStatus rqa3 = null;
            QAStatus rqa4 = null;
            QAStatus rqa5 = null;
            QAStatus rqa6 = null;
            QAStatus rqa7 = null;

            if (ds.TablePrefix == "WaterTemp")
            {
                // OK, find the additional RowQA Statuses for WaterTemp.
                rqa2 = db.QAStatuses.Find(12);
                rqa3 = db.QAStatuses.Find(13);
                rqa4 = db.QAStatuses.Find(14);
                rqa5 = db.QAStatuses.Find(15);
                rqa6 = db.QAStatuses.Find(16);
                rqa7 = db.QAStatuses.Find(17);
            }

            new_ds.QAStatuses = new List<QAStatus>();
            new_ds.QAStatuses.Add(qa1);
            new_ds.QAStatuses.Add(qa2);

            new_ds.RowQAStatuses = new List<QAStatus>();
            new_ds.RowQAStatuses.Add(qa3);

            if (ds.TablePrefix == "WaterTemp")
            {
                // Now, add the additional RowQA statuses to WaterTemp
                new_ds.RowQAStatuses.Add(rqa2);
                new_ds.RowQAStatuses.Add(rqa3);
                new_ds.RowQAStatuses.Add(rqa4);
                new_ds.RowQAStatuses.Add(rqa5);
                new_ds.RowQAStatuses.Add(rqa6);
                new_ds.RowQAStatuses.Add(rqa7);
            }

            new_ds.Fields= new List<DatasetField>();

            foreach (var field in json.DatasetFields)
            {
                logger.Debug(" -- " + field.Id); 
                int field_id = field.Id.ToObject<int>();
                Field the_field = db.Fields.Find(field_id);

                DatasetField the_ds_field = new DatasetField();

                the_ds_field.FieldId = the_field.Id;
                the_ds_field.FieldRoleId = the_field.FieldRoleId;
                the_ds_field.CreateDateTime = DateTime.Now;
                the_ds_field.Label = the_field.Name;
                the_ds_field.DbColumnName = the_field.DbColumnName;
                the_ds_field.ControlType = the_field.ControlType;
                the_ds_field.Validation = the_field.Validation;
                the_ds_field.Rule = the_field.Rule;
                the_ds_field.SourceId = 1;


                new_ds.Fields.Add(the_ds_field);
                //logger.Debug(" -- added " + field.Id);

            }

            db.Datasets.Add(new_ds);
            db.SaveChanges();

            //logger.Debug(new_ds);
            
            return new HttpResponseMessage(HttpStatusCode.OK);

        }


        // POST /api/v1/dataset/savedatasetfield
        [HttpPost]
        public HttpResponseMessage SaveDatasetField(JObject jsonData)
        {
            var db = ServicesContext.Current;

            dynamic json = jsonData;

            User me = AuthorizationManager.getCurrentUser();

            DatasetField df = db.DatasetFields.Find(json.Id.ToObject<int>());

            if (df == null || me == null)
                throw new System.Exception("Configuration error. Please try again.");

            df.Label = json.Label;
            df.Validation = json.Validation;
            df.Rule = json.Rule;
            df.DbColumnName = json.DbColumnName;
            df.FieldRoleId = json.FieldRoleId.ToObject<int>();
            try
            {
                df.OrderIndex = json.OrderIndex.ToObject<int>();
            }
            catch (System.Exception)
            {
                logger.Debug("didn't have an orderindex.");
            }
            df.ControlType = json.ControlType;
            df.SourceId = json.SourceId.ToObject<int>();

            db.SaveChanges();

            return Request.CreateResponse(HttpStatusCode.OK, df);

        }

        /*
         * Remove a field from a project's version of the dataset
         * (does not remove the master field).
         */
         // POST /api/v1/dataset/deletedatasetfield
        [HttpPost]
        public HttpResponseMessage DeleteDatasetField(JObject jsonData)
        {
            logger.Debug("Inside DatastoreController.cs, DeleteDatasetField...");
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + DatasetId);

            int FieldId = json.FieldId.ToObject<int>();
            logger.Debug("FieldId = " + FieldId);

            //var field = db.DatasetFields.Find(FieldId); // Original line
            List<DatasetField> datasetFieldRecords = (from item in db.DatasetFields
                                                      where item.DatasetId == DatasetId && item.FieldId == FieldId
                                                      select item).ToList();

            if (datasetFieldRecords.Count == 0)
                throw new System.Exception("Field could not be retrieved for dataset: " + DatasetId);
            else if (datasetFieldRecords.Count > 1)
                logger.Debug("Found " + datasetFieldRecords.Count + " records (fields).");
            else
                logger.Debug("Found field.");

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();

                //var query = "DELETE FROM DatasetFields where DatasetId = " + dataset.Id + " and FieldId = " + field.Id; // Original line
                var query = "";
                foreach (var item in datasetFieldRecords)
                {
                    query = "DELETE FROM DatasetFields where Id = " + item.Id;
                    logger.Debug("SQL command = " + query);
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        //logger.Debug(query);
                        //cmd.ExecuteNonQuery(); // Original line
                        try
                        {
                            cmd.ExecuteNonQuery();
                            logger.Debug("Delete action done...");
                        }
                        catch (System.Exception e)
                        {
                            logger.Debug("Delete action failed:  " + e.Message);
                        }
                    }
                }
            }

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

    }
}