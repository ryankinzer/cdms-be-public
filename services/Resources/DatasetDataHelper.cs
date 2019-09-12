using services.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Resources
{
    public class DatasetDataHelper
    {

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

            var newQA_query = "INSERT INTO ActivityQAs (ActivityId, QAStatusId, Comments, EffDt, UserId) VALUES (";

            ActivityQA newQA = new ActivityQA();
            newQA.ActivityId = new_activityid;
            newQA.QAStatusId = (activityqastatus != null) ? activityqastatus.QAStatusId : 6; //6=readyforqa
            newQA.Comments = (activityqastatus != null && activityqastatus.Comments != null) ? activityqastatus.Comments : "";
            newQA.EffDt = DateTime.Now;
            newQA.UserId = user_id;

            newQA_query += newQA.ActivityId + "," +
                newQA.QAStatusId + "," +
                "'" + newQA.Comments + "','" +
                newQA.EffDt + "'," +
                newQA.UserId + ");";


            return newQA_query;
        }

    }
}