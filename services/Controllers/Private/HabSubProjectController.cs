using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using services.Models;
using services.Models.Data;
using services.Resources;
using services.ExtensionMethods;

namespace services.Controllers
{
    // this class is a PRIVATE Controller 
    //  it should be excluded from the main CTUIR release of cdms

    [Authorize]
    public class HabSubProjectController : CDMSController
    {
        //api/v1/habsubproject/gethabsubprojects
        // Note:  This is a POST, instead of a GET, because we are pulling lots of data.
        [HttpPost]
        public IEnumerable<Subproject_Hab> GetHabSubprojects(JObject jsonData)
        {
            logger.Debug("Inside ProjectSubprojects...");
            //logger.Debug("Fetching Subprojects for Project " + Id);
            var db = ServicesContext.Current;

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            logger.Debug("project.Id = " + project.Id);

            var s = (from item in db.Subproject_Hab()
                         //where item.Id > 1
                     where item.Id > 1 && item.ProjectId == project.Id
                     orderby item.EffDt descending
                     select item).ToList();

            foreach (var sp in s)
            {
                logger.Debug("sp = " + sp.ProjectName);

                // First, convert the results to a list, so that we can sort them easily.
                sp.HabitatItems = sp.HabitatItems.ToList();

                //foreach (var hi in sp.HabitatItems)
                //{
                //    logger.Debug("hi = " + hi.ItemName);
                //}

                // Next, do the sort.
                sp.HabitatItems = sp.HabitatItems.OrderByDescending(x => x.EffDt).ToList();
            }

            return s.AsEnumerable();
        }

        /*[HttpPost]
        public IEnumerable<services.Models.File> SubprojectFiles(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;

            User me = AuthorizationManager.getCurrentUser();
            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            logger.Debug("ProjectId = " + project.Id);
            if (project == null || me == null)
                throw new Exception("Configuration error. Please try again.");

            Subproject_Hab subproject = db.Subproject_Hab.Find(json.SubprojectId.ToObject<int>());
            logger.Debug("SubprojectId = " + subproject.Id);

            var result = (from item in db.Files
                     where item.ProjectId == project.Id
                     where item.Subproject_CrppId == subproject.Id
                     select item).ToList();

            return result.AsEnumerable();
        }*/

        // POST /api/v1/habsubproject/uploadhabitatfile
        public Task<HttpResponseMessage> UploadHabitatFile()
        //public IEnumerable<services.Models.File> UploadHabitatFile()
        {
            logger.Debug("Inside UploadHabitatFile...");
            logger.Debug("starting to process incoming Habitat files.");

            /* -- we can simplify this maybe -- check out this newer way... 
             https://stackoverflow.com/questions/10320232/how-to-accept-a-file-post
            */
            var httpRequest = System.Web.HttpContext.Current.Request;
            logger.Debug("So we have files: " + httpRequest.Files.Count);


            foreach (string file in httpRequest.Files)
            {
                var postedFile = httpRequest.Files[file];
                var filePath = System.Web.HttpContext.Current.Server.MapPath("~/" + postedFile.FileName);
                //postedFile.SaveAs(filePath);
                logger.Debug("--> " + filePath);
                // NOTE: To store in memory use postedFile.InputStream
            }

            var result_dictionary = new Dictionary<string, dynamic>();

            /*
             * -- this ends your new stuff --
            */

        if (!Request.Content.IsMimeMultipartContent())
            {
                //TODO: wrap into results?
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                
            }

            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToHabitatProjectDocuments"];
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";

            logger.Debug("root = " + root);
            string rootUrl = Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.AbsolutePath, String.Empty);
            logger.Debug("rootUrl = " + rootUrl);


            // Make sure our folder exists
            DirectoryInfo dirInfo = new DirectoryInfo(@root);
            if (!dirInfo.Exists)
            {
                logger.Debug("Dir does not exist; will create it...");
                //dirInfo.Create();
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
                logger.Debug("Dir already exists...");

            logger.Debug("saving files to location: " + root);
            logger.Debug(" and the root url = " + rootUrl);

            var provider = new MultipartFormDataStreamProvider(root);
            logger.Debug("provider = " + provider.ToString());

            User me = AuthorizationManager.getCurrentUser();

            var db = ServicesContext.Current;

            // provider below gets set to the root path, a few lines up above.
            var task = Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
            {
                if (o.IsFaulted || o.IsCanceled)
                {
                    logger.Debug("Error: " + o.Exception.Message);
                    throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.InternalServerError, o.Exception));
                }

                //Look up our project
                Int32 ProjectId = Convert.ToInt32(provider.FormData.Get("ProjectId"));
                logger.Debug("And we think the ProjectId = " + ProjectId);

                Int32 SubprojectId = Convert.ToInt32(provider.FormData.Get("SubprojectId"));
                logger.Debug("And we think the Subprojectid = " + SubprojectId);

                string SubprojectType = provider.FormData.Get("SubprojectType");
                logger.Debug("And we think the SubprojectType = " + SubprojectType);

                int SubprojectFeatureImage = 0;
                SubprojectFeatureImage = Convert.ToInt32(provider.FormData.Get("FeatureImage"));
                logger.Debug("And we think FeatureImage = " + SubprojectFeatureImage);

                //string strDatastoreTablePrefix = provider.FormData.Get("DatastoreTablePrefix");
                //logger.Debug("And we think the DatastoreTablePrefix = " + strDatastoreTablePrefix);

                Project project = db.Projects.Find(ProjectId);
                logger.Debug("project.Id = " + project.Id);

                Subproject_Hab subproject = db.Subproject_Hab().Find(SubprojectId);
                logger.Debug("subproject.Id = " + subproject.Id);

                if (project == null)
                    throw new Exception("Project ID not found: " + ProjectId);

                if (!project.isOwnerOrEditor(me))
                    throw new Exception("Authorization error.");

                if (subproject == null)
                    throw new Exception("Subproject ID not found: " + SubprojectId);

                //if (strDatastoreTablePrefix == null)
                //    throw new Exception("DatastoreTablePrefix not found: " + strDatastoreTablePrefix);

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
                            var newFileName = FileController.relocateSubprojectFile(
                                            file.LocalFileName,
                                            ProjectId,
                                            SubprojectId,
                                            filename,
                                            false);

                            var info = new System.IO.FileInfo(newFileName);

                            services.Models.File newFile = new services.Models.File();
                            newFile.Title = provider.FormData.Get("Title"); //"Title_1, etc.
                            logger.Debug("Title = " + newFile.Title);

                            newFile.Description = provider.FormData.Get("Description"); //"Description_1, etc.
                            logger.Debug("Desc = " + newFile.Description);

                            newFile.Name = info.Name;//.Headers.ContentDisposition.FileName;
                            logger.Debug("newFile.Name = " + newFile.Name);

                            newFile.Link = System.Configuration.ConfigurationManager.AppSettings["UploadsLinkPrefix"] + "\\P\\" + ProjectId + "\\S\\" + SubprojectId + "\\" + info.Name;
                            logger.Debug("newFile.Link = " + newFile.Link);

