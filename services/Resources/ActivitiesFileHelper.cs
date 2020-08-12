using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Web;
using NLog;
using services.Models;

namespace services.Resources
{
    public class ActivitiesFileHelper
    {
        public static Logger logger = LogManager.GetCurrentClassLogger();


        //removes all files (system and files table) for a detail item
        public static void DeleteAllFilesForDetail(dynamic detail, Dataset dataset)
        {
            var db = ServicesContext.Current;

            //all files for this dataset
            List<Models.File> files = (from f in db.Files where f.DatasetId == dataset.Id select f).ToList<Models.File>();

            foreach (var file in files)
            {
                foreach (var field in dataset.Fields.Where(o => o.ControlType == "file" && o.FieldRoleId == 2)) //detail role fields
                {
                    //look for match
                    var file_field_property = detail.GetType().GetProperty(field.DbColumnName);

                    if (file_field_property != null)
                    {
                        var file_field_value = file_field_property.GetValue(detail, null);

                        //logger.Debug("checking for file match in file_field_value = " + file_field_value);
                        //logger.Debug("  looking for: " + @"""" + file.Name + @"""");

                        if (file_field_value != null && file_field_value.ToString().Contains(@"""" + file.Name + @""""))
                        {
                            logger.Debug("OK! we are deleting this file : " + file.Name + " because it is in this field " + file_field_value);
                            DeleteDatasetFile(file, dataset.ProjectId, dataset.Id);
                        }
                    }
                    else
                    {
                        logger.Debug("property not found (no files for that field?): " + field.DbColumnName);
                    }
                }
            }
        }


        //removes all files (system and files table) for an activity
        public static void DeleteAllFilesForActivity(dynamic data, Dataset dataset)
        {
            var db = ServicesContext.Current;

            //all files for this dataset
            List<Models.File> files = (from f in db.Files where f.DatasetId == dataset.Id select f).ToList<Models.File>();

            //delete files from the header
            //iterate all files
            //and then iterate all file fields and see if file is in one... if so, delete it.
            foreach (var file in files)
            {

                //header fields that have files
                foreach (var field in dataset.Fields.Where(o => o.ControlType == "file" && o.FieldRoleId == 1))
                {
                    //look for match
                    var file_field_property = data.Header.GetType().GetProperty(field.DbColumnName);

                    if(file_field_property != null)
                    {
                        var file_field_value = file_field_property.GetValue(data.Header, null);

                        //logger.Debug("checking for file match in file_field_value = " + file_field_value);
                        //logger.Debug("  looking for: " + @"""" + file.Name + @"""");

                        if (file_field_value != null && file_field_value.ToString().Contains(@"""" + file.Name + @""""))
                        {
                            logger.Debug("OK! we are deleting this file : " + file.Name + " because it is in this field " + file_field_value);
                            DeleteDatasetFile(file, dataset.ProjectId, dataset.Id);
                        }
                    }
                    else
                    {
                        logger.Debug("property not found (no files for that field?): " + field.DbColumnName);
                    }
                }
            }

            //delete files from each detail row

            var detailsCollection = (data.Details is DataTable) ? data.Details.Rows : data.Details;

            foreach (var detail in detailsCollection)
            {
                foreach(var file in files)
                {
                    foreach (var field in dataset.Fields.Where(o => o.ControlType == "file" && o.FieldRoleId == 2)) //detail role fields
                    {
                        //look for match
                        var file_field_property = detail.GetType().GetProperty(field.DbColumnName);

                        if (file_field_property != null)
                        {
                            var file_field_value = file_field_property.GetValue(detail, null);

                            //logger.Debug("checking for file match in file_field_value = " + file_field_value);
                            //logger.Debug("  looking for: " + @"""" + file.Name + @"""");

                            if (file_field_value != null && file_field_value.ToString().Contains(@"""" + file.Name + @""""))
                            {
                                logger.Debug("OK! we are deleting this file : " + file.Name + " because it is in this field " + file_field_value);
                                DeleteDatasetFile(file, dataset.ProjectId, dataset.Id);
                            }
                        }
                        else
                        {
                            logger.Debug("property not found (no files for that field?): " + field.DbColumnName);
                        }
                    }
                }
            }

            logger.Debug(" >> done -- all files deleted for activity ID: " + data.Header.ActivityId);

        }

        //removes the file from both the File table and the disk
        public static void DeleteDatasetFile(Models.File existing_file, int projectId, int datasetId)
        {
            var db = ServicesContext.Current;

            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            string theFullPath = root + projectId + "\\D\\" + datasetId + "\\" + existing_file.Name;
            
            var provider = new MultipartFormDataStreamProvider(theFullPath);

            logger.Debug("About to delete the file:  " + theFullPath);

            FileInfo fi = new FileInfo(theFullPath);
            bool exists = fi.Exists;
            if (exists)
            {
                logger.Debug("File exists.  Deleting...");
                System.IO.File.Delete(theFullPath);
            }
            else
            {
                logger.Debug("File does not exist.");
            }
            
            var fileToDelete = (from f in db.Files
                                    where f.ProjectId == projectId && f.DatasetId == datasetId && f.Name == existing_file.Name
                                    select f).FirstOrDefault();

            if(fileToDelete != null)
            {
                logger.Debug("Removing " + fileToDelete.Name + " from datasetId " + datasetId + " in the database.");
                db.Files.Remove(fileToDelete);
                logger.Debug("Saving the action");
                db.SaveChanges();
            }
            else
            {
                logger.Debug("No record in tbl Files for Pid:  " + projectId + ", datasetId = " + datasetId + ", fileName = " + existing_file.Name);
            }

            logger.Debug("Done deleting file: " + existing_file.Name);
        }
    }

}