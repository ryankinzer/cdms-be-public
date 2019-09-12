using Newtonsoft.Json.Linq;
using NLog;
using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Linq;

namespace services.Resources
{
    public class DatasetDataDetailHelper
    {

        private static Logger logger = LogManager.GetCurrentClassLogger();

        private string targetTable;
        private List<string> detailFields;
        private List<DatasetField> detailDatasetFields = new List<DatasetField>();
        private int rowId;

        public DatasetDataDetailHelper(Dataset dataset, string table_prefix, JObject detail_row){
            targetTable = table_prefix + "_Detail";
            detailFields = new List<string> { "ActivityId", "ByUserId", "EffDt","RowStatusId","RowId","QAStatusId" };
            
            IList<string> propertyNames = detail_row.Properties().Select(p => p.Name).ToList();
            foreach (var prop_field in propertyNames)
            {
                if (detailFields.Contains(prop_field))
                    continue;

                DatasetField the_field = dataset.Fields.Where(o => o.Field.DbColumnName == prop_field && o.FieldRoleId == 2).SingleOrDefault();
                if (the_field != null)
                {
                    detailFields.Add(prop_field);
                    detailDatasetFields.Add(the_field);
                }
            }

            rowId = 1;

        }

        public void resetRowId(){
            rowId = 1;
        }

        //get an SQL query for inserting a header with these values.
        public string getInsertQuery(int activityId, int userId, JObject detail)
        {
            List<string> detailValues = new List<string>();

            var QAStatusId = (detail.GetValue("QAStatusId") != null) ? detail.GetValue("QAStatusId") : "1"; //1=ok

            detailValues.Add(activityId.ToString());
            detailValues.Add(userId.ToString());
            detailValues.Add("'" + DateTime.Now.ToString() + "'");
            detailValues.Add(DataDetail.ROWSTATUS_ACTIVE.ToString());
            detailValues.Add(rowId.ToString());
            detailValues.Add(QAStatusId.ToString());

            //now populate detail values 
            foreach (DatasetField prop_field in detailDatasetFields)
            {
                if (prop_field.DbColumnName != "QAStatusId" && prop_field.DbColumnName != "ActivityId" && prop_field.DbColumnName != "ByUserId" && prop_field.DbColumnName != "EffDt" && prop_field.DbColumnName != "RowId" && prop_field.DbColumnName != "RowStatusId") //these are already done.
                {                   
                    var objVal = detail.GetValue(prop_field.DbColumnName);

                    if (objVal == null || objVal.Type == JTokenType.Null)
                        detailValues.Add("null");
                    else
                        detailValues.Add(QueryHelper.getStringValueByControlType(prop_field.ControlType, objVal.ToString()));
                    
                }
            }
            rowId++;
            return "INSERT INTO " + targetTable + " (" + string.Join(",", detailFields) + ") VALUES ( " + string.Join(",", detailValues) + ")";

        }

    }
}