                            newFile.Size = (info.Length / 1024).ToString(); //file.Headers.ContentLength.ToString();
                            logger.Debug("newFile.Size = " + newFile.Size);

                            newFile.FileTypeId = FileType.getFileTypeFromFilename(info);
                            logger.Debug("newFile.FileTypeId = " + newFile.FileTypeId);

                            newFile.UserId = me.Id;
                            logger.Debug("newFile.UserId = " + newFile.UserId);

                            newFile.ProjectId = project.Id;
                            logger.Debug("newFile.ProjectId = " + newFile.ProjectId);

                            // I used this for CRPP, but changed to the SubprojectFiles table later, with the advent of Habitat.
                            // So, CRPP will also need to be changed over to the SubprojectFiles also.
                            // For now, the HabSubproject SubprojectId cannot be stored here, because it causes a problem with the foreign key.
                            /*
                            newFile.Subproject_CrppId = SubprojectId;
                            logger.Debug("newFile.Subproject_CrppId = " + newFile.Subproject_CrppId);
                            
                            newFile.SubprojectType = SubprojectType;
                            logger.Debug("newFile.SubprojectType = " + newFile.SubprojectType);
                            */
                            newFile.UploadDate = DateTime.Now;
                            logger.Debug("newFile.UploadDate = " + newFile.UploadDate);

                            logger.Debug(" Adding file " + newFile.Name + " at " + newFile.Link);

