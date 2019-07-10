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
using System.Net.Mail;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Data.SqlClient;
using System.Configuration;

namespace services.Controllers
{
    // this class is a PRIVATE extension of DataActionController. 
    //  it should be excluded from the main CTUIR release of cdms

    [Authorize]
    public class OlcSubProjectController : CDMSController
    {
        // POST /api/v1/olcsubproject/uploadolcsubprojectfile
        public Task<HttpResponseMessage> UploadOlcSubprojectFile()
        {
            logger.Debug("Inside UploadSubprojectFile...");
            logger.Debug("starting to process incoming subproject files.");

            //string strErrorMessage = "";

            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads/subprojects");
            //string prefix = @"";
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToCrppProjectDocuments"] + ("\\uploads\\subprojects");
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            //string root = System.IO.Path.Combine(prefix, strPath);
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
                logger.Debug("P dir already exists...");

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
                logger.Debug("And we think the ProjectId === " + ProjectId);

                Int32 SubprojectId = Convert.ToInt32(provider.FormData.Get("SubprojectId"));
                logger.Debug("And we think the Subprojectid === " + SubprojectId);

                //string strDatastoreTablePrefix = provider.FormData.Get("DatastoreTablePrefix");
                //logger.Debug("And we think the DatastoreTablePrefix = " + strDatastoreTablePrefix);

                Project project = db.Projects.Find(ProjectId);

                Subproject_Olc subproject = db.Subproject_Olc().Find(SubprojectId);

                if (project == null)
                    throw new Exception("Project ID not found: " + ProjectId);

                if (!project.isOwnerOrEditor(me))
                    throw new Exception("Authorization error.");

                if (subproject == null)
                    throw new Exception("Subproject ID not found: " + SubprojectId);

                //if (strDatastoreTablePrefix == null)
                //    throw new Exception("DatastoreTablePrefix not found: " + strDatastoreTablePrefix);

                //If the project/dataset folder does not exist, create it.
                string subprojectPath = root + project.Id + "\\S\\" + subproject.Id;
                //DirectoryInfo datasetDirInfo = new DirectoryInfo(@root);
                DirectoryInfo subprojectDirInfo = new DirectoryInfo(subprojectPath);
                if (!subprojectDirInfo.Exists)
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

                                newFile.Name = info.Name;
                            
                                newFile.Link = System.Configuration.ConfigurationManager.AppSettings["UploadsLinkPrefix"] + "\\P\\" + ProjectId + "\\S\\" + SubprojectId + "\\" + info.Name;



                                newFile.Size = (info.Length / 1024).ToString(); //file.Headers.ContentLength.ToString();
                                newFile.FileTypeId = FileType.getFileTypeFromFilename(info);
                                newFile.UserId = me.Id;
                                newFile.ProjectId = ProjectId;
                                newFile.DatasetId = null; // No datasetId for subproject files.
                                newFile.Subproject_CrppId = SubprojectId;
                                logger.Debug(" Adding file " + newFile.Name + " at " + newFile.Link);

                                files.Add(newFile);
                            
                        }
                        catch (Exception e)
                        {
                            // For BodyPart cleanup, turn this line on.
                            //strErrorMessage = "Error: " + e.ToString();
                            logger.Debug("Error: " + e.ToString());
                            throw e;
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

                
                logger.Debug("Done saving subproject files.");
                var result = JsonConvert.SerializeObject(thefiles);
                HttpResponseMessage resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(result, System.Text.Encoding.UTF8, "text/plain");  //to stop IE from being stupid.

                return resp;
            });

