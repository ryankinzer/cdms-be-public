using Newtonsoft.Json.Linq;
using services.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace services.Resources
{    
    /**
    * Used for inserting new header rows into a dataset header table
    */
    public class DatasetDataHeaderHelper
    {
        private string targetTable;
        private JObject headerData;
        private List<string> headerFields;
        private List<DatasetField> headerDatasetFields = new List<DatasetField>();

        //constructor - called once with the header row to introspect the fields so we can generate SQL from it
        public DatasetDataHeaderHelper(Dataset dataset, string table_prefix, JObject header_data)
        {
            targetTable = table_prefix + "_Header";
            headerData = header_data;

            headerFields = new List<string> { "ActivityId", "ByUserId", "EffDt" };

            //now spin through and add any incoming header field names from our JSON.
            IList<string> propertyNames = headerData.Properties().Select(p => p.Name).ToList();
            foreach (var prop_field in propertyNames)
            {
                var dataset_field = dataset.Fields.Where(o => o.Field.DbColumnName == prop_field && o.FieldRoleId == 1).SingleOrDefault();
                if(dataset_field != null){
                    headerFields.Add(prop_field);
                    headerDatasetFields.Add(dataset_field);
                }
            }

        }

        //get an SQL query for inserting a header with these values.
        public string getInsertQuery(int activityId, int userId){

            var headerValues = new List<string>();

            headerValues.Add(activityId.ToString());
            headerValues.Add(userId.ToString());
            headerValues.Add("'" + DateTime.Now.ToString() + "'");

            //now populate header values 
            foreach (DatasetField prop_field in headerDatasetFields)
            {
                if (prop_field.DbColumnName != "ActivityId" && prop_field.DbColumnName != "ByUserId" && prop_field.DbColumnName != "EffDt") //these are already done.
                {
                    var objVal = headerData.GetValue(prop_field.DbColumnName);

                    if (objVal == null || objVal.Type == JTokenType.Null)
                        headerValues.Add("null");
                    else
                        headerValues.Add(QueryHelper.getStringValueByControlType(prop_field.ControlType, objVal.ToString()));
                }
            }

            return "INSERT INTO " + targetTable + " (" + string.Join(",", headerFields) + ") VALUES (" + string.Join(",", headerValues) + ")";

        }


        //bah! to update we insert... because of point-in-time effective dating
        public string getUpdateQuery(int activityId, int userId){

            var query = "UPDATE " + targetTable + " SET" + 
                " ActivityId = " + activityId.ToString() + 
                " ByUserId = " + userId.ToString() +
                " EffDt = '" + DateTime.Now.ToString() + "'";

            List<string> query_fields = new List<string>();

            foreach (DatasetField prop_field in headerDatasetFields)
            {
                if (prop_field.DbColumnName != "ActivityId" && prop_field.DbColumnName != "ByUserId" && prop_field.DbColumnName != "EffDt") //these are already done.
                {
                    var objVal = headerData.GetValue(prop_field.DbColumnName);

                    if (objVal == null || objVal.Type == JTokenType.Null)
                        objVal = "null";
                    else
                        objVal = QueryHelper.getStringValueByControlType(prop_field.ControlType, objVal.ToString());

                    query_fields.Add(" " + prop_field.DbColumnName + " = " + objVal);

                }
            }

            var header_id = ((dynamic)headerData).Id.ToObject<int>();

            return query + string.Join(",", query_fields) + " WHERE Id = " + header_id;

        }

    }
}