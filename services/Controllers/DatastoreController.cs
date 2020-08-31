using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Dynamic;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Newtonsoft.Json.Linq;
using services.Models;
using services.Resources;

/*
 * DatastoreController
 * Think of a "datastore" as a "master dataset" -- The datastore defines the table(s) where the dataset is stored and the information
 * about the master dataset. The "fields" table defines the fields in this master dataset. 
 * Then a "dataset" can be defined for a project that has a subset of those fields (or all of them) defined 
 * for that particular project's version of that "master dataset". 
 */ 

namespace services.Controllers
{
    public class DatastoreController : CDMSController
    {
        // GET /api/v1/datastore/getdatastores
        [HttpGet]
        public IEnumerable<Datastore> GetDatastores()
        {
            var db = ServicesContext.Current;
            return db.Datastores.AsEnumerable();
        }

        
        /*
           * Get list of all fields for a datastore (master fields)
        */
        //GET /api/v1/datastore/getdatastorefields/5
        [HttpGet]
        public IEnumerable<Field> GetDatastoreFields(int Id)
        {
            var db = ServicesContext.Current;
            logger.Info("Getting all fields...where DatastoreId = " + Id);
            return db.Fields.Where(o => o.DatastoreId == Id).OrderBy(o => o.Name).AsEnumerable();
        }



        /*
         * Get a datastore by id
         */
        // GET /api/v1/datastore/getdatastore/5
        [HttpGet]
        public Datastore GetDatastore(int Id)
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();

            var datastore = db.Datastores.Find(Id);
            if (datastore == null)
                throw new System.Exception("Configuration error: Datastore not recognized.");

            return datastore;
        }

        /*
         * Get a datastore's locations
         */ 
         // GET /api/v1/datastore/getdatastorelocations/5
        [HttpGet]
        public IEnumerable<Location> GetDatastoreLocations(int Id)
        {
            logger.Debug("Id = " + Id);

            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();

            Dataset ds = db.Datasets.Find(Id);
            logger.Debug("ds.Datastore = " + ds.DatastoreId);

            var datastore = db.Datastores.Find(ds.DatastoreId);
            logger.Debug("datastore.Name = " + datastore.Name);

            if (datastore == null)
                throw new System.Exception("Configuration error: Datastore not recognized");

            return datastore.Locations;

        }

        /*
         * Returns list of a datastore's fields 
         * Think of this as the list of master fields for the master dataset
         */ 
         // GET /api/v1/datastore/getdatastorefields/5
/* -- can get this directly since fields have a datastoreid 
        [HttpGet]
        public IEnumerable<Field> GetDatastoreFields(int Id)
        {
            var db = ServicesContext.Current;
            
            var datastore = db.Datastores.Find(Id);
            if (datastore == null)
                throw new System.Exception("Configuration error: Datastore not recognized");

            return datastore.Fields;
        }
*/
        /*
         * Returns list of projects associated with a datastore id
         */ 
         // GET /api/v1/datastore/getdatastoreprojects/5
        [HttpGet]
        public IEnumerable<Project> GetDatastoreProjects(int Id)
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();

            var datastore = db.Datastores.Find(Id);
            if (datastore == null)
                throw new System.Exception("Configuration error: Datastore not recognized");

