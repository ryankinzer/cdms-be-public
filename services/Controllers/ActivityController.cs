using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using services.Models;
using services.Models.Data;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace services.Controllers
{
    /**
     * ActivityController - Handles any api requests dealing with activities.
     * 
     * Any data in a dataset will have belong to an "activity".
     * 
     */
    public class ActivityController : CDMSController
    {
        /*
         * Sets the QA Status of an activity. Since we do audit tracking, this actually amounts to
         * inserting a new row to indicate that the qa status has changed. Any queries/views must always fetch/join
         * the most recent QA Status for the activity to know its latest state. In this way you can always see all of the
         * states that an activity has gone through as it has changed.
         */

        // POST /api/v1/activity/setqastatus
        [HttpPost]
        public HttpResponseMessage SetQaStatus(JObject jsonData)
        {
            var db = ServicesContext.Current;

            dynamic json = jsonData;

            User me = AuthorizationManager.getCurrentUser();
            Activity activity = db.Activities.Find(json.ActivityId.ToObject<int>());

            if (activity == null || me == null)
                throw new Exception("SetQAStatus: Configuration error. Please try again.");

            logger.Debug("Userid = " + me.Id + " Activity = " + activity.Id);

            var aq = new ActivityQA();
            aq.ActivityId = activity.Id;
            aq.EffDt = DateTime.Now;
            aq.Comments = json.Comments;
            aq.UserId = me.Id; //current user.
            aq.QAStatusId = json.QAStatusId;

            db.ActivityQAs.Add(aq);

            db.SaveChanges();

            return new HttpResponseMessage(HttpStatusCode.OK);


        }

        /*
         * get list of activities for this datasetid (returns an empty list if none)
         */
        //GET /api/v1/activity/getdatasetactivities/5
        [HttpGet]
        public IEnumerable<Activity> GetDatasetActivities(int Id)
        {
            var ndb = ServicesContext.Current;
            return ndb.Activities.Where(o => o.DatasetId == Id).ToList();
        }

        /*
         * get list of seasons for this datasetid (returns an empty list if none)
         */
        //GET /api/v1/activity/getdatasetseasons/5
        /*[HttpGet]
        public IEnumerable<Seasons> GetDatasetSeasons(int id)
        {
            logger.Debug("Inside GetDatasetSeasons...");
            logger.Debug("id = " + id);
            var ndb = ServicesContext.Current;
            return ndb.Seasons.Where(o => o.DatasetId == id).ToList();
        }
        */

        /*
        * This queries just the information we need for showing the Activities on the
        * Data tab on CDMS front-end (for performance).
        */
        // GET /api/v1/activity/getdatasetactivitiesview/5
        [HttpGet]
        public dynamic GetDatasetActivitiesView(int Id)
        {
            var db = ServicesContext.Current;

            var dataset = db.Datasets.Find(Id);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + Id);

            var data_header_name = dataset.Datastore.TablePrefix + "_Header_VW";

            //var sql = "SELECT * FROM " + data_header_name + " vw JOIN Activities a ON a.Id = vw.ActivityId WHERE a.datasetid = "+Id;

            var sql = @"
SELECT a.Id, a.Description, a.DatasetId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, 
a.InstrumentId, a.AccuracyCheckId, a.PostAccuracyCheckId,
vw.*, 
qv.QAStatusId,
loc.Label as LocationLabel, loc.LocationTypeId, loc.OtherAgencyId,
wb.Name as WaterBodyName,
u.Fullname as UserFullname
FROM " + data_header_name + @" vw 
JOIN Activities a ON a.Id = vw.ActivityId 
JOIN ActivityQAs_VW qv ON a.Id = qv.ActivityId
JOIN Locations loc ON a.LocationId = loc.Id
LEFT JOIN WaterBodies wb ON loc.WaterBodyId = wb.Id
JOIN Users u ON u.Id = a.UserId
WHERE a.datasetid = " + Id;


            DataTable activities = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(activities);
                }
            }

            return activities;
        }



        /*
         * This queries just the information we need for showing the Activities on the
         * Data tab on CDMS front-end (for performance).
         */
        // GET /api/v1/activity/getdatasetactivitiesview/5
        [HttpGet]
        public dynamic GetDatasetActivitiesView_old(int Id)
        {
            var db = ServicesContext.Current;

            Dataset ds = db.Datasets.Find(Id);
            if (ds == null)
                throw new Exception("Configuration Error:  Could not find the DatasetID in the database.");

            /*var query = @"SELECT a.Id, a.LocationId, a.UserId, a.ActivityDate, a.Description, l.Label, l.LocationTypeId, l.SdeObjectId, l.WaterBodyId,
                l.OtherAgencyId, l.GPSEasting, l.GPSNorthing, l.Projection, l.UTMZone, l.Latitude, l.Longitude, w.Name as WaterBodyName,
                u.Fullname, qa.QAStatusId, qa.UserId as QAStatusUserId, qa.QAStatusName
                FROM dbo.Activities AS a
                    JOIN dbo.ActivityQAs_VW AS qa ON a.Id = qa.ActivityId
                    JOIN dbo.Locations AS l ON a.LocationId = l.Id
                    LEFT JOIN dbo.WaterBodies AS w ON l.WaterBodyId = w.Id
                    JOIN dbo.Users AS u ON a.UserId = u.Id
                WHERE a.DatasetId = " + Id;
            */
            string strQuery = BuildQueryString(Id, ds.Datastore.TablePrefix);

            DataTable activities = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(strQuery, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(activities);
                }
            }

            //build up our json instead of sending back the whole blasted object graph
            //return activities;

            /*JArray datasetactivities =
                new JArray(                     //array of activities
                from a in activities.AsEnumerable()
                select new JObject              //one for each activity
                (
                    new JProperty("Id", a["Id"]),
                    new JProperty("LocationId", a["LocationId"]),
                    new JProperty("UserId", a["UserId"]),
                    new JProperty("Description", a["Description"]),
                    new JProperty("ActivityDate", a["ActivityDate"]),
                    new JProperty("Location",
                        new JObject(
                            new JProperty("Id", a["LocationId"]),
                            new JProperty("Label", a["Label"]),
                            new JProperty("OtherAgencyId", a["OtherAgencyId"]),
                            new JProperty("LocationTypeId", a["LocationTypeId"]),
                            new JProperty("SdeObjectId", a["SdeObjectId"]),
                            new JProperty("WaterBodyId", a["WaterBodyId"]),
                            new JProperty("GPSEasting", a["GPSEasting"]),
                            new JProperty("GPSNorthing", a["GPSNorthing"]),
                            new JProperty("Projection", a["Projection"]),
                            new JProperty("UTMZone", a["UTMZone"]),
                            new JProperty("Latitude", a["Latitude"]),
                            new JProperty("Longitude", a["Longitude"]),
                            new JProperty("WaterBody",
                                new JObject(
                                    new JProperty("Id", a["WaterBodyId"]),
                                    new JProperty("Name", a["WaterBodyName"])))
                            )), //closes location
                    new JProperty("User",
                        new JObject(
                            new JProperty("Id", a["UserId"]),
                            new JProperty("Fullname", a["Fullname"]))),
                    new JProperty("ActivityQAStatus",
                        new JObject(
                            new JProperty("QAStatusId", a["QAStatusId"]),
                            new JProperty("UserId", a["QAStatusUserId"]),
                            new JProperty("QAStatusName", a["QAStatusName"])
                            ))
                )
                  );
            */
            JArray datasetactivities = BuildJArray(activities, ds.Datastore.TablePrefix);

            return datasetactivities;
        }

        // GET /api/v1/activity/getcreelsurveydatasetactivitiesview/5
        [HttpGet]
        public dynamic GetCreelSurveyDatasetActivitiesView(int Id)
        {
            logger.Debug("Insidle GetCreelSurveyDatasetActivitiesView...Id = " + Id);

            var query = @"SELECT a.Id, a.LocationId, a.UserId, a.Description, 
                h.ByUserId, convert(varchar(19), h.TimeStart, 120) AS TimeStart,
                l.Label, l.LocationTypeId, l.SdeObjectId, l.WaterBodyId, l.OtherAgencyId, 
                l.GPSEasting, l.GPSNorthing, l.Projection, l.UTMZone, l.Latitude, l.Longitude, 
                w.Name as WaterBodyName,
                u.Fullname, 
                qa.QAStatusId, qa.UserId as QAStatusUserId, qa.QAStatusName
                FROM dbo.Activities AS a
                    JOIN dbo.ActivityQAs_VW AS qa ON a.Id = qa.ActivityId
					JOIN dbo.CreelSurvey_Header AS h on a.Id = h.ActivityId
                    JOIN dbo.Locations AS l ON a.LocationId = l.Id
                    LEFT JOIN dbo.WaterBodies AS w ON l.WaterBodyId = w.Id
                    JOIN dbo.Users AS u ON a.UserId = u.Id
                WHERE a.DatasetId = " + Id +
                "AND (h.EffDt = (SELECT MAX(EffDt) AS MaxEffDt " +
                "FROM dbo.CreelSurvey_Header AS hh WHERE(ActivityId = h.ActivityId)))";

            DataTable activities = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(activities);
                }
            }

            //string strDate = "";
            //foreach(DataRow r in activities.Rows)
            //{
            //    strDate = r.Field<string>("ActivityDate").ToString();
            //}

            //build up our json instead of sending back the whole blasted object graph
            //return activities;

            JArray datasetactivities =
                new JArray(                     //array of activities
                from a in activities.AsEnumerable()
                select new JObject              //one for each activity
                (
                    new JProperty("Id", a["Id"]),
                    new JProperty("LocationId", a["LocationId"]),
                    new JProperty("UserId", a["UserId"]),
                    new JProperty("Description", a["Description"]),
                    //new JProperty("ActivityDate", a["ActivityDate"]),
                    new JProperty("Location",
                        new JObject(
                            new JProperty("Id", a["LocationId"]),
                            new JProperty("Label", a["Label"]),
                            new JProperty("OtherAgencyId", a["OtherAgencyId"]),
                            new JProperty("LocationTypeId", a["LocationTypeId"]),
                            new JProperty("SdeObjectId", a["SdeObjectId"]),
                            new JProperty("WaterBodyId", a["WaterBodyId"]),
                            new JProperty("GPSEasting", a["GPSEasting"]),
                            new JProperty("GPSNorthing", a["GPSNorthing"]),
                            new JProperty("Projection", a["Projection"]),
                            new JProperty("UTMZone", a["UTMZone"]),
                            new JProperty("Latitude", a["Latitude"]),
                            new JProperty("Longitude", a["Longitude"]),
                            new JProperty("WaterBody",
                                new JObject(
                                    new JProperty("Id", a["WaterBodyId"]),
                                    new JProperty("Name", a["WaterBodyName"])))
                            )), //closes location
                    new JProperty("headerdata",
                        new JObject(
                            new JProperty("ByUserId", a["ByUserId"]),
                            new JProperty("TimeStart", a["TimeStart"]))),
                    new JProperty("User",
                        new JObject(
                            new JProperty("Id", a["UserId"]),
                            new JProperty("Fullname", a["Fullname"]))),
                    new JProperty("ActivityQAStatus",
                        new JObject(
                            new JProperty("QAStatusId", a["QAStatusId"]),
                            new JProperty("UserId", a["QAStatusUserId"]),
                            new JProperty("QAStatusName", a["QAStatusName"])
                            ))
                )
                  );

            return datasetactivities;
        }

        // GET /api/v1/activity/getdatasetactivitydata/5
        /*
         * returns a dataset model instance (like "AdultWeir") populated with the data related to an activity id
         */
        [HttpGet]
        public dynamic GetDatasetActivityData(int Id)
        {
            logger.Debug("Inside DatasetData.  Need data for this activity:  " + Id);
            var db = ServicesContext.Current;
            Activity activity = db.Activities.Find(Id);

            if (activity == null)
                throw new Exception("Configuration Error");

            logger.Debug("activity.Id = " + activity.Id);

            /* The next commands gets the name of the dataset from the Datastore table prefix.
             * This is how we determine which dataset class we are working with.
            */
            logger.Debug("activity.Dataset.Datastore.TablePrefix = " + activity.Dataset.Datastore.TablePrefix);
            System.Type type = db.GetTypeFor(activity.Dataset.Datastore.TablePrefix);

            //instantiate by name: AdultWeir(activity.Id)
            return Activator.CreateInstance(type, activity.Id);
        }


        /*
         * Deletes activities (by id) for a given dataset. Must be owner or editor of the dataset.
         * This action does not do audit tracking, but is administrative - it actually removes the 
         * records and this cannot be undone.
         */
        // POST /api/v1/activity/deletedatasetactivities
        [HttpPost]
        public HttpResponseMessage DeleteDatasetActivities(JObject jsonData)
        {
            var db = ServicesContext.Current;

            dynamic json = jsonData;

            Dataset dataset = db.Datasets.Find(json.DatasetId.ToObject<int>());

            Project project = db.Projects.Find(dataset.ProjectId);

            if (project == null)
                throw new Exception("DeleteDatasetActivities: Configuration error.");

            User me = AuthorizationManager.getCurrentUser();
            if (!project.isOwnerOrEditor(me))
                throw new Exception("DeleteDatasetActivities: Configuration error.");

            var Activities = new List<string>();

            foreach (var item in json.ActivityIds)
            {
                //make sure we can cast as an int otherwise it will throw an exception.
                int test_int = item.ToObject<int>();
                Activities.Add("" + test_int);

                //delete all the files for this activity
                logger.Debug("deleting all files for : " + test_int);
                Resources.ActivitiesFileHelper.DeleteAllFilesForActivity(GetDatasetActivityData(test_int), dataset);
            }

            var ActivityIds = string.Join(",", Activities);

            logger.Debug("Deleting the following activities: " + ActivityIds);

            var DataTable = dataset.Datastore.TablePrefix;


            //open a raw database connection...
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();

                var query = "DELETE FROM " + DataTable + "_Detail WHERE ActivityId in (" + ActivityIds + ")";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    logger.Debug(query);
                    cmd.ExecuteNonQuery();
                }

                query = "DELETE FROM " + DataTable + "_Header WHERE ActivityId in (" + ActivityIds + ")";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    logger.Debug(query);
                    cmd.ExecuteNonQuery();
                }

                query = "DELETE FROM ActivityQAs WHERE ActivityId in (" + ActivityIds + ")";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    logger.Debug(query);
                    cmd.ExecuteNonQuery();
                }

                query = "DELETE FROM Activities WHERE DatasetId = " + dataset.Id + " AND Id in (" + ActivityIds + ")";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    logger.Debug(query);
                    cmd.ExecuteNonQuery();
                }
            }
            

            return new HttpResponseMessage(HttpStatusCode.OK);

        }




        /**
         * Updates activities for a dataset.
         * json with: DatasetId, ProjectId, activities
         */
        // POST /api/v1/activity/updatedatasetactivities
        [HttpPost]
        public HttpResponseMessage UpdateDatasetActivities(JObject jsonData)
        {
            logger.Debug("Inside UpdateDatasetActivities...");
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

            //setup our generic data stuff
            var data_header_name = dataset.Datastore.TablePrefix + "_Header";
            var data_detail_name = dataset.Datastore.TablePrefix + "_Detail";
            var dbset_header = db.GetDbSet(data_header_name);
            var dbset_detail = db.GetDbSet(data_detail_name);
            var dbset_header_type = db.GetTypeFor(data_header_name);
            var dbset_detail_type = db.GetTypeFor(data_detail_name);

            //update the Activity with all of the incoming values
            dynamic activity_json = json.Activity;

            logger.Debug("Updating activity id: " + activity_json.Id);

            Activity activity = db.Activities.Find(activity_json.Id.ToObject<int>());
            if (activity == null)
            {
                throw new Exception("Invalid Activity.");
            }

            activity.LocationId = activity_json.LocationId;
            try
            {
                activity.ActivityDate = activity_json.ActivityDate;
            }
            catch (Exception e)
            {
                logger.Debug("Ooops had an error converting date: " + activity_json.ActivityDate);
                logger.Debug(e.ToString());
                throw (e);
            }

            //activity.DatasetId = json.DatasetId;
            activity.UserId = me.Id;
            activity.SourceId = activity_json.SourceId;
            activity.ActivityTypeId = activity_json.ActivityTypeId;
            activity.InstrumentId = activity_json.InstrumentId;
            activity.AccuracyCheckId = activity_json.AccuracyCheckId;
            activity.PostAccuracyCheckId = activity_json.PostAccuracyCheckId;
            activity.Timezone = activity_json.Timezone;

            db.Entry(activity).State = EntityState.Modified;
            db.SaveChanges();

            logger.Debug("Updated an activity: ");
            logger.Debug(" LocationID = " + activity_json.LocationId);
            logger.Debug(" ActivityDate = " + activity_json.ActivityDate);
            logger.Debug("  ID = " + activity.Id);

            //now check our activity status -- update it if we've changed.
            dynamic activityqastatus = activity_json.ActivityQAStatus;

            if (activity.ActivityQAStatus.QAStatusId != activityqastatus.QAStatusId.ToObject<int>() || activity.ActivityQAStatus.Comments != activityqastatus.Comments.ToString())
            {
                QAStatus new_qastatus = db.QAStatuses.Find(activityqastatus.QAStatusId.ToObject<int>());

                //logger.Debug(activity_json.ActivityQAStatus);
                //logger.Debug(activityqastatus.QAStatusId.ToObject<int>());

                ActivityQA newQA = new ActivityQA();
                newQA.ActivityId = activity.Id;
                newQA.QAStatusId = activityqastatus.QAStatusId.ToObject<int>();
                newQA.Comments = (activityqastatus.Comments != null) ? activityqastatus.Comments.ToString() : null;
                newQA.EffDt = DateTime.Now;
                newQA.UserId = activity.UserId;
                newQA.QAStatusName = new_qastatus.Name;
                newQA.QAStatusDescription = new_qastatus.Description;

                db.ActivityQAs.Add(newQA);
                db.SaveChanges();

            }



            //get our last header and then check against incoming header field values to see if anything has changed.
            var last_header_list = dbset_header.SqlQuery("SELECT * FROM " + data_header_name + " WHERE ActivityId = " + activity.Id + " ORDER BY EffDt DESC");
            //.SqlQuery("SELECT * FROM " + data_header_name + " WHERE ActivityId = " + activity.Id + " ORDER BY EffDt DESC").AsQueryable().f; 
            //db.AdultWeir_Header.Where(o => o.ActivityId == activity.Id).OrderByDescending(d => d.EffDt).FirstOrDefault();

            var last_header = LookupFieldHelper.getFirstItem(last_header_list);

            logger.Debug("Ok -- here we are with our lastheader:");
            logger.Debug(last_header);


            if (last_header == null)
                throw new Exception("Somehow there is no previous header even though we are trying to update.");

            bool header_updated = false;

            //spin through and check the header fields for changes...
            foreach (JProperty header_field in json.header)
            {
                logger.Debug("Checking last header value of field : '" + header_field.Name + "' with incoming value + '" + header_field.Value + "'");

                var headerobj = last_header.GetType().GetProperty(header_field.Name);

                if (headerobj == null)
                    continue;

                var objval = headerobj.GetValue(last_header, null);
                logger.Debug("Got the value from the header field.");

                if (objval != null)
                {
                    logger.Debug("objval not null. header_field.Name: " + header_field.Name + ", value: " + objval + ", with incoming value: " + header_field.Value);

                    if (objval.ToString() != header_field.Value.ToString())
                    {
                        logger.Debug("a different value! we'll save a header then...");
                        header_updated = true;
                        break;
                    }
                }
                else
                {
                    if (header_field.Value.ToString() != "")
                    {
                        logger.Debug("Dunno why, but objval was null." + header_field + " we are going to save a new one.");
                        header_updated = true;
                        break;
                    }
                    else
                        logger.Debug("objval is empty ''");
                }
            }

            if (header_updated)
            {
                logger.Debug("Saving a new header then");
                var header = json.header.ToObject(dbset_header_type);

                //now do the saving! -- this works the exact same way for update as it does for new
                header.ActivityId = activity.Id;
                header.ByUserId = activity.UserId;
                header.EffDt = DateTime.Now;
                dbset_header.Add(header);
                db.SaveChanges();
            }

            //there are three possible cases of changes:
            //  1) updated row (has ID and is in "editedRowIds" list)
            //  2) new row (has no ID)
            //  3) deleted row (is not in the list, ID is in "deletedRowIds" list)

            //we ALWAYS make such indication by INSERTING a new row with a matching rowid + activityid + new current effective date.
            //  exception is NEW row which gets and incremented rowid

            //first, lets lookup our last row id so we have a place to start if we add rows.                    
            int rowid = 1;

            var last_row_list = dbset_detail.SqlQuery("SELECT * FROM " + data_detail_name + " WHERE ActivityId = " + activity.Id + " AND RowStatusId = " + DataDetail.ROWSTATUS_ACTIVE + " ORDER BY RowId DESC");
            //db.AdultWeir_Detail.Where(o => o.ActivityId == activity.Id).Where(o => o.RowStatusId == DataDetail.ROWSTATUS_ACTIVE).OrderByDescending(d => d.RowId).FirstOrDefault();

            var last_row = LookupFieldHelper.getFirstItem(last_row_list);
            if (last_row != null)
            {
                rowid = last_row.RowId + 1;
            }
            else
                logger.Debug("Hmm there were no previous details rows for activity : " + activity.Id + " so we are starting at 1.");

            //now lets iterate our incoming rows and see what we've got.
            var details = new List<DataDetail>();

            List<int> updated_rows = new List<int>();
            foreach (var updated_row in json.editedRowIds)
            {
                logger.Debug("Found an updated row: " + updated_row);
                updated_rows.Add(updated_row.ToObject<int>());
            }

            List<int> deleted_rows = new List<int>();
            foreach (var deleted_row in json.deletedRowIds)
            {
                logger.Debug("Found a deleted row: " + deleted_row);
                deleted_rows.Add(deleted_row.ToObject<int>());
                if (updated_rows.Contains(deleted_row.ToObject<int>()))
                    updated_rows.Remove(deleted_row.ToObject<int>());
            }


            foreach (var detailitem in json.details)
            {
                var adw = detailitem.ToObject(dbset_detail_type);

                //logger.Debug("spinning through incoming details: " + adw.Id);

                if (adw.Id == 0)
                {
                    //new record
                    adw.RowId = rowid; rowid++;
                    details.Add(adw);
                }
                else
                {
                    //deleted or updated?
                    if (updated_rows.Contains(adw.Id))
                    {
                        //updated
                        adw.Id = 0;
                        details.Add(adw);
                    }
                    else if (deleted_rows.Contains(adw.Id))
                    {
                        //deleted
                        adw.Id = 0;
                        adw.RowStatusId = DataDetail.ROWSTATUS_DELETED;
                        details.Add(adw);

                        //delete any files associated with this detail item
                        Resources.ActivitiesFileHelper.DeleteAllFilesForDetail(adw, dataset);
                    }
                    //otherwise nothing.
                }

            }

            //logger.Debug(JsonConvert.SerializeObject(grids, Formatting.Indented));
            //logger.Debug(JsonConvert.SerializeObject(details, Formatting.Indented));

            foreach (var detail in details)
            {
                detail.ActivityId = activity.Id;
                detail.ByUserId = activity.UserId;
                detail.EffDt = DateTime.Now;

                dbset_detail.Add(detail);

            }

            db.SaveChanges();

            //If there is a ReadingDateTime field in use, set the activity description to be the range of reading dates for this activity.
            if (dataset.Datastore.TablePrefix == "WaterTemp") // others with readingdatetime?
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
                {
                    con.Open();
                    var query = "update Activities set Description = (select concat(convert(varchar,min(ReadingDateTime),111), ' - ', convert(varchar,max(ReadingDateTime),111)) from " + dataset.Datastore.TablePrefix + "_Detail_VW where ActivityId = " + activity.Id + ") where Id = " + activity.Id;

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        logger.Debug(query);
                        cmd.ExecuteNonQuery();
                    }

                }
            }
            
            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        
        /*
         * Saves activities for a dataset
         */ 

        // POST /api/v1/activity/savedatasetactivities
        [HttpPost]
        public HttpResponseMessage SaveDatasetActivities(JObject jsonData)
        {
            return SaveDatasetActivitiesEFF(jsonData);
        }

        //entity framework version of saving - this is slow but effective.
        private HttpResponseMessage SaveDatasetActivitiesEFF(JObject jsonData)
        {
            logger.Debug("Saving dataset activities: ");
            var db = ServicesContext.RestartCurrent;
            User me = AuthorizationManager.getCurrentUser();

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            //COPY PASTE -- TODO -- reduce code smell!
            Dataset dataset = db.Datasets.Find(json.DatasetId.ToObject<int>());
            if (dataset == null)
                throw new Exception("Configuration Error:  Could not find the DatasetID in the database.");

            Project project = db.Projects.Find(dataset.ProjectId);
            if (project == null)
                throw new Exception("Configuration Error:  Could not find the ProjectId in the database.");

            if (!project.isOwnerOrEditor(me))
                throw new Exception("Authorization Error:  The user attempting to make changes is not an Owner or Editor.");

            //setup our generic data stuff
            var data_header_name = dataset.Datastore.TablePrefix + "_Header";
            var data_detail_name = dataset.Datastore.TablePrefix + "_Detail";
            var dbset_header = db.GetDbSet(data_header_name);
            var dbset_detail = db.GetDbSet(data_detail_name);
            var dbset_header_type = db.GetTypeFor(data_header_name);
            var dbset_detail_type = db.GetTypeFor(data_detail_name);

            DateTime now;

            //var duplicateActivities = new List<Activity>();

            var new_records = new List<Activity>();

            db.Configuration.AutoDetectChangesEnabled = false;
            db.Configuration.ValidateOnSaveEnabled = false;

            int newActivityId = 0;
            
            dynamic activity_json = json.Activity;

            Activity activity = new Activity();
            activity.LocationId = activity_json.LocationId;

            try
            {
                activity.ActivityDate = activity_json.ActivityDate;
            }
            catch (Exception e)
            {
                logger.Debug("Ooops had an error converting activity date: " + activity_json.ActivityDate);
                logger.Debug(e.ToString());

                throw e;
            }

            try
            {
                activity.DatasetId = json.DatasetId;
                activity.UserId = me.Id;
                activity.SourceId = 1 ;  
                activity.ActivityTypeId = 1 ;
                activity.CreateDate = DateTime.Now;
                activity.InstrumentId = (activity_json.InstrumentId != null) ? activity_json.InstrumentId : null;
                activity.AccuracyCheckId = (activity_json.AccuracyCheckId != null) ? activity_json.AccuracyCheckId : null;
                activity.PostAccuracyCheckId = (activity_json.PostAccuracyCheckId != null) ? activity_json.PostAccuracyCheckId : null;
                activity.Timezone = (activity_json.Timezone != null) ? activity_json.Timezone : null;

                
                string strActivity = "activity.DatasetId = " + activity.DatasetId + "\n" +
                    "activity.UserId = " + activity.UserId + "\n" +
                    "activity.SourceId = " + activity.SourceId + "\n" +
                    "activity.ActivityTypeId = " + activity.ActivityTypeId + "\n" +
                    "activity.CreateDate = " + activity.CreateDate + "\n" +
                    "activity.InstrumentId = " + activity.InstrumentId + "\n" +
                    //"activity.LaboratoryId = " + activity.LaboratoryId + "\n" +
                    "activity.AccuracyCheckId = " + activity.AccuracyCheckId + "\n" +
                    "activity.PostAccuracyCheckId = " + activity.PostAccuracyCheckId + "\n" +
                    "activity.Timezone = " + activity.Timezone;

                logger.Debug("activity = " + activity);
                logger.Debug(strActivity);
                
                logger.Debug("and we have finished parameters (DataActionController).");
                /*
                //check for duplicates.  If it is a duplicate, add it to our list and bail out.
                if (activity.isDuplicate())
                {
                    duplicateActivities.Add(activity);
                }
                */

                db.Activities.Add(activity);
                now = DateTime.Now;
                logger.Debug("Added activity..." + now);
                db.SaveChanges();
                now = DateTime.Now;
                logger.Debug("Saved activity..." + now);

                dynamic activityqastatus = activity_json.ActivityQAStatus;

                newActivityId = activity.Id;

                //lookup the activityqastatus by id so we can use the name+description b/c they are no longer coming from the fe.
                QAStatus new_qastatus = db.QAStatuses.Find(activityqastatus.QAStatusId.ToObject<int>());

                ActivityQA newQA = new ActivityQA();
                newQA.ActivityId = activity.Id;
                newQA.QAStatusId = activityqastatus.QAStatusId.ToObject<int>();
                newQA.Comments = activityqastatus.Comments;
                newQA.EffDt = DateTime.Now;
                newQA.UserId = activity.UserId;
                newQA.QAStatusName = new_qastatus.Name;
                newQA.QAStatusDescription = new_qastatus.Description;

                db.ActivityQAs.Add(newQA);
                //now = DateTime.Now;
                //logger.Debug("Added ActivityQAs..." + now);
                db.SaveChanges();
                //now = DateTime.Now;
                //logger.Debug("Saved ActivityQAs..." + now);

                logger.Debug("Created a new activity: ");
                logger.Debug(" LocationID = " + activity_json.LocationId);
                logger.Debug(" ActivityDate = " + activity_json.ActivityDate);
                logger.Debug("  ID = " + activity.Id);

                var header = json.header.ToObject(dbset_header_type);
                //foreach (var hItem in activity_json.Header)
                //{
                //    logger.Debug("hItem = " + hItem);
                //}
                var details = new List<DataDetail>();

                foreach (var detailitem in json.details)
                {
                    //copy this json object into a EFF object // this is probably slow.
                    details.Add(detailitem.ToObject(dbset_detail_type));

                }

                //now do the saving!
                header.ActivityId = activity.Id;
                logger.Debug("header.ActivityId = " + header.ActivityId);

                header.ByUserId = activity.UserId;
                logger.Debug("header.ByUserId = " + header.ByUserId);

                header.EffDt = DateTime.Now;
                logger.Debug("header.EffDt = " + header.EffDt);

                dbset_header.Add(header);
                db.SaveChanges();
                now = DateTime.Now;
                logger.Debug("Added header..." + now);

                //details
                int rowid = 1;
                foreach (var detail in details)
                {
                    //logger.Debug("Got a detail...");
                    detail.RowId = rowid;
                    detail.RowStatusId = DataDetail.ROWSTATUS_ACTIVE;
                    detail.ActivityId = activity.Id;
                    detail.ByUserId = activity.UserId;
                    detail.EffDt = DateTime.Now;

                    dbset_detail.Add(detail);

                    rowid++;
                }
                if (details.Count > 0)
                {
                    now = DateTime.Now;
                    logger.Debug("Added details..." + now);
                }

                db.SaveChanges(); //save all details for this activity, then iterate to the next activity.
                now = DateTime.Now;
                logger.Debug("Saved records..." + now);
            }
            catch (Exception e)
            {
                logger.Debug(e);
                logger.Debug("An error occurred saving the activity or details: " + newActivityId);

                db = ServicesContext.RestartCurrent;
                db.Configuration.AutoDetectChangesEnabled = true;
                db.Configuration.ValidateOnSaveEnabled = true;

                //ok, lets try to delete the activity that went bad.
                db.Activities.Remove(db.Activities.Find(newActivityId));
                db.SaveChanges();

                logger.Debug("ok so we auto-deleted the activity we created: " + newActivityId);

                throw e; //rethrow so that it'll come back as an error in the client.
            }
            finally
            {
                db.Configuration.AutoDetectChangesEnabled = true;
                db.Configuration.ValidateOnSaveEnabled = true;
            }

            //If there is a ReadingDateTime field in use, set the activity description to be the range of reading dates for this activity.
            if (newActivityId != 0 && (dataset.Datastore.TablePrefix == "WaterTemp")) // others with readingdatetime?
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
                {
                    con.Open();
                    var query = "update Activities set Description = (select concat(convert(varchar,min(ReadingDateTime),111), ' - ', convert(varchar,max(ReadingDateTime),111)) from " + dataset.Datastore.TablePrefix + "_Detail_VW where ActivityId = " + newActivityId + ") where Id = " + newActivityId;

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        logger.Debug(query);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            else if (newActivityId != 0 && (dataset.Datastore.TablePrefix == "WaterQuality")) // others with readingdatetime?
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
                {
                    con.Open();
                    var query = "update Activities set Description = (select concat(convert(varchar,min(SampleDate),111), ' - ', convert(varchar,max(SampleDate),111)) from " + dataset.Datastore.TablePrefix + "_Detail_VW where ActivityId = " + newActivityId + ") where Id = " + newActivityId;

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        logger.Debug(query);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            else if (newActivityId != 0 && (dataset.Datastore.TablePrefix == "Genetic")) // others with SampleYear?
            {
                DataTable dt = new DataTable();
                //int minSampleYear = 0;
                //int maxSampleYear = 0;
                string strMinSampleYear = "";
                string strMaxSampleYear = "";
                string strSampleYearRange = "";

                string query = "";
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
                {
                    con.Open();

                    // *** Get the bottom of the SampleYear range.
                    query = "select min(SampleYear) from " + dataset.Datastore.TablePrefix + "_Detail_VW where ActivityId = " + newActivityId;
                    logger.Debug("query (min) = " + query);
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.SelectCommand.CommandTimeout = 120;
                        da.Fill(dt);
                        da.Dispose();
                        cmd.Dispose();
                    }
                    query = "";
                    logger.Debug("Filled dt...");
                    logger.Debug("dt.Rows.Count = " + dt.Rows.Count);

                    foreach (DataRow row in dt.Rows)
                    {
                        strMinSampleYear = row[0].ToString();
                    }
                    logger.Debug("strMinSampleYear = " + strMinSampleYear);
                    dt.Clear();


                    // *** Get the top of the SampleYear range.
                    query = "select max(SampleYear) from " + dataset.Datastore.TablePrefix + "_Detail_VW where ActivityId = " + newActivityId;
                    logger.Debug("query (max) = " + query);
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.SelectCommand.CommandTimeout = 120;
                        da.Fill(dt);
                        da.Dispose();
                        cmd.Dispose();
                    }
                    query = "";
                    logger.Debug("Filled dt again...");

                    foreach (DataRow row in dt.Rows)
                    {
                        strMaxSampleYear = row[0].ToString();
                    }
                    logger.Debug("strMaxSampleYear = " + strMaxSampleYear);
                    dt.Clear();

                    // Set the range
                    if (strMinSampleYear == strMaxSampleYear)
                    {
                        strSampleYearRange = strMinSampleYear;
                    }
                    else
                    {
                        strSampleYearRange = strMinSampleYear + " - " + strMaxSampleYear;
                    }
                    logger.Debug("strSampleYearRange = " + strSampleYearRange);

                    // Set the query with the range.
                    query = "update Activities set Description = '" + strSampleYearRange + "' where Id = " + newActivityId;
                    logger.Debug("query (to update Activities) = " + query);
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        logger.Debug(query);
                        cmd.ExecuteNonQuery();
                    }
                }
            }


            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        // POST /api/v1/activity/SaveDatasetActivitiesConnector
        [HttpPost]
        public HttpResponseMessage SaveDatasetActivitiesConnector(JObject jsonData)
        {
            return SaveDatasetActivitiesSQL(jsonData);
        }

        //sql version of saving - used for connectors inserting new activities
        private HttpResponseMessage SaveDatasetActivitiesSQL(JObject jsonData)
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();

            dynamic json = jsonData;

            Dataset dataset = db.Datasets.Find(json.DatasetId.ToObject<int>());

            if (dataset == null)
                throw new Exception("Configuration Error.");

            Project project = db.Projects.Find(dataset.ProjectId);
            if (!project.isOwnerOrEditor(me))
                throw new Exception("Authorization error.");

            var data_header_name = dataset.Datastore.TablePrefix + "_Header";
            var data_detail_name = dataset.Datastore.TablePrefix + "_Detail";

            //these will get loaded once and then stay the same every time.
            var query_header = "INSERT INTO " + data_header_name + " (";
            var query_detail = "INSERT INTO " + data_detail_name + " (";
            var headerFields = new List<string>();
            var detailFields = new List<string>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();

                foreach (var item in json.activities)
                {
                    int newActivityId = 0;

                    //each activity in its own transaction - maybe usually only one

                    var trans = con.BeginTransaction();
                    if (item is JProperty)
                    {
                        var prop = item as JProperty;
                        dynamic activity_json = prop.Value;

                        //mapping to our activity object verifies all of the types

                        Activity activity = new Activity();
                        activity.LocationId = activity_json.LocationId;
                        activity.ActivityDate = (activity_json.ActivityDate != null) ? activity_json.ActivityDate : DateTime.Now;
                        activity.DatasetId = json.DatasetId;
                        activity.UserId = me.Id;
                        activity.SourceId = (activity_json.SourceId != null) ? activity_json.SourceId : 3; //3=stream
                        activity.ActivityTypeId = 1;
                        activity.CreateDate = DateTime.Now;
                        activity.InstrumentId = (activity_json.InstrumentId != null) ? (activity_json.InstrumentId) : null;
                        activity.AccuracyCheckId = (activity_json.AccuracyCheckId != null) ? activity_json.AccuracyCheckId : null;
                        activity.PostAccuracyCheckId = (activity_json.PostAccuracyCheckId != null) ? activity_json.PostAccuracyCheckId : null;
                        activity.Timezone = (activity_json.Timezone != null) ? activity_json.Timezone.Replace("'", "''") : "";

                        var activity_query = "INSERT INTO Activities (LocationId, ActivityDate, DatasetId, UserId, SourceId, ActivityTypeId, CreateDate, ";

                        var activity_query_values =
                            activity.LocationId + ",'" +
                            activity.ActivityDate + "'," +
                            activity.DatasetId + "," +
                            activity.UserId + "," +
                            activity.SourceId + "," +
                            activity.ActivityTypeId + "," +
                            "'" + activity.CreateDate + "',";

                            if(activity.InstrumentId != null)
                            {
                                activity_query += "InstrumentId, ";
                                activity_query_values += activity.InstrumentId + ",";
                            }

                            if (activity.AccuracyCheckId != null)
                            {
                                activity_query += "AccuracyCheckId, ";
                                activity_query_values += activity.AccuracyCheckId + ",";
                            }

                            if (activity.PostAccuracyCheckId != null)
                            {
                                activity_query += "PostAccuracyCheckId, ";
                                activity_query_values += activity.PostAccuracyCheckId + ",";
                            }

                            activity_query += "Timezone) VALUES("; 
                            activity_query_values += "'" + activity.Timezone + "');";

                        activity_query += activity_query_values + "SELECT SCOPE_IDENTITY();";

                        logger.Debug(activity_query);
                        logger.Debug(activity_query_values);

                        using (SqlCommand cmd = new SqlCommand(activity_query, con, trans))
                        {
                            var result = cmd.ExecuteScalar();
                            //logger.Debug(result + result.GetType().ToString()); = System.Decimal?!
                            newActivityId = Convert.ToInt32(result.ToString());
                        }

                        //this element is optional. if not included, we'll default to "6" and "initial import"
                        dynamic activityqastatus = activity_json.ActivityQAStatus;

                        activity.Id = newActivityId;
                        logger.Debug("Hey!  we have a new activity id: " + activity.Id);

                        var newQA_query = "INSERT INTO ActivityQAs (ActivityId, QAStatusId, Comments, EffDt, UserId) VALUES (";

                        ActivityQA newQA = new ActivityQA();
                        newQA.ActivityId = newActivityId;
                        newQA.QAStatusId = (activityqastatus != null) ? activityqastatus.QAStatusID : 6; //6=readyforqa
                        newQA.Comments = (activityqastatus != null) ? activityqastatus.Comments.Replace("'", "''") : "Initial Import";
                        newQA.EffDt = DateTime.Now;
                        newQA.UserId = activity.UserId;

                        newQA_query += newQA.ActivityId + "," +
                            newQA.QAStatusId + "," +
                            "'" + newQA.Comments + "','" +
                            newQA.EffDt + "'," +
                            newQA.UserId + ");";

                        logger.Debug(newQA_query);

                        using (SqlCommand cmd = new SqlCommand(newQA_query, con, trans))
                        {
                            if (cmd.ExecuteNonQuery() == 0)
                            {
                                logger.Debug("Failed to execute query: " + newQA_query);
                                throw new Exception("Failed to execute qa query.  See log.");
                            }
                        }

                        //get these ready for a new set of values
                        var query_header_values = " VALUES (";
                        var query_detail_values = " VALUES (";
                        var headerValues = new List<string>();
                        var detailValues = new List<string>();

                        //have our headers been populated yet?  we only have to do it once.
                        if (headerFields.Count == 0)
                        {
                            //first the ones we always have
                            headerFields.Add("ActivityId");
                            headerFields.Add("ByUserId");
                            headerFields.Add("EffDt");

                            //now spin through and add any incoming ones from our JSON.
                            var the_header = activity_json.Header as JObject;
                            IList<string> propertyNames = the_header.Properties().Select(p => p.Name).ToList();
                            foreach (var prop_field in propertyNames)
                            {
                                headerFields.Add(prop_field);
                            }
                        }

                        headerValues.Add(activity.Id.ToString());
                        headerValues.Add(activity.UserId.ToString());
                        headerValues.Add("'" + DateTime.Now.ToString() + "'");

                        //now populate header values 
                        foreach (var prop_field in headerFields)
                        {
                            if (prop_field != "ActivityId" && prop_field != "ByUserId" && prop_field != "EffDt") //these are already done.
                            {
                                var control_type = dataset.Fields.Where(o => o.Field.DbColumnName == prop_field).Single().ControlType;
                                var objVal = activity_json.Header.GetValue(prop_field);
                                if (objVal == null)
                                    headerValues.Add("null");
                                else
                                {
                                    headerValues.Add(QueryHelper.getStringValueByControlType(control_type, objVal.ToString()));
                                }
                            }
                        }

                        var the_query = query_header + string.Join(",", headerFields) + ") " + query_header_values + string.Join(",", headerValues) + ")";
                        logger.Debug(the_query);
                        using (SqlCommand cmd = new SqlCommand(the_query, con, trans))
                        {
                            if (cmd.ExecuteNonQuery() == 0)
                            {
                                logger.Debug("Failed to execute query: " + the_query);
                                throw new Exception("Failed to execute header query.  See log.");
                            }
                        }

                        //---------------- now for the details...
                        int rowid = 1;
                        foreach (JObject detail in activity_json.Details)
                        {
                            //have our detail fields been populated yet?  we only have to do it once.
                            if (detailFields.Count == 0)
                            {
                                //first the ones we always have
                                detailFields.Add("ActivityId");
                                detailFields.Add("ByUserId");
                                detailFields.Add("EffDt");
                                detailFields.Add("RowStatusId");
                                detailFields.Add("RowId");
                                detailFields.Add("QAStatusId");

                                //now spin through and add any incoming ones from our JSON.
                                IList<string> propertyNames = detail.Properties().Select(p => p.Name).ToList();
                                foreach (var prop_field in propertyNames)
                                {
                                    DatasetField the_field = dataset.Fields.Where(o => o.Field.DbColumnName == prop_field && o.FieldRoleId == 2).SingleOrDefault();
                                    if (the_field != null)
                                        detailFields.Add(prop_field);
                                }
                            }

                            var QAStatusId = (detail.GetValue("QAStatusId") != null) ? detail.GetValue("QAStatusId") : "1"; //1=ok

                            detailValues.Add(activity.Id.ToString());
                            detailValues.Add(activity.UserId.ToString());
                            detailValues.Add("'" + DateTime.Now.ToString() + "'");
                            detailValues.Add(DataDetail.ROWSTATUS_ACTIVE.ToString());
                            detailValues.Add(rowid.ToString());
                            detailValues.Add(QAStatusId.ToString());

                            //now populate detail values 
                            foreach (var prop_field in detailFields)
                            {
                                if (prop_field != "QAStatusId" && prop_field != "ActivityId" && prop_field != "ByUserId" && prop_field != "EffDt" && prop_field != "RowId" && prop_field != "RowStatusId") //these are already done.
                                {
                                    var control_type = dataset.Fields.Where(o => o.Field.DbColumnName == prop_field).SingleOrDefault().ControlType;
                                    var objVal = detail.GetValue(prop_field);
                                    if (objVal == null)
                                        detailValues.Add("null");
                                    else
                                    {
                                        detailValues.Add(QueryHelper.getStringValueByControlType(control_type, objVal.ToString()));

                                    }
                                }
                            }
                            rowid++;
                            var the_detail_query = query_detail + string.Join(",", detailFields) + ") " + query_detail_values + string.Join(",", detailValues) + ")";
                            logger.Debug(the_detail_query);
                            using (SqlCommand cmd = new SqlCommand(the_detail_query, con, trans))
                            {
                                if (cmd.ExecuteNonQuery() == 0)
                                {
                                    logger.Debug("Problem executing: " + the_detail_query);
                                    throw new Exception("Failed to execute detail query!");
                                }
                            }
                            detailValues = new List<string>();
                        }//foreach detail

                        //If there is a ReadingDateTime field in use, set the activity description to be the range of reading dates for this activity.
                        if (newActivityId != 0 && dataset.Datastore.TablePrefix == "WaterTemp") // others with readingdatetime?
                        {
                            var query = "update Activities set Description = (select concat(convert(varchar,min(ReadingDateTime),111), ' - ', convert(varchar,max(ReadingDateTime),111)) from " + dataset.Datastore.TablePrefix + "_Detail_VW where ActivityId = " + newActivityId + ") where Id = " + newActivityId;

                            using (SqlCommand cmd = new SqlCommand(query, con, trans))
                            {
                                logger.Debug(query);
                                cmd.ExecuteNonQuery();
                            }
                        }


                    }//if is a jproperty

                    trans.Commit();

                }//foreach activity
            }//connection

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        // POST /api/v1/activity/savedatasetseason
        public HttpResponseMessage SaveDatasetSeason(JObject jsonData)
        {
            logger.Debug("Inside SaveDatasetSeason...");
            var db = ServicesContext.Current;
            logger.Debug("db = " + db);

            dynamic json = jsonData;
            logger.Debug("json = " + json);

            //string strJson = "[" + json + "]";

            User me = AuthorizationManager.getCurrentUser();
            logger.Debug("me = " + me);

            int pId = json.ProjectId.ToObject<int>();
            logger.Debug("pId = " + pId);

            Project p = db.Projects.Find(pId);
            logger.Debug("p = " + p);
            if (p == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("p.isOwnerOrEditor(me) = " + p.isOwnerOrEditor(me));
            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");

            logger.Debug("About to check incoming data for Season...");
            Seasons s = new Seasons();

            s.Id = json.Id.ToObject<int>();
            s.Species = json.Species.ToObject<string>();
            s.Season = json.Season.ToObject<int>();
            s.OpenDate = json.OpenDate.ToObject<DateTime>();
            s.CloseDate = json.CloseDate.ToObject<DateTime>();
            s.TotalDays = json.TotalDays.ToObject<int>();


            logger.Debug(
                "s.Id = " + s.Id + "\n" +
                "s.Species = " + s.Species + "\n" +
                "s.Season = " + s.Season + "\n" +
                "s.OpenDate = " + s.OpenDate + "\n" +
                "s.CloseDate = " + s.CloseDate + "\n" +
                "s.TotalDays = " + s.TotalDays + "\n"
                );

            if (s.Id == 0)
            {
                logger.Debug("About to add new season...");
                db.Seasons.Add(s);
                logger.Debug("created new season...");

                db.SaveChanges();
            }
            else
            {
                logger.Debug("About to update season...");
                db.Entry(s).State = EntityState.Modified;

                db.SaveChanges();
                logger.Debug("updated existing season...");

            }
            db.SaveChanges();

            int newId = s.Id;
            logger.Debug("newId = " + s.Id);

            //return new HttpResponseMessage(HttpStatusCode.OK);
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, s);
            return response;
        }


        // POST /api/v1/activity/HasExistingActivity
        // checks for existing activities with matching keys
        [HttpPost]
        public HttpResponseMessage HasExistingActivity(JObject jsonData)
        {
            var db = ServicesContext.Current;

            dynamic json = jsonData;
            logger.Debug("json = " + json);

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("HasExistingActivity running for DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + DatasetId);

            var data_header_name = dataset.Datastore.TablePrefix + "_Header_VW";

            var sql = "SELECT a.Id FROM " + data_header_name + " vw JOIN Activities a ON a.Id = vw.ActivityId WHERE 1=1";

            var conditions = QueryHelper.getQueryConditions(dataset.Fields, json.Fields);
            var criteria_string = string.Join(" AND ", conditions.ToArray());
            logger.Debug(criteria_string);
            sql = sql + " AND " + criteria_string;
            logger.Debug(sql);
            Int32? duplicate_id = 0;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(sql, con);
                duplicate_id = (Int32?)cmd.ExecuteScalar();

            }


            var result = new JObject(
                            new JProperty("DuplicateActivityId", duplicate_id),
                            new JProperty("query", criteria_string)
                        );


            return Request.CreateResponse(HttpStatusCode.OK, result);

        }

        //QuerySpecificActivities
        // POST /api/v1/activity/queryspecificactivities
        /*[HttpPost]
        public DataTable QuerySpecificActivities(JObject jsonData)
        {
            logger.Debug("Inside ActivityController.cs, QuerySpecificActivities...");
            var db = ServicesContext.Current;
            //DataTable datatable = null;
            DataTable datatable = new DataTable();

            dynamic json = jsonData;
            logger.Debug("json = " + json);

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + DatasetId);

            int LocationId = json.LocationId.ToObject<int>();
            logger.Debug("LocationId = " + LocationId);

            DateTime ActivityDate = json.ActivityDate.ToObject<DateTime>();
            string strActivityDate = ActivityDate.ToString("u");
            logger.Debug("strActivityDate = " + strActivityDate);

            int intSpaceLoc = strActivityDate.IndexOf(" ");
            logger.Debug("intSpaceLoc = " + intSpaceLoc);

            strActivityDate = strActivityDate.Substring(0, intSpaceLoc);
            strActivityDate += " 00:00:00.000";
            logger.Debug("strActivityDate (after stripping time) = " + strActivityDate);

            DateTime ActivityDate2 = ActivityDate.AddDays(1);
            string strActivityDate2 = ActivityDate2.ToString("u");
            strActivityDate2 = strActivityDate2.Substring(0, intSpaceLoc);
            strActivityDate2 += " 00:00:00.000";

            string query = "";
            query += "select Id from dbo.Activities where DatasetId = " + DatasetId;
            query += " AND LocationId = " + LocationId;
            query += " AND ActivityDate >= '" + strActivityDate + "'";
            query += " AND ActivityDate < '" + strActivityDate2 + "'";

            logger.Debug("query = " + query);

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                // Enable setting the command timeout.
                con.Open();
                logger.Debug("Opened connection...");

                SqlCommand cmd = new SqlCommand(query, con);
                logger.Debug("Created SQL commaned...");

                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                logger.Debug("Set cmd timeout...");

                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    logger.Debug("Created SqlDataAdapter...");

                    da.SelectCommand.CommandTimeout = 120; // 2 minutes in seconds
                    logger.Debug("Set da timeout...");

                    da.Fill(datatable);
                    logger.Debug("Filled SqlDataAdapter da...");
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return datatable;
        }
        */

        public DataTable QueryActivities(string strQuery)
        {
            logger.Debug("Inside ActivityController.cs, QueryActivities...");
            var db = ServicesContext.Current;
            //DataTable datatable = null;
            DataTable datatable = new DataTable();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                // Enable setting the command timeout.
                con.Open();
                logger.Debug("Opened connection...");

                SqlCommand cmd = new SqlCommand(strQuery, con);
                logger.Debug("Created SQL commaned...");

                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                logger.Debug("Set cmd timeout...");

                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    logger.Debug("Created SqlDataAdapter...");

                    da.SelectCommand.CommandTimeout = 120; // 2 minutes in seconds
                    logger.Debug("Set da timeout...");

                    da.Fill(datatable);
                    logger.Debug("Filled SqlDataAdapter da...");
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return datatable;
        }

        public DataTable QuerySpecificActivities(JObject jsonData)
        {
            logger.Debug("Inside ActivityController.cs, QuerySpecificActivities...");
            var db = ServicesContext.Current;
            //DataTable datatable = null;
            DataTable datatable = new DataTable();

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + DatasetId);

            logger.Debug("dataset.Name = " + dataset.Name);

            // This works for when one LocationId comes in by itself.
            // However, when several location Ids come in, as an arry, it does not work.
            //int LocationId = json.LocationId.ToObject<int>();
            //logger.Debug("LocationId = " + LocationId);

            // For an array, we handle it like this (one way anyway).
            //*** Location Ids ***
            string strActivityLocationIdList = "";

            JArray jaryLocationIdList = (JArray)json.LocationId;

            int count = 0;
            foreach (var item in jaryLocationIdList)
            {
                //logger.Debug("item = " + item);
                if (count == 0)
                    strActivityLocationIdList = item.ToString();
                else
                    strActivityLocationIdList += "," + item.ToString();
            }
            logger.Debug("strActivityLocationIdList = " + strActivityLocationIdList);

            //*** Activity Dates ***
            var dtList2 = new List<string>();
            string strActivityDateList = "";

            JArray jaryActivityDateList = (JArray)json.ActivityDate;

            count = 0;
            string strDtList = "";
            string strActivityDate = "";
            int intSpaceLoc = -1;
            int intYear = 0;
            int intMonth = 0;
            int intDay = 0;

            foreach (var dtItem in jaryActivityDateList)
            {
                strActivityDate = dtItem.ToString();
                intSpaceLoc = strActivityDate.IndexOf(" ");
                //logger.Debug("intSpaceLoc = " + intSpaceLoc);

                //strActivityDate = strActivityDate.Substring(0, intSpaceLoc);
                //strActivityDate += " 00:00:00.000";
                //logger.Debug("strActivityDate (after stripping time) = " + strActivityDate);

                intYear = Convert.ToInt32(strActivityDate.Substring(0, 4)); // Start here, how many
                intMonth = Convert.ToInt32(strActivityDate.Substring(6, 2));
                intDay = Convert.ToInt32(strActivityDate.Substring(9, 2));
                logger.Debug("intYear = " + intYear + ", intMonth = " + intMonth + ", intDay = " + intDay);

                DateTime dtActivityDate2 = new DateTime(intYear, intMonth, intDay);
                //logger.Debug("Created dtActivityDate2...");

                dtActivityDate2 = dtActivityDate2.AddDays(1);
                //logger.Debug("dtActivityDate2 = " + dtActivityDate2.ToString("u"));

                dtList2.Add("\'" + strActivityDate + "\'");
                //logger.Debug("Added dtActivityDate2 to dtList2...");

                if (count == 0)
                    strDtList += "'" + dtItem + "'";
                else
                    strDtList += "\'" + dtItem + "\'";
            }
            logger.Debug("strActivityDateList = " + strActivityDateList);

            string query = "";
            query += "select Id from dbo.Activities where DatasetId = " + DatasetId;
            //query += " AND LocationId = " + strActivityLocationIdList;
            //query += " AND ActivityDate >= '" + strActivityDate + "'";
            //query += " AND ActivityDate < '" + strActivityDate2 + "'";
            query += " AND LocationId in (" + string.Join(",", jaryLocationIdList) + ")";
            query += " AND ActivityDate in (" + string.Join(",", dtList2.ToArray()) + ")";

            logger.Debug("query = " + query);

            return QueryActivities(query);

            /*using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                // Enable setting the command timeout.
                con.Open();
                logger.Debug("Opened connection...");

                SqlCommand cmd = new SqlCommand(query, con);
                logger.Debug("Created SQL commaned...");

                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                logger.Debug("Set cmd timeout...");

                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    logger.Debug("Created SqlDataAdapter...");

                    da.SelectCommand.CommandTimeout = 120; // 2 minutes in seconds
                    logger.Debug("Set da timeout...");

                    da.Fill(datatable);
                    logger.Debug("Filled SqlDataAdapter da...");
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return datatable;
            */
        }

        // QuerySpecificActivitiesWithBounds
        // POST /api/v1/activity/queryspecificactivitieswithbounds
        [HttpPost]
        public DataTable QuerySpecificActivitiesWithBounds(JObject jsonData)
        {
            logger.Debug("Inside ActivityController.cs, QuerySpecificActivitiesWithBounds...");
            var db = ServicesContext.Current;
            //DataTable datatable = null;
            //DataTable datatable = new DataTable();

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + DatasetId);

            logger.Debug("dataset.Name = " + dataset.Name);

            // This works for when one LocationId comes in by itself.
            // However, when several location Ids come in, as an arry, it does not work.
            //int LocationId = json.LocationId.ToObject<int>();
            //logger.Debug("LocationId = " + LocationId);

            // For an array, we handle it like this (one way anyway).
            //*** Location Ids ***
            string strActivityLocationIdList = "";

            JArray jaryLocationIdList = (JArray)json.LocationId;

            int count = 0;
            foreach (var item in jaryLocationIdList)
            {
                //logger.Debug("item = " + item);
                if (count == 0)
                    strActivityLocationIdList = item.ToString();
                else
                    strActivityLocationIdList += "," + item.ToString();

                count++;
            }
            logger.Debug("strActivityLocationIdList = " + strActivityLocationIdList);

            //*** Activity Dates ***
            var dtList2 = new List<string>();
            //string strActivityDateList = "";

            JArray jaryActivityDateList = (JArray)json.ActivityDate;
            logger.Debug("jaryActivityDateList.Count = " + jaryActivityDateList.Count);

            count = 0;
            //string strDtList = "";
            string strActivityDate = "";
            int intSpaceLoc = -1;
            int intYear = 0;
            int intMonth = 0;
            int intDay = 0;

            List<DateTimeHelper> dtList = new List<DateTimeHelper>();

            foreach (var dtItem in jaryActivityDateList)
            {
                strActivityDate = dtItem.ToString();
                //logger.Debug("strActivityDate = " + strActivityDate);
                intSpaceLoc = strActivityDate.IndexOf(" ");
                //logger.Debug("intSpaceLoc = " + intSpaceLoc);

                //strActivityDate = strActivityDate.Substring(0, intSpaceLoc);
                //strActivityDate += " 00:00:00.000";
                //logger.Debug("strActivityDate (after stripping time) = " + strActivityDate);

                intYear = Convert.ToInt32(strActivityDate.Substring(0, 4)); // Start here, how many
                //logger.Debug("intYear = " + intYear);

                intMonth = Convert.ToInt32(strActivityDate.Substring(5, 2));
                //logger.Debug("intMonth = " + intMonth);

                intDay = Convert.ToInt32(strActivityDate.Substring(8, 2));
                //logger.Debug("intDay = " + intDay);

                DateTime dtActivityDate = new DateTime(intYear, intMonth, intDay);
                //logger.Debug("dtActivityDate = " + dtActivityDate.ToString("u"));
                //DateTime dtActivityDate2 = new DateTime(intYear, intMonth, intDay);
                //dtActivityDate2 = dtActivityDate2.AddDays(1);

                //dtList2.Add("\'" + strActivityDate + "\'");

                DateTimeHelper dtPair = new DateTimeHelper(dtActivityDate);
                //logger.Debug("Created dtPair...");

                dtList.Add(dtPair);
                //logger.Debug("Added dtPair to list...");

                //if (count == 0)
                //    strDtList += "\'" + dtItem + "'";
                //else
                //    strDtList += "\'" + dtItem + "\'";
            }
            //logger.Debug("strActivityDateList = " + strActivityDateList);

            //DateTime ActivityDate = json.ActivityDate.ToObject<DateTime>();
            //string strActivityDate = ActivityDate.ToString("u");
            //logger.Debug("strActivityDate = " + strActivityDate);

            //int intSpaceLoc = strActivityDate.IndexOf(" ");
            //logger.Debug("intSpaceLoc = " + intSpaceLoc);

            //strActivityDate = strActivityDate.Substring(0, intSpaceLoc);
            //strActivityDate += " 00:00:00.000";
            //logger.Debug("strActivityDate (after stripping time) = " + strActivityDate);

            //DateTime ActivityDate2 = ActivityDate.AddDays(1);
            //string strActivityDate2 = ActivityDate2.ToString("u");
            //strActivityDate2 = strActivityDate2.Substring(0, intSpaceLoc);
            //strActivityDate2 += " 00:00:00.000";

            string query = "";
            query += "select ActivityDate from dbo.Activities where DatasetId = " + DatasetId;
            //query += " AND LocationId = " + strActivityLocationIdList;
            //query += " AND ActivityDate >= '" + strActivityDate + "'";
            //query += " AND ActivityDate < '" + strActivityDate2 + "'";
            query += " AND LocationId in (" + string.Join(",", jaryLocationIdList) + ")";
            //query += " AND ActivityDate in (" + string.Join(",", dtList2.ToArray()) + ")";

            count = 0;
            string strDatePairList = "";
            foreach (var item in dtList)
            {
                //logger.Debug("item.strDateTime1 = " + item.strDateTime1 + ", item.strDateTime2 = " + item.strDateTime2);
                if (count == 0)
                {
                    strDatePairList = "(ActivityDate >= \'" + item.strDateTime1 + "\' AND ActivityDate < \'" + item.strDateTime2 + "\')";
                }
                else
                {
                    strDatePairList += " OR (ActivityDate >= \'" + item.strDateTime1 + "\' AND ActivityDate < \'" + item.strDateTime2 + "\')";
                }
                count++;
            }
            query += " AND (" + strDatePairList + ")";

            logger.Debug("query = " + query);

            return QueryActivities(query);

            /*using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                // Enable setting the command timeout.
                con.Open();
                logger.Debug("Opened connection...");

                SqlCommand cmd = new SqlCommand(query, con);
                logger.Debug("Created SQL commaned...");

                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                logger.Debug("Set cmd timeout...");

                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    logger.Debug("Created SqlDataAdapter...");

                    da.SelectCommand.CommandTimeout = 120; // 2 minutes in seconds
                    logger.Debug("Set da timeout...");

                    da.Fill(datatable);
                    logger.Debug("Filled SqlDataAdapter da...");
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            //foreach (DataRow dr in datatable.Rows)
            //{
            //    logger.Debug("dr = " + dr["ActivityDate"]);
            //}

            return datatable;
            */
        }

        //QuerySpecificWaterTempActivities
        // POST /api/v1/activity/queryspecificwatertempactivities
        [HttpPost]
        public DataTable QuerySpecificWaterTempActivities(JObject jsonData)
        {
            logger.Debug("Inside ActivityController.cs, QuerySpecificWaterTempActivities...");
            var db = ServicesContext.Current;
            //DataTable datatable = null;
            DataTable datatable = new DataTable();

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + DatasetId);

            logger.Debug("dataset.Name = " + dataset.Name);

            // This works for when one LocationId comes in by itself.
            // However, when several location Ids come in, as an arry, it does not work.
            //int LocationId = json.LocationId.ToObject<int>();
            //logger.Debug("LocationId = " + LocationId);

            // For an array, we handle it like this (one way anyway).
            //*** Location Ids ***
            string strActivityLocationIdList = "";

            JArray jaryLocationIdList = (JArray)json.LocationId;

            int count = 0;
            foreach (var item in jaryLocationIdList)
            {
                //logger.Debug("item = " + item);
                if (count == 0)
                    strActivityLocationIdList = item.ToString();
                else
                    strActivityLocationIdList += "," + item.ToString();
            }
            logger.Debug("strActivityLocationIdList = " + strActivityLocationIdList);


            //*** Instrument Ids Ids ***
            string strInstrumentIdList = "";

            JArray jaryInstrumentIdList = (JArray)json.InstrumentId;

            count = 0;
            foreach (var item in jaryInstrumentIdList)
            {
                //logger.Debug("item = " + item);
                if (count == 0)
                    strInstrumentIdList = item.ToString();
                else
                    strInstrumentIdList += "," + item.ToString();
            }
            logger.Debug("strInstrumentIdList = " + strInstrumentIdList);

            //*** ReadingDateTime ***
            string strReadingDateTimeList = "";

            JArray jaryReadingDateTimeList = (JArray)json.DateTimeList;

            count = 0;
            foreach (var item in jaryReadingDateTimeList)
            {
                //logger.Debug("item = " + item);
                if (count == 0)
                    strReadingDateTimeList = item.ToString();
                else
                    strReadingDateTimeList += "," + item.ToString();
            }
            logger.Debug("strReadingDateTimeList = " + strReadingDateTimeList);

            //var locList = strActivityLocationIdList.Split(',').ToList();
            //var locList2 = new List<int>();
            //logger.Debug("Created locLilst...");

            //foreach (var locItem in locList)
            //{
            //    locList2.Add(Convert.ToInt32(locItem));
            //}
            //logger.Debug("Loaded locList2...");

            //var instrumentList = strInstrumentIdList.Split(',').ToList();
            //var instrumentList2 = new List<int>();
            //logger.Debug("Created instrumentList2...");

            //foreach (var instrumentItem in instrumentList)
            //{
            //    instrumentList2.Add(Convert.ToInt32(instrumentItem));
            //}
            //logger.Debug("Loaded instrumentList2...");

            //var dtList_in = JArray.Parse(strReadingDateTimeList);
            //logger.Debug("dtList_in = " + dtList_in);

            //var dtList = strReadingDateTimeList.Split(',').ToList();
            //var dtList2 = new List<string>();
            //logger.Debug("Created dtList...");

            //foreach(var dtItem in dtList)
            //{
            //    dtList2.Add("\'" + dtItem + "\'");
            //}
            //logger.Debug("Loaded dtList2...");
            var dtList2 = new List<string>();


            /*string strDtList = "";
            int count = 0;
            foreach(var dtItem in dtList)
            {
                if (count == 0)
                    strDtList += "'" + dtItem + "'";
                else
                    strDtList += "\'" + dtItem + "\'";
            }
            logger.Debug("strDtList = " + strDtList);
            */
            string strDtList = "";
            foreach (var dtItem in jaryReadingDateTimeList)
            {
                dtList2.Add("\'" + dtItem.ToString() + "\'");

                if (count == 0)
                    strDtList += "'" + dtItem + "'";
                else
                    strDtList += "\'" + dtItem + "\'";
            }

            string query = "";
            query += "select ReadingDateTime from dbo.WaterTemp_VW where DatasetId = " + DatasetId;
            //query += " AND LocationId in (" + string.Join(",", locList2.ToArray()) + ")";
            //query += " AND InstrumentId in (" + string.Join(",", instrumentList2.ToArray()) + ")";
            //query += " AND ReadingDateTime in (" + string.Join(",", dtList2.ToArray()) + ")";
            query += " AND LocationId in (" + string.Join(",", jaryLocationIdList) + ")";
            query += " AND InstrumentId in (" + string.Join(",", jaryInstrumentIdList) + ")";
            query += " AND ReadingDateTime in (" + string.Join(",", dtList2.ToArray()) + ")";

            /*logger.Debug(json.RowQAStatusId);
            var rowqas = new List<string>();
            var rowqas_in = JArray.Parse(json.RowQAStatusId.ToObject<string>());
            foreach (var item in rowqas_in)
            {
                rowqas.Add(filterForSQL(item));
            }
            conditions.Add("QAStatusId IN (" + string.Join(",", rowqas.ToArray()) + ")");
            */

            logger.Debug("query = " + query);

            return QueryActivities(query);

            /*using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                // Enable setting the command timeout.
                con.Open();
                logger.Debug("Opened connection...");

                SqlCommand cmd = new SqlCommand(query, con);
                logger.Debug("Created SQL commaned...");

                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                logger.Debug("Set cmd timeout...");

                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    logger.Debug("Created SqlDataAdapter...");

                    da.SelectCommand.CommandTimeout = 120; // 2 minutes in seconds
                    logger.Debug("Set da timeout...");

                    da.Fill(datatable);
                    logger.Debug("Filled SqlDataAdapter da...");
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return datatable;
            */
        }

        //QuerySpecificCreelSurveyActivities
        // POST /api/v1/activity/queryspecificcreelsurveyactivities
        [HttpPost]
        public DataTable QuerySpecificCreelSurveyActivities(JObject jsonData)
        {
            logger.Debug("Inside ActivityController.cs, QuerySpecificCreelSurveyActivities...");
            var db = ServicesContext.Current;
            //DataTable datatable = null;
            DataTable datatable = new DataTable();

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + DatasetId);

            logger.Debug("dataset.Name = " + dataset.Name);

            // This works for when one LocationId comes in by itself.
            // However, when several location Ids come in, as an arry, it does not work.
            //int LocationId = json.LocationId.ToObject<int>();
            //logger.Debug("LocationId = " + LocationId);

            // For an array, we handle it like this (one way anyway).
            //*** Location Ids ***
            string strActivityLocationIdList = "";

            JArray jaryLocationIdList = (JArray)json.LocationId;

            int count = 0;
            foreach (var item in jaryLocationIdList)
            {
                //logger.Debug("item = " + item);
                if (count == 0)
                    strActivityLocationIdList = item.ToString();
                else
                    strActivityLocationIdList += "," + item.ToString();
            }
            logger.Debug("strActivityLocationIdList = " + strActivityLocationIdList);

            //*** Activity Dates ***
            var dtList2 = new List<string>();
            //string strActivityDateList = "";

            JArray jaryActivityDateList = (JArray)json.ActivityDate;

            count = 0;
            string strDtList = "";
            string strActivityDate = "";
            int intSpaceLoc = -1;
            int intYear = 0;
            int intMonth = 0;
            int intDay = 0;

            foreach (var dtItem in jaryActivityDateList)
            {
                strActivityDate = dtItem.ToString();
                intSpaceLoc = strActivityDate.IndexOf(" ");
                //logger.Debug("intSpaceLoc = " + intSpaceLoc);

                strActivityDate = strActivityDate.Substring(0, intSpaceLoc);
                //strActivityDate += " 00:00:00.000";
                logger.Debug("strActivityDate (after stripping time) =  x" + strActivityDate + "x");

                intYear = Convert.ToInt32(strActivityDate.Substring(0, 4)); // Start here, how many
                logger.Debug("intYear = " + intYear);
                //logger.Debug("strActivityDate.Substring(6, 2) = " + strActivityDate.Substring(6, 2));
                intMonth = Convert.ToInt32(strActivityDate.Substring(5, 2));
                //logger.Debug("intMonth = " + intMonth);
                intDay = Convert.ToInt32(strActivityDate.Substring(8, 2));
                //logger.Debug("intDay = " + intDay);
                logger.Debug("intYear = " + intYear + ", intMonth = " + intMonth + ", intDay = " + intDay);

                DateTime dtActivityDate2 = new DateTime(intYear, intMonth, intDay);
                //logger.Debug("Created dtActivityDate2...");

                dtActivityDate2 = dtActivityDate2.AddDays(1);
                //logger.Debug("dtActivityDate2 = " + dtActivityDate2.ToString("u"));

                dtList2.Add("\'" + strActivityDate + "\'");
                //logger.Debug("Added dtActivityDate2 to dtList2...");

                if (count == 0)
                    strDtList += "'" + dtItem + "'";
                else
                    strDtList += "\'" + dtItem + "\'";
            }
            logger.Debug("strDtList = " + strDtList);

            //*** Time Start ***
            string strTimeStart = json.TimeStart.ToObject<string>();
            /*string strTimeStartList = "";

            JArray jaryTimeStartList = (JArray)json.TimeStart;

            count = 0;
            foreach (var item in jaryTimeStartList)
            {
                //logger.Debug("item = " + item);
                if (count == 0)
                    strTimeStartList = item.ToString();
                else
                    strTimeStartList += "," + item.ToString();
            }
            logger.Debug("strTimeStartList = " + strTimeStartList);
            */
            logger.Debug("strTimeStart = " + strTimeStart);


            string query = "";
            query += "SELECT a.Id FROM dbo.Activities AS a ";
            query += "INNER JOIN dbo.CreelSurvey_Header_VW AS h on h.ActivityId = a.Id ";
            query += "where a.DatasetId = " + DatasetId;
            //query += " AND LocationId = " + strActivityLocationIdList;
            //query += " AND ActivityDate >= '" + strActivityDate + "'";
            //query += " AND ActivityDate < '" + strActivityDate2 + "'";
            query += " AND a.LocationId in (" + string.Join(",", jaryLocationIdList) + ")";
            query += " AND CONVERT(date, a.ActivityDate) in (" + string.Join(",", dtList2.ToArray()) + ")";
            query += " AND CONVERT(time, h.TimeStart) in ('" + strTimeStart + "')";

            logger.Debug("query = " + query);

            return QueryActivities(query);

            /*using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                // Enable setting the command timeout.
                con.Open();
                logger.Debug("Opened connection...");

                SqlCommand cmd = new SqlCommand(query, con);
                logger.Debug("Created SQL commaned...");

                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                logger.Debug("Set cmd timeout...");

                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    logger.Debug("Created SqlDataAdapter...");

                    da.SelectCommand.CommandTimeout = 120; // 2 minutes in seconds
                    logger.Debug("Set da timeout...");

                    da.Fill(datatable);
                    logger.Debug("Filled SqlDataAdapter da...");
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return datatable;
            */
        }

        //QuerySpecificScrewTrapActivities
        // POST /api/v1/activity/queryspecificscrewtrapactivities
        [HttpPost]
        public DataTable QuerySpecificScrewTrapActivities(JObject jsonData)
        {
            logger.Debug("Inside ActivityController.cs, QuerySpecificScrewTrapActivities...");
            var db = ServicesContext.Current;
            //DataTable datatable = null;
            DataTable datatable = new DataTable();
            bool blnArrivalTimePresent = false;

            dynamic json = jsonData;
            logger.Debug("json = " + json);

            int DatasetId = json.DatasetId.ToObject<int>();
            logger.Debug("DatasetId = " + DatasetId);
            var dataset = db.Datasets.Find(DatasetId);
            if (dataset == null)
                throw new System.Exception("Dataset could not be found: " + DatasetId);

            logger.Debug("dataset.Name = " + dataset.Name);

            // This works for when one LocationId comes in by itself.
            // However, when several location Ids come in, as an arry, it does not work.
            //int LocationId = json.LocationId.ToObject<int>();
            //logger.Debug("LocationId = " + LocationId);

            // For an array, we handle it like this (one way anyway).
            //*** Location Ids ***
            string strActivityLocationIdList = "";

            JArray jaryLocationIdList = (JArray)json.LocationId;

            int count = 0;
            foreach (var item in jaryLocationIdList)
            {
                //logger.Debug("item = " + item);
                if (count == 0)
                    strActivityLocationIdList = item.ToString();
                else
                    strActivityLocationIdList += "," + item.ToString();
            }
            logger.Debug("strActivityLocationIdList = " + strActivityLocationIdList);

            //*** Activity Dates ***
            var dtList2 = new List<string>();
            string strActivityDateList = "";

            JArray jaryActivityDateList = (JArray)json.ActivityDate;

            count = 0;
            string strDtList = "";
            string strActivityDate = "";
            int intSpaceLoc = -1;
            int intYear = 0;
            int intMonth = 0;
            int intDay = 0;

            foreach (var dtItem in jaryActivityDateList)
            {
                strActivityDate = dtItem.ToString();
                intSpaceLoc = strActivityDate.IndexOf(" ");
                //logger.Debug("intSpaceLoc = " + intSpaceLoc);

                strActivityDate = strActivityDate.Substring(0, intSpaceLoc);
                //strActivityDate += " 00:00:00.000";
                logger.Debug("strActivityDate (after stripping time) =  x" + strActivityDate + "x");

                intYear = Convert.ToInt32(strActivityDate.Substring(0, 4)); // Start here, how many
                logger.Debug("intYear = " + intYear);
                //logger.Debug("strActivityDate.Substring(6, 2) = " + strActivityDate.Substring(6, 2));
                intMonth = Convert.ToInt32(strActivityDate.Substring(5, 2));
                //logger.Debug("intMonth = " + intMonth);
                intDay = Convert.ToInt32(strActivityDate.Substring(8, 2));
                //logger.Debug("intDay = " + intDay);
                logger.Debug("intYear = " + intYear + ", intMonth = " + intMonth + ", intDay = " + intDay);

                DateTime dtActivityDate2 = new DateTime(intYear, intMonth, intDay);
                //logger.Debug("Created dtActivityDate2...");

                dtActivityDate2 = dtActivityDate2.AddDays(1);
                //logger.Debug("dtActivityDate2 = " + dtActivityDate2.ToString("u"));

                dtList2.Add("\'" + strActivityDate + "\'");
                //logger.Debug("Added dtActivityDate2 to dtList2...");

                if (count == 0)
                    strDtList += "'" + dtItem + "'";
                else
                    strDtList += "\'" + dtItem + "\'";
            }
            logger.Debug("strDtList = " + strDtList);


            string strCounty = (string)jsonData["Subproject"]["CountyAry"].ToString();
            logger.Debug("strCounty = " + strCounty);
            if ((!String.IsNullOrEmpty(strCounty)) || (strCounty.Length < 3)) // < 3 means "[]"
            { }

            //*** ArrivalTime ***
            string strArrivalTime = (string)jsonData["ArrivalTime"].ToString();

            if (!String.IsNullOrEmpty(strArrivalTime))
            {
                blnArrivalTimePresent = true;
                strArrivalTime = json.ArrivalTime.ToObject<string>();

                /*
                JArray jaryArrivalTimeList = (JArray)json.ArrivalTime;

                string strArrivalTimeList = "";
                count = 0;
                foreach (var item in jaryArrivalTimeList)
                {
                    //logger.Debug("item = " + item);
                    if (count == 0)
                        strArrivalTimeList = item.ToString();
                    else
                        strArrivalTimeList += "," + item.ToString();
                }
                logger.Debug("strArrivalTimeList = " + strArrivalTimeList);
                */
                logger.Debug("strArrivalTime = " + strArrivalTime);
            }

            string query = "";
            query += "SELECT a.Id FROM dbo.Activities AS a ";
            query += "INNER JOIN dbo.ScrewTrap_Header_VW AS h on h.ActivityId = a.Id ";
            query += "where a.DatasetId = " + DatasetId;
            //query += " AND LocationId = " + strActivityLocationIdList;
            //query += " AND ActivityDate >= '" + strActivityDate + "'";
            //query += " AND ActivityDate < '" + strActivityDate2 + "'";
            query += " AND a.LocationId in (" + string.Join(",", jaryLocationIdList) + ")";
            query += " AND CONVERT(date, a.ActivityDate) in (" + string.Join(",", dtList2.ToArray()) + ")";

            if (blnArrivalTimePresent)
                query += " AND CONVERT(time, h.ArrivalTime) in ('" + strArrivalTime + "')";

            logger.Debug("query = " + query);

            return QueryActivities(query);

            /*using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                // Enable setting the command timeout.
                con.Open();
                logger.Debug("Opened connection...");

                SqlCommand cmd = new SqlCommand(query, con);
                logger.Debug("Created SQL commaned...");

                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                logger.Debug("Set cmd timeout...");

                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    logger.Debug("Created SqlDataAdapter...");

                    da.SelectCommand.CommandTimeout = 120; // 2 minutes in seconds
                    logger.Debug("Set da timeout...");

                    da.Fill(datatable);
                    logger.Debug("Filled SqlDataAdapter da...");
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return datatable;
            */
        }

        private string BuildQueryString(int Id, string strTblPrefix)
        {
            string strQuery = "";

            if (strTblPrefix == "CreelSurvey")
            {
                strQuery = @"SELECT a.Id, a.LocationId, a.UserId, a.Description, 
                h.ByUserId, convert(varchar(19), h.TimeStart, 120) AS TimeStart,
                l.Label, l.LocationTypeId, l.SdeObjectId, l.WaterBodyId, l.OtherAgencyId, 
                l.GPSEasting, l.GPSNorthing, l.Projection, l.UTMZone, l.Latitude, l.Longitude, 
                w.Name as WaterBodyName,
                u.Fullname, 
                qa.QAStatusId, qa.UserId as QAStatusUserId, qa.QAStatusName
                FROM dbo.Activities AS a
                    JOIN dbo.ActivityQAs_VW AS qa ON a.Id = qa.ActivityId
					JOIN dbo.CreelSurvey_Header AS h on a.Id = h.ActivityId
                    JOIN dbo.Locations AS l ON a.LocationId = l.Id
                    LEFT JOIN dbo.WaterBodies AS w ON l.WaterBodyId = w.Id
                    JOIN dbo.Users AS u ON a.UserId = u.Id
                WHERE a.DatasetId = " + Id +
                "AND (h.EffDt = (SELECT MAX(EffDt) AS MaxEffDt " +
                "FROM dbo.CreelSurvey_Header AS hh WHERE(ActivityId = h.ActivityId)))";
            }
            else
            {
                strQuery = @"SELECT a.Id, a.LocationId, a.UserId, a.ActivityDate, a.Description, l.Label, l.LocationTypeId, l.SdeObjectId, l.WaterBodyId,
                l.OtherAgencyId, l.GPSEasting, l.GPSNorthing, l.Projection, l.UTMZone, l.Latitude, l.Longitude, w.Name as WaterBodyName,
                u.Fullname, qa.QAStatusId, qa.UserId as QAStatusUserId, qa.QAStatusName
                FROM dbo.Activities AS a
                    JOIN dbo.ActivityQAs_VW AS qa ON a.Id = qa.ActivityId
                    JOIN dbo.Locations AS l ON a.LocationId = l.Id
                    LEFT JOIN dbo.WaterBodies AS w ON l.WaterBodyId = w.Id
                    JOIN dbo.Users AS u ON a.UserId = u.Id
                WHERE a.DatasetId = " + Id;
            }

            return strQuery;
        }

        private JArray BuildJArray(DataTable activities, string strTblPrefix)
        {
            JArray datasetactivities = null;
            if (strTblPrefix == "CreelSurvey")
            {
                datasetactivities =
                    new JArray(                     //array of activities
                    from a in activities.AsEnumerable()
                    select new JObject              //one for each activity
                    (
                        new JProperty("Id", a["Id"]),
                        new JProperty("LocationId", a["LocationId"]),
                        new JProperty("UserId", a["UserId"]),
                        new JProperty("Description", a["Description"]),
                        //new JProperty("ActivityDate", a["ActivityDate"]),
                        new JProperty("Location",
                            new JObject(
                                new JProperty("Id", a["LocationId"]),
                                new JProperty("Label", a["Label"]),
                                new JProperty("OtherAgencyId", a["OtherAgencyId"]),
                                new JProperty("LocationTypeId", a["LocationTypeId"]),
                                new JProperty("SdeObjectId", a["SdeObjectId"]),
                                new JProperty("WaterBodyId", a["WaterBodyId"]),
                                new JProperty("GPSEasting", a["GPSEasting"]),
                                new JProperty("GPSNorthing", a["GPSNorthing"]),
                                new JProperty("Projection", a["Projection"]),
                                new JProperty("UTMZone", a["UTMZone"]),
                                new JProperty("Latitude", a["Latitude"]),
                                new JProperty("Longitude", a["Longitude"]),
                                new JProperty("WaterBody",
                                    new JObject(
                                        new JProperty("Id", a["WaterBodyId"]),
                                        new JProperty("Name", a["WaterBodyName"])))
                                )), //closes location
                        new JProperty("headerdata",
                            new JObject(
                                new JProperty("ByUserId", a["ByUserId"]),
                                new JProperty("TimeStart", a["TimeStart"]))),
                        new JProperty("User",
                            new JObject(
                                new JProperty("Id", a["UserId"]),
                                new JProperty("Fullname", a["Fullname"]))),
                        new JProperty("ActivityQAStatus",
                            new JObject(
                                new JProperty("QAStatusId", a["QAStatusId"]),
                                new JProperty("UserId", a["QAStatusUserId"]),
                                new JProperty("QAStatusName", a["QAStatusName"])
                                ))
                    )
                );
            }
            else
            {
                datasetactivities =
                    new JArray(                     //array of activities
                    from a in activities.AsEnumerable()
                    select new JObject              //one for each activity
                    (
                        new JProperty("Id", a["Id"]),
                        new JProperty("LocationId", a["LocationId"]),
                        new JProperty("UserId", a["UserId"]),
                        new JProperty("Description", a["Description"]),
                        new JProperty("ActivityDate", a["ActivityDate"]),
                        new JProperty("Location",
                            new JObject(
                                new JProperty("Id", a["LocationId"]),
                                new JProperty("Label", a["Label"]),
                                new JProperty("OtherAgencyId", a["OtherAgencyId"]),
                                new JProperty("LocationTypeId", a["LocationTypeId"]),
                                new JProperty("SdeObjectId", a["SdeObjectId"]),
                                new JProperty("WaterBodyId", a["WaterBodyId"]),
                                new JProperty("GPSEasting", a["GPSEasting"]),
                                new JProperty("GPSNorthing", a["GPSNorthing"]),
                                new JProperty("Projection", a["Projection"]),
                                new JProperty("UTMZone", a["UTMZone"]),
                                new JProperty("Latitude", a["Latitude"]),
                                new JProperty("Longitude", a["Longitude"]),
                                new JProperty("WaterBody",
                                    new JObject(
                                        new JProperty("Id", a["WaterBodyId"]),
                                        new JProperty("Name", a["WaterBodyName"])))
                                )), //closes location
                        new JProperty("User",
                            new JObject(
                                new JProperty("Id", a["UserId"]),
                                new JProperty("Fullname", a["Fullname"]))),
                        new JProperty("ActivityQAStatus",
                            new JObject(
                                new JProperty("QAStatusId", a["QAStatusId"]),
                                new JProperty("UserId", a["QAStatusUserId"]),
                                new JProperty("QAStatusName", a["QAStatusName"])
                                ))
                    )
                );
            }

            return datasetactivities;
        }
    }
}
