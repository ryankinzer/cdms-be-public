using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NLog;
using services.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace services.Resources
{
    public class QueryHelper
    {
        public static Logger logger = LogManager.GetCurrentClassLogger();
        public static List<string>ActivityFieldsToIgnore = new List<string>(){ "AccuracyCheckId", "PostAccuracyCheckId", "QAComments", "QAStatusId", "Timezone" };
        /*
         * Executes a query from the given criteria in our json object on the given dataset 
         * datafieldsource can be a dataset or a datastore
         * returns: DataTable of results
         */

        

        //dataset, json, "Query"
        public static DataTable getQueryResults(dynamic datafieldsource, dynamic json, string productTarget) // productTarget is set by the calling method.
        {
            logger.Debug("Inside getQueryResults...");
            logger.Debug("productTarget = " + productTarget);


            var conditions = getQueryConditions(datafieldsource.Fields, json.Fields);

            logger.Debug("Conditions == ");
            logger.Debug(conditions.ToString());

/*
            //DATE criteria
            if (json.DateSearchType == "singleYear")
            {
                if (json.TablePrefix == "ScrewTrap")
                    conditions.Add("MigrationYear = " + filterForSQL(json.MigrationYear));
                else if (json.TablePrefix == "AdultWeir")
                    conditions.Add("RunYear = " + filterForSQL(json.RunYear));
                else if (json.TablePrefix == "Metrics")
                    conditions.Add("YearReported = " + filterForSQL(json.ReportYear));
                else if (json.TablePrefix == "StreamNet_NOSA")
                    conditions.Add("SpawningYear = " + filterForSQL(json.SpawningYear));
                else if (json.TablePrefix == "StreamNet_RperS")
                    conditions.Add("BroodYear = '" + filterForSQL(json.BroodYear) + "'");
                else if (json.TablePrefix == "StreamNet_SAR")
                    conditions.Add("OutmigrationYear = " + filterForSQL(json.OutmigrationYear));
                else if (json.TablePrefix == "Benthic")
                    conditions.Add("SampleYear = " + filterForSQL(json.SampleYear));
                else if (json.TablePrefix == "Drift")
                    conditions.Add("SampleYear = " + filterForSQL(json.SampleYear));
            }
            else if (json.DateSearchType == "between")
            {
                if (json.TablePrefix == "WaterQuality")
                    conditions.Add("SampleDate BETWEEN CONVERT(Date, '" + filterForSQL(json.FromDate, true) + "') AND DATEADD(DAY,1,CONVERT(Date, '" + filterForSQL(json.ToDate, true) + "'))");
                else if (json.TablePrefix == "WaterTemp")
                    conditions.Add("ReadingDateTime BETWEEN CONVERT(Date, '" + filterForSQL(json.FromDate, true) + "') AND DATEADD(DAY,1,CONVERT(Date, '" + filterForSQL(json.ToDate, true) + "'))");
                else if (json.TablePrefix == "FishScales")
                    conditions.Add("ScaleCollectionDate BETWEEN CONVERT(Date, '" + filterForSQL(json.FromDate, true) + "') AND DATEADD(DAY,1,CONVERT(Date, '" + filterForSQL(json.ToDate, true) + "'))");
                //else if (json.TablePrefix == "StreamNet")
                //    conditions.Add("SpawningYear BETWEEN CONVERT(Date, '" + json.FromDate + "') AND DATEADD(DAY,1,CONVERT(Date, '" + json.ToDate + "'))");
                else
                    conditions.Add("ActivityDate BETWEEN CONVERT(Date, '" + filterForSQL(json.FromDate, true) + "') AND DATEADD(DAY,1,CONVERT(Date, '" + filterForSQL(json.ToDate, true) + "'))");
            }
*/


/*
            //LOCATION criteria
            if (json.Locations != "[\"all\"]")
            {
                logger.Debug("Locations = " + json.Locations);
                var locations = new List<string>();
                var locations_in = JArray.Parse(json.Locations.ToObject<string>());
                foreach (var item in locations_in)
                {
                    locations.Add(filterForSQL(item));
                }
                conditions.Add("LocationId IN (" + string.Join(",", locations.ToArray()) + ")");
            }

            //QASTATUS
            if (json.QAStatusId != "all")
            {
                conditions.Add("ActivityQAStatusId=" + filterForSQL(json.QAStatusId));
            }

            //ROWQASTATUS
            if (json.RowQAStatusId != null && json.RowQAStatusId != "[\"all\"]")
            {
                logger.Debug(json.RowQAStatusId);
                var rowqas = new List<string>();
                var rowqas_in = JArray.Parse(json.RowQAStatusId.ToObject<string>());
                foreach (var item in rowqas_in)
                {
                    rowqas.Add(filterForSQL(item));
                }
                conditions.Add("QAStatusId IN (" + string.Join(",", rowqas.ToArray()) + ")");
            }
*/

            /* old stuff

            var all_details = from d in db.AdultWeir_Detail
                              join a in db.Activities on d.ActivityId equals a.Id
                              where d.RowStatusId == DataDetail.ROWSTATUS_ACTIVE
                              join h2 in
                                (
                                    from hh in db.AdultWeir_Detail
                                    where hh.EffDt <= DateTime.Now
                                    group hh by new { hh.ActivityId, hh.RowId } into cig
                                    select new { ActivityId = cig.Key.ActivityId, RowId = cig.Key.RowId, EffDt = cig.Max(ed => ed.EffDt) }
                                ) on new { d.ActivityId, d.RowId, d.EffDt } equals new { h2.ActivityId, h2.RowId, h2.EffDt }
                            select d;

            var criteria_string = string.Join(" AND ", conditions.ToArray());
            logger.Debug(criteria_string);

            all_details = all_details.Where(criteria_string);

            return all_details;
             * */

            var datatable_prefix = "UNKNOWN";

            if (datafieldsource is Dataset)
                datatable_prefix = datafieldsource.Datastore.TablePrefix;
            else
                datatable_prefix = datafieldsource.TablePrefix;


/*
            //string query = "SET QUOTED_IDENTIFIER OFF; SELECT " + datafieldsource.getExportSelectString() + " from " + datatable_prefix + "_VW WHERE 1=1";
            string query = "";
            if ((datatable_prefix == "WaterTemp") ||
                (datatable_prefix == "WaterQuality"))
            {
                //query = "SET QUOTED_IDENTIFIER OFF; SELECT " + datafieldsource.getExportSelectString() + " from " + datatable_prefix + "_VW WITH (index(ix_ActivityId_EffDt)) WHERE 1=1";
                query = "SET QUOTED_IDENTIFIER OFF; SELECT " + datafieldsource.getExportSelectString(productTarget) + " from " + datatable_prefix + "_VW WITH (index(ix_ActivityId_EffDt)) WHERE 1=1";
            }
            else
            {
                //query = "SET QUOTED_IDENTIFIER OFF; SELECT " + datafieldsource.getExportSelectString() + " from " + datatable_prefix + "_VW WHERE 1=1";
                query = "SET QUOTED_IDENTIFIER OFF; SELECT " + datafieldsource.getExportSelectString(productTarget) + " from " + datatable_prefix + "_VW WHERE 1=1";
            }
*/



            string query = "SET QUOTED_IDENTIFIER OFF; SELECT * from " + datatable_prefix + "_VW WHERE 1=1";

            if (datafieldsource is Dataset)
                query += " AND DatasetId = " + datafieldsource.Id;

            var aryConditions = conditions.ToArray();

            //foreach(var item in aryConditions){
            //    logger.Debug("item = " + item.toString());
            //}

            var criteria_string = string.Join(" AND ", conditions.ToArray());

            if (criteria_string != "")
                query += " AND " + criteria_string;

            logger.Debug("final query = " + query);
            //query = "SET QUOTED_IDENTIFIER OFF; SELECT * from AdultWeir_VW WHERE DatasetId = 5 AND Species=\"CHS\"";


            //open a raw database connection...
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                // Original block
                /*using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }*/

                // New block, to enable setting the command timeout.
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                //try
                //{
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.SelectCommand.CommandTimeout = 120;
                    da.Fill(dt);
                //}
                //catch (SqlException e)
               // {
                 //   logger.Debug("Query sql command timed out..." + e.Message);
                 //   logger.Debug(e.InnerException);
                //}
            }

            return dt;
        }

        //filter an incoming parameter that will be appended to a SQL statement for
        // any possible misbehaving sql characters.
        public static string filterForSQL(dynamic value)
        {
            return filterForSQL(value, false); //default to not allowing spaces
        }

        //optionally allow spaces since date parameters require them.
        public static string filterForSQL(dynamic value, bool allowspace)
        {
            if (value == null) return "";

            value = value.ToString()
                        .Replace("'", "''")
                        .Replace(";", "")
                        .Replace("--", "")
                        .Replace("@", "")
                        .Replace("\"", "")
                        .Replace("[", "")
                        .Replace("]", "");

            //replace " " with "" unless allowspace=true
            if (!allowspace)
            {
                value = value.Replace(" ", "");
            }

            return value;

        }

        //returns string value for SQL based on the field type.
        public static string getStringValueByControlType(string control_type, string in_val)
        {
            string retval = null;

            switch (control_type)
            {
                case "text":
                case "textarea":
                case "multiselect":
                case "select":
                case "date":
                case "datetime":
                    retval = "'" + in_val.Replace("'", "''") + "'";
                    break;
                default:
                    retval = in_val;
                    break;
            }

            return retval;
        }

        //returns an SQL query with conditions for each of the fields in jsonFields
        // list = getQueryConditions(dataset.Fields, json.Fields) where json.Fields is { DbColumnName: "FieldName", Value: "Value" }
        // then you might say: var criteria_string = string.Join(" AND ", conditions.ToArray());
        public static List<string> getQueryConditions(IEnumerable<DatasetField> fields, dynamic jsonFields)
        {
            logger.Debug("Inside QueryHelper, getQueryConditions...");
            //logger.Debug(json.Fields);
            //logger.Debug(json.Fields.ToString());
            logger.Debug("jsonFields = " + jsonFields);

            var conditions = new List<string>();

            //fields in the criteria
            foreach (var item in jsonFields)
            {
                logger.Debug(item);
                logger.Debug("Colname!: " + item.DbColumnName);

                //spin through each of our dataset/datastore fields and find a match, adding it to our criteria...
                foreach (var field in fields)
                {

                    //if (field.DbColumnName != item.DbColumnName.ToString()) // this is probably necessary? kb10/22/18 && field.Id != item.Id.ToObject<int>())
                    if (field.DbColumnName != item.DbColumnName.ToString())
                        continue;

                    if (item.Value == null)
                        continue;

                    logger.Debug("Have a field: " + field.DbColumnName);

                    //if (field == null)
                    //    throw new Exception("Field not configured properly: " + item.Value);

                    string ControlType = field.ControlType.ToString(); //hmm, can't use directly in a switch.
                    logger.Debug("ControlType = " + ControlType);

                    var conditional = " = ";
                    var value = "";

                    //now add field criteria to our list...
                    switch (ControlType)
                    {
                        case "number":
                            value = filterForSQL(item.Value);
                            if (value.ToString().Contains(">") || value.ToString().Contains("<"))
                                conditional = "";
                            logger.Debug("A number");
                            conditions.Add(field.DbColumnName + conditional + value); //>100
                            break;
                        case "currency":
                        case "time":
                        case "easting":
                        case "northing":
                            logger.Debug("A currency, time, northing, or easting");
                            conditions.Add(field.DbColumnName + "=" + filterForSQL(item.Value)); //>100
                            break;
                        case "instrument-select": 
                        case "location-select":
                        case "fisherman-select":
                            logger.Debug("a location, instrument, or fisherman");
                            value = filterForSQL(item.Value);
                            if (value.ToString().Contains(","))
                                conditional = " in ";
                            //conditions.Add(field.DbColumnName + conditional + "(" + filterForSQL(item.Value) +")"); //>100
                            conditions.Add(field.DbColumnName + conditional + "(" + value + ")"); //>100
                            break;

                        case "text":
                        case "textarea":
                        case "activity-text":
                            logger.Debug("A txt");
                            if (item.Value.ToString().Contains("%"))
                                conditional = " LIKE ";

                            conditions.Add(field.DbColumnName + conditional + "'" + filterForSQL(item.Value, true) + "'");
                            break;

                        case "multiselect":
                            logger.Debug("A MULTIselect:" + item.Value);
                            if (item.Value == null)
                                break;

                            //dynamic mselect_val = item.Value; //array
                            var mselect_val = JArray.Parse(item.Value.ToObject<string>());

                            logger.Debug(mselect_val);

                            //iterate and construct strings.
                            List<string> ms_condition = new List<string>();

                            foreach (var ms_item in mselect_val)
                            {
                                ms_condition.Add(field.DbColumnName + " = '" + filterForSQL(ms_item) + "'"); 
                            }
                            //conditions.Add(field.DbColumnName + " in('" + string.Join("','", mselect_val) + "')");

                            conditions.Add("(" + string.Join(" OR ", ms_condition) + ")");

                            break;
                        case "select":
                            logger.Debug("A select:" + item.Value);
                            if (item.Value == null)
                                break;

                            //dynamic select_val = JsonConvert.DeserializeObject<string>(item.Value);
                            logger.Debug(item.Value);

                            //conditions.Add(field.DbColumnName + " in('" + string.Join("','", select_val) + "')");
                            conditions.Add(field.DbColumnName + " = '" + item.Value + "'");
                            break;
                        case "date":
                        case "datetime":
                            logger.Debug("A date!: ");
                            if (item.Value.ParamFieldDateType == "between") //otherwise, do nothing with this criteria
                            {
                                conditions.Add(field.DbColumnName + " between '" + filterForSQL(item.Value.BetweenFromFieldDate, true) + "' and '" + filterForSQL(item.Value.BetweenToFieldDate, true) + "'");
                            }
                            break;
                        case "activity-date": 
                            conditions.Add("CONVERT(date,'" + filterForSQL(item.Value, true) + "') = CONVERT(date,ActivityDate)");
                            break;
                    }
                }

            }

            return conditions;
        }

    }
}