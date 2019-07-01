using System;
using services.Models;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Newtonsoft.Json.Linq;
using services.Resources;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Configuration;

namespace services.Controllers
{
    [System.Web.Http.Authorize]
    public class UserController : CDMSController
    {
        // GET api/v1/user/getusers
        public IEnumerable<User> GetUsers()
        {
            var db = ServicesContext.Current;
            //var user = db.User.Include(u => u.Organization);
            List<User> userList = (from u in db.User
                            where u.Inactive != 1
                            orderby u.Fullname
                            select u).Include(u => u.Organization).ToList();

            //return userAsEnumerable();
            return userList.AsEnumerable();
        }

        // GET api/v1/user/getusers
        public IEnumerable<User> GetAllUsers()
        {
            var db = ServicesContext.Current;
            
            List<User> userList = (from u in db.User
                                   orderby u.Fullname
                                   select u).ToList();

            //return userAsEnumerable();
            return userList.AsEnumerable();
        }

        // GET api/Users/5
        [System.Web.Mvc.OutputCache(NoStore = true, Duration = 0, VaryByParam = "None")]
        public User GetUser(int id)
        {
            var db = ServicesContext.Current;
            User user = db.User.Find(id);
            if (user == null)
            {
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotFound));
            }

            return user;
        }


        // POST /api/v1/user/saveuserpreference
        //we will overwrite any of the keys that exist in the request
        [HttpPost]
        public HttpResponseMessage SaveUserPreference(JObject jsonData)
        {
            //string result = "{message: 'Success'}"; //TODO!
            //var resp = new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.OK);
            //resp.Content = new System.Net.Http.StringContent(result, System.Text.Encoding.UTF8, "text/plain");

            var ndb = ServicesContext.Current;

            dynamic json = jsonData;
            JObject jpref = json.UserPreference;
            var pref = jpref.ToObject<UserPreference>();

            logger.Debug("Hey we have a user preference save!" + pref.Name + " = " + pref.Value);

            User me = AuthorizationManager.getCurrentUser();

            logger.Debug("Userid = " + me.Id);

            pref.UserId = me.Id; // you can only save preferences that are your own.

            //fetch user with preferences from the database -- really want a round-trip here.
            me = ndb.User.Find(me.Id);

            logger.Debug("Number of existing prefs for user = " + me.UserPreferences.Count());

            UserPreference match = me.UserPreferences.Where(x => x.Name == pref.Name).SingleOrDefault();

            if (match != null)
            {
                match.Value = pref.Value;
                ndb.Entry(match).State = EntityState.Modified;
            }
            else
            {
                me.UserPreferences.Add(pref);
            }

            try
            {
                ndb.SaveChanges();
            }
            catch (Exception e)
            {
                logger.Debug("Something went wrong saving the preference: " + e.Message);
            }

            return new HttpResponseMessage(HttpStatusCode.OK);
        }

        // POST /api/v1/user/saveuser
        public HttpResponseMessage SaveUser(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            User in_user = json.User.ToObject<User>();

            User me = AuthorizationManager.getCurrentUser();

            if (in_user == null || !me.Roles.Contains("Admin"))
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotAcceptable));

            User user;

            if(in_user.Id == 0) //new user (creating)
            {
                user = new User();
                user.OrganizationId = services.Models.User.DEFAULT_ORGANIZATIONID;
                user.UserPreferences = new List<UserPreference>();
                db.User.Add(user);
                user.BumpLastLoginDate();
            }
            else //existing user (editing)
            {
                user = db.User.Find(in_user.Id);
                if (user == null)
                    throw new Exception("Configuration Error UserID: " + in_user.Id);

                db.Entry(user).State = EntityState.Modified;
            }

            user.DepartmentId = in_user.DepartmentId;
            user.Username = in_user.Username;
            user.Fullname = in_user.Fullname;
            user.Description = in_user.Description;
            user.Inactive = in_user.Inactive;
            user.Roles = in_user.Roles;

            //update password if there is one...
            if(json.User.Password != null)
            {
                string str = json.User.Password;
                byte[] data = Convert.FromBase64String(str);
                string decodedString = System.Text.Encoding.UTF8.GetString(data);

                var salt = System.Configuration.ConfigurationManager.AppSettings["PasswordSalt"]; //in web.config

                UserPreference local_auth = user.UserPreferences.Where(o => o.Name == AccountController.LOCAL_USER_AUTH).SingleOrDefault();
                
                if(local_auth == null) //doesn't exist (create)
                {
                    UserPreference up = new UserPreference();
                    up.Name = AccountController.LOCAL_USER_AUTH;
                    up.Value = MD5Util.GetMd5Hash(decodedString + salt);
                    user.UserPreferences.Add(up);
                }
                else //exists (edit)
                {
                    local_auth.Value = MD5Util.GetMd5Hash(decodedString + salt);
                    db.Entry(local_auth).State = EntityState.Modified;
                }
            }

            db.SaveChanges();
            logger.Debug("Saved the changes for user: " + user.Id);

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.OK, user);
            return response;
        }

        // POST /api/v1/user/saveuserinfo
        public HttpResponseMessage SaveUserInfo(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            HttpResponseMessage resp;

            // Get the user info from that was passed in, and write it in the log file.
            User userInfo = json.User.ToObject<User>();
            logger.Debug("userInfo.Id = " + userInfo.Id);
            logger.Debug("userInfo.Username = " + userInfo.Username);
            logger.Debug("userInfo.DepartmentId = " + userInfo.DepartmentId);
            logger.Debug("userInfo.Description = " + userInfo.Description);
            logger.Debug("userInfo.Fullname = " + userInfo.Fullname);

            //KB 9/8/17 - TODO: this should be rewritten (with a test!) to just fetch by id
            // User usr = db.User.Find(userInfo.Id);

            // Check the databse table for the user.
            var queryUserCount = db.User.Where(u => u.Id == userInfo.Id).Count();

            if (queryUserCount.Equals(0))
            {
                logger.Debug("Could not find a user with that Id.");
                resp = new HttpResponseMessage(System.Net.HttpStatusCode.NotFound);
            }
            else
            {
                logger.Debug("Found the user.");

                // Walk update the table recode with the passed in userInfo.
                var query = db.User.Where(u => u.Id == userInfo.Id);
                foreach (User usr in query)
                {
                    usr.DepartmentId = userInfo.DepartmentId;
                    usr.Description = userInfo.Description;
                    usr.Fullname = userInfo.Fullname;
                }
                resp = new HttpResponseMessage(System.Net.HttpStatusCode.OK);
                logger.Debug("Set resp to OK.");

                // This line is used in DatastoreController.cs, SaveProjectLocation, which I (GC) used for an example.
                // However, here is causes a problem and stops exection, and I am not sure why.
                // Taking the line out keeps things running OK.
                //db.Entry(userInfo).State = EntityState.Modified;
                //logger.Debug("Set db State to Modified.");
                db.SaveChanges();
                logger.Debug("Saved the changes.");
            }

            string result = JsonConvert.SerializeObject(userInfo);

            //HttpResponseMessage resp = new HttpResponseMessage(System.Net.HttpStatusCode.OK);
            resp.Content = new System.Net.Http.StringContent(result, System.Text.Encoding.UTF8, "text/plain");  //to stop IE from being stupid.

            logger.Debug("resp = " + resp.StatusCode.ToString());
            return resp;
        }

        [HttpPost]
        public Feedback SaveFeedback(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            Feedback feedback = json.Feedback.ToObject<Feedback>();

            db.Feedback.Add(feedback);
            db.SaveChanges();

            Resources.FeedbackNotifier.notify(feedback);

            return feedback;

        }


        // GET /api/v1/user/getmydatasets
        [HttpGet]
        public IEnumerable<Dataset> GetMyDatasets()
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();
            var mydatasets = "";
            IEnumerable<Dataset> datasets = null;
            
            try
            {
                mydatasets = me.UserPreferences.Where(o => o.Name == UserPreference.DATASETS).FirstOrDefault().Value;

                if (mydatasets != "")
                {
                    datasets = db.Datasets.SqlQuery("SELECT * FROM Datasets WHERE Id in (" + mydatasets + ") ORDER BY Name");
                }

            }
            catch (Exception e)
            {
                logger.Debug("GetMyDatasets: Couldn't get your datasets -- probably don't have any favorites.");
                logger.Debug(e);
            }
            
            return datasets;
        }

        // GET /api/v1/user/getmyprojects
        [HttpGet]
        public IEnumerable<Project> GetMyProjects()
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();
            var my_projects = "";
            IEnumerable<Project> myprojects = null;
            try
            {
                my_projects = me.UserPreferences.Where(o => o.Name == UserPreference.PROJECTS).FirstOrDefault().Value;
                if (my_projects != "")
                {
                    myprojects = db.Projects.SqlQuery("SELECT * FROM Projects WHERE Id in (" + my_projects + ") ORDER BY Name");
                    //logger.Debug(myprojects);
                }
            }
            catch (Exception e)
            {
                logger.Debug("GetMyProjects: Couldn't get your projects -- probably don't have any favorites.");
                logger.Debug(e);
            }

            return myprojects;
        }

        //a list of my projects with just the basic project information
        // GET /api/v1/user/GetMyProjectsList
        [HttpGet]
        public dynamic GetMyProjectsList()
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();
            var my_projects = "";
            DataTable projects = new DataTable();
            try
            {
                my_projects = me.UserPreferences.Where(o => o.Name == UserPreference.PROJECTS).FirstOrDefault().Value;
                if (my_projects != "")
                {
                    var sql = @"SELECT * FROM Projects WHERE Id in (" + my_projects + ") ORDER BY Name";

                    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand(sql, con))
                        {
                            con.Open();
                            SqlDataAdapter da = new SqlDataAdapter(cmd);
                            da.Fill(projects);
                        }
                    }

                }
            }
            catch (Exception e)
            {
                logger.Debug("GetMyProjects: Couldn't get your projects -- probably don't have any favorites.");
                logger.Debug(e);
            }

            return projects;

        }


        //a list of my datasets with just the basic dataset information
        // GET /api/v1/user/getmydatasetslist
        [HttpGet]
        public dynamic GetMyDatasetsList()
        {
            var db = ServicesContext.Current;
            User me = AuthorizationManager.getCurrentUser();
            var mydatasets = "";
            DataTable datasets = new DataTable();

            try
            {
                mydatasets = me.UserPreferences.Where(o => o.Name == UserPreference.DATASETS).FirstOrDefault().Value;

                if (mydatasets != "")
                {
                    var sql = @"SELECT * FROM Datasets WHERE Id in (" + mydatasets + ") ORDER BY Name";

                    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand(sql, con))
                        {
                            con.Open();
                            SqlDataAdapter da = new SqlDataAdapter(cmd);
                            da.Fill(datasets);
                        }
                    }

                }

            }
            catch (Exception e)
            {
                logger.Debug("GetMyDatasets: Couldn't get your datasets -- probably don't have any favorites.");
                logger.Debug(e);
            }

            return datasets;
        }



        // GET api/v1/user/getCrppStaff
        public IEnumerable<User> GetCrppStaff()
        {
            logger.Debug("Inside UserController.cs, GetCrppStaff...");
            var db = ServicesContext.Current;
            List<User> userList = (from u in db.User
                                   where u.Inactive == null && u.Roles.Contains("CRPP")
                                   orderby u.Fullname
                                   select u).ToList();

            //return userAsEnumerable();
            return userList.AsEnumerable();
        }

        // GET api/v1/user/getolcstaff
        public IEnumerable<User> GetOlcStaff()
        {
            logger.Debug("Inside UserController.cs, GetOlcStaff...");
            var db = ServicesContext.Current;
            List<User> userList = (from u in db.User
                                   where u.Inactive == null && u.Roles.Contains("OLC")
                                   orderby u.Fullname
                                   select u).ToList();

            return userList.AsEnumerable();
        }

        public dynamic GetMyLastUpdatedDatasets() {

            User me = AuthorizationManager.getCurrentUser();

            var sql = @"select * from LastUpdatedDatasets_VW where UserId = " + me.Id + " order by CreateDate DESC";

            DataTable datasets = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(datasets);
                }
            }

            return datasets;

        }
    }
}