using NLog;
using services.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace services.Resources
{
    public class DatasetDataHelper
    {

        private static Logger logger = LogManager.GetCurrentClassLogger();

        public static string getHeaderQuery(string tableName)
        {
            return @"SELECT * FROM " + tableName + @"_Header as h 
              WHERE(h.EffDt =
                (SELECT        MAX(hh.EffDt) AS MaxEffDt
                               FROM            " + tableName + @"_Header AS hh
                               WHERE(hh.ActivityId = h.ActivityId)))";
        }

        public static string getDetailQuery(string tableName)
        {
            return @"SELECT * FROM " + tableName + @"_Detail as d 
              WHERE(d.EffDt =
                (SELECT        MAX(dd.EffDt) AS MaxEffDt
                               FROM            " + tableName + @"_Detail AS dd
                               WHERE        (dd.ActivityId = d.ActivityId) AND (dd.RowId = d.RowId))) AND (d.RowStatusId = 0)";
        }

        public static string getMaxRowIdSQL(string tableName, int activityId){
            return "select max(RowId) from " + tableName + "_Detail where ActivityId = " + activityId + " and RowStatusId = 0 ";
        }

        // creates a sql insert statement from a json object representing an activity
        public static string getInsertActivitySQL(Dataset dataset, dynamic activity_json, int user_id){

            //mapping to our activity object verifies all of the types

            Activity activity = new Activity();
            activity.LocationId = activity_json.LocationId;
            activity.ActivityDate = (activity_json.ActivityDate != null) ? activity_json.ActivityDate : DateTime.Now;
            activity.DatasetId = dataset.Id;
            activity.UserId = user_id;
            activity.SourceId = (activity_json.SourceId != null) ? activity_json.SourceId : 3; //3=stream
            activity.ActivityTypeId = 1;
            activity.CreateDate = DateTime.Now;
            activity.InstrumentId = (activity_json.InstrumentId != null) ? (activity_json.InstrumentId) : null;
            activity.AccuracyCheckId = (activity_json.AccuracyCheckId != null) ? activity_json.AccuracyCheckId : null;
            activity.PostAccuracyCheckId = (activity_json.PostAccuracyCheckId != null) ? activity_json.PostAccuracyCheckId : null;
            activity.Timezone = (activity_json.Timezone != null) ? activity_json.Timezone : "";

            var activity_query = "INSERT INTO Activities (LocationId, ActivityDate, DatasetId, UserId, SourceId, ActivityTypeId, CreateDate, ";

            var activity_query_values =
                activity.LocationId + ",'" +
                activity.ActivityDate + "'," +
                activity.DatasetId + "," +
                activity.UserId + "," +
                activity.SourceId + "," +
                activity.ActivityTypeId + "," +
                "'" + activity.CreateDate + "',";

            if (activity.InstrumentId != null)
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

            return activity_query;

        }


        public static string getInsertActivityQASQL(int new_activityid, dynamic activity_json, int user_id )
        {
            //this element is optional. if not included, we'll default to "6" and "initial import"
            dynamic activityqastatus = activity_json.ActivityQAStatus;

            var newQA_query = "INSERT INTO ActivityQAs (ActivityId, QAStatusId, QAComments, EffDt, UserId) VALUES (";

            ActivityQA newQA = new ActivityQA();
            newQA.ActivityId = new_activityid;
            newQA.QAStatusId = (activityqastatus != null) ? activityqastatus.QAStatusId : 6; //6=readyforqa
            newQA.QAComments = (activityqastatus != null && activityqastatus.QAComments != null) ? activityqastatus.QAComments : "";
            newQA.EffDt = DateTime.Now;
            newQA.UserId = user_id;

            newQA_query += newQA.ActivityId + "," +
                newQA.QAStatusId + "," +
                "'" + newQA.QAComments + "','" +
                newQA.EffDt + "'," +
                newQA.UserId + ");";


            return newQA_query;
        }


        //update an activity + activityQA with an incoming activity json
        public static Activity updateActivity(dynamic activity_json, User me){

            logger.Debug("Updating activity id: " + activity_json.Id);

            var db = ServicesContext.Current;

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

            if (activity.ActivityQAStatus.QAStatusId != activityqastatus.QAStatusId.ToObject<int>() || activity.ActivityQAStatus.QAComments != activityqastatus.QAComments.ToString())
            {
                QAStatus new_qastatus = db.QAStatuses.Find(activityqastatus.QAStatusId.ToObject<int>());

                //logger.Debug(activity_json.ActivityQAStatus);
                //logger.Debug(activityqastatus.QAStatusId.ToObject<int>());

                ActivityQA newQA = new ActivityQA();
                newQA.ActivityId = activity.Id;
                newQA.QAStatusId = activityqastatus.QAStatusId.ToObject<int>();
                newQA.QAComments = (activityqastatus.QAComments != null) ? activityqastatus.QAComments.ToString() : null;
                newQA.EffDt = DateTime.Now;
                newQA.UserId = activity.UserId;
                newQA.QAStatusName = new_qastatus.Name;
                newQA.QAStatusDescription = new_qastatus.Description;

                db.ActivityQAs.Add(newQA);
                db.SaveChanges();

            }

            return activity;

        }

        //our special case sql that needs to run after inserting a new detail
        public static string getPostDetailInsertQuerySQL(string tableName, int newActivityId) {
            var query = "";

            if (tableName == "WaterTemp")
                query = "update Activities set Description = (select concat(convert(varchar,min(ReadingDateTime),111), ' - ', convert(varchar,max(ReadingDateTime),111)) from " + tableName + "_Detail_VW where ActivityId = " + newActivityId + ") where Id = " + newActivityId;
            else if (tableName == "WaterQuality" || tableName == "MetStation")
                query = "update Activities set Description = (select concat(convert(varchar,min(SampleDate),111), ' - ', convert(varchar,max(SampleDate),111)) from " + tableName + "_Detail_VW where ActivityId = " + newActivityId + ") where Id = " + newActivityId;
            else if (tableName == "Genetic")
                query = @"update Activities set Description = (
                                        select 
	                                        case
		                                        when MinSampleYear = MaxSampleYear then MinSampleYear
		                                        else MinSampleYear + '-' + MaxSampleYear
	                                        end as SampleYearRange
                                        from
	                                        (select 
		                                        convert(varchar,min(SampleYear),111) as MinSampleYear, 
		                                        convert(varchar,max(SampleYear),111) as MaxSampleYear
	                                        from "+ tableName + @"_Detail_VW 
	                                        where ActivityId = " + newActivityId + @") a
                                    ) where Id = " + newActivityId;

            return query;
        }

    }
}