            return datastore.Projects;
        }

        /*
         * Returns list of datasets associated with a datastore id
         */ 
         //GET /api/v1/datastore/getdatastoredatasets/5
        [HttpGet]
        public IEnumerable<Dataset> GetDatastoreDatasets(int Id)
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();

            var datastore = db.Datastores.Find(Id);
            if (datastore == null)
                throw new System.Exception("Configuration error: Datastore not recognized");

            return datastore.Datasets;
        }

        /*
         * Add a field (from the list of master fields) to a project's dataset
         */ 
         // POST /api/v1/datastore/addmasterfieldtodataset
        [HttpPost]
        public HttpResponseMessage AddMasterFieldToDataset(JObject jsonData)
        {
            logger.Debug("Inside AddMasterFieldToDataset...");
            var db = ServicesContext.Current;
            dynamic json = jsonData;

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);

            int FieldId = json.FieldId.ToObject<int>();
            logger.Debug("FieldId = " + FieldId);
            var field = db.Fields.Find(FieldId);

            DatasetField df = new DatasetField();

            df.DatasetId = dataset.Id;
            df.FieldId = field.Id;
            df.FieldRoleId = field.FieldRoleId;
            df.CreateDateTime = DateTime.Now;
            df.Label = field.Name;
            df.DbColumnName = field.DbColumnName;
            df.SourceId = 1;
            df.ControlType = field.ControlType;

            db.DatasetFields.Add(df);
            db.SaveChanges();
            logger.Debug("Added/saved the field: " + field.DbColumnName);

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, df);
            return response;

        }

        

        /*
         * update a master field's information (a field on a datastore)
         */ 
        // POST /api/v1/datastore/savemasterfield
        [HttpPost]
        public HttpResponseMessage SaveMasterField(JObject jsonData)
        {
            logger.Debug("Inside DatastoreController, SaveMasterField...");

            var db = ServicesContext.Current;

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();

            Datastore datastore = db.Datastores.Find(json.DatastoreId.ToObject<int>());

            Field df = null;

            if (json["Id"] == null)
                df = new Field();
            else
                df = db.Fields.Find(json.Id.ToObject<int>());

            if (df == null || me == null)
                throw new System.Exception("Configuration error. Please try again.");

            if(json["DbColumnName"]==null || json["Name"]==null){
                throw new System.Exception("Name and DbColumnName are required fields.");
            }

            df.DatastoreId = datastore.Id;
            df.Name = json.Name;
            df.Validation = json.Validation;
            df.Rule = json.Rule;
            df.Units = json.Units;
            df.TechnicalName = json.TechnicalName;
            df.DbColumnName = json.DbColumnName;
            df.DataType = json.DataType;
            df.ControlType = json.ControlType;
            df.PossibleValues = json.PossibleValues;
            df.Description = json.Description;
            df.DataSource = json.DataSource;
            df.FieldRoleId = json.FieldRoleId;

            //logger.Debug("json['Id'] = " + json["Id"]);
            if (json["Id"] == null)
            {
                DatabaseColumnHelper.addFieldToDatabase(df);
                db.Fields.Add(df);
            }
            else
            {
                db.Entry(df).State = EntityState.Modified;
            }

            logger.Debug("About to save...");
            db.SaveChanges();
            logger.Debug("Done saving... Creating view.");

            DatabaseTableHelper.regenerateViews(datastore);

            logger.Debug("done!");

            return Request.CreateResponse(HttpStatusCode.Created, df);
        }

        [HttpPost]
        public HttpResponseMessage RemoveMasterField(JObject jsonData){
            var db = ServicesContext.Current;

            dynamic json = jsonData;

            User me = AuthorizationManager.getCurrentUser();

            Datastore datastore = db.Datastores.Find(json.DatastoreId.ToObject<int>());

            Field df = null;

            if (json["FieldId"] == null)
                df = new Field();
            else
                df = db.Fields.Find(json.FieldId.ToObject<int>());

            if (df == null || me == null)
                throw new System.Exception("Configuration error. Please try again.");

            DatabaseColumnHelper.removeFieldFromDatabase(df);

            db.Fields.Remove(df);
            db.SaveChanges();

            DatabaseTableHelper.regenerateViews(datastore);

            return Request.CreateResponse(HttpStatusCode.Created, df);

        }


        // POST /api/v1/datastore/savemasterfield
        [HttpPost]
        public HttpResponseMessage SaveNewDatastore(JObject jsonData)
        {
            var db = ServicesContext.Current;

            dynamic json = jsonData;

            User me = AuthorizationManager.getCurrentUser();

            if(me == null)
                throw new System.Exception("Configuration error. Please try again.");

            Datastore datastore = new Datastore();

            datastore.Name = json.Datastore.Name;
            datastore.Description = json.Datastore.Description;
            datastore.TablePrefix = UppercaseFirst(json.Datastore.TablePrefix.ToString().Replace(" ", ""));
            datastore.OwnerUserId = me.Id;
			//datastore.DefaultConfig = "{}";
			//Tribal CDMS Edit
			datastore.DefaultConfig = "{\"AllowSaveWithErrors\":false}";
            datastore.TableType = json.Datastore.TableType;

            LocationType loctype = new LocationType();
            loctype.Name = datastore.Name;
            loctype.Description = datastore.Description;

            //first let's make sure we can create the tables...
            if (json.Datastore.TableType == "Single")
            {
                datastore.DefaultConfig = "{\"ActivitiesPage\":{\"Route\":\"table\"}}";
                DatabaseTableHelper.addSingleToDatabase(datastore);
            } else {
                DatabaseTableHelper.addDatasetTablesToDatabase(datastore);
            }

            db.LocationType.Add(loctype);
            db.SaveChanges();

            datastore.LocationTypeId = loctype.Id.ToString();

            db.Datastores.Add(datastore);
            db.SaveChanges();

            return Request.CreateResponse(HttpStatusCode.Created, datastore);
        }

        static string UppercaseFirst(string s)
        {
            // Check for empty string.
            if (string.IsNullOrEmpty(s))
            {
                return string.Empty;
            }
            // Return char and concat substring.
            return char.ToUpper(s[0]) + s.Substring(1);
        }

    }
}
