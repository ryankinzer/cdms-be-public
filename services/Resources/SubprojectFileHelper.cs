using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Web;
using NLog;
using services.Models;

namespace services.Resources
{
    public class SubprojectFileHelper
    {

        public static Logger logger = LogManager.GetCurrentClassLogger();

        //removes the file from both the File table and the disk
        public static void DeleteSubprojectFile(Models.File existing_file, int projectId, int subprojectId)
        {
            logger.Debug("Inside DeleteSubprojectFile...");
            logger.Debug("existing_file.Name = " + existing_file.Name + ", projectId = " + projectId + ", subprojectId = " + subprojectId);

            var db = ServicesContext.Current;

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToHabitatProjectDocuments"] + ("\\uploads\\subprojects");
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            string theFullPath = root + projectId + "\\S\\" + subprojectId + "\\" + existing_file.Name;
            //string rootUrl = Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.AbsolutePath, String.Empty);
            //logger.Debug("Deleting files from location: " + root + "\\" + subprojectId);
            //logger.Debug(" and the root url = " + rootUrl);
            //logger.Debug("theFullPath = " + theFullPath);

            //var provider = new MultipartFormDataStreamProvider(root);
            var provider = new MultipartFormDataStreamProvider(theFullPath);
            //logger.Debug("provider = " + provider);

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

            int numFiles = (from sf in db.Files
                            where sf.ProjectId == projectId && sf.Subproject_CrppId == subprojectId && sf.Name == existing_file.Name
                            select sf).Count();

            if (numFiles > 0)
            {
                var fileToDelete = (from f in db.Files
                                    where f.ProjectId == projectId && f.Subproject_CrppId == subprojectId && f.Name == existing_file.Name
                                    select f).FirstOrDefault();

                logger.Debug("Removing " + fileToDelete.Name + " from subproject " + subprojectId + " in the database.");
                db.Files.Remove(fileToDelete);
                logger.Debug("Saving the action");
                db.SaveChanges();
            }
            else
            {
                logger.Debug("No record in tbl Files for Pid:  " + projectId + ", SubpId = " + subprojectId + ", fileName = " + existing_file.Name);
            }
            logger.Debug("Done deleting file: " + existing_file.Name);
        }
    }
}