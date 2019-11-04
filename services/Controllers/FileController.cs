using Microsoft.VisualBasic.FileIO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using services.Models;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.Entity;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace services.Controllers
{
    public class FileController : CDMSController
    {
        //returns list of the files associated with a datasetid (empty list if none)
        // GET /api/v1/file/getdatasetfiles
        [HttpGet]
        public IEnumerable<Models.File> GetDatasetFiles(int Id)
        {
            //var result = new List<File>();

            var db = ServicesContext.Current;

            Dataset dataset = db.Datasets.Find(Id);
            if (dataset == null)
            {
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotFound));
            }

            List<Models.File> result = (from item in db.Files
                                 where item.DatasetId == Id
                                 orderby item.Id
                                 select item).ToList();

            return result;
        }


        /**
         * Handle uploaded files
         * IEnumerable<File>
         */
        public Task<HttpResponseMessage> PostFiles()
        {
            logger.Debug("starting to process incoming files.");

            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            string rootUrl = Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.AbsolutePath, String.Empty);

            logger.Debug("saving files to location: " + root);
            logger.Debug(" and the root url = " + rootUrl);

            var provider = new MultipartFormDataStreamProvider(root);

            User me = AuthorizationManager.getCurrentUser();

            var db = ServicesContext.Current;

            var task = Request.Content.ReadAsMultipartAsync(provider).
                ContinueWith<HttpResponseMessage>(o =>
                {

                    if (o.IsFaulted || o.IsCanceled)
                    {
                        logger.Debug("Error: " + o.Exception.Message);
                        throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.InternalServerError, o.Exception));
                    }

                    //Look up our project
                    Int32 ProjectId = Convert.ToInt32(provider.FormData.Get("ProjectId"));
                    logger.Debug("And we think the projectid === " + ProjectId);

                    Project project = db.Projects.Find(ProjectId);

                    if (project == null)
                        throw new Exception("Project ID not found: " + ProjectId);

                    //TODO: collaborators?
                    //security check :: you can only edit your own projects
                    if (project.Owner.Id != me.Id)
                    {
                        throw new Exception("NotAuthorized: You can only edit projects you own.");
                    }


                    //Now iterate through the files that just came in
                    List<Models.File> files = new List<Models.File>();

                    foreach (MultipartFileData file in provider.FileData)
                    {

                        logger.Debug("Filename = " + file.LocalFileName);
                        logger.Debug("Orig = " + file.Headers.ContentDisposition.FileName);
                        logger.Debug("Name? = " + file.Headers.ContentDisposition.Name);

                        //var fileIndex = getFileIndex(file.Headers.ContentDisposition.Name); //"uploadedfile0" -> 0
                        var fileIndex = "0";
                        logger.Debug("Fileindex = " + fileIndex);
                        var filename = file.Headers.ContentDisposition.FileName;
                        filename = filename.Replace("\"", string.Empty);

                        if (!String.IsNullOrEmpty(filename))
                        {
                            try
                            {
                                var newFileName = relocateProjectFile(
                                                file.LocalFileName,
                                                ProjectId,
                                                filename);

                                var info = new System.IO.FileInfo(newFileName);

                                Models.File newFile = new Models.File();
                                newFile.Title = provider.FormData.Get("Title_" + fileIndex); //"Title_1, etc.
                                logger.Debug("Title = " + newFile.Title);

                                newFile.Description = provider.FormData.Get("Description_" + fileIndex); //"Description_1, etc.
                                logger.Debug("Desc = " + newFile.Description);

                                newFile.Name = info.Name;//.Headers.ContentDisposition.FileName;

                                //TODO: this should be from the config
                                newFile.Link = rootUrl + "/services/uploads/" + ProjectId + "/" + info.Name; //file.LocalFileName;
                                newFile.Size = (info.Length / 1024).ToString(); //file.Headers.ContentLength.ToString();
                                newFile.FileTypeId = FileType.getFileTypeFromFilename(info);
                                newFile.SharingLevel = Models.File.SHARINGLEVEL_PRIVATE;
                                newFile.UserId = me.Id;
                                logger.Debug(" Adding file " + newFile.Name + " at " + newFile.Link);

                                files.Add(newFile);
                            }
                            catch (Exception e)
                            {
                                logger.Debug("Error: " + e.ToString());
                            }
                        }
                    }

                    //Add files to database for this project.
                    if (files.Count() > 0)
                    {
                        logger.Debug("woot -- we have file objects to save");
                        foreach (var file in files)
                        {
                            project.Files.Add(file);
                        }
                        db.Entry(project).State = EntityState.Modified;
                        db.SaveChanges();
                    }

                    logger.Debug("Done saving files.");

                    //TODO: actual error/success message handling
                    string result = "{message: 'Success'}";

                    HttpResponseMessage resp = new HttpResponseMessage(System.Net.HttpStatusCode.OK);
                    resp.Content = new System.Net.Http.StringContent(result, System.Text.Encoding.UTF8, "text/plain");

                    return resp;

                });

            return task;

        }

        //"uploadedfile0" -> 0
        public static object getFileIndex(string name)
        {
            var fileIndex = name.Replace("\"", string.Empty);
            fileIndex = fileIndex.Replace("uploadedfile", string.Empty);
            return fileIndex;
        }

        /**
         * takes current filename, project id and original filename and moves the file
         * from something like: D:\WebSites\GISInternet\services\uploads\BodyPart_c0a2f6f8-446b-42ee-88ab-2f2f3ace1e75
         * to D:\WebSites\GISInternet\services\uploads\3729\originalFilename.pdf 
         * where 3729 is the projectid folder that will be created if it doesn't exist.
         */
        // makeUnique comes in false from DataActionController.cs, uploadProjectFile, true from uploadImportFile
        public static string relocateProjectFile(string current_fullfile, int ProjectId, string orig_fullfile, bool makeUnique = false)
        {
            string new_filename = current_fullfile;

            orig_fullfile = orig_fullfile.Replace("\"", string.Empty);

            if (String.IsNullOrEmpty(orig_fullfile))
                throw new Exception("Original filename path is not given.");

            logger.Debug("Incoming current: " + current_fullfile);
            logger.Debug("Original file: " + orig_fullfile);

            string directory = System.IO.Path.GetDirectoryName(current_fullfile);
            string orig_filename = System.IO.Path.GetFileName(orig_fullfile);

            //unless we want to make a UNIQUE filename (like for importing)
            if (makeUnique)
            {
                orig_filename = System.IO.Path.GetFileNameWithoutExtension(orig_fullfile) + "_" + System.IO.Path.GetFileNameWithoutExtension(System.IO.Path.GetRandomFileName()) + System.IO.Path.GetExtension(orig_fullfile);
            }

            string project_directory = directory + @"\" + ProjectId;

            logger.Debug("New target file: " + orig_filename);

            //first, ensure we have a projectid folder (will auto-create if necessary)
            logger.Debug("Creating (if necessary) project directory: " + project_directory);
            System.IO.Directory.CreateDirectory(project_directory);

            //now move the file from where it is to the project directory with the new name.
            new_filename = project_directory + @"\" + orig_filename;
            logger.Debug("Moving uploaded file to: " + new_filename);
            System.IO.File.Move(current_fullfile, new_filename);

            return new_filename;

        }

        /**
         * takes current filename, project id and original filename and moves the file
         * from something like: D:\WebSites\GISInternet\services\uploads\BodyPart_c0a2f6f8-446b-42ee-88ab-2f2f3ace1e75
         * to D:\WebSites\GISInternet\services\uploads\3729\originalFilename.pdf 
         * where 3729 is the projectid folder that will be created if it doesn't exist.
         */
        // makeUnique comes in false from DataActionController.cs, uploadDatasetFile
        //public static string relocateDatasetFile(string current_fullfile, int DatasetId, string orig_fullfile, bool makeUnique = false)
        public static string relocateDatasetFile(string current_fullfile, int ProjectId, int DatasetId, string orig_fullfile, bool makeUnique = false)
        {
            logger.Debug("Inside relocateDatasetFile...");
            logger.Debug("current_fullfile = " + current_fullfile);
            logger.Debug("DatasetId = " + DatasetId);
            logger.Debug("orig_fullfile = " + orig_fullfile);

            string new_filename = current_fullfile;
            logger.Debug("new_filename = " + new_filename);

            orig_fullfile = orig_fullfile.Replace("\"", string.Empty);

            if (String.IsNullOrEmpty(orig_fullfile))
                throw new Exception("Original filename path is not given.");

            logger.Debug("Incoming current: " + current_fullfile);
            logger.Debug("Original file: " + orig_fullfile);

            string directory = System.IO.Path.GetDirectoryName(current_fullfile);
            logger.Debug("directory = " + directory);
            string orig_filename = System.IO.Path.GetFileName(orig_fullfile);
            logger.Debug("orig_filename = " + orig_filename);

            //unless we want to make a UNIQUE filename (like for importing)
            if (makeUnique)
            {
                orig_filename = System.IO.Path.GetFileNameWithoutExtension(orig_fullfile) + "_" + System.IO.Path.GetFileNameWithoutExtension(System.IO.Path.GetRandomFileName()) + System.IO.Path.GetExtension(orig_fullfile);
            }

            //string dataset_directory = directory + @"\" + DatasetId;
            string dataset_directory = directory + "\\" + ProjectId + @"\D\" + DatasetId;

            logger.Debug("New target file: " + orig_filename);

            //first, ensure we have a projectid folder (will auto-create if necessary)
            logger.Debug("Creating (if necessary) dataset directory: " + dataset_directory);
            System.IO.Directory.CreateDirectory(dataset_directory);

            //now move the file from where it is to the project directory with the new name.
            new_filename = dataset_directory + @"\" + orig_filename;
            logger.Debug("Moving uploaded file to: " + new_filename);
            System.IO.File.Move(current_fullfile, new_filename);

            return new_filename;

        }

        /* This works like relocateProjectFile, except that it puts the subproject files here...
         * from something like: D:\WebSites\GISInternet\services\uploads\subprojects\BodyPart_c0a2f6f8-446b-42ee-88ab-2f2f3ace1e75 (local)
         * to D:\WebSites\GISInternet\services\uploads\subprojects\123\originalFilename.pdf (local)
         * or from \\gis-data01\Fisheries-GIS-Share\CDMS\Dev\BodyPart_c0a2f6f8-446b-42ee-88ab-2f2f3ace1e75
         * to \\gis-data01\Fisheries-GIS-Share\CDMS\Dev\123\originalFilename.pdf (local)
         */
        // makeUnique comes in false from DataActionController.cs, uploadSubprojectFile
        //public static string relocateSubprojectFile(string current_fullfile, int SubprojectId, string orig_fullfile, bool makeUnique = false)
        public static string relocateSubprojectFile(string current_fullfile, int ProjectId, int SubprojectId, string orig_fullfile, bool makeUnique = false)
        {
            logger.Debug("Inside relocateSubprojectFile...");
            logger.Debug("current_fullfile = " + current_fullfile);
            logger.Debug("SubprojectId = " + SubprojectId);
            logger.Debug("orig_fullfile = " + orig_fullfile);

            string new_filename = current_fullfile;
            logger.Debug("new_filename = " + new_filename);

            orig_fullfile = orig_fullfile.Replace("\"", string.Empty);

            if (String.IsNullOrEmpty(orig_fullfile))
                throw new Exception("Original filename path is not given.");

            logger.Debug("Incoming current: " + current_fullfile);
            logger.Debug("Original file: " + orig_fullfile);

            string directory = System.IO.Path.GetDirectoryName(current_fullfile);
            logger.Debug("directory = " + directory);
            string orig_filename = System.IO.Path.GetFileName(orig_fullfile);
            logger.Debug("orig_filename = " + orig_filename);

            //unless we want to make a UNIQUE filename (like for importing)
            if (makeUnique)
            {
                orig_filename = System.IO.Path.GetFileNameWithoutExtension(orig_fullfile) + "_" + System.IO.Path.GetFileNameWithoutExtension(System.IO.Path.GetRandomFileName()) + System.IO.Path.GetExtension(orig_fullfile);
            }

            string subproject_directory = directory + @"\" + ProjectId + "\\S\\" + SubprojectId;

            logger.Debug("New target file: " + orig_filename);

            //first, ensure we have a subprojectid folder (will auto-create if necessary)
            logger.Debug("Creating (if necessary) subproject directory: " + subproject_directory);
            System.IO.Directory.CreateDirectory(subproject_directory);

            //now move the file from where it is to the project directory with the new name.
            new_filename = subproject_directory + @"\" + orig_filename;
            logger.Debug("Moving uploaded file to: " + new_filename);

           
            if (System.IO.File.Exists(new_filename))
            {
                logger.Debug("Oops!  That file already exists in the folder.  Cleaning up...");
                logger.Debug("current_fullfile = " + current_fullfile);
                logger.Debug("Deleting this file:  " + current_fullfile);
                System.IO.File.Delete(current_fullfile);
                throw new Exception("File already exists");
            }

            try
            {
                System.IO.File.Move(current_fullfile, new_filename);
                logger.Debug("File moved OK...");
            }
            catch (System.IO.IOException sioe)
            {
                logger.Debug("This file was not a duplicate, but it could not be saved.  This was the error...");
                string strErrorMessage = "Error message = " + sioe.Message.ToString() + ", inner error message = " + sioe.InnerException.ToString();
                logger.Debug(strErrorMessage);
                logger.Debug("Leaving the body part in place, for follow-up troubleshooting....");
                throw new Exception("This file was not a duplicate, but it could not be saved.  This was the error...");
            }
            
            return new_filename;
        }

        public static HttpResponseMessage MoveFile(string sourceFile, string destinationFile)
        {
            try
            {
                System.IO.File.Move(sourceFile, destinationFile);
                return new HttpResponseMessage(HttpStatusCode.OK);
            }
            catch
            {
                return new HttpResponseMessage(HttpStatusCode.Forbidden);
            }
        }

        // GET /api/v1/file/getprojectfiles/5
        //returns the files for this projectid (empty list if none found...)
        //
        [System.Web.Http.HttpGet]
        public List<Models.File> GetProjectFiles(int Id)
        {
            //var result = new List<File>();

            var db = ServicesContext.Current;

            Project project = db.Projects.Find(Id);
            if (project == null)
            {
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotFound));
            }

            List<Models.File> result = (from item in db.Files
                                 where item.ProjectId == Id
                                 where item.DatasetId == null
                                 orderby item.Id
                                 select item).ToList();


            if (result.Count == 0)
            {
                logger.Debug("No project files for project " + Id);
            }
            return result;
        }

        //UploadProjectFile - add a file to this project.
        // POST /api/v1/file/uploadprojectfile
        public Task<HttpResponseMessage> UploadProjectFile()
        {
            logger.Debug("starting to process incoming project files.");

            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            // Notes about root:
            // When a project file gets uploaded, it initially gets saved to the root location.
            // Then the file gets moved/renamed to its ultimate destination.
            // If the save fails, a file with a GUID-looking name remains in the root location.
            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            //string root = System.Configuration.ConfigurationManager.AppSettings["UploadsLinkPrefix"];
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            logger.Debug("root = " + root);
            string rootUrl = Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.AbsolutePath, String.Empty);
            logger.Debug("rootUrl = " + rootUrl);


            // Make sure our folder exists
            DirectoryInfo dirInfo = new DirectoryInfo(root);
            if (!dirInfo.Exists)
            {
                logger.Debug("Directory DOES NOT exist; creating it...");
                dirInfo.Create();
                logger.Debug("...Created...");
            }
            else
            {
                logger.Debug("P dir already exists...");
                // Let's do some clean-up first.
                // If the file-move/copy fails for any reason, the Body-part file gets left behind.

                string[] filepaths = Directory.GetFiles(root);
                //logger.Debug("filepaths = " + filepaths);

                // Get yesterday's date.
                DateTime dtYesterday = DateTime.Now.AddDays(-1);

                /*foreach (string filePath in filepaths)
                {
                    try
                    {
                        // It is possible for two or more people to be uploading a file at the same time.
                        // So they could both have a bodypart showing.
                        // If the file's LastWriteTime <= yesterday's date, no one is working on it anymore,
                        // so we can delete it.  Basically, we let the file hang around for a day, 
                        // so we DO NOT delete a large file that someone is in the process of uploading.
                        FileInfo aFile = new FileInfo(filePath);
                        if (aFile.LastWriteTime <= dtYesterday)
                        {
                            logger.Debug("Cleaning out (deleting) file: " + filePath);
                            System.IO.File.Delete(filePath);
                        }
                    }
                    catch (IOException ioException)
                    {
                        logger.Debug("Had a problem cleaning out project files...");
                        logger.Debug("Exception Message:  " + ioException.Message);
                        logger.Debug("Inner Exception Message:  " + ioException.InnerException.Message);
                    }
                }
                */
            }

            logger.Debug("saving files to location: " + root);
            logger.Debug(" and the root url = " + rootUrl);

            var provider = new MultipartFormDataStreamProvider(root);
            logger.Debug("Got provider...");

            User me = AuthorizationManager.getCurrentUser();
            logger.Debug("me = " + me.Username);

            var db = ServicesContext.Current;
            logger.Debug("Got db context");

            var task = Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
            {
                logger.Debug("Inside task...");
                if (o.IsFaulted || o.IsCanceled)
                {
                    logger.Debug("Error: " + o.Exception.Message);
                    throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.InternalServerError, o.Exception));
                }

                //Look up our project
                Int32 ProjectId = Convert.ToInt32(provider.FormData.Get("ProjectId"));
                logger.Debug("And we think the projectid === " + ProjectId);

                Project project = db.Projects.Find(ProjectId);

                if (project == null)
                    throw new Exception("Project ID not found: " + ProjectId);

                if (!project.isOwnerOrEditor(me))
                    throw new Exception("Authorization error.");

                //Now iterate through the files that just came in
                List<services.Models.File> files = new List<services.Models.File>();

                foreach (MultipartFileData file in provider.FileData)
                {

                    logger.Debug("Filename = " + file.LocalFileName);
                    logger.Debug("Orig = " + file.Headers.ContentDisposition.FileName);
                    logger.Debug("Name? = " + file.Headers.ContentDisposition.Name);

                    //var fileIndex = getFileIndex(file.Headers.ContentDisposition.Name); //"uploadedfile0" -> 0
                    var fileIndex = "0";
                    logger.Debug("Fileindex = " + fileIndex);
                    var filename = file.Headers.ContentDisposition.FileName;
                    filename = filename.Replace("\"", string.Empty);

                    if (!String.IsNullOrEmpty(filename))
                    {
                        try
                        {
                            var newFileName = FileController.relocateProjectFile(
                                            file.LocalFileName,
                                            ProjectId,
                                            filename,
                                            false);

                            var info = new System.IO.FileInfo(newFileName);

                            services.Models.File newFile = new services.Models.File();
                            newFile.Title = provider.FormData.Get("Title"); //"Title_1, etc.
                            logger.Debug("Title = " + newFile.Title);

                            newFile.Description = provider.FormData.Get("Description"); //"Description_1, etc.
                            logger.Debug("Desc = " + newFile.Description);

                            newFile.SharingLevel = Convert.ToInt32(provider.FormData.Get("SharingLevel"));

                            newFile.Name = info.Name;//.Headers.ContentDisposition.FileName;

                            //newFile.Link = rootUrl + "/services/uploads/" + ProjectId + "/" + info.Name; //file.LocalFileName;
                            //newFile.Link = rootUrl + "/" + System.Configuration.ConfigurationManager.AppSettings["ExecutingEnvironment"] + "uploads/" + ProjectId + "/" + info.Name;
                            newFile.Link = System.Configuration.ConfigurationManager.AppSettings["UploadsLinkPrefix"] + "\\P\\" + ProjectId + "\\" + info.Name;

                            newFile.Size = (info.Length / 1024).ToString(); //file.Headers.ContentLength.ToString();
                            newFile.FileTypeId = FileType.getFileTypeFromFilename(info);
                            newFile.UserId = me.Id;
                            //newFile.SharingLevel = Models.File.SHARINGLEVEL_PRIVATE;
                            logger.Debug(" Adding file " + newFile.Name + " at " + newFile.Link);

                            files.Add(newFile);
                        }
                        catch (Exception e)
                        {
                            logger.Debug("Error: " + e.ToString());
                        }
                    }
                }

                List<services.Models.File> thefiles = new List<services.Models.File>();

                //Add files to database for this project.
                if (files.Count() > 0)
                {
                    logger.Debug("woot -- we have file objects to save");
                    foreach (var file in files)
                    {
                        project.Files.Add(file);
                        thefiles.Add(file);
                    }
                    db.Entry(project).State = EntityState.Modified;
                    db.SaveChanges();

                }

                logger.Debug("Done saving project files.");
                var result = JsonConvert.SerializeObject(thefiles);
                HttpResponseMessage resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(result, System.Text.Encoding.UTF8, "text/plain");  //to stop IE from being stupid.

                return resp;
            });

            return task;
        }

        // POST /api/v1/file/uploaddatasetfile
        public Task<HttpResponseMessage> UploadDatasetFile()
        {
            logger.Debug("Inside UploadDatasetFile...");
            logger.Debug("starting to process incoming dataset files.");

            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            logger.Debug("root = " + root);
            string rootUrl = Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.AbsolutePath, String.Empty);
            logger.Debug("rootUrl = " + rootUrl);

            // Make sure our folder exists
            DirectoryInfo dirInfo = new DirectoryInfo(@root);
            if (!dirInfo.Exists)
            {
                logger.Debug("Dir does not exist; will create it...");
                try
                {
                    System.IO.Directory.CreateDirectory(root);
                    logger.Debug("Created the dir...");
                }
                catch (IOException ioe)
                {
                    logger.Debug("Exception:  " + ioe.Message + ", " + ioe.InnerException);
                }
            }
            else
            {
                logger.Debug("P dir already exists...");

                // Let's do some clean-up first.
                // If the file-move/copy fails for any reason, the Body-part file gets left behind.

                string[] filepaths = Directory.GetFiles(root);
                //logger.Debug("filepaths = " + filepaths);

                // Get yesterday's date.
                DateTime dtYesterday = DateTime.Now.AddDays(-1);

                /*foreach (string filePath in filepaths)
                {
                    try
                    {
                        // It is possible for two or more people to be uploading a file at the same time.
                        // So they could both have a bodypart showing.
                        // If the file's LastWriteTime <= yesterday's date, no one is working on it anymore,
                        // so we can delete it.  Basically, we let the file hang around for a day, 
                        // so we DO NOT delete a large file that someone is in the process of uploading.
                        FileInfo aFile = new FileInfo(filePath);
                        if (aFile.LastWriteTime <= dtYesterday)
                        {
                            logger.Debug("Cleaning out (deleting) file: " + filePath);
                            System.IO.File.Delete(filePath);
                        }
                    }
                    catch (IOException ioException)
                    {
                        logger.Debug("Had a problem cleaning out dataset files...");
                        logger.Debug("Exception Message:  " + ioException.Message);
                        logger.Debug("Inner Exception Message:  " + ioException.InnerException.Message);
                    }
                }
                */
            }

            logger.Debug("root location: " + root);
            logger.Debug(" root url = " + rootUrl);

            var provider = new MultipartFormDataStreamProvider(root);
            logger.Debug("provider = " + provider.ToString());

            User me = AuthorizationManager.getCurrentUser();

            var db = ServicesContext.Current;

            // provider below gets set to the root path, a few lines up above.
            var task = Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
            {
                logger.Debug("Inside task part...");

                if (o.IsFaulted || o.IsCanceled)
                {
                    logger.Debug("Error: " + o.Exception.Message);
                    throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.InternalServerError, o.Exception));
                }

                //foreach (var item in provider.FormData)
                //{
                //    logger.Debug("item = " + item);
                //}

                //Look up our project
                Int32 ProjectId = Convert.ToInt32(provider.FormData.Get("ProjectId"));
                logger.Debug("And we think the ProjectId === " + ProjectId);

                Int32 DatasetId = Convert.ToInt32(provider.FormData.Get("DatasetId"));
                logger.Debug("And we think the DatasetId === " + DatasetId);

                Project project = db.Projects.Find(ProjectId);

                Dataset dataset = db.Datasets.Find(DatasetId);

                if (project == null)
                    throw new Exception("Project ID not found: " + ProjectId);

                if (!project.isOwnerOrEditor(me))
                    throw new Exception("Authorization error:  The user trying to import is neither an Owner nor an Editor.");

                if (dataset == null)
                    throw new Exception("Dataset ID not found: " + DatasetId);

                //If the project/dataset folder does not exist, create it.
                string datasetPath = root + project.Id + "\\D\\" + dataset.Id;
                //DirectoryInfo datasetDirInfo = new DirectoryInfo(@root);
                DirectoryInfo datasetDirInfo = new DirectoryInfo(datasetPath);
                if (!datasetDirInfo.Exists)
                {
                    logger.Debug("Dir does not exist; will create it...");
                    try
                    {
                        //System.IO.Directory.CreateDirectory(root);
                        System.IO.Directory.CreateDirectory(datasetPath);
                        logger.Debug("Created the dir...");
                    }
                    catch (IOException ioe)
                    {
                        logger.Debug("Exception:  " + ioe.Message + ", " + ioe.InnerException);
                    }
                }



                //Now iterate through the files that just came in
                List<services.Models.File> files = new List<services.Models.File>();

                foreach (MultipartFileData file in provider.FileData)
                {

                    logger.Debug("Filename = " + file.LocalFileName);
                    logger.Debug("Orig = " + file.Headers.ContentDisposition.FileName);
                    logger.Debug("Name? = " + file.Headers.ContentDisposition.Name);

                    //var fileIndex = getFileIndex(file.Headers.ContentDisposition.Name); //"uploadedfile0" -> 0
                    var fileIndex = "0";
                    logger.Debug("Fileindex = " + fileIndex);
                    var filename = file.Headers.ContentDisposition.FileName;
                    filename = filename.Replace("\"", string.Empty);
                    logger.Debug("filename = " + filename);

                    if (!String.IsNullOrEmpty(filename))
                    {
                        try
                        {
                            //var newFileName = ActionController.relocateDatasetFile(
                            //                file.LocalFileName,
                            //                DatasetId,
                            //                filename,
                            //                false);

                            var newFileName = FileController.relocateDatasetFile(
                                            file.LocalFileName,
                                            ProjectId,
                                            DatasetId,
                                            filename,
                                            false);

                            var info = new System.IO.FileInfo(newFileName);

                            services.Models.File newFile = new services.Models.File();
                            newFile.Title = provider.FormData.Get("Title"); //"Title_1, etc.
                            logger.Debug("Title = " + newFile.Title);

                            newFile.Description = provider.FormData.Get("Description"); //"Description_1, etc.
                            logger.Debug("Desc = " + newFile.Description);

                            newFile.Name = info.Name;//.Headers.ContentDisposition.FileName;

                            //newFile.Link = rootUrl + "/" + System.Configuration.ConfigurationManager.AppSettings["ExecutingEnvironment"] + "uploads/" + ProjectId + "/" + info.Name;
                            //newFile.Link = rootUrl + "/" + System.Configuration.ConfigurationManager.AppSettings["UploadsLinkPrefix"] + "\\P\\" + ProjectId + "\\D\\" + DatasetId + "\\" + info.Name;
                            newFile.Link = System.Configuration.ConfigurationManager.AppSettings["UploadsLinkPrefix"] + "\\P\\" + ProjectId + "\\D\\" + DatasetId + "\\" + info.Name;

                            newFile.Size = (info.Length / 1024).ToString(); //file.Headers.ContentLength.ToString();
                            newFile.FileTypeId = FileType.getFileTypeFromFilename(info);
                            newFile.UserId = me.Id;
                            newFile.ProjectId = ProjectId;
                            newFile.DatasetId = DatasetId;
                            newFile.SharingLevel = Models.File.SHARINGLEVEL_PRIVATE;
                            newFile.Subproject_CrppId = null; // No subprojectId for dataset files.
                            logger.Debug(" Adding file " + newFile.Name + " at " + newFile.Link);

                            files.Add(newFile);
                        }
                        catch (Exception e)
                        {
                            logger.Debug("Error: " + e.ToString());
                        }
                    }
                }

                // We will return thefiles to the calling program.
                List<services.Models.File> thefiles = new List<services.Models.File>();

                //Add files to database for this project.
                if (files.Count() > 0)
                {
                    logger.Debug("woot -- we have file objects to save");
                    foreach (var file in files)
                    {
                        project.Files.Add(file);
                        thefiles.Add(file);
                    }
                    db.Entry(project).State = EntityState.Modified;
                    db.SaveChanges();

                }

                logger.Debug("Done saving dataset files.");
                var result = JsonConvert.SerializeObject(thefiles);
                HttpResponseMessage resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(result, System.Text.Encoding.UTF8, "text/plain");  //to stop IE from being stupid.

                return resp;
            });
            return task;
        }

        // Users can upload waypoints; the data will be extracted, converted to json, then sent back to the browser in the response.
        // The uploaded files will NOT be saved.
        // Note:  The Id column may have different names, so we must get the header row, present the columns to the user, and make them choose
        // the Id column for us to use.
        // POST /api/v1/file/getwaypointscolheaders
        [HttpPost]
        public Task<HttpResponseMessage> GetWaypointsColHeaders()
        {
            logger.Debug("Inside GetWaypointsColHeaders...");

            List<string> lstFieldItems = new List<string>();

            var provider = new MultipartMemoryStreamProvider();

            var task = Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
            {
                //var data = new Dictionary<string, Dictionary<string, string>>();

                foreach (var contents in provider.Contents)
                {
                    var csvData = contents.ReadAsStreamAsync();
                    csvData.Wait();
                    var res = csvData.Result;

                    var parser = new TextFieldParser(res);
                    logger.Debug("Created parser...");
                    parser.TextFieldType = Microsoft.VisualBasic.FileIO.FieldType.Delimited;
                    logger.Debug("Set TextFieldType...");

                    StreamReader reader = new StreamReader(res);
                    logger.Debug("Created reader...");
                    string strLine = "";
                    strLine = reader.ReadLine();
                    logger.Debug("strLine = " + strLine);
                    reader.Close();

                    int intTabLoc = -1;
                    intTabLoc = strLine.IndexOf("\t");
                    if (intTabLoc > -1)
                    {
                        logger.Debug("We have a tab-delimited file.");
                        parser.SetDelimiters("\t");
                    }
                    else
                    {
                        logger.Debug("We have a csv file.");
                        parser.SetDelimiters(",");
                    }

                    //var parser = new TextFieldParser(res);
                    //parser.TextFieldType = Microsoft.VisualBasic.FileIO.FieldType.Delimited;
                    //parser.SetDelimiters(",");


                    var fields = parser.ReadFields();

                    foreach (var f in fields)
                    {
                        lstFieldItems.Add(f);
                    }

                    parser.Close();
                }

                var resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(JsonConvert.SerializeObject(lstFieldItems), System.Text.Encoding.UTF8, "text/plain");
                return resp;
            });

            return task;
        }

        // Users can upload waypoints; the data will be extracted, converted to json, then sent back to the browser in the response.
        // The uploaded files will NOT be saved.
        // Note:  The Id column may have different names, so we must get the header row, present the columns to the user, and make them choose
        // the Id column for us to use.
        // POST /api/v1/file/getwaypointscolheaders
        [HttpPost]
        public Task<HttpResponseMessage> GetWaypointsColHeaders2()
        {
            logger.Debug("Inside GetWaypointsColHeaders2...");

            List<string> lstFieldItems = new List<string>();
            bool blnIsTabDelimited = false;
            string strDelimitedBy = "";

            var provider = new MultipartMemoryStreamProvider();

            var task = Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
            {
                foreach (var contents in provider.Contents)
                {
                    var csvData = contents.ReadAsStreamAsync();
                    csvData.Wait();

                    StreamReader reader = new StreamReader(csvData.Result);
                    logger.Debug("Created reader...");
                    string strLine = "";
                    strLine = reader.ReadLine();
                    logger.Debug("strLine = " + strLine);
                    reader.Close();

                    int intTabLoc = -1;
                    intTabLoc = strLine.IndexOf("\t");
                    if (intTabLoc > -1)
                    {
                        logger.Debug("We have a tab-delimited file.");
                        blnIsTabDelimited = true;
                        strDelimitedBy = "tab";
                    }
                    else
                    {
                        logger.Debug("We have a csv file.");
                        strDelimitedBy = "comma";
                    }
                    logger.Debug("strDelimitedBy = " + strDelimitedBy);

                    string[] aryFields;

                    if (blnIsTabDelimited)
                    {
                        aryFields = strLine.Split('\t');
                    }
                    else
                        aryFields = strLine.Split(',');

                    //foreach (var f in fields)
                    foreach (var f in aryFields)
                    {
                        lstFieldItems.Add(f);
                    }

                }

                // Add the delimiter onto the end of the array.  In the frontend, we will remove the delimiter.
                lstFieldItems.Add(strDelimitedBy);

                var resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(JsonConvert.SerializeObject(lstFieldItems), System.Text.Encoding.UTF8, "text/plain");
                return resp;
            });

            return task;
        }

        // After selecting the column that contains the Waypoint Id, users can upload waypoints,
        // and the app will use the specified column as the Id column.
        // The data will be extracted, converted to json, then sent back to the browser in the response.
        // The uploaded files will NOT be saved.
        // POST /api/v1/file/handlewaypoints2
        [HttpPost]
        public Task<HttpResponseMessage> HandleWaypoints2()
        {
            logger.Debug("Inside HandleWaypoints2...");

            var provider = new InMemoryMultipartFormDataStreamProvider();

            var task = Request.Content.ReadAsMultipartAsync<InMemoryMultipartFormDataStreamProvider>(provider).ContinueWith(o =>
            {
                logger.Debug("Inside task part...");

                if (!Request.Content.IsMimeMultipartContent())
                    return error("Uploaded file does not look like a waypoints file");
                else if (!Request.Content.IsMimeMultipartContent("form-data"))
                {
                    return error("Missing the Waypoint Id Column.");
                }

                var data = new Dictionary<string, Dictionary<string, string>>();

                string strWaypointIdFieldName = provider.FormData.Get("WaypointIdFieldName");
                //logger.Debug("strWaypointIdFieldName = " + strWaypointIdFieldName);

                string strTheDelimiter = provider.FormData.Get("TheDelimiter");
                //logger.Debug("strTheDelimiter = " + strTheDelimiter);

                char charDelimiter;
                if (strTheDelimiter == "tab")
                    charDelimiter = '\t';
                else
                    charDelimiter = ',';


                foreach (var contents in provider.Files)
                {
                    var csvData = contents.ReadAsStreamAsync();
                    csvData.Wait();

                    var readingHeaderRow = true;
                    var id = -1;
                    var lat = -1;
                    var lng = -1;
                    var x = -1;
                    var y = -1;

                    StreamReader reader = new StreamReader(csvData.Result);
                    string strLine = "";
                    strLine = reader.ReadLine();
                    string[] aryFields = strLine.Split(charDelimiter);

                    while (strLine != null)
                    {
                        // Figure out which fields we want
                        if (readingHeaderRow)
                        {
                            //var fields = strLine.Split(charDelimiter);
                            //aryFields = strLine.Split(charDelimiter);

                            var ctr = 0;
                            //foreach (var f in fields)
                            foreach (var f in aryFields)
                            {
                                logger.Debug("f = " + f);
                                if (f == strWaypointIdFieldName)
                                {
                                    id = ctr;
                                    //logger.Debug("Found the Id field...");
                                }
                                else if (f == "Longitude")
                                    lng = ctr;
                                else if (f == "Latitude")
                                    lat = ctr;
                                else if (f == "x_proj")
                                    x = ctr;
                                else if (f == "y_proj")
                                    y = ctr;
                                ctr++;
                            }

                            if (id == -1)
                                return error("Could not find waypoint id column");
                            if (lat == -1)
                                return error("Could not find lat column");
                            if (lng == -1)
                                return error("Could not find long column");
                            if (x == -1)
                                return error("Could not find projected x column");
                            if (y == -1)
                                return error("Could not find projected y column");

                            readingHeaderRow = false;
                        }
                        else    // Parse a data row
                        {
                            try
                            {
                                var dict = new Dictionary<string, string>();
                                dict["lat"] = aryFields[lat];
                                dict["long"] = aryFields[lng];
                                dict["x"] = aryFields[x];
                                dict["y"] = aryFields[y];
                                // Ids look like 1.00000.... sanitize it to 1
                                data[int.Parse(aryFields[id], NumberStyles.Any).ToString()] = dict;    // Will clobber data if ids are reused
                            }
                            catch
                            {
                                return error("Could not parse waypoint file");
                            }
                        }
                        strLine = reader.ReadLine();
                        if (!string.IsNullOrEmpty(strLine))
                            aryFields = strLine.Split(charDelimiter);
                    }
                    reader.Close();
                }

                var resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(JsonConvert.SerializeObject(data), System.Text.Encoding.UTF8, "text/plain");
                return resp;
            });

            return task;
        }

        // Users can upload waypoints; the data will be extracted, converted to json, then sent back to the browser in the response.
        // The uploaded files will NOT be saved.
        // POST /api/v1/file/handlewaypoints
        [HttpPost]
        public Task<HttpResponseMessage> HandleWaypoints()
        {
            logger.Debug("Inside HandleWaypoints...");

            var provider = new MultipartMemoryStreamProvider();
            //logger.Debug("Created provider...");

            var task = Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
            {
                //logger.Debug("Starting task setup...");

                if (!Request.Content.IsMimeMultipartContent())
                    return error("Uploaded file does not look like a waypoints file");

                var data = new Dictionary<string, Dictionary<string, string>>();

                foreach (var contents in provider.Contents)
                {
                    logger.Debug("contents = " + contents.ToString());

                    var csvData = contents.ReadAsStreamAsync();
                    csvData.Wait();
                    var res = csvData.Result;

                    var parser = new TextFieldParser(res);

                    var readingHeaderRow = true;
                    var id = -1;
                    var lat = -1;
                    var lng = -1;
                    var x = -1;
                    var y = -1;

                    parser.TextFieldType = Microsoft.VisualBasic.FileIO.FieldType.Delimited;
                    parser.SetDelimiters(",");
                    while (!parser.EndOfData)
                    {
                        var fields = parser.ReadFields();

                        // Figure out which fields we want
                        if (readingHeaderRow)
                        {
                            var ctr = 0;
                            foreach (var f in fields)
                            {
                                if (f == "WP_")
                                    id = ctr;
                                else if (f == "Longitude")
                                    lng = ctr;
                                else if (f == "Latitude")
                                    lat = ctr;
                                else if (f == "x_proj")
                                    x = ctr;
                                else if (f == "y_proj")
                                    y = ctr;
                                ctr++;
                            }

                            if (id == -1)
                                return error("Could not find waypoint id column");
                            if (lat == -1)
                                return error("Could not find lat column");
                            if (lng == -1)
                                return error("Could not find long column");
                            if (x == -1)
                                return error("Could not find projected x column");
                            if (y == -1)
                                return error("Could not find projected y column");

                            readingHeaderRow = false;
                        }
                        else    // Parse a data row
                        {
                            try
                            {
                                var dict = new Dictionary<string, string>();
                                dict["lat"] = fields[lat];
                                dict["long"] = fields[lng];
                                dict["x"] = fields[x];
                                dict["y"] = fields[y];
                                // Ids look like 1.00000.... sanitize it to 1
                                data[int.Parse(fields[id], NumberStyles.Any).ToString()] = dict;    // Will clobber data if ids are reused
                            }
                            catch
                            {
                                return error("Could not parse waypoint file");
                            }
                        }
                    }
                    parser.Close();
                }

                var resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(JsonConvert.SerializeObject(data), System.Text.Encoding.UTF8, "text/plain");
                return resp;
            });

            return task;
        }

        // POST /api/v1/file/updatefile
        [HttpPost]
        public HttpResponseMessage UpdateFile(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            User me = AuthorizationManager.getCurrentUser();
            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            if (project == null)
                throw new System.Exception("Configuration error.  Please try again.");

            if (!project.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error:  The user attempting the change is neither an Owner nor an Editor.");

            services.Models.File in_file = json.File.ToObject<services.Models.File>();

            services.Models.File existing_file = project.Files.Where(o => o.Id == in_file.Id).SingleOrDefault();

            if (existing_file == null)
                throw new System.Exception("File not found.");

            existing_file.Title = in_file.Title;
            existing_file.Description = in_file.Description;
            existing_file.SharingLevel = in_file.SharingLevel;
            db.Entry(existing_file).State = EntityState.Modified;
            db.SaveChanges();

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        // POST /api/v1/file/deletefile
        [HttpPost]
        public HttpResponseMessage DeleteFile(JObject jsonData)
        {
            logger.Debug("Inside FileController.cs, DeleteFile...");

            var db = ServicesContext.Current;
            dynamic json = jsonData;
            //logger.Debug("jsonData = " + jsonData);

            User me = AuthorizationManager.getCurrentUser();
            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            if (project == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("The project = " + project.Name + ", project Id = " + project.Id);

            if (!project.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");
            else
                logger.Debug("User is authorized.");

            services.Models.File in_file = json.File.ToObject<services.Models.File>();
            logger.Debug("Obtained file from input data...");

            logger.Debug("Checking list for file name...");
            services.Models.File existing_file = project.Files.Where(o => o.Id == in_file.Id).SingleOrDefault();
            
            if (existing_file == null)
                throw new System.Exception("File not found.");
            else
                logger.Debug("The file exists.");

            logger.Debug("existing_file.Name = " + existing_file.Name);

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            string theFullPath = root + project.Id + "\\" + existing_file.Name;
            string rootUrl = Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.AbsolutePath, String.Empty);
            logger.Debug("Deleting files from location: " + root);
            logger.Debug(" and the root url = " + rootUrl);
            logger.Debug("theFullPath = " + theFullPath);

            var provider = new MultipartFormDataStreamProvider(root);
            logger.Debug("provider.FileData = " + provider.FileData);

            try
            {
                System.IO.File.Delete(theFullPath);
                //result = ActionController.deleteProjectFile(theFullPath);
                //logger.Debug("Result of delete action:  " + result);
            }
            catch (System.Exception e)
            {
                logger.Debug("Delete action encountered an error...\n" + e.Message);
            }

            var fileToDelete = (from f in db.Files
                                where f.ProjectId == project.Id && f.Name == existing_file.Name
                                select f).FirstOrDefault();
            logger.Debug("Removing " + fileToDelete.Name + " from project " + project.Id + " in the database.");

            db.Files.Remove(fileToDelete);
            logger.Debug("Saving the action");
            db.SaveChanges();

            logger.Debug("Done.");

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        // POST /api/v1/file/deletedatasetfile
        [HttpPost]
        public HttpResponseMessage DeleteDatasetFile(JObject jsonData)
        {
            logger.Debug("Inside DeleteDatasetFile...");

            var db = ServicesContext.Current;
            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();
            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            if (project == null)
                throw new System.Exception("Configuration (project) error.  Please try again.");

            logger.Debug("ProjectId = " + project.Id);

            Dataset dataset = db.Datasets.Find(json.DatasetId.ToObject<int>());
            if (dataset == null)
                throw new System.Exception("Configuration (dataset) error.  Please try again.");

            logger.Debug("DatasetId = " + dataset.Id);

            if (!project.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");
            else
                logger.Debug("User is authorized.");

            services.Models.File existing_file = json.File.ToObject<services.Models.File>();
            logger.Debug("Obtained file from input data...");
            logger.Debug("existing_file.Name = " + existing_file.Name);

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            string theFullPath = root + project.Id + "\\D\\" + dataset.Id + "\\" + existing_file.Name;
            //string rootUrl = Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.AbsolutePath, String.Empty);
            logger.Debug("Deleting files from: " + theFullPath);
            //logger.Debug(" and the root url = " + rootUrl);
            //logger.Debug("theFullPath = " + theFullPath);

            var provider = new MultipartFormDataStreamProvider(theFullPath);
            logger.Debug("provider.FileData = " + provider.FileData);

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

            //var fileToDelete = (from f in db.Files
            //                    where f.ProjectId == project.Id && f.Name == existing_file.Name
            //                    select f).FirstOrDefault();

            int numFiles = (from f in db.Files
                            where f.ProjectId == project.Id && f.DatasetId == dataset.Id && f.Name == existing_file.Name
                            select f).Count();

            if (numFiles > 0)
            {
                var fileToDelete = (from f in db.Files
                                    where f.ProjectId == project.Id && f.DatasetId == dataset.Id && f.Name == existing_file.Name
                                    select f).FirstOrDefault();
                logger.Debug("Removing " + fileToDelete.Name + " from project " + project.Id + ", dataset " + dataset.Id + " in the database.");
                db.Files.Remove(fileToDelete);
                logger.Debug("Saving the action");
                db.SaveChanges();
            }
            else
            {
                logger.Debug("No record in tbl Files for Pid:  " + project.Id + ", dataset " + dataset.Id + ", fileName = " + existing_file.Name);
            }

            //logger.Debug("Removing " + fileToDelete.Name + " from project " + project.Id + " in the database.");

            //db.Files.Remove(fileToDelete);
            logger.Debug("Saving the action");
            db.SaveChanges();

            logger.Debug("Done.");

            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}
