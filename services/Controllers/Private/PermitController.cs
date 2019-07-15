using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using services.ExtensionMethods;
using services.Models;
using services.Models.Data;
using services.Resources;
using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace services.Controllers.Private
{
    [System.Web.Http.Authorize]
    public class PermitController : CDMSController
    {

        public static string ROLE_REQUIRED = "Permits";

        [HttpGet]
        public dynamic AllPermits()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            //return db.Permit().AsEnumerable(); <-- not as fast as a direct sql... 


            var sql = @"select * from Permits order by ApplicationDate desc";

            DataTable requests = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(requests);
                }
            }

            return requests;

        }

        [HttpGet]
        public dynamic RoutingPermits()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.Permit().Where(o => o.PermitStatus == "Under Review" || o.PermitStatus == "New Application").OrderByDescending(o => o.ApplicationDate).AsEnumerable();

        }


        [HttpGet]
        public dynamic InspectionPermits()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.Permit().Where(o => o.PermitStatus == "Approved" || o.PermitStatus == "Conditionally Approved").OrderByDescending(o => o.ApplicationDate).AsEnumerable();

        }


        [HttpGet]
        public dynamic AllParcels()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.PermitCadasterView().OrderBy(o => o.ParcelId).AsEnumerable();

        }
        

                [HttpGet]
        public dynamic GetPermitContacts(int Id)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.PermitContacts().Where(o => o.PermitId == Id).AsEnumerable();

        }

        [HttpGet]
        public dynamic GetPermitParcels(int Id)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.PermitParcels().Where(o => o.PermitId == Id).AsEnumerable();

        }

        [HttpGet]
        public dynamic GetRelatedParcels(string ParcelId )
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            //permits with matching parcelids
            List<int> parcels = db.PermitParcels().Where(o => o.ParcelId == ParcelId).Select(o => o.PermitId).ToList<int>();
            return db.Permit().Where(o => parcels.Contains(o.Id)).AsEnumerable();

        }


        [HttpGet]
        public dynamic GetPermitEvents(int Id)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.PermitEvents().Where(o => o.PermitId == Id).AsEnumerable();

        }


        [HttpGet]
        public dynamic GetAllPermitPersons()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.PermitPerson().AsEnumerable();

        }

        [HttpGet]
        public dynamic GetOutstandingRequests()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            var sql = @"select p.PermitNumber, p.ProjectName, p.ReviewedBy, pe.EventType, pe.ItemType, pe.RequestDate 
            from permits p
            join permitevents pe on pe.PermitId = p.Id
            where
            pe.ResponseDate is null
            and pe.EventType in ('Review', 'Inspection')";

            DataTable requests = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(requests);
                }
            }

            return requests;

        }

        [HttpGet]
        public dynamic GetExpiringPermits()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            var sql = @"select p.PermitNumber, p.ProjectName, p.ReviewedBy, p.ExpireDate, 
            (select max(RequestDate) from PermitEvents where PermitId = p.Id) as RequestDate,
            (select max(ResponseDate) from PermitEvents where PermitId = p.Id) as ResponseDate
            from permits p
            where p.ExpireDate < dateadd(dd,30,getDate())";

            DataTable expires = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(expires);
                }
            }

            return expires;

        }

        
        [HttpGet]
        public dynamic GetPermitStatistics()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            var sql = @"select PermitStatus, count(*) as TotalCount from permits group by PermitStatus";

            DataTable stats = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(stats);
                }
            }

            return stats;

        }


        [HttpGet]
        public dynamic GetPermitFiles(int ProjectId, int PermitId)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.Files.Where(o => o.ProjectId == ProjectId && o.Subproject_CrppId == PermitId).AsEnumerable();

        }

        [HttpGet]
        public dynamic GetPermitRoutes(string ItemType)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            //dynamic json = jsonData;

            //string in_itemtype = json["ItemType"];

            return db.PermitRoute().Where(o => o.ItemType == ItemType).AsEnumerable();

        }

        [HttpPost]
        public HttpResponseMessage SavePermit(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            dynamic json = jsonData;

            Permit permit = json.Permit.ToObject<Permit>();

            if(permit.Id == 0) {
                db.Permit().Add(permit);
                db.SaveChanges();
            }
            else{
                db.Entry(permit).State = EntityState.Modified;
                db.SaveChanges();
            }

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, permit);
            return response;
        }


        [HttpPost]
        public HttpResponseMessage SavePermitPerson(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            dynamic json = jsonData;

            PermitPerson person = json.PermitPerson.ToObject<PermitPerson>();

            if (person.Id == 0)
            {
                db.PermitPerson().Add(person);
                db.SaveChanges();
            }
            else
            {
                db.Entry(person).State = EntityState.Modified;
                db.SaveChanges();
            }

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, person);
            return response;
        }

        [HttpPost]
        public HttpResponseMessage SavePermitContact(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            dynamic json = jsonData;

            PermitContact incoming_contact = json.PermitContact.ToObject<PermitContact>();

            PermitContact existing = db.PermitContacts().Find(incoming_contact.PermitId, incoming_contact.PermitPersonId);

            if(existing == null) {
                db.PermitContacts().Add(incoming_contact);
                db.SaveChanges();
            } else {
                existing.IsPrimary = incoming_contact.IsPrimary;
                existing.ContactType = incoming_contact.ContactType;
                db.Entry(existing).State = EntityState.Modified;
                db.SaveChanges();
            }

           
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, incoming_contact);
            return response;
        }


        [HttpPost]
        public HttpResponseMessage RemovePermitContact(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            dynamic json = jsonData;

            PermitContact incoming_contact = json.PermitContact.ToObject<PermitContact>();

            PermitContact existing = db.PermitContacts().Find(incoming_contact.PermitId, incoming_contact.PermitPersonId);

            if (existing != null)
            {
                db.PermitContacts().Remove(existing);
                db.SaveChanges();
            }
            
            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK);
            return response;
        }

        [HttpPost]
        public HttpResponseMessage SavePermitParcel(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            dynamic json = jsonData;

            PermitParcel incoming_parcel = json.PermitParcel.ToObject<PermitParcel>();

            db.PermitParcels().Add(incoming_parcel);
            db.SaveChanges();


            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, incoming_parcel);
            return response;
        }


        [HttpPost]
        public HttpResponseMessage RemovePermitParcel(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            dynamic json = jsonData;

            PermitParcel incoming_parcel = json.PermitParcel.ToObject<PermitParcel>();

            PermitParcel existing = db.PermitParcels().Find(incoming_parcel.Id);

            if (existing != null)
            {
                db.PermitParcels().Remove(existing);
                db.SaveChanges();
            }

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK);
            return response;
        }


        [HttpPost]
        public HttpResponseMessage SavePermitEvent(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            dynamic json = jsonData;

            PermitEvent incoming_event = json.PermitEvent.ToObject<PermitEvent>();

            PermitEvent existing = db.PermitEvents().Find(incoming_event.Id);

            if (existing == null)
            {
                db.PermitEvents().Add(incoming_event);
                db.SaveChanges();

                if (incoming_event.EventType == "Review" || incoming_event.EventType == "Inspection")
                {
                    Permit permit = db.Permit().Find(incoming_event.PermitId);
                    Resources.PermitEventNotifier.notify(permit, incoming_event, json.PermitEvent); //only notify on "new" events
                }
            }
            else
            {
                existing.ByUser = incoming_event.ByUser;
                existing.Comments = incoming_event.Comments;
                existing.EventDate = incoming_event.EventDate;
                existing.EventType = incoming_event.EventType;
                existing.Files = incoming_event.Files;
                existing.ItemType = incoming_event.ItemType;
                existing.PermitId = incoming_event.PermitId;
                existing.Reference = incoming_event.Reference;
                existing.RequestDate = incoming_event.RequestDate;
                existing.ResponseDate = incoming_event.ResponseDate;
                existing.Result = incoming_event.Result;
                existing.Reviewer = incoming_event.Reviewer;
                
                db.Entry(existing).State = EntityState.Modified;
                db.SaveChanges();
            }

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, incoming_event);
            return response;
        }

        // POST /api/v1/permit/UploadFile
        public Task<HttpResponseMessage> UploadFile()
        {
            logger.Debug("starting to process incoming permit files.");

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

                Int32 ItemId = Convert.ToInt32(provider.FormData.Get("ItemId"));
                logger.Debug("And we think the ItemId === " + ItemId);

                Project project = db.Projects.Find(ProjectId);
                Permit permit = db.Permit().Find(SubprojectId);

                if (project == null)
                    throw new Exception("Project ID not found: " + ProjectId);

                if (!project.isOwnerOrEditor(me))
                    throw new Exception("Authorization error.");

                if (permit == null)
                    throw new Exception("Subproject ID not found: " + SubprojectId);


                //If the project/dataset folder does not exist, create it.
                string subprojectPath = root + project.Id + "\\S\\" + permit.Id;
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

                            newFile.ItemId = ItemId;

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
                //var result = JsonConvert.SerializeObject(thefiles);

                return Request.CreateResponse(HttpStatusCode.OK, thefiles);
                //resp.Content = new StringContent(result, System.Text.Encoding.UTF8, "text/plain");  //to stop IE from being stupid.

                //return resp;
            });

            return task;
        }

        // POST /api/v1/permit/deletefile
        [HttpPost]
        public HttpResponseMessage DeleteFile(JObject jsonData)
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
            int itemId = json.ItemId.ToObject<int>();
            logger.Debug("EventId = " + itemId);

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

    }
}