                            files.Add(newFile);
                            logger.Debug("Added file " + newFile.Name);
                        }
                        catch (Exception e)
                        {
                            logger.Debug("Error: " + e.ToString());
                            throw e; //rethrow.
                        }
                    }
                }

                //List<services.Models.File> thefiles = new List<services.Models.File>();
                //List<int> fileIds = new List<int>();

                logger.Debug("files.Count() = " + files.Count());
                //Add files to database for this project.
                if (files.Count() > 0)
                {
                    logger.Debug("woot -- we have file objects to save");

                    if (SubprojectFeatureImage > 0)
                    {
                        // First, make a list of the SubprojectFiles for this subproject and set the FeatureImage to 0.
                        // Note:  If we are creating a new subproject, there won't be any records.
                        logger.Debug("ProjectId: " + project.Id + ", SubprojectId: " + subproject.Id);
                        //List<services.Models.SubprojectFiles> spFileList = (from item in db.SubprojectFiles
                        //                                                    where item.ProjectId == project.Id
                        //                                                    where item.SubprojectId == subproject.Id
                        //                                                    orderby item.Id
                        //                                                    select item).ToList();

                        List<services.Models.File> spFileList = (from item in db.Files
                                                                 where item.ProjectId == project.Id
                                                                 where item.Subproject_CrppId == subproject.Id
                                                                 orderby item.Id
                                                                 select item).ToList();

                        logger.Debug("spFileList size = " + spFileList.Count);
                        foreach (var spFile in spFileList)
                        {
                            //logger.Debug("Updating FeatureImage for " + spFile.FileName);
                            logger.Debug("Updating FeatureImage for " + spFile.Name);
                            spFile.FeatureImage = 0;
                            db.Entry(spFile).State = EntityState.Modified;
                        }

                        try
                        {
                            db.SaveChanges();
                        }
                        catch (System.Exception e)
                        {
                            logger.Debug("Error = " + e.InnerException);
                            throw e;
                        }
                    }

                    // Next save the file in the Files table.
                    foreach (var file in files)
                    {
                        logger.Debug("file.name = " + file.Name);
                        //if (SubprojectFeatureImage > 0)
                        file.FeatureImage = SubprojectFeatureImage;

                        file.Subproject_CrppId = subproject.Id;

                        project.Files.Add(file);
                        logger.Debug("Added file to project.Files...");
                        logger.Debug("file.id = " + file.Id);
                        //fileIds.Add(file.Id);

                        //thefiles.Add(file);
                        //logger.Debug("Added file to thefiles");
                    }
                    db.Entry(project).State = EntityState.Modified;
                    logger.Debug("Set State...");
                    try
                    {
                        db.SaveChanges();
                    }
                    catch (System.Exception e)
                    {
                        logger.Debug("Error = " + e.InnerException);
                        throw e;

                    }
                    logger.Debug("Saved changes to db...");
                }
                
                logger.Debug("Done saving files.");
                var result = JsonConvert.SerializeObject(files);
                logger.Debug("result = " + result);

                HttpResponseMessage resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(result, System.Text.Encoding.UTF8, "text/plain");  //to stop IE from being stupid.

                return resp;
            });

            return task;
        }

        [HttpPost]
        public HttpResponseMessage UploadHabitatLink(JObject jsonData)
        {
            logger.Debug("Inside UploadHabitatLink...");
            logger.Debug("starting to process incoming Habitat links.");

            var db = ServicesContext.RestartCurrent;
            User me = AuthorizationManager.getCurrentUser();

            dynamic json = jsonData;

            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            if (project == null)
                throw new Exception("Configuration Error:  Could not find the ProjectId in the database.");

            if (!project.isOwnerOrEditor(me))
                throw new Exception("Authorization Error:  The user attempting to make changes is not an Owner or Editor.");

            Subproject_Hab subproject = db.Subproject_Hab().Find(json.SubprojectId.ToObject<int>());
            if (subproject == null)
                throw new Exception("Configuration Error:  Could not find the SubprojectId in the database.");

            string SubprojectType = json.SubprojectType.ToObject<string>();
            logger.Debug("And we think the SubprojectType = " + SubprojectType);

            //foreach (var item in linkList)

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        //GET /api/v1/habsubproject/gethabsubprojects
        [HttpGet]
        public IEnumerable<Subproject_Hab> GetHabSubprojects()
        //public IEnumerable<Subproject_Hab> GetHabSubprojects(int Id)
        {
            logger.Info("Inside DatastoreController, GetHabSubprojects...");
            //logger.Debug("ProjectId = " + Id);
            var db = ServicesContext.Current;

            /*  These are the results we want...
             *  Subproject records sorted in descending order by EffDt (most recent update on top).
             *  Then the Subprojects associated CorrespondenceEvents also sorted descending (most recent update on top).
             *  
             *  In order to achieve the goal, referring to the following article...
             *  http://stackoverflow.com/questions/30869122/how-to-order-by-list-inside-list-using-linq-in-c-sharp
             *  we had to sort each list separately.
             *  Therefore, we sort the Subprojects via our select statement.
             *  Then we walk the list, and sort each Subprojects associated CorrespondenceEvents.
             */

            // ***** This works.
            List<Subproject_Hab> s = (from item in db.Subproject_Hab()
                                      where item.Id > 1
                                      //where item.Id > 1 && item.ProjectId == Id
                                      orderby item.EffDt descending
                                      select item).ToList();
            // *****
            logger.Info("Got s");


            foreach (var hi in s)
            {
                logger.Debug("hi = " + hi.ProjectName);
                //hi.HabitatItems = hi.HabitatItems.ToList();
                hi.HabitatItems = hi.HabitatItems.OrderByDescending(x => x.EffDt).ToList();
            }



            return s.AsEnumerable();

            /******************************************/
            // This part works, manually testing the function.
            /*Subproject_Hab sTest = new Subproject_Hab();
            sTest.Id = 1;
            sTest.ProjectName = "PN1";
            sTest.ProjectDescription = "PD1";
            sTest.ProjectStartDate = DateTime.Now;
            sTest.ProjectEndDate = DateTime.Now.AddDays(14);
            sTest.FirstFoods = "FF1";
            sTest.RiverVisionTouchstone = "RVT1";
            sTest.HabitatObjectives = "HO1";
            sTest.NoaaEcologicalConcernsSubcategories = "NECS1";
            sTest.NoaaEcologicalConcerns = "NEC1";
            sTest.LimitingFactors = "LF1";
            sTest.Funding = "F1";
            sTest.Staff = "S1";
            sTest.Collaborators = "C1";
            sTest.Comments = "Comments1";
            sTest.EffDt = DateTime.Now;
            sTest.ByUserId = 1081;

            List<Subproject_Hab> sp = new List<Subproject_Hab>();
            sp.Add(sTest);

            return sp.AsEnumerable();
            */
            /******************************************/
        }

        // GET /api/v1/habsubproject/gethabsubproject/5
        [HttpGet]
        public IEnumerable<Subproject_Hab> GetHabSubproject(int Id)
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();

            List<Subproject_Hab> s = (from item in db.Subproject_Hab()
                                      where item.Id == Id
                                      select item).ToList();

            return s.AsEnumerable();

        }

        // GET /api/v1/habsubproject/getprojectcollaborators/5
        [System.Web.Http.HttpGet]
        public IEnumerable<Collaborator> GetProjectCollaborators(int Id)
        {
            logger.Debug("Inside ProjectCollaborators...");
            logger.Debug("Fetching Collaborators for Project " + Id);
            var result = new List<Collaborator>();

            var ndb = ServicesContext.Current;

            //var datasets = ndb.Datasets.Where(o => o.ProjectId == Id);
            var c = (from item in ndb.Collaborators
                         //where item.Id > 1
                     where item.ProjectId == Id
                     orderby item.ProjectId, item.SubprojectId
                     select item).ToList();

            //return datasets;
            return c;
        }

        // GET /api/v1/habsubproject/getprojectfunders/5
        [System.Web.Http.HttpGet]
        public IEnumerable<Funding> GetProjectFunders(int Id)
        {
            logger.Debug("Inside ProjectFunders...");
            logger.Debug("Fetching Funders for Project " + Id);
            var result = new List<Funding>();

            var ndb = ServicesContext.Current;

            //var datasets = ndb.Datasets.Where(o => o.ProjectId == Id);
            var f = (from item in ndb.Funding
                         //where item.Id > 1
                     where item.ProjectId == Id
                     orderby item.ProjectId, item.SubprojectId
                     select item).ToList();

            //return datasets;
            return f;
        }

        // POST /api/v1/habsubproject/deletehabitatitemfile
        [HttpPost]
        public HttpResponseMessage DeleteHabitatItemFile(JObject jsonData)
        {
            logger.Debug("Inside DeleteHabitatItemFile...");

            var db = ServicesContext.Current;
            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();
            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            if (project == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("The project = " + project);

            if (project == null)
                throw new System.Exception("Configuration error.  Please try again.");

            if (!project.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");
            else
                logger.Debug("User is authorized.");

            int subprojectId = json.SubprojectId.ToObject<int>();
            logger.Debug("subprojectId = " + subprojectId);
            int habItemId = json.HiId.ToObject<int>();
            logger.Debug("habItemId = " + habItemId);

            services.Models.File existing_file = json.File.ToObject<services.Models.File>();
            logger.Debug("Obtained file from input data...");
            logger.Debug("existing_file.Name = " + existing_file.Name);

            /*if (existing_file == null)
                throw new System.Exception("File not found.");
            else
                logger.Debug("The file exists.");
             */

            Resources.SubprojectFileHelper.DeleteSubprojectFile(existing_file, project.Id, subprojectId);

            return new HttpResponseMessage(HttpStatusCode.OK);
        }


        // POST /api/v1/habsubproject/deletehabsubprojectfile
        [HttpPost]
        public HttpResponseMessage DeleteHabSubprojectFile(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();
            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            if (project == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("The project = " + project);

            if (project == null)
                throw new System.Exception("Configuration error.  Please try again.");

            if (!project.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");
            else
                logger.Debug("User is authorized.");

            int subprojectId = json.SubprojectId.ToObject<int>();
            logger.Debug("subprojectId = " + subprojectId);
            //int habItemId = json.HiId.ToObject<int>();
            //logger.Debug("habItemId = " + habItemId);

            services.Models.File existing_file = json.File.ToObject<services.Models.File>();
            logger.Debug("Obtained file from input data...");
            logger.Debug("existing_file.Name = " + existing_file.Name);

            /*if (existing_file == null)
                throw new System.Exception("File not found.");
            else
                logger.Debug("The file exists.");
             */

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToHabitatProjectDocuments"] + ("\\uploads\\subprojects");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToHabitatProjectDocuments"];
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            //string theFullPath = root + "\\" + subprojectId + "\\" + existing_file.Name;
            string theFullPath = root + project.Id + "\\S\\" + subprojectId + "\\" + existing_file.Name;
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

            //result = ActionController.deleteProjectFile(theFullPath);
            //logger.Debug("Result of delete action:  " + result);

            // Using a list, but there should only be one.
            //List<int> FileId = (from sf in db.SubprojectFiles
            //                    where sf.ProjectId == project.Id && sf.SubprojectId == subprojectId && sf.FileName == existing_file.Name
            //                    select sf.Id).ToList();
            List<int> FileId = (from sf in db.Files
                                where sf.ProjectId == project.Id && sf.Subproject_CrppId == subprojectId && sf.Name == existing_file.Name
                                select sf.Id).ToList();

            //foreach (var aFileId in FileId)
            //{
            //    //SubprojectFiles spFile = db.SubprojectFiles.Find(aFileId);
            //    services.Models.File spFile = db.Files.Find(aFileId);
            //    db.Files.Remove(spFile);
            //    db.SaveChanges();
            //    logger.Debug("Removed file with ID = " + aFileId + " from table Files");
            //}

            int numFiles = (from sf in db.Files
                            where sf.ProjectId == project.Id && sf.Name == existing_file.Name
                            select sf).Count();

            if (numFiles > 0)
            {
                var fileToDelete = (from f in db.Files
                                    where f.ProjectId == project.Id && f.Name == existing_file.Name
                                    select f).FirstOrDefault();

                logger.Debug("Removing " + fileToDelete.Name + " from subproject " + subprojectId + " in the database.");
                db.Files.Remove(fileToDelete);
                logger.Debug("Saving the action");
                db.SaveChanges();
            }
            else
            {
                logger.Debug("No record in tbl Files for Pid:  " + project.Id + ", SubpId = " + subprojectId + ", fileName = " + existing_file.Name);
            }
            logger.Debug("Done.");

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        // POST /api/v1/habsubproject/removehabsubproject
        [HttpPost]
        public HttpResponseMessage RemoveHabSubproject(JObject jsonData)
        {
            logger.Debug("Inside RemoveHabSubproject...");

            var db = ServicesContext.Current;
            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();
            logger.Debug("Got me...");
            Project p = db.Projects.Find(json.ProjectId.ToObject<int>());
            logger.Debug("p.Name = " + p.Name);

            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");
            logger.Debug("Checked OwnerOrEditor");

            int intSubprojectId = json.SubprojectId.ToObject<int>();
            logger.Debug("SubprojectId to delete:  " + intSubprojectId);

            Subproject_Hab habSubproject = db.Subproject_Hab().Find(intSubprojectId);
            if (p == null || habSubproject == null)
                throw new System.Exception("Configuration error.  Please try again.");
            logger.Debug("habSubproject.ProjectName = " + habSubproject.ProjectName);

            int intLocationId = json.LocationId.ToObject<int>();
            Location location = db.Location.Find(intLocationId);
            if (location == null)
                logger.Debug("Could not find the location in the Locations table.");
            else
            {
                try
                {
                    p.Locations.Remove(location);
                    logger.Debug("Just removed this location:  " + intLocationId + " from LocationProjects.");
                }
                catch (System.Exception)
                {
                    logger.Debug("Could not remove the project location.");
                }

                try
                {
                    db.Location.Remove(location);
                    logger.Debug("Just removed this location:  " + location + " from Locations");
                }
                catch (System.Exception)
                {
                    logger.Debug("Could not remove the location.");
                }
            }

            //*** Remove the associated records from the Funding table.
            List<Funding> fundersList = (from funder in db.Funding
                                         where funder.ProjectId == p.Id && funder.SubprojectId == habSubproject.Id
                                         select funder).ToList();

            foreach (var funder in fundersList)
            {
                db.Funding.Remove(funder);
                logger.Debug("Removed funder: " + funder.Name);
            }
            //***

            //*** Remove the associated records from the Collaborators table.
            List<Collaborator> CollaboratorsList = (from collaborator in db.Collaborators
                                                    where collaborator.ProjectId == p.Id && collaborator.SubprojectId == habSubproject.Id
                                                    select collaborator).ToList();

            foreach (var collaborator in CollaboratorsList)
            {
                db.Collaborators.Remove(collaborator);
                logger.Debug("Removed collaborator: " + collaborator.Name);
            }
            //***

            //List<SubprojectFiles> subprojectFilesList;
            List<services.Models.File> subprojectFilesList;
            //*** Check the SubprojectFiles table; it will give us the ID for record in the Files table.
            //subprojectFilesList = (from file in db.SubprojectFiles
            //                       where file.ProjectId == p.Id && file.SubprojectId == habSubproject.Id && file.FeatureImage == 1
            //                       select file).ToList();

            subprojectFilesList = (from file in db.Files
                                   where file.ProjectId == p.Id && file.Subproject_CrppId == habSubproject.Id && file.FeatureImage == 1
                                   select file).ToList();
            //***

            List<services.Models.File> FileList;
            //*** Remove the record from the Files table.
            foreach (var spFile in subprojectFilesList)
            {
                FileList = (from file in db.Files
                            where file.Id == spFile.Id
                            select file).ToList();

                foreach (var file in FileList)
                {
                    db.Files.Remove(file);
                    logger.Debug("Removed file: " + file.Name);
                }
            }
            db.SaveChanges();
            //***

            //*** Now remove any associated records (FeatureImage and any others) from the SubprojectFiles table.
            //subprojectFilesList = (from file in db.SubprojectFiles
            subprojectFilesList = (from file in db.Files
                                   where file.ProjectId == p.Id && file.Subproject_CrppId == habSubproject.Id
                                   select file).ToList();

            foreach (var spFile in subprojectFilesList)
            {
                //db.SubprojectFiles.Remove(spFile);
                db.Files.Remove(spFile);
                //logger.Debug("Removed spFile: " + spFile.FileName);
                logger.Debug("Removed spFile: " + spFile.Name);
            }
            //***


            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads/subprojects");
            //string root = System.Web.HttpContext.Current.Server.MapPath("~/");
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            logger.Debug("root = " + root);

            string strSubprojectsPath = root + p.Id + "\\S\\" + habSubproject.Id;
            //string strSubprojectsPath = root + habSubproject.Id;
            logger.Debug("The path for the subproject is:  " + strSubprojectsPath);

            if (Directory.Exists(strSubprojectsPath))
            {
                System.IO.Directory.Delete(strSubprojectsPath, true);
                logger.Debug("Just deleted documents folder and contents for this subproject:  " + habSubproject.Id);
            }
            else
            {
                logger.Debug("Could not find folder: " + strSubprojectsPath);
            }

            db.Subproject_Hab().Remove(habSubproject);
            logger.Debug("Just removed this subproject from table Subproject_Hab:  " + habSubproject.Id);

            db.SaveChanges();
            logger.Debug("Changes saved...");

            return new HttpResponseMessage(HttpStatusCode.OK);

        }

        // POST /api/v1/habsubproject/removehabitatitem
        [HttpPost]
        public HttpResponseMessage RemoveHabitatItem(JObject jsonData)
        {
            logger.Debug("Inside RemoveHabitatItem...");
            //bool blnEventFilesPresent = true;

            var db = ServicesContext.Current;
            logger.Debug("Set database...");

            dynamic json = jsonData;
            //logger.Debug("json = " + json);
            User me = AuthorizationManager.getCurrentUser();
            Project p = db.Projects.Find(json.ProjectId.ToObject<int>());
            logger.Debug("ProjectId = " + p.Id);

            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");

            Subproject_Hab subproject = db.Subproject_Hab().Find(json.SubprojectId.ToObject<int>());
            if (p == null || subproject == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("habSubprojectId = " + subproject.Id);

            int intHabitatItemId = json.HabitatItemId.ToObject<int>();
            logger.Debug("intHabitatItemId = " + intHabitatItemId);

            if (db.HabitatItem().Any(u => u.Id == intHabitatItemId))
            {
                logger.Debug("The Habitat Item exists...");
                //HabitatItem habitatItem = db.HabitatItems.Find(json.HabitatItemId.ToObject<int>());
                HabitatItem habitatItem = db.HabitatItem().Find(intHabitatItemId);
                if (p == null || habitatItem == null)
                    throw new System.Exception("Configuration error.  Please try again.");

                logger.Debug("habitatItem = " + habitatItem.ItemName);

                //string strDatastoreTablePrefix = json.DatastoreTablePrefix.ToObject<string>();

                var files_in_subproject = (from file in db.Files
                         where file.Subproject_CrppId == subproject.Id
                         select file).ToList();

                //iterate potential files for match to delete
                foreach (var file in files_in_subproject)
                {
                    //habitatItem.ItemFiles is a JSON string of filenames that belong to this item. If we match, delete this one.
                    if (habitatItem.ItemFiles != null && habitatItem.ItemFiles.Contains("\"" + file.Name + "\"")) //use "somefile.jpg" so that we don't delete: mysomefile.jpg
                    {
                        //removes the File and the actual filesystem file
                        Resources.SubprojectFileHelper.DeleteSubprojectFile(file, subproject.ProjectId, subproject.Id);

                    }
                }

                db.HabitatItem().Remove(habitatItem);
                logger.Debug("Just removed this event from table HabitatItems:  " + habitatItem.Id);

                //db.CrppSubprojects.State = EntityState.Modified;
                db.SaveChanges();
                logger.Debug("Changes saved...");
            }
            else
                logger.Debug("The Habitat Item does not exist...");

            return new HttpResponseMessage(HttpStatusCode.OK);
        }


        // POST /api/v1/habsubproject/savehabsubproject
        [HttpPost]
        public HttpResponseMessage SaveHabSubproject(JObject jsonData)
        //public int SaveSubproject(JObject jsonData)
        {
            logger.Debug("Inside SaveHabSubproject...");
            var db = ServicesContext.Current;
            logger.Debug("db = " + db);

            dynamic json = jsonData;
            logger.Debug("json = " + json);

            //string strJson = "[" + json + "]";

            User me = AuthorizationManager.getCurrentUser();
            logger.Debug("me = " + me);

            int pId = json.ProjectId.ToObject<int>();
            logger.Debug("pId = " + pId);

            Project p = db.Projects.Find(pId);
            logger.Debug("p = " + p);
            if (p == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("p.isOwnerOrEditor(me) = " + p.isOwnerOrEditor(me));
            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");

            logger.Debug("About to check incoming data for Subproject...");
            Subproject_Hab s = new Subproject_Hab();
            logger.Debug("Found Subproject in incoming data...");


            // Spin through the fields passed in; as we find the fields, we will capture the data.
            foreach (var item in json.Subproject)
            {
                logger.Debug("Inside foreach loop");
                //int newSubprojectId = 0;

                if (!(item is JProperty))
                {
                    throw new System.Exception("There is a problem with your request. Format error.");
                }

                var prop = item as JProperty;
                logger.Debug("Property name = " + prop.Name);

                dynamic subproject_json = prop.Value;
                //logger.Debug("Property value = " + subproject_json);

                if (prop.Name == "Id")
                    s.Id = subproject_json;
                else if (prop.Name == "ProjectId")
                {
                    logger.Debug("Found ProjectId...");
                    s.ProjectId = subproject_json;
                    logger.Debug("ProjectId = " + s.ProjectId);
                }
                else if (prop.Name == "ProjectName")
                    s.ProjectName = subproject_json;
                else if (prop.Name == "ProjectSummary")
                    s.ProjectSummary = subproject_json;
                else if (prop.Name == "ProjectDescription")
                    s.ProjectDescription = subproject_json;
                else if (prop.Name == "LocationId")
                    s.LocationId = subproject_json;
                else if (prop.Name == "ProjectStartDate")
                    s.ProjectStartDate = subproject_json;
                else if (prop.Name == "ProjectEndDate")
                    s.ProjectEndDate = subproject_json;
                else if (prop.Name == "FirstFoods")
                {
                    //logger.Debug("Found FirstFoods...");
                    s.FirstFoods = subproject_json.ToString();
                    s.FirstFoods = StringHelper.removeFormattingChars(s.FirstFoods);
                    //logger.Debug("FirstFoods = " + s.FirstFoods);
                }
                else if (prop.Name == "RiverVisionTouchstone")
                {
                    //logger.Debug("Found RiverVisionTouchstone...");
                    s.RiverVisionTouchstone = subproject_json.ToString();
                    s.RiverVisionTouchstone = StringHelper.removeFormattingChars(s.RiverVisionTouchstone);
                    //logger.Debug("RiverVisionTouchstone = " + s.RiverVisionTouchstone);
                }
                else if (prop.Name == "HabitatObjectives")
                {
                    //logger.Debug("Found HabitatObjectives...");
                    s.HabitatObjectives = subproject_json.ToString();
                    s.HabitatObjectives = StringHelper.removeFormattingChars(s.HabitatObjectives);
                    //logger.Debug("HabitatObjectives = " + s.HabitatObjectives);
                }
                else if (prop.Name == "NoaaEcologicalConcerns")
                {
                    //logger.Debug("Found NoaaEcologicalConcerns...");
                    s.NoaaEcologicalConcerns = subproject_json.ToString();
                    s.NoaaEcologicalConcerns = StringHelper.removeFormattingChars(s.NoaaEcologicalConcerns);
                    //logger.Debug("NoaaEcologicalConcerns = " + s.NoaaEcologicalConcerns);
                }
                else if (prop.Name == "NoaaEcologicalConcernsSubcategories")
                {
                    //logger.Debug("Found NoaaEcologicalConcernsSubcategories...");
                    s.NoaaEcologicalConcernsSubcategories = subproject_json.ToString();
                    s.NoaaEcologicalConcernsSubcategories = StringHelper.removeFormattingChars(s.NoaaEcologicalConcernsSubcategories);
                    //logger.Debug("NoaaEcologicalConcernsSubcategories = " + s.NoaaEcologicalConcernsSubcategories);
                }
                else if (prop.Name == "LimitingFactors")
                {
                    //logger.Debug("Found LimitingFactors...");
                    s.LimitingFactors = subproject_json.ToString();
                    s.LimitingFactors = StringHelper.removeFormattingChars(s.LimitingFactors);
                    //logger.Debug("LimitingFactors = " + s.LimitingFactors);
                }
                else if (prop.Name == "Staff")
                    s.Staff = subproject_json;
                //else if (prop.Name == "Collaborators")
                //{
                //s.Collaborators = subproject_json;
                //    s.Collaborators = subproject_json.ToString();
                //}
                else if (prop.Name == "Comments")
                    s.Comments = subproject_json;
                //else if (prop.Name == "OtherFundingAgency")
                //    s.OtherFundingAgency = subproject_json.ToString();
                //else if (prop.Name == "OtherCollaborators")
                //    s.OtherCollaborators = subproject_json.ToString();
            }

            s.ProjectId = pId;
            logger.Debug("Set s.ProjectId = " + s.ProjectId);

            s.EffDt = DateTime.Now;
            logger.Debug("Set s.EffDt = " + s.EffDt);

            s.ByUserId = me.Id;
            logger.Debug("s.ByUserId = " + s.ByUserId);

            logger.Debug(
                "s.Id = " + s.Id + "\n" +
                "s.ProjectId = " + s.ProjectId + "\n" +
                "s.ProjectName = " + s.ProjectName + "\n" +
                "s.ProjectDescription = " + s.ProjectDescription + "\n" +
                "s.LocationId = " + s.LocationId + "\n" +
                "s.ProjectStartDate = " + s.ProjectStartDate + "\n" +
                "s.ProjectEndDate = " + s.ProjectEndDate + "\n" +
                "s.FirstFoods = " + s.FirstFoods + "\n" +
                "s.RiverVisionTouchstone = " + s.RiverVisionTouchstone + "\n" +
                "s.HabitatObjectives = " + s.HabitatObjectives + "\n" +
                "s.NoaaEcologicalConcernsSubcategories = " + s.NoaaEcologicalConcernsSubcategories + "\n" +
                "s.NoaaEcologicalConcerns = " + s.NoaaEcologicalConcerns + "\n" +
                "s.LimitingFactors = " + s.LimitingFactors + "\n" +
                //"s.Funding = " + s.Funding + "\n" +
                "s.Staff = " + s.Staff + "\n" +
                //"s.Collaborators = " + s.Collaborators + "\n" +
                //"s.OtherCollaborator = " + s.OtherCollaborators + "\n" +
                "s.EffDt = " + s.EffDt + "\n" +
                "s.ByUserId = " + s.ByUserId + "\n" +
                "s.Comments = " + s.Comments + "\n"
                );

            if (s.Id == 0)
            {
                logger.Debug("About to add new habSubproject...");
                db.Subproject_Hab().Add(s);
                logger.Debug("created new habSubproject");

                db.SaveChanges();
            }
            else
            {
                logger.Debug("About to update habSubproject...");
                db.Entry(s).State = EntityState.Modified;
                //db.Entry(s).Property("UpdateTime").IsModified = true;

                db.SaveChanges();
                logger.Debug("updated existing habSubproject");

                var locationList = (from item in db.Location
                                      where item.ProjectId == s.ProjectId
                                      where item.SubprojectId == s.Id
                                      select item.Id).ToList();

                int spLocationId = 0;
                // There should be only 1.
                foreach (var n in locationList)
                {
                    spLocationId = n;
                }
                //logger.Debug("Located the item...X" + spLocationId + "X");

                Location spLocation = db.Location.Find(Convert.ToInt32(spLocationId.ToString()));
                logger.Debug("spLocation Id = " + spLocation.Id);

                if (s.ProjectName != spLocation.Label)
                {
                    logger.Debug("Updating Location.Label also...");
                    spLocation.Label = s.ProjectName;

                    db.Entry(spLocation).State = EntityState.Modified;
                    db.SaveChanges();
                }

            }

            //db.SaveChanges();
            logger.Debug("Just saved the DB changes.");

            int newId = s.Id;
            logger.Debug("newId = " + s.Id);

            // Funding Start*********************************
            var funding = new List<Funding>();

            // Let's check for a funding object.
            // This works.  Now we need to add the incoming record to the Funding table.
            try
            {
                string strFunding = (string)jsonData["Subproject"]["Funding"].ToString();// .Value<string>();
                logger.Debug("strFunding = " + strFunding);
                if ((!String.IsNullOrEmpty(strFunding)) || (strFunding.Length < 3)) // < 3 means "[]"
                {
                    JArray aryFunding = (JArray)jsonData["Subproject"]["Funding"];
                    foreach (JToken f in aryFunding)
                    {
                        logger.Debug("Inside aryFunding loop.");
                        //logger.Debug("Name = " + f["Name"]);
                        //logger.Debug("Amount = " + f["Amount"]);

                        Funding funder = new Funding();
                        funder.Id = Convert.ToInt32(f["Id"].ToString());
                        funder.Name = f["Name"].ToString();
                        funder.Amount = Convert.ToDouble(f["Amount"].ToString());
                        funder.SubprojectId = newId;
                        funder.ProjectId = s.ProjectId;
                        //funder.OtherName = f["OtherFunder"].ToString();

                        logger.Debug("funder.Id = " + funder.Id);
                        logger.Debug("funder.Name = " + funder.Name);
                        logger.Debug("funder.Amount = " + funder.Amount);
                        logger.Debug("funder.SubprojectId = " + funder.SubprojectId);
                        logger.Debug("funder.ProjectId = " + funder.ProjectId);
                        //logger.Debug("funder.OtherName = " + funder.OtherName);

                        funding.Add(funder);
                    }

                    logger.Debug("Cleaning out funder data for this subproject...");
                    // If the funder list changes, we cannot use the current list to determine who used to be on the list.
                    // Therefore, just delete all the funders for this subproject first, then we will add the ones actually assocated to the subproject.
                    List<services.Models.Funding> funderList = (from item in db.Funding
                                                                where item.ProjectId == p.Id
                                                                where item.SubprojectId == s.Id
                                                                orderby item.Id
                                                                select item).ToList();

                    foreach (var item in funderList)
                    {
                        db.Funding.Remove(item);
                        logger.Debug("Removed funder: " + item.Name);
                    }



                    logger.Debug("");
                    logger.Debug("funding.length = " + funding.Count());
                    foreach (var item in funding)
                    {
                        logger.Debug("item.Id = " + item.Id);
                        logger.Debug("item.Name = " + item.Name);
                        logger.Debug("item.Amount = " + item.Amount);
                        //logger.Debug("item.OtherName = " + item.OtherName);
                        //if (item.Id == 0)
                        //{
                        db.Funding.Add(item);
                        logger.Debug("Added funder Name: " + item.Name);
                        //}
                        //else
                        //{
                        //    db.Entry(item).State = EntityState.Modified;
                        //    logger.Debug("Updated funder Id: " + item.Id + ", Name: " + item.Name);
                        //}
                    }
                    db.SaveChanges();
                }

                //habFunding.Add(fundingItem.ToObject(dbset_funding_type));
                //var fundingRec = new Funding();

            }
            catch (System.Exception e)
            {
                logger.Debug(e.Message + ", " + e.InnerException);
                logger.Debug("Could not locate Funding (optional field).  Skipping...");
            }
            // Funding End**************************************

            // Collaborators Start*********************************
            var collaborators = new List<Collaborator>();

            // Let's check for a collaborator object.
            // This works.  Now we need to add the incoming record to the Funding table.
            try
            {
                string strCollaborator = (string)jsonData["Subproject"]["Collaborators"].ToString();// .Value<string>();
                logger.Debug("strCollaborator = " + strCollaborator);
                if ((!String.IsNullOrEmpty(strCollaborator)) || (strCollaborator.Length < 3)) // < 3 means "[]"
                {
                    JArray aryCollaborator = (JArray)jsonData["Subproject"]["Collaborators"];
                    foreach (JToken c in aryCollaborator)
                    {
                        logger.Debug("Inside aryCollaborator loop.");
                        //logger.Debug("Name = " + c["Name"]);

                        Collaborator collaborator = new Collaborator();
                        collaborator.Id = Convert.ToInt32(c["Id"].ToString());
                        collaborator.Name = c["Name"].ToString();
                        collaborator.SubprojectId = newId;
                        collaborator.ProjectId = s.ProjectId;

                        logger.Debug("collaborator.Id = " + collaborator.Id);
                        logger.Debug("collaborator.Name = " + collaborator.Name);
                        logger.Debug("collaborator.SubprojectId = " + collaborator.SubprojectId);
                        logger.Debug("collaborator.ProjectId = " + collaborator.ProjectId);

                        collaborators.Add(collaborator);
                    }

                    logger.Debug("Cleaning out collaborator data for this subproject...");
                    // If the collaborator list changes, we cannot use the current list to determine who used to be on the list.
                    // Therefore, just delete all the collaborators for this subproject first, then we will add the ones actually assocated to the subproject.
                    List<services.Models.Collaborator> collaboratorList = (from item in db.Collaborators
                                                                           where item.ProjectId == p.Id
                                                                           where item.SubprojectId == s.Id
                                                                           orderby item.Id
                                                                           select item).ToList();

                    foreach (var item in collaboratorList)
                    {
                        db.Collaborators.Remove(item);
                        logger.Debug("Removed collaborator: " + item.Name);
                    }



                    logger.Debug("");
                    logger.Debug("collaborators.length = " + collaborators.Count());
                    foreach (var item in collaborators)
                    {
                        logger.Debug("item.Id = " + item.Id);
                        logger.Debug("item.Name = " + item.Name);
                        //logger.Debug("item.OtherName = " + item.OtherName);
                        //if (item.Id == 0)
                        //{
                        db.Collaborators.Add(item);
                        logger.Debug("Added collaborator Name: " + item.Name);
                        //}
                        //else
                        //{
                        //    db.Entry(item).State = EntityState.Modified;
                        //    logger.Debug("Updated funder Id: " + item.Id + ", Name: " + item.Name);
                        //}
                    }
                    db.SaveChanges();
                }
            }
            catch (System.Exception e)
            {
                logger.Debug(e.Message + ", " + e.InnerException);
                logger.Debug("Could not locate collaborator (optional field).  Skipping...");
            }
            // Collaborators end**************************************


            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads/subprojects");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToHabitatProjectDocuments"] + ("uploads\\subprojects");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToHabitatProjectDocuments"];
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"];
            logger.Debug("root = " + root);

            //string strSubprojectsPath = root + "\\" + s.Id;
            string strSubprojectsPath = root + "\\P\\" + p.Id + "\\S\\" + s.Id;
            logger.Debug("The path for the new subproject will be:  " + strSubprojectsPath);

            System.IO.Directory.CreateDirectory(strSubprojectsPath);
            logger.Debug("Just created folder for the new habSubproject:  " + s.Id);

            //return new HttpResponseMessage(HttpStatusCode.OK);
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, s);
            return response;
        }

        //POST /api/v1/habsubproject/savehabitatitem
        [HttpPost]
        public HttpResponseMessage SaveHabitatItem(JObject jsonData)
        {
            logger.Debug("Inside SaveHabitatItem...");
            //string strId = null;  // Delare this up here, so that all if/try blocks can see it.
            var db = ServicesContext.Current;
            logger.Debug("db = " + db);

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();
            //logger.Debug("me = " + me); // getCurrentUser displays the username; this is just machinestuff.

            int pId = json.ProjectId.ToObject<int>();
            logger.Debug("pId = " + pId);

            Project p = db.Projects.Find(pId);
            logger.Debug("p = " + p);
            if (p == null)
                throw new System.Exception("Configuration error.  Please try again.");


            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");

            int spId = json.SubprojectId.ToObject<int>();
            logger.Debug("spId = " + spId);

            // Locate the associated subproject.
            Subproject_Hab spH1 = db.Subproject_Hab().Find(spId);
            Subproject_Hab spH2 = db.Subproject_Hab().Find(spId);
            HabitatItem hi = new HabitatItem();
            logger.Debug("Created hi...");


            /* Per this article:  http://stackoverflow.com/questions/24233104/extract-data-from-json-string
            *  the cause was that CorrespondenceEvent is an object, within the object.
            *  Usually, we are dealing with an object with several properties (like ProjectId and SubprojectId).
            *  This case is different, so we must access the "sub-object differently."
            *  In this case, we use the SelectToken technique seen below.
            *  Can we do this more dynamically using a dictionary?  Something to consider down the road...
            */

            // CorrespondenceDate is required.
            // First get the date as a string, so that we can easily check if it blank (null or empty).
            //string strCorrespondenceDate = jsonData.SelectToken(@"CorrespondenceEvent.CorrespondenceDate").Value<string>();
            //logger.Debug("strCorrespondenceDate = " + strCorrespondenceDate);
            /*string strCorrespondenceDate = null;
            try
            {
                strCorrespondenceDate = jsonData.SelectToken(@"CorrespondenceEvent.CorrespondenceDate", true).Value<string>();
                // We know we have a date, so we just process it.
                try
                {
                    DateTime dtCorrespondenceDate = jsonData.SelectToken(@"CorrespondenceEvent.CorrespondenceDate").Value<DateTime>();
                    ce.CorrespondenceDate = dtCorrespondenceDate;

                    logger.Debug("ce.CorrespondenceDate = " + ce.CorrespondenceDate);
                }
                catch (Exception setdateException)
                {
                    logger.Debug("Ooops had an error setting the CorrespondenceDate: " + strCorrespondenceDate);
                    logger.Debug(setdateException.ToString());

                    throw setdateException;
                }
            }
            catch (Exception tokenException)
            {
                logger.Debug("Could not find the CorrespondenceDate in the JSON data: " + strCorrespondenceDate);
                logger.Debug(tokenException.ToString());

                throw tokenException;
            }
             */


            // Spin through the fields passed in; as we find the fields, we will capture the data.
            foreach (var item in json.HabitatItem)
            {
                logger.Debug("Inside foreach loop");
                //int newSubprojectId = 0;

                if (!(item is JProperty))
                {
                    throw new System.Exception("There is a problem with your request. Format error.");
                }

                var prop = item as JProperty;
                logger.Debug("Property name = " + prop.Name);
                int intPropNameLength = prop.Name.Length;
                logger.Debug("intPropNameLength = " + intPropNameLength);

                dynamic subproject_json = prop.Value;
                logger.Debug("Property value = " + subproject_json);

                if ((intPropNameLength == 2) && (prop.Name.IndexOf("Id") > -1))
                {

                    hi.Id = subproject_json;
                    logger.Debug("hi.Id = " + hi.Id);
                }
                /*else if ((intPropNameLength > 0) && (prop.Name.IndexOf("SubprojectId") > -1))
                {
                    hi.SubprojectId = subproject_json;
                    logger.Debug("hi.SubprojectId = " + hi.SubprojectId);
                }
                */
                else if ((intPropNameLength == 8) && (prop.Name.IndexOf("ItemName") > -1))
                {
                    hi.ItemName = subproject_json;
                    logger.Debug("hi.ItemName = " + hi.ItemName);
                }
                else if ((intPropNameLength == 8) && (prop.Name.IndexOf("ItemType") > -1))
                {
                    hi.ItemType = subproject_json;
                    logger.Debug("hi.ItemType = " + hi.ItemType);
                }
                else if ((intPropNameLength == 9) && (prop.Name.IndexOf("ItemFiles") > -1))
                {
                    hi.ItemFiles = subproject_json;
                    logger.Debug("hi.ItemFiles = " + hi.ItemFiles);
                }
                else if ((intPropNameLength == 13) && (prop.Name.IndexOf("ExternalLinks") > -1))
                {
                    hi.ExternalLinks = subproject_json;
                    logger.Debug("hi.ExternalLinks = " + hi.ExternalLinks);
                }
            }

            hi.SharingLevel = json.HabitatItem.SharingLevel.ToObject<int>();
            hi.SubprojectId = spId;
            hi.ByUserId = me.Id;
            hi.EffDt = DateTime.Now;

            spH2.ProjectName = spH1.ProjectName;
            spH2.ProjectSummary = spH1.ProjectSummary;
            spH2.ProjectDescription = spH1.ProjectDescription;
            spH2.ProjectStartDate = spH1.ProjectStartDate;
            spH2.ProjectEndDate = spH1.ProjectEndDate;
            spH2.FirstFoods = spH1.FirstFoods;
            spH2.RiverVisionTouchstone = spH1.RiverVisionTouchstone;
            spH2.HabitatObjectives = spH1.HabitatObjectives;
            spH2.NoaaEcologicalConcerns = spH1.NoaaEcologicalConcerns;
            spH2.NoaaEcologicalConcernsSubcategories = spH1.NoaaEcologicalConcernsSubcategories;
            spH2.LimitingFactors = spH1.LimitingFactors;
            spH2.Staff = spH1.Staff;
            spH2.Collaborators = spH1.Collaborators;
            spH2.Comments = spH1.Comments;
            spH2.ByUserId = spH1.ByUserId;
            spH2.ProjectId = spH1.ProjectId;
            spH2.LocationId = spH1.LocationId;
            spH2.OtherCollaborators = spH1.OtherCollaborators;
            spH2.FeatureImage = spH1.FeatureImage;
            spH2.EffDt = DateTime.Now;

            logger.Debug(//"hi.ItemName = " + hi.ItemName);

                "hi.Id = " + hi.Id + "\n" +
                "hi.SubprojectId = " + hi.SubprojectId + "\n" +
                "hi.ItemType = " + hi.ItemType + "\n" +
                "hi.ItemName = " + hi.ItemName + "\n" +
                "hi.ExternalLinks = " + hi.ExternalLinks + "\n" +
                "hi.ItemFiles = " + hi.ItemFiles + "\n" +
                "hi.ByUserId = " + hi.ByUserId + "\n" +
                "hi.EffDt = " + hi.EffDt + "\n"
                );

            try
            {
                //hi.SubprojectId = spId;
                //hi.ByUserId = me.Id;
                //hi.EffDt = DateTime.Now;
                // Now let's try to save the Habita Item.
                if (hi.Id == 0)
                {
                    // The Id field auto-increments and will not accept a 0; therefore, let's just leave it blank.

                    // Save changes before adding the HabitatItem.
                    db.SaveChanges();
                    logger.Debug("Save DB just before adding the new habitat item.");

                    // Add the HabitatItem
                    db.HabitatItem().Add(hi);
                    logger.Debug("created new habitat item");
                    db.Entry(spH2).State = EntityState.Modified;
                }
                else
                {
                    HabitatItem hi2 = db.HabitatItem().Find(hi.Id);

                    hi2.Id = hi.Id;
                    hi2.SubprojectId = hi.SubprojectId;
                    hi2.ItemType = hi.ItemType;
                    hi2.ItemName = hi.ItemName;
                    hi2.SharingLevel = hi.SharingLevel;
                    hi2.ExternalLinks = hi.ExternalLinks;
                    hi2.ItemFiles = hi.ItemFiles;
                    hi2.ByUserId = hi.ByUserId;
                    hi2.EffDt = hi.EffDt;

                    db.Entry(hi2).State = EntityState.Modified;
                    logger.Debug("updated Habitat item");
                    db.Entry(spH2).State = EntityState.Modified;
                }

                try
                {
                    logger.Debug("Trying to save db again.");
                    db.SaveChanges();
                    logger.Debug("Just saved the DB changes.");

                    // Now let's save the documents.

                    //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads/subprojects");
                    //string root = System.Configuration.ConfigurationManager.AppSettings["PathToHabitatProjectDocuments"] + ("uploads\\subprojects");
                    //string root = System.Configuration.ConfigurationManager.AppSettings["PathToHabitatProjectDocuments"];
                    string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
                    logger.Debug("root = " + root);
                    string strCleanupFolder = root;

                    //string strSubprojectsFolder = root + "\\";
                    string strSubprojectsFolder = root + p.Id + "\\S\\" + hi.SubprojectId + "\\";
                    logger.Debug("strSubprojectsPath = " + strSubprojectsFolder);
                    logger.Debug("strCleanupFolder = " + strCleanupFolder);

                    // Let's do some clean-up first.
                    // If the file-move/copy fails for any reason, the Body-part file gets left behind.
                    //string strSubprojectsPath = System.Configuration.ConfigurationManager.AppSettings["PathToServices"] + "uploads\\subprojects\\";

                    // Create the folder path, if neceesary; if any folders are missing, they will be created.
                    System.IO.Directory.CreateDirectory(strSubprojectsFolder);
                    logger.Debug("Just created folder for the new subproject:  " + strSubprojectsFolder);

                    //string[] filepaths = Directory.GetFiles(strSubprojectsFolder);
                    string[] filepaths = Directory.GetFiles(strCleanupFolder);

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
                            logger.Debug("Had a problem cleaning out files...");
                            logger.Debug("Exception Message:  " + ioException.Message);
                            logger.Debug("Inner Exception Message:  " + ioException.InnerException.Message);
                        }
                    }
                    */
                }
                catch (System.Exception dbSave)
                {
                    logger.Debug("An error occurred saving the database changes for hi.Id: " + hi.Id);
                    System.Exception currentException = dbSave;
                    do
                    {
                        logger.Debug("\n {0}", currentException.Message);
                        currentException = currentException.InnerException;
                    } while (currentException != null);

                    logger.Debug("Error: " + dbSave.Message);

                    throw dbSave;
                }
            }
            catch (System.Exception AddHi)
            {
                logger.Debug("Had problems adding Habitat item to database.");
                logger.Debug("hi.Id = " + hi.Id + ", e.Message = " + AddHi.Message);

                db = ServicesContext.RestartCurrent;
                db.Configuration.AutoDetectChangesEnabled = true;
                db.Configuration.ValidateOnSaveEnabled = true;

                //ok, lets try to delete the correspondence event that went bad.
                db.CorrespondenceEvents().Remove(db.CorrespondenceEvents().Find(hi.Id));
                db.SaveChanges();

                logger.Debug("ok so we auto-deleted the Habitat item we created: " + hi.Id);

                throw AddHi; //rethrow so that it'll come back as an error in the client.
            }
            finally
            {
                db.Configuration.AutoDetectChangesEnabled = true;
                db.Configuration.ValidateOnSaveEnabled = true;
            }


            /*
            //check for duplicates.  If it is a duplicate, add it to our list and bail out.
            if (activity.isDuplicate())
            {
                duplicateActivities.Add(activity);
            }
            */


            return Request.CreateResponse(HttpStatusCode.Created, hi);


        }



    }
}