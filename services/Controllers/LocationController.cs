﻿using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using services.Models;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace services.Controllers
{
    public class LocationController : CDMSController
    {
        // GET /api/v1/location/getlocationtypes
        [HttpGet]
        public IEnumerable<LocationType> GetLocationTypes()
        {
            var db = ServicesContext.Current;
            return db.LocationType.AsEnumerable();
        }

        // GET /api/v1/location/getlocations
        [HttpGet]
        public IEnumerable<Location> GetLocations()
        {
            var db = ServicesContext.Current;
            return db.Location.AsEnumerable();
        }

        // POST /api/v1/location/saveprojectlocation
        [HttpPost]
        public HttpResponseMessage SaveProjectLocation(JObject jsonData)
        {
            logger.Debug("Inside SaveProjectLocation...");
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            //logger.Debug("json = " + json);
            User me = AuthorizationManager.getCurrentUser();
            Project project = db.Projects.Find(json.ProjectId.ToObject<int>());
            if (project == null)
                throw new System.Exception("Configuration error.  Please try again.");

            if (!project.isOwnerOrEditor(me))
                throw new System.Exception("Authorization error:  The user attempting the change is neither an Owner nor an Editor.");

            Location location = json.Location.ToObject<Location>();
            location.UserId = me.Id;
            location.ProjectId = project.Id;
            string strLocation = "Id = " + location.Id + "\n" +
                "Projection = " + location.Projection + "\n" +
                "UTMZone = " + location.UTMZone + "\n" +
                "Label = " + location.Label + "\n" +
                "Description = " + location.Description + "\n" +
                "GPSEasting = " + location.GPSEasting + "\n" +
                "GPSNorthing = " + location.GPSNorthing + "\n" +
                "ProjectId = " + location.ProjectId + "\n" +
                "SdeObjectId = " + location.SdeObjectId + "\n" +
                "StudyDesign = " + location.StudyDesign + "\n" +
                "ProjectId = " + location.ProjectId;
            logger.Debug(strLocation);

            //IF the incoming location has an ID then we update, otherwise we create a new project location
            if (location.Id == 0)
            {
                location.CreateDateTime = DateTime.Now;
                project.Locations.Add(location);
                db.SaveChanges();
                logger.Debug("success adding NEW project location!");
            }
            else
            {
                db.Entry(location).State = EntityState.Modified;
                db.SaveChanges();
                logger.Debug("success updating EXISTING project location!");
            }

            string result = JsonConvert.SerializeObject(location);

            //TODO: actual error/success message handling
            //string result = "{\"message\": \"Success\"}";

            HttpResponseMessage resp = new HttpResponseMessage(System.Net.HttpStatusCode.OK);
            resp.Content = new System.Net.Http.StringContent(result, System.Text.Encoding.UTF8, "text/plain");  //to stop IE from being stupid.

            return resp;

            //return new HttpResponseMessage(HttpStatusCode.OK);

        }

        // POST /api/v1/location/deletelocation
        [HttpPost]
        public HttpResponseMessage DeleteLocation(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            User me = AuthorizationManager.getCurrentUser();

            Location loc = db.Location.Find(json.LocationId.ToObject<int>());

            if (loc == null)
                throw new System.Exception("Configuration error.");

            if (db.Activities.Where(o => o.LocationId == loc.Id).Count() == 0)
            {
                db.Location.Remove(loc);
                db.SaveChanges();
                logger.Debug("Deleted location " + loc.Id + " because there was no activity.");
            }
            else
            {
                logger.Debug("Tried to delete location " + loc.Id + " when activities exist.");
                throw new System.Exception("Location Delete failed because activities exist!");
            }
            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}