            return task;
        }

        // GET /api/v1/olcsubproject/getolcsubprojectfiles/5
        [System.Web.Http.HttpGet]
        public IEnumerable<Models.File> GetOlcSubprojectFiles(int Id)
        {
            logger.Debug("Inside GetOlcSubprojectFiles...");
            logger.Debug("Fetching Files for Project " + Id);
            var result = new List<Models.File>();

            var ndb = ServicesContext.Current;

            result = (from item in ndb.Files
                      where item.ProjectId == Id
                      where item.Subproject_CrppId != null
                      orderby item.ProjectId, item.Subproject_CrppId
                      select item).ToList();

            return result;
        }

        // GET /api/v1/olcsubproject/getolcsubprojects
        [HttpGet]
        public IEnumerable<Subproject_Olc> GetOlcSubprojects()
        {
            var db = ServicesContext.Current;
            logger.Info("Inside OlcSubProjectController, getting OLC subprojects...");

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
            List<Subproject_Olc> s = (from item in db.Subproject_Olc()
                                       where item.Id > 1
                                       orderby item.EffDt descending
                                       select item).ToList();
            // *****
            logger.Info("Got s");

            foreach (var olce in s)
            {
                //logger.Debug("olce = " + olce.CatalogNumber);
                olce.OlcEvents = olce.OlcEvents.OrderByDescending(x => x.EffDt).ToList();
            }


            return s.AsEnumerable();

            /******************************************/
            // This part works, manually testing the function.
            /*Subproject sTest = new Subproject();
            sTest.Id = 1;
            sTest.ProjectName = "PN1";
            sTest.Agency = "A1";
            sTest.ProjectProponent = "PP1";
            sTest.TrackingNumber = "TN1";
            sTest.ActionNeeded = "AN1";
            sTest.YearDate = "20160304_103015";
            sTest.Closed = "No";
            sTest.EffDt = DateTime.Now;
            sTest.ByUserId = 1081;

            List<Subproject> sp = new List<Subproject>();
            sp.Add(sTest);

            return sp.AsEnumerable();
            */
            /******************************************/
        }

        // POST /api/v1/olcsubproject/queryolcsubprojectsforsearch
        [HttpPost]
        public DataTable QueryOlcSubprojectsForSearch(JObject jsonData)
        {
            var db = ServicesContext.Current;
            logger.Info("Inside OlcSubProjectController, getting OLC subprojects...");

            //List<Subproject_Olc> s = (from item in db.Subproject_Olc()
            //                          where item.Id > 1
            //                          orderby item.EffDt descending
            //                          select item).ToList();

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                string query = "SELECT * FROM dbo.OlcSubprojectsAndEvents_vw where SubprojectId > 1";
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.CommandTimeout = 120; // 2 minutes in seconds.

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.SelectCommand.CommandTimeout = 120;
                da.Fill(dt);
            }

            return dt;
        }

        // POST /api/v1/olcsubproject/deleteolceventfile
        [HttpPost]
        public HttpResponseMessage DeleteOlcEventFile(JObject jsonData)
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
            int olcEventId = json.OlceId.ToObject<int>();
            logger.Debug("olcEventId = " + olcEventId);

            services.Models.File existing_file = json.File.ToObject<services.Models.File>();
            logger.Debug("Obtained file from input data...");
            logger.Debug("existing_file.Name = " + existing_file.Name);

            /*if (existing_file == null)
                throw new System.Exception("File not found.");
            else
                logger.Debug("The file exists.");
             */

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToCrppProjectDocuments"] + ("\\uploads\\subprojects");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToCrppProjectDocuments"];
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
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

            int numFiles = (from f in db.Files
                            where f.ProjectId == project.Id && f.Subproject_CrppId == subprojectId && f.Name == existing_file.Name
                            select f).Count();

            if (numFiles > 0)
            {
                var fileToDelete = (from f in db.Files
                                    where f.ProjectId == project.Id && f.Subproject_CrppId == subprojectId && f.Name == existing_file.Name
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

        //POST /api/v1/olcsubproject/removecrppsubproject
        [HttpPost]
        public HttpResponseMessage RemoveOlcSubproject(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            User me = AuthorizationManager.getCurrentUser();
            Project p = db.Projects.Find(json.ProjectId.ToObject<int>());

            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");

            Subproject_Olc olcSubproject = db.Subproject_Olc().Find(json.SubprojectId.ToObject<int>());
            if (p == null || olcSubproject == null)
                throw new System.Exception("Configuration error.  Please try again.");

            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            logger.Debug("root = " + root);

            string strSubprojectsPath = root + p.Id + "\\S\\" + olcSubproject.Id;
            logger.Debug("The path for the subproject is:  " + strSubprojectsPath);

            if (Directory.Exists(strSubprojectsPath))
            {
                System.IO.Directory.Delete(strSubprojectsPath, true);
                logger.Debug("Just deleted documents folder and contents for this subproject:  " + olcSubproject.Id);
            }
            else
            {
                logger.Debug("Could not find folder: " + strSubprojectsPath);
            }

            //Now we can remove the Subproject itself.
            db.Subproject_Olc().Remove(olcSubproject);
            logger.Debug("Just removed this subproject from table OlcSubprojects:  " + olcSubproject.Id);

            //db.CrppSubprojects.State = EntityState.Modified;
            db.SaveChanges();
            logger.Debug("Changes saved...");

            return new HttpResponseMessage(HttpStatusCode.OK);

        }

        // POST /api/v1/olcsubproject/removeolcevent
        [HttpPost]
        public HttpResponseMessage RemoveOlcEvent(JObject jsonData)
        {
            logger.Debug("Inside RemoveOlcEvent...");

            var db = ServicesContext.Current;
            logger.Debug("Set database...");

            dynamic json = jsonData;
            //logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();
            Project p = db.Projects.Find(json.ProjectId.ToObject<int>());
            logger.Debug("ProjectId = " + p.Id);

            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");

            Subproject_Olc subproject = db.Subproject_Olc().Find(json.SubprojectId.ToObject<int>());
            if (p == null || subproject == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("olcSubprojectId = " + subproject.Id);

            OlcEvents olcEvent = db.OlcEvents().Find(json.OlcEventId.ToObject<int>());
            if (p == null || olcEvent == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("olcEvent = " + olcEvent.Id);

            //string strDatastoreTablePrefix = json.DatastoreTablePrefix.ToObject<string>();

            var files_in_subproject = (from file in db.Files
                                       where file.ProjectId == p.Id
                                       where file.Subproject_CrppId == subproject.Id
                                       select file).ToList();

            logger.Debug("Got files_in_subproject...count = " + files_in_subproject.Count);

            //iterate potential files for match to delete
            foreach (var file in files_in_subproject)
            {
                //olcEvent.FileAttach is a JSON string of filenames that belong to this item. If we match, delete this one.
                if (olcEvent.FileAttach != null && olcEvent.FileAttach.Contains("\"" + file.Name + "\"")) //use "somefile.jpg" so that we don't delete: mysomefile.jpg
                {
                    // First, delete the file from the disk.
                    logger.Debug("Found the file...");
                    //removes the File and the actual filesystem file
                    Resources.SubprojectFileHelper.DeleteSubprojectFile(file, p.Id, subproject.Id);
                    logger.Debug("Deleted the file...");

                    // Next, delete the file from dbo.Files.
                    //open a raw database connection...
                    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
                    {
                        con.Open();

                        var query = "DELETE FROM dbo.Files WHERE ProjectId = " + p.Id + " AND Subproject_CrppId = " + subproject.Id + " AND Name = '" + file.Name + "'";
                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            logger.Debug(query);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            db.OlcEvents().Remove(olcEvent);
            logger.Debug("Just removed this event from table OlcEvent:  " + olcEvent.Id);

            //db.CrppSubprojects.State = EntityState.Modified;
            db.SaveChanges();
            logger.Debug("Changes saved...");

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        // POST /api/v1/olcsubproject/saveolcsubproject
        [HttpPost]
        //public HttpResponseMessage SaveSubproject(JObject jsonData)
        public HttpResponseMessage SaveOlcSubproject(JObject jsonData)
        //public int SaveSubproject(JObject jsonData)
        {
            logger.Debug("Inside SaveOlcSubproject...");
            var db = ServicesContext.Current;
            logger.Debug("db = " + db);

            dynamic json = jsonData;
            logger.Debug("json = " + json);

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

            Subproject_Olc s = json.Subproject.ToObject<Subproject_Olc>();

            logger.Debug("Found Subproject in incoming data...");


            logger.Debug(
                //"s.CatalogNumber = " + s.CatalogNumber + "\n" +
                "s.Agency = " + s.Agency + "\n" +
                "s.AgencyLocation = " + s.AgencyLocation + "\n" +
                "s.RecordGroup = " + s.RecordGroup + "\n" +
                "s.SeriesTitle = " + s.SeriesTitle + "\n" +
                "s.FacilityHoused = " + s.FacilityHoused + "\n" +
                "s.OtherFacilityHoused = " + s.OtherFacilityHoused + "\n" +
                "s.Box = " + s.Box + "\n" +
                //"s.BoxLocation = " + s.BoxLocation + "\n" +
                "s.CategoryTitle = " + s.CategoryTitle + "\n" +
                //"s.CategoryIndex = " + s.CategoryIndex + "\n" +
                "s.CategorySubtitle = " + s.CategorySubtitle + "\n" +
                //"s.SignatoryTitle = " + s.SignatoryTitle + "\n" +
                //"s.SignatoryAgency = " + s.SignatoryAgency + "\n" +
                //"s.SignatoryName = " + s.SignatoryName + "\n" +
                "s.EffDt = " + s.EffDt + "\n" +
                "s.ByUserId = " + s.ByUserId + "\n"
                );

            s.EffDt = DateTime.Now;
            logger.Debug("Set s.EffDt = " + s.EffDt);

            s.ByUserId = me.Id;
            logger.Debug("s.ByUserId = " + s.ByUserId);

            /* Note:  Up above, we created a subproject, in which put all the incoming data.
             * However, since that item is not "tied" to an item in the database, it can only 
             * be used to add a new record.
             * If we wish to edit an existing record, we must locate that record, and poke the stuff
             * If we wish to edit an existing record, we must locate that record, and poke the stuff
             * we just pulled in into that existing record.
             * Otherwise, if we try to edit a record, even though we have the ID of an existing record,
             * the system will give a weird error like this:
             * "Attaching an entity of type 'services.Models.User' failed because another entity of the same type already has the same primary key value"
             * So, create a new variable for the existing record in the database, go and fined it, then put the incoming data into it.
             * Then when we save.
             */
            logger.Debug("s.Id = " + s.Id);
            if (s.Id == 0)
            {
                logger.Debug("About to add new subproject...");
                db.Subproject_Olc().Add(s);
                logger.Debug("created new subproject");
            }
            else
            {
                logger.Debug("About to update subproject...");
                try
                {
                    Subproject_Olc s2 = db.Subproject_Olc().Find(s.Id);

                    //s2.CatalogNumber = s.CatalogNumber;
                    s2.Agency = s.Agency;
                    s2.AgencyLocation = s.AgencyLocation;
                    s2.RecordGroup = s.RecordGroup;
                    s2.SeriesTitle = s.SeriesTitle;
                    s2.FacilityHoused = s.FacilityHoused;
                    s2.OtherFacilityHoused = s.OtherFacilityHoused;
                    s2.Box = s.Box;
                    //s2.BoxLocation = s.BoxLocation;
                    s2.CategoryTitle = s.CategoryTitle;
                    //s2.CategoryIndex = s.CategoryIndex;
                    s2.CategorySubtitle = s.CategorySubtitle;
                    //s2.SignatoryTitle = s.SignatoryTitle;
                    //s2.SignatoryAgency = s.SignatoryAgency;
                    //s2.SignatoryName = s.SignatoryName;
                    s2.EffDt = s.EffDt;
                    s2.ByUserId = s.ByUserId;

                    //db.Entry(s).State = EntityState.Modified;
                    db.Entry(s2).State = EntityState.Modified;
                }
                catch (System.Exception e)
                {
                    logger.Debug("Exception:  " + e.Message + ", " + e.InnerException);
                }
                //db.Entry(s).Property("UpdateTime").IsModified = true;
                logger.Debug("updated existing subproject");
            }

            db.SaveChanges();
            logger.Debug("Just saved the DB changes.");

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads/subprojects");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToCrppProjectDocuments"] + ("\\uploads\\subprojects");
            //string root = System.Configuration.ConfigurationManager.AppSettings["PathToCrppProjectDocuments"];
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\" + p.Id + "\\S\\";
            logger.Debug("root = " + root);

            //string strSubprojectsPath = root + "\\" + s.Id;
            string strSubprojectsPath = root + s.Id;
            logger.Debug("The path for the new subproject will be:  " + strSubprojectsPath);

            System.IO.Directory.CreateDirectory(strSubprojectsPath);
            logger.Debug("Just created folder for the new subproject:  " + s.Id);

            int newId = s.Id;
            logger.Debug("newId = " + s.Id);

            //return new HttpResponseMessage(HttpStatusCode.OK);
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, s);
            return response;
        }

        // POST /api/v1/olcsubproject/saveolcevent
        [HttpPost]
        public HttpResponseMessage SaveOlcEvent(JObject jsonData)
        {
            logger.Debug("Inside SaveOlcEvent...");
            string strId = null;  // Delare this up here, so that all if/try blocks can see it.
            string strTmp = "";

            var db = ServicesContext.Current;
            logger.Debug("db = " + db);

            dynamic json = jsonData;
            logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();
            //logger.Debug("me = " + me); // getCurrentUser displays the username; this is just machinestuff.

            int pId = json.ProjectId.ToObject<int>();
            logger.Debug("pId = " + pId);

            Project p = db.Projects.Find(pId);
            logger.Debug("p = " + p);
            if (p == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("p.isOwnerOrEditor(me) = " + p.isOwnerOrEditor(me));
            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");

            int sId = json.SubprojectId.ToObject<int>();
            logger.Debug("sId = " + sId);

            OlcEvents olcEvent = new OlcEvents();

            logger.Debug("About to check incoming data for Event item...");


            // Spin through the fields passed in; as we find the fields, we will capture the data.
            foreach (var item in json.OlcEvent)
            {
                logger.Debug("Inside foreach loop");
                //int newSubprojectId = 0;

                if (!(item is JProperty))
                {
                    throw new System.Exception("There is a problem with your request. Format error.");
                }

                var prop = item as JProperty;
                logger.Debug("Property name = " + prop.Name);

                //try
                //{
                //    strTmp = item.ToObject<string>(); // We will use to determine if the value is blank, regardless of what the ultimate value is.
                //    logger.Debug("strTmp = " + strTmp);
                //}
                //catch (Exception e)
                //{
                //    logger.Debug("Hmm -- couldn't convert this to a string: " + prop.Name + " ... this is probably fine.");
                    //logger.Debug(e);
                //}

                dynamic subproject_json = prop.Value;
                logger.Debug("Property value = " + subproject_json);

                //if (prop.Name == "SubprojectId")
                //    olcEvent.SubprojectId = sId;
                if (prop.Name == "Id")
                    olcEvent.Id = subproject_json;
                else if (prop.Name == "DocumentType")
                    olcEvent.DocumentType = subproject_json;
                else if (prop.Name == "DocumentDate")
                    olcEvent.DocumentDate = subproject_json;
                else if (prop.Name == "FileName")
                    olcEvent.FileName = subproject_json;
                else if (prop.Name == "Author")
                    olcEvent.Author = subproject_json;
                //else if (prop.Name == "AuthorAgency")
                //    olcEvent.AuthorAgency = subproject_json;
                else if (prop.Name == "AgencyDivision")
                    olcEvent.AgencyDivision = subproject_json;
                else if (prop.Name == "SignatoryName")
                    olcEvent.SignatoryName = subproject_json;
                else if (prop.Name == "SignatoryTitle")
                    olcEvent.SignatoryTitle = subproject_json;
                else if (prop.Name == "RecipientName")
                    olcEvent.RecipientName = subproject_json;
                else if (prop.Name == "RecipientTitle")
                    olcEvent.RecipientTitle = subproject_json;
                else if (prop.Name == "RecipientAgency")
                    olcEvent.RecipientAgency = subproject_json;
                else if (prop.Name == "RecipientLocation")
                    olcEvent.RecipientLocation = subproject_json;
                else if (prop.Name == "Boundary")
                {
                    logger.Debug("Boundary = " + subproject_json);

                    olcEvent.Boundary = subproject_json;
                    logger.Debug("olcEvent.Boundary = " + olcEvent.Boundary);
                }
                else if (prop.Name == "OtherBoundary")
                {
                    logger.Debug("OtherBoundary = " + subproject_json);

                    olcEvent.OtherBoundary = subproject_json;
                    logger.Debug("olcEvent.OtherBoundary = " + olcEvent.OtherBoundary);
                }
                else if (prop.Name == "SignificantArea")
                {
                    logger.Debug("SignificantArea = " + subproject_json);

                    olcEvent.SignificantArea = subproject_json;
                    logger.Debug("olcEvent.SignificantArea = " + olcEvent.SignificantArea);
                }
                else if (prop.Name == "MiscellaneousContext")
                {
                    logger.Debug("MiscellaneousContext = " + subproject_json);

                    olcEvent.MiscellaneousContext = subproject_json;
                    logger.Debug("olcEvent.MiscellaneousContext = " + olcEvent.MiscellaneousContext);
                }
                else if (prop.Name == "SurveyNumber")
                    olcEvent.SurveyNumber = subproject_json;
                else if (prop.Name == "SurveyContractNumber")
                    olcEvent.SurveyContractNumber = subproject_json;
                else if (prop.Name == "SurveyorName")
                    olcEvent.SurveyorName = subproject_json;
                else if (prop.Name == "SurveyAuthorizingAgency")
                    olcEvent.SurveyAuthorizingAgency = subproject_json;
                else if (prop.Name == "SurveyDates")
                    olcEvent.SurveyDates = subproject_json;
                else if (prop.Name == "Description")
                    olcEvent.Description = subproject_json;
                else if (prop.Name == "TwnRngSec")
                    olcEvent.TwnRngSec = subproject_json;
                else if (prop.Name == "NumberItems")
                    olcEvent.NumberItems = subproject_json;
                else if (prop.Name == "DateDiscovered")
                    olcEvent.DateDiscovered = subproject_json;
                else if (prop.Name == "PersonDiscovered")
                    olcEvent.PersonDiscovered = subproject_json;
                else if (prop.Name == "Reference")
                    olcEvent.Reference = subproject_json;
                //else if (prop.Name == "EventComments")
                //    olcEvent.EventComments = subproject_json;
                else if (prop.Name == "Tasks")
                    olcEvent.Tasks = subproject_json;
                else if (prop.Name == "FileAttach")
                {
                        olcEvent.FileAttach = subproject_json;
                }
            }

            olcEvent.SubprojectId = sId;

            olcEvent.EffDt = DateTime.Now;
            logger.Debug("Set olcEvent.EffDt = " + olcEvent.EffDt);

            olcEvent.ByUserId = me.Id;
            logger.Debug("Set olcEvent.ByUserId = " + olcEvent.ByUserId);

            logger.Debug(
                "olcEvent.Id = " + olcEvent.Id + "\n" +
                "olcEvent.SubprojectId = " + olcEvent.SubprojectId + "\n" +
                "olcEvent.DocumentType = " + olcEvent.DocumentType + "\n" +
                "olcEvent.DocumentDate = " + olcEvent.DocumentDate + "\n" +
                "olcEvent.FileName = " + olcEvent.FileName + "\n" +
                "olcEvent.Author = " + olcEvent.Author + "\n" +
                //"olcEvent.AuthorAgency = " + olcEvent.AuthorAgency + "\n" +
                "olcEvent.AgencyDivision = " + olcEvent.AgencyDivision + "\n" +
                "olcEvent.SignatoryName = " + olcEvent.SignatoryName + "\n" +
                "olcEvent.SignatoryTitle = " + olcEvent.SignatoryTitle + "\n" +
                "olcEvent.RecipientName = " + olcEvent.RecipientName + "\n" +
                "olcEvent.RecipientTitle = " + olcEvent.RecipientTitle + "\n" +
                "olcEvent.RecipientAgency = " + olcEvent.RecipientAgency + "\n" +
                "olcEvent.RecipientLocation = " + olcEvent.RecipientLocation + "\n" +
                "olcEvent.Boundary = " + olcEvent.Boundary + "\n" +
                "olcEvent.OtherBoundary = " + olcEvent.OtherBoundary + "\n" +
                "olcEvent.SignificantArea = " + olcEvent.SignificantArea + "\n" +
                "olcEvent.MiscellaneousContext = " + olcEvent.MiscellaneousContext + "\n" +
                "olcEvent.SurveyNumber = " + olcEvent.SurveyNumber + "\n" +
                "olcEvent.SurveyContractNumber = " + olcEvent.SurveyContractNumber + "\n" +
                "olcEvent.SurveyorName = " + olcEvent.SurveyorName + "\n" +
                "olcEvent.SurveyAuthorizingAgency = " + olcEvent.SurveyAuthorizingAgency + "\n" +
                "olcEvent.SurveyDates = " + olcEvent.SurveyDates + "\n" +
                "olcEvent.Description = " + olcEvent.Description + "\n" +
                "olcEvent.TwnRngSec = " + olcEvent.TwnRngSec + "\n" +
                "olcEvent.NumberItems = " + olcEvent.NumberItems + "\n" +
                "olcEvent.DateDiscovered = " + olcEvent.DateDiscovered + "\n" +
                "olcEvent.PersonDiscovered = " + olcEvent.PersonDiscovered + "\n" +
                "olcEvent.Reference = " + olcEvent.Reference + "\n" +
                //"olcEvent.EventComments = " + olcEvent.EventComments + "\n" +
                "olcEvent.Tasks = " + olcEvent.Tasks + "\n" +
                "olcEvent.EffDt = " + olcEvent.EffDt + "\n" +
                "olcEvent.ByUserId = " + olcEvent.ByUserId + "\n"
                );

            if (olcEvent.Id == 0)
            {
                logger.Debug("About to add new Event item...");
                db.OlcEvents().Add(olcEvent);
                logger.Debug("created new Event item...");

                db.SaveChanges();
                logger.Debug("Added Event item to the db...");
            }
            else
            {
                logger.Debug("About to update Event item...");
                db.Entry(olcEvent).State = EntityState.Modified;
                //db.Entry(s).Property("UpdateTime").IsModified = true;

                db.SaveChanges();
                logger.Debug("updated existing Event item...");

            }

            logger.Debug("Just saved the DB changes.");

            int newId = olcEvent.Id;
            logger.Debug("newId = " + olcEvent.Id);

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, olcEvent);
            return response;

        }

        // POST /api/v1/olcsubproject/migrateolcevent
        [HttpPost]
        public HttpResponseMessage MigrateOlcEvent(JObject jsonData)
        {
            logger.Debug("Inside MigrateOlcEvent...");

            var db = ServicesContext.Current;
            logger.Debug("db = " + db);

            dynamic json = jsonData;
            logger.Debug("json = " + json);

            User me = AuthorizationManager.getCurrentUser();
            //logger.Debug("me = " + me); // getCurrentUser displays the username; this is just machinestuff.

            int pId = json.ProjectId.ToObject<int>();
            logger.Debug("pId = " + pId);

            Project p = db.Projects.Find(pId);
            logger.Debug("p = " + p);
            if (p == null)
                throw new System.Exception("Configuration error.  Please try again.");

            logger.Debug("p.isOwnerOrEditor(me) = " + p.isOwnerOrEditor(me));
            if (!p.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error.");

            int sId = json.SubprojectId.ToObject<int>();
            logger.Debug("sId = " + sId);

            string strFileNames = json.FileNames.ToObject<string>();
            logger.Debug("strFileNames = " + strFileNames);

            int intCurrentEventId = -1;
            int intNewEventId = -1;
            int intMoveToSubprojectId = -1;
            string strFileAttach = "";

            // Spin through the fields passed in; as we find the fields, we will capture the data.
            foreach (var item in json.OlcEvent)
            {
                //logger.Debug("Inside foreach loop");

                if (!(item is JProperty))
                {
                    throw new System.Exception("There is a problem with your request. Format error.");
                }

                var prop = item as JProperty;
                //logger.Debug("Property name = " + prop.Name);

                dynamic event_json = prop.Value;
                //logger.Debug("Property value = " + event_json);
                //logger.Debug("Property type = " + prop.Type);

                if (prop.Name == "Id")
                {
                    intCurrentEventId = event_json;
                    logger.Debug("Got the current event Id:  " + intCurrentEventId);
                }
                else if (prop.Name == "ToSourceId")
                {
                    intMoveToSubprojectId = event_json;
                    logger.Debug("Got the subproject Id that we are moving this event to:  " + intMoveToSubprojectId);
                }

            }

            string strCurrentFilePath = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\" + pId + "\\S\\" + sId;
            string strCurrentFilePathWithName = "";

            string strNewFilePath = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\" + pId + "\\S\\" + intMoveToSubprojectId;
            logger.Debug("The new path for the new subproject is:  " + strNewFilePath);
            string strNewFilePathWithName = "";

            string strNewFileLinks = "";

            string[] aryFileNameList = strFileNames.Split(',');

            string strFileLinks = "";
            int intCount = 0;
            foreach (var strFileName in aryFileNameList)
            {
                if (intCount == 0)
                    strNewFileLinks += strNewFilePath + "\\" +strFileName;
                else
                    strNewFileLinks += "," + strNewFilePath + "\\" + strFileName;

                var TheFileInfo = new
                {
                    Name = strFileName,
                    Link = strNewFileLinks
                };


                if (intCount == 0)
                    strFileLinks += JsonConvert.SerializeObject(TheFileInfo);
                else
                    strFileLinks += "," + JsonConvert.SerializeObject(TheFileInfo);
                intCount++;
            }
            //logger.Debug("strNewFileLinks = " + strNewFileLinks);
            strFileLinks = "[" + strFileLinks + "]";
            logger.Debug("strFileLinks = " + strFileLinks);

            
            logger.Debug("Got the info we need, now to reassign the event and update the link...");

            intCount = 0;
            //open a raw database connection...
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();

                var query = "UPDATE dbo.OlcEvents set SubprojectId = " + intMoveToSubprojectId + ", FileAttach = '" + strFileLinks + "' where [Id] = " + intCurrentEventId;
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    logger.Debug(query);
                    cmd.ExecuteNonQuery();
                }

                string strfLink = "";

                foreach (var strFileName in aryFileNameList)
                {
                    strfLink = strNewFilePath + "\\" + strFileName;
                    
                    query = "UPDATE dbo.Files set Subproject_CrppId = " + intMoveToSubprojectId + ", Link = '" + strfLink + "' where Subproject_CrppId = " + sId + " AND [Name] = '" + strFileName + "'";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        logger.Debug(query);
                        cmd.ExecuteNonQuery();
                        //logger.Debug("Executed sql command...");
                    }
                }
            }

            logger.Debug("OK, we updated the link, now to move the file from the old subproject folder to the updated...");

            HttpResponseMessage resp = new HttpResponseMessage();
            foreach (var strFileName in aryFileNameList)
            {
                strCurrentFilePathWithName = strCurrentFilePath + "\\" + strFileName;
                strNewFilePathWithName = strNewFilePath + "\\" + strFileName;

                if (System.IO.File.Exists(strNewFilePathWithName))
                {
                    //logger.Debug("File move error:  The file - " + strNewFilePathWithName + " - already exists in the new destination folder; skipping...");
                    throw new Exception("File move error:  The file - " + strNewFilePathWithName + " - already exists in the new destination folder");
                }
                else
                    resp = FileController.MoveFile(strCurrentFilePathWithName, strNewFilePathWithName);
            }
            

            //HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, olcEvent);
            return resp;

            //return new HttpResponseMessage(HttpStatusCode.OK);
        }

        //private void SendEmailToProjectLead(string projectLeadUsername, string projectLeadFullName, string projectName, string updatingPerson)
        private void SendEmailToProjectLead(string projectLeadUsername, string projectLeadFullName, string projectName, string updatingPerson,
        DateTime? responseDate, int numberOfDays)
        {
            logger.Debug("**********Inside SendEmailToProjectLead...**********");
            logger.Debug("projectLeadUsername = " + projectLeadUsername);
            logger.Debug("projectLeadFullName = " + projectLeadFullName);
            logger.Debug("projectName = " + projectName);
            logger.Debug("updatingPerson = " + updatingPerson);

            string strStatus = null;
            string strProjectLeadEmail = null;
            bool foundEmail = false;
            bool foundUsername = false;
            bool blnDoesUserExist = false;

            //String adConnectionString = WebConfigurationManager.ConnectionStrings["ADConnectionString"].ConnectionString;
            //logger.Debug("ContextType.Domain = " + ContextType.Domain);

            //logger.Debug("Environment.UserDomainName = " + Environment.UserDomainName);
            // If we get the Environment.UserDomainName from the system, it returns IIS APPPOOL, but we need it to be MAILCOMM.
            // Therefore, we just set it that way.

            if (DoesUserExist(projectLeadUsername))
            {
                blnDoesUserExist = true;
            }

            if (blnDoesUserExist)
            {
                logger.Debug("Checking Active Directory for the user's email address...");
                using (var context = new PrincipalContext(ContextType.Domain, "MAILCOMM"))
                {
                    //logger.Debug("Created context...");
                    using (var searcher = new PrincipalSearcher(new UserPrincipal(context)))
                    {
                        //logger.Debug("Created searcher...");
                        foreach (var result in searcher.FindAll())
                        {
                            string strResult = result.ToString();
                            strResult = strResult.Trim();

                            if (strResult.Equals(projectLeadFullName))
                            {
                                DirectoryEntry de = result.GetUnderlyingObject() as DirectoryEntry;
                                System.DirectoryServices.PropertyCollection pc = de.Properties;
                                int theCount = 0;
                                logger.Debug("projectLeadUsername = " + projectLeadUsername);
                                foreach (PropertyValueCollection col in pc)
                                {
                                    //rtxStatusText.AppendText("Checking property name, looking for sAMAccountName...\n");
                                    //logger.Debug(col.PropertyName + " : " + col.Value);
                                    if ((col.PropertyName.Equals("sAMAccountName")) && (col.Value.Equals(projectLeadUsername)))
                                    {
                                        logger.Debug("*********************Found username:  " + projectLeadUsername);
                                        foundUsername = true;
                                        strStatus = "Success";
                                    }
                                    else if (col.PropertyName.Equals("mail"))
                                    {
                                        logger.Debug("*********************Found email:  " + col.Value);
                                        strProjectLeadEmail = col.Value.ToString();
                                        foundEmail = true;
                                        strStatus = "Success";
                                    }
                                    theCount++;

                                    if (foundUsername && foundEmail)
                                        break;
                                }
                                if ((theCount > 0) && (String.IsNullOrEmpty(strStatus)))
                                {
                                    strStatus = "Failed to find user.";
                                    logger.Debug(strStatus);
                                }
                            } // if strResult
                            if (foundUsername && foundEmail)
                                break;
                        } // foreach result
                    } // using searcher
                } // using context
            }

            //logger.Debug("strProjectLeadEmail = " + strProjectLeadEmail);

            /***** Leaving this in place, but commenting out for now. *****
            //***CREATE AN APPOINTMENT WITH REMINDER****
            Microsoft.Office.Interop.Outlook.Application olApp = null;
            Microsoft.Office.Interop.Outlook.AppointmentItem appointment = null;

            olApp = new Microsoft.Office.Interop.Outlook.Application();

            if (responseDate != null)
            {
                try
                {
                    appointment = (Microsoft.Office.Interop.Outlook.AppointmentItem)olApp.CreateItem(Microsoft.Office.Interop.Outlook.OlItemType.olAppointmentItem);
                    //Microsoft.Office.Interop.Outlook.AppointmentItem appt = (Microsoft.Office.Interop.Outlook.AppointmentItem)appointment;

                    appointment.Subject = "Reminder for Response";
                    //appt.Subject = "Reminder for Response";

                    appointment.Body = "Project " + projectName + " needs a response.";
                    //appt.Body = "Project " + projectName + " needs a response.";

                    DateTime apptStart = (System.DateTime) responseDate;
                    apptStart.AddHours(8);
                    appointment.Start = apptStart;
                    //appt.Start = apptStart;

                    DateTime apptEnd = apptStart;
                    apptEnd.AddHours(1);
                    appointment.End = apptEnd;
                    //appt.End = apptEnd;

                    appointment.ReminderSet = true;
                    //appt.ReminderSet = true;

                    appointment.ReminderMinutesBeforeStart = 10080; // 7 days in minutes = (60 * 24 * 7)
                    //appt.ReminderMinutesBeforeStart = 10080; // 7 days in minutes = (60 * 24 * 7)

                    appointment.Importance = OlImportance.olImportanceHigh;
                    //appt.Importance = OlImportance.olImportanceHigh;

                    appointment.Save();
                    //appt.Save();

                    // Note:  Within the next few lines, some are marked at the end with //*.
                    // The compiler does not like these lines, saying 
                    // Ambiguity between method Microsoft.Office.Interop.Outlook._AppointmentItem.Send() 
                    // and non-method Microsoft.Office.Interop.Outlook.ItemEvents_10_Event.Send.  Using method group.
                    //

                    //appointment.Send(); //*
                    //appt.Send(); //*

                    Microsoft.Office.Interop.Outlook._MailItem mailItem = appointment.ForwardAsVcal();
                    mailItem.To = strProjectLeadEmail;
                    //((Microsoft.Office.Interop.Outlook._MailItem)mailItem).Send(); //*
                    mailItem.Send();

                }
                catch (System.Exception e)
                {
                    logger.Debug("Had a problem creating/sending the reminder:  " + e.Message + ",\n" + e.InnerException);
                }
            }
             */


            //***CREATE NEW MAIL MESSAGE****
            MailMessage message = new MailMessage();

            //***SET TO AND FROM MAIL PROPERTIES****
            //message.To.Add(new MailAddress(strProjectLeadEmail));  // Real email address.
            if (blnDoesUserExist && isProduction())
                message.To.Add(new MailAddress(strProjectLeadEmail));  // Real email address.
            else
                message.To.Add(new MailAddress(System.Configuration.ConfigurationManager.AppSettings["CrppDefaultEmail"]));  // Real email address.

            message.From = new MailAddress("NO-Reply@ctuir.org");
            //message.To.Add(new MailAddress("GeorgeClark@ctuir.org")); // Test email address.
            //message.From = new MailAddress("GeorgeClark@ctuir.org");

            //'***SET MAIL FORMAT TO HTML****
            message.IsBodyHtml = true;

            //***SET MAIL SUBJECT****
            string strSubject = "New or Updated  Correspondence Event for project named " + projectName;
            message.Subject = strSubject;

            //***SET MAIL BODY****
            //string strEmailBody = "<strong><font color=#000099>Project " + projectName + " was updated by " + updatingPerson + "." +
            //    "</font></strong><br><br>Courtesy email from the CDMS system...";
            string strEmailBody = "";
            if (blnDoesUserExist)
            {
                strEmailBody = "<strong><font color=#000099>Project " + projectName + " was updated by " + updatingPerson + "." +
                "</font></strong><br><br>Courtesy email from the CDMS system...";
            }
            else
            {
                strEmailBody = "<strong><font color=#ff0000>Project Lead " + projectLeadFullName + " is no longer with CTUIR.</font></strong>" +
                                "<br><br>" +
                                "<strong><font color=#000099>Project " + projectName + " was updated by " + updatingPerson + "." + "</font></strong>" +
                                "<br><br>Courtesy email from the CDMS system...";
            }
            message.Body = strEmailBody;

            //***DECLARE SMTP CLIENT FOR MAIL SEND****
            SmtpClient client = new SmtpClient();

            //***SPECIFIY SMTP LOCAL SERVER****
            client.Host = "ctuir-exchg01.mailcomm.ctuir.com";

            try
            {
                client.Send(message);
                logger.Debug("Just sent email to project lead.");
                //return "Success";
            }
            catch (System.Exception e)
            {
                string strPath = Directory.GetCurrentDirectory() + "\\";
                string strApp = "SendEmailToProjectLead:  ";
                string strError = e.Message;
                string strMessage = strPath + strApp + strError;
                logger.Debug(strMessage);
                //return "Failed";
            }
            client.Dispose();
        }

        public bool DoesUserExist(string userName)
        {
            using (var domainContext = new PrincipalContext(ContextType.Domain, "MAILCOMM"))
            {
                using (var foundUser = UserPrincipal.FindByIdentity(domainContext, IdentityType.SamAccountName, userName))
                {
                    return foundUser != null;
                }
            }
        }

    }
}