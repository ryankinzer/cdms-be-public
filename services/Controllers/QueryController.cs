using Newtonsoft.Json.Linq;
using services.Models;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace services.Controllers
{
    public class QueryController : CDMSController
    {
        //QUERY
        //QueryDatasetActivities -- can call with a datasetId or a datastoreId
        // POST /api/v1/query/querydatasetactivities
        [HttpPost]
        public DataTable QueryDatasetActivities(JObject jsonData)
        {
            logger.Debug("Inside QueryController, QueryDatasetActivities...");
            var db = ServicesContext.Current;
            DataTable datatable = null;

            dynamic json = jsonData;
            logger.Debug("json = " + json);

            //let's see if we're dealing with a dataset 
            if (json["DatasetId"] is JToken)
            {
                //grab a reference to this dataset so we can parse incoming fields
                Dataset dataset = db.Datasets.Find(json.DatasetId.ToObject<int>());
                if (dataset == null)
                    throw new Exception("Configuration error. Please try again.");

                logger.Debug("Alright!  we are working with dataset: " + dataset.Id);

                //datatable = getQueryResults(dataset, json);
                datatable = QueryHelper.getQueryResults(dataset, json, "Query");

            }


            //let's see if we're dealing with a datastore.
            if (json["DatastoreId"] is JToken)
            {
                //grab a reference to this dataset so we can parse incoming fields
                Datastore datastore = db.Datastores.Find(json.DatastoreId.ToObject<int>());
                if (datastore == null)
                    throw new Exception("Configuration error. Please try again.");

                logger.Debug("Alright!  we are working with datastore: " + datastore.Id);

                datatable = QueryHelper.getQueryResults(datastore, json, "Query");

            }


            return datatable;

        }
    }
}
