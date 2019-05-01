using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using services.Models;
using Newtonsoft.Json.Linq;
using services.Resources;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;

namespace services.Controllers
{
    public class MetadataController : CDMSController
    {
        // GET api/v1/metadata/getmetadataproperties
        public IEnumerable<MetadataProperty> GetMetadataProperties()
        {
            var db = ServicesContext.Current;
            var metadataproperty = db.MetadataProperty.Include(m => m.MetadataEntity);
            return metadataproperty.AsEnumerable();
        }

        // GET api/v1/metadata/GetMetadataPropertiesForEntity/id
        public IEnumerable<MetadataProperty> GetMetadataPropertiesForEntity(int Id)
        {
            var db = ServicesContext.Current;
            var metadataproperty = db.MetadataProperty.Where(o => o.MetadataEntityId == Id);
            return metadataproperty.AsEnumerable();
        }
        

        // GET api/Metadata/5
        public MetadataProperty GetMetadataProperty(int id)
        {
            var db = ServicesContext.Current;
            MetadataProperty metadataproperty = db.MetadataProperty.Find(id);
            if (metadataproperty == null)
            {
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotFound));
            }

            return metadataproperty;
        }

        // PUT api/Metadata/5
        public HttpResponseMessage PutMetadataProperty(int id, MetadataProperty metadataproperty)
        {
            var db = ServicesContext.Current;
            if (!ModelState.IsValid)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ModelState);
            }

            if (id != metadataproperty.Id)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }

            db.Entry(metadataproperty).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
            }

            return Request.CreateResponse(HttpStatusCode.OK);
        }

        public dynamic GetMetadataEntities() {
            var db = ServicesContext.Current;
    
            //note: this is a slick way to return an object with its children as objects.

            var entities = from entity in db.MetadataEntity
                           select new 
                           { 
                                Id = entity.Id, 
                                Name = entity.Name, 
                                Description = entity.Description, 
                                Properties = (from q in db.MetadataProperty where q.MetadataEntityId == entity.Id select q )
                            }; 

            return entities.AsEnumerable();
        }

        // POST api/Metadata
        public HttpResponseMessage SaveMetadataProperty(MetadataProperty metadataproperty)
        {
            var db = ServicesContext.Current;

            HttpResponseMessage response = null;

            if (ModelState.IsValid)
            {
                if (metadataproperty.Id == 0)
                {
                    db.MetadataProperty.Add(metadataproperty);
                    response = Request.CreateResponse(HttpStatusCode.Created, metadataproperty);
                }else{
                    db.Entry(metadataproperty).State = EntityState.Modified;
                    response = Request.CreateResponse(HttpStatusCode.OK, metadataproperty);
                }
            }
            else
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ModelState);
            }

            db.SaveChanges();
            return response;

        }

        //  api/Metadata/5
        [HttpPost]
        public HttpResponseMessage DeleteMetadataProperty(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;
            int PropertyId = json.Id.ToObject<int>();
            MetadataProperty metadataproperty = db.MetadataProperty.Find(PropertyId);
            if (metadataproperty == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }

            db.MetadataProperty.Remove(metadataproperty);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
            }

            return Request.CreateResponse(HttpStatusCode.OK, metadataproperty);
        }

        //Returns metadata properties of an entity for a relationid
        // POST /api/v1/metadata/getmetadatafor
        [HttpPost]
        public dynamic GetMetadataFor(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;

            User me = AuthorizationManager.getCurrentUser();
            int RelationId = json.RelationId.ToObject<int>();
            int EntityTypeId = json.EntityTypeId.ToObject<int>();

            if (RelationId == 0 || EntityTypeId == 0 || me == null)
                throw new Exception("GetMetadataFor: Configuration error. Please try again.");

            var sql = @"select p.Id as MetadataPropertyId, MetadataEntityId, Name, Description, DataType, PossibleValues, ControlType,
vw.RelationId, vw.[Values], vw.UserId, vw.EffDt from metadataproperties p 
left outer join metadatavalues_vw vw on vw.MetadataPropertyId = p.Id and vw.RelationId = " + RelationId + @"
where p.MetadataEntityId = " + EntityTypeId;

            DataTable metadata = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                //using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(metadata);
                }
            }
            
            return metadata;

            //            return MetadataHelper.getMetadata(project.Id, EntityTypeId).AsEnumerable();

        }

        // POST /api/v1/metadata/setdatasetmetadata
        [HttpPost]
        public HttpResponseMessage SetDatasetMetadata(JObject jsonData)
        {
            var db = ServicesContext.Current;
            dynamic json = jsonData;

            Dataset dataset = db.Datasets.Find(json.DatasetId.ToObject<int>());
            if (dataset == null)
                throw new Exception("SetDatasetMetadata: Configuration error.");

            Project project = db.Projects.Find(dataset.ProjectId);

            User me = AuthorizationManager.getCurrentUser();
            if (!project.isOwnerOrEditor(me))
                throw new Exception("SetDatasetMetadata: Configuration error.");

            //Now save metadata
            List<MetadataValue> metadata = new List<MetadataValue>();

            foreach (var jmv in json.Metadata)
            {
                var mv = jmv.ToObject<MetadataValue>();
                mv.UserId = me.Id;
                metadata.Add(mv);
                //logger.Debug("Found new metadata: " + mv.MetadataPropertyId + " + + " + mv.Values);
            }

            //fire setMetdata which will handle persisting the metadata
            dataset.Metadata = metadata;

            db.SaveChanges();

            return new HttpResponseMessage(HttpStatusCode.OK);

        }

        [HttpGet]
        public IEnumerable<MetadataProperty> GetPropertiesForEntity(int Id){
            var db = ServicesContext.Current;
            return db.MetadataProperty.Where(o => o.MetadataEntityId == Id);
        }


    }
}