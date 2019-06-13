using Newtonsoft.Json.Linq;
using services.ExtensionMethods;
using services.Models;
using services.Models.Data;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Http;
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

            return db.Permit().OrderByDescending(o => o.ApplicationDate).AsEnumerable(); 

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
        public dynamic GetPermitFiles(int ProjectId, int PermitId)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            return db.Files.Where(o => o.ProjectId == ProjectId && o.ItemId == PermitId).AsEnumerable();

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

    }
}
