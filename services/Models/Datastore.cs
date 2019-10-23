using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using NLog;

namespace services.Models
{
    public class Datastore
    {

        //represents the "big bucket" 
        
            public int Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public string TablePrefix { get; set; }
            public string LocationTypeId { get; set; } 
            public string DefaultConfig { get; set; }
            public int OwnerUserId { get; set; }
            public string TableType { get; set; }

            private static Logger logger = LogManager.GetCurrentClassLogger();

            // returns all of the locations that are related to any project that uses a dataset with this datastore.
            [NotMapped]
            [JsonIgnore]
            public IEnumerable<Location> Locations
            {
                get
                {
                    logger.Debug("Inside Datastore.Locations...");
                    var db = ServicesContext.Current;

                    //return db.Location.SqlQuery("select distinct ll.* from Locations ll join LocationProjects lp on lp.Location_Id = ll.Id join Projects p on p.Id = lp.Project_Id join Datasets d on d.ProjectId = p.Id where d.DatastoreId = " +
                    //    this.Id + " and ll.LocationTypeId = "+LocationType.DATA_TYPE + " order by ll.Label");
                    logger.Debug("this.Id = " + this.Id);

                    List<Location> locations = db.Location.SqlQuery("select distinct ll.* " + 
                                                "from Locations ll " +
                                                "join LocationProjects lp on lp.Location_Id = ll.Id " +
                                                "join Projects p on p.Id = lp.Project_Id " + 
                                                "join Datasets d on d.ProjectId = p.Id " + 
                                                "where d.ProjectId = " + this.Id + 
                                                " and ll.LocationTypeId = " + LocationType.DATA_TYPE + 
                                                " order by ll.Label").ToList();

                    if (locations.Count == 0)
                        return null;
                    else
                        return locations.AsEnumerable();

                }
            }

            // returns all of the fields that are related to any dataset with this datastore
            [NotMapped]
            [JsonIgnore]
            public IEnumerable<Field> Fields
            {
                get
                {
                    var db = ServicesContext.Current;

                    return db.Fields.SqlQuery("select * from Fields where d.DatastoreId =" +
                        this.Id + " ORDER BY ff.Name ASC");
                }
            }


            // returns all of the projects that are related to any dataset with this datastore
            [NotMapped]
            [JsonIgnore]
            public IEnumerable<Project> Projects
            {
                get
                {
                    var db = ServicesContext.Current;

                    return db.Projects.SqlQuery("select p.* from Projects p join Datasets d on d.ProjectId = p.Id where d.DatastoreId = " +
                        this.Id);
                }
            }

            // returns all of the datasets that are related to this datastore
            [NotMapped]
            [JsonIgnore]
            public IEnumerable<Dataset> Datasets
            {
                get
                {
                    var db = ServicesContext.Current;

                    return db.Datasets.SqlQuery("select d.* from Datasets d where d.DatastoreId = " +
                        this.Id);
                }
            }
            
            //Dataset has its own version of these specific to DatasetFields, ours is for global Fields
            internal string getExportSelectString()
            {
                var fields = string.Join(",", Fields.OrderBy(o => o.DbColumnName).Select(o => o.DbColumnName));
                
                //add on any "system" fields we want to also return
                var activity_fields = "ActivityDate, (select Label from Locations where Id = LocationId) as Location,";
                var system_fields = "(select Fullname from [Users] where Id = Activity_UserId) as ActivityUser,CreateDate,QAStatusName, ActivityQAComments, (select Fullname from [Users] where Id = ActivityQAUserId) as QAUser,(select Name from Sources where Id = SourceId) as Source,LocationId,ActivityQAStatusId,DatasetId,ActivityId";

                return activity_fields + fields + "," + system_fields;
            }

            internal IEnumerable<string> getExportLabelsList()
            {
                IEnumerable<string> labels = null;
                try
                {
                    labels = new string[] { "ActivityDate", "Location" };

                    labels = labels
                      .Concat(this.Fields.OrderBy(o => o.Name).Select(o => o.Name + " " + o.Units))
                      .Concat(new List<string>(new string[] { "ActivityByUser", "CreateDate", "QAStatus", "ActivityQAComments", "ActivityQAUser", "Source", "LocationId", "ActivityQAStatusId", "Dataset", "ActivityId" }));

                    foreach (var item in labels)
                    {
                        logger.Debug(item);
                    }

                }
                catch (Exception e)
                {
                    logger.Debug("Error!");
                    logger.Debug(e);
                }
                return labels;

            }


        
    }
}