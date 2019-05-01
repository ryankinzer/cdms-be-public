using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using services.ExtensionMethods;
using services.Models;
using services.Models.Data;
using services.Resources;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Dynamic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace services.Controllers.Private
{
    [System.Web.Http.Authorize]
    public class LeaseController : CDMSController
    {
        public static string ROLE_REQUIRED = "Leasing";

        //GET /api/v1/lease/getlease/5
        [HttpGet]
        public Lease GetLease(int id)
        {

            //user must be in the "Leasing" group in order to do anything here.
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            Lease lease = db.Lease().Find(id);

            if (lease == null)
            {
                throw new HttpResponseException(Request.CreateResponse(HttpStatusCode.NotFound));
            }

            return lease;
        }

        //GET /api/v1/lease/getleasesbyfield/5
        [HttpGet]
        public IEnumerable<Lease> GetLeasesByField(int id)
        {

            //user must be in the "Leasing" group in order to do anything here.
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            var query = @"select Lease_Id from leases L
            join leasefieldleases lfl on lfl.Lease_id = L.id
            where
            lfl.LeaseField_FieldId = " + id;

            List<Lease> result = new List<Lease>();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    int leaseId = Convert.ToInt32(reader["Lease_Id"]);
                    Lease lease = db.Lease().Find(leaseId);
                    result.Add(lease);
                }
            }

            return result;
        }

        [HttpGet]
        public dynamic AllLeases()
        {

            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            var leases = from l in db.Lease()
            join LeaseOperator in db.LeaseOperator() on l.LeaseOperatorId equals LeaseOperator.Id
            select new
            {
                l.Id,
                l.AllotmentName,
                l.LeaseNumber,
                l.FarmNumber,
                l.FSATractNumber,
                l.LeaseType,
                l.NegotiateDate,
                l.LeaseOperatorId,
                l.LeaseAcres,
                l.ProductiveAcres,
                l.LeaseDuration,
                l.LeaseStart,
                l.LeaseEnd,
                l.DueDate,
                l.DollarPerAnnum,
                l.DollarAdvance,
                l.DollarBond,
                l.TransactionDate,
                l.LeaseFee,
                l.ApprovedDate,
                l.WithdrawlDate,
                l.Level,
                l.Status,
                l.StatusDate,
                l.StatusBy,
                l.ResidueRequiredPct,
                l.GreenCoverRequiredPct,
                l.ClodRequiredPct,
                l.OptionalAlternativeCrop,
                l.HEL,
                l.GrazeStart,
                l.GrazeEnd,
                l.AUMs,
                l.GrazeAnimal,
                l.Notes,
                l.TAAMSNumber,
                l.UnderInternalReview,
                l.InternalReviewStartDate,
                LeaseOperator
            };


            return leases;
        }


        [HttpGet]
        public dynamic ActiveLeases()
        {

            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            var leases = from l in db.Lease() where l.Status == Lease.STATUS_ACTIVE
                         join LeaseOperator in db.LeaseOperator() on l.LeaseOperatorId equals LeaseOperator.Id
                         select new
                         {
                             l.Id,
                             l.AllotmentName,
                             l.LeaseNumber,
                             l.FarmNumber,
                             l.FSATractNumber,
                             l.LeaseType,
                             l.NegotiateDate,
                             l.LeaseOperatorId,
                             l.LeaseAcres,
                             l.ProductiveAcres,
                             l.LeaseDuration,
                             l.LeaseStart,
                             l.LeaseEnd,
                             l.DueDate,
                             l.DollarPerAnnum,
                             l.DollarAdvance,
                             l.DollarBond,
                             l.TransactionDate,
                             l.LeaseFee,
                             l.ApprovedDate,
                             l.WithdrawlDate,
                             l.Level,
                             l.Status,
                             l.StatusDate,
                             l.StatusBy,
                             l.ResidueRequiredPct,
                             l.GreenCoverRequiredPct,
                             l.ClodRequiredPct,
                             l.OptionalAlternativeCrop,
                             l.HEL,
                             l.GrazeStart,
                             l.GrazeEnd,
                             l.AUMs,
                             l.GrazeAnimal,
                             l.Notes,
                             l.TAAMSNumber,
                             l.UnderInternalReview,
                             l.InternalReviewStartDate,
                             LeaseOperator
                         };

            return leases;
        }

        [HttpGet]
        public IEnumerable<Lease> PendingLeases()
        {

            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            return db.Lease().Where(o => o.Status == Lease.STATUS_PENDING).AsEnumerable();
        }

        [HttpGet]
        public IEnumerable<LeaseOperator> GetOperators()
        {

            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            return db.LeaseOperator().AsEnumerable();
        }

        [HttpGet]
        public HttpResponseMessage DeleteOperator(int Id){
            var db = ServicesContext.Current;
            
            User me = AuthorizationManager.getCurrentUser();

            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            if(Id == 0)
                throw new System.Exception("Configuration error.");

            LeaseOperator lo = db.LeaseOperator().Find(Id);

            if (lo != null){ 
                db.LeaseOperator().Remove(lo);
                db.SaveChanges();
                logger.Debug("Deleted operator " + lo.Id + " for " + me.Username);
            }
            else
            {
                logger.Debug("Tried to delete lease operator " + lo.Id + " but it was not found.");
                throw new System.Exception("Operator not found");
            }

            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    


        [HttpGet]
        public DataTable AvailableFields()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            string query = "select * from Lease_AvailableFields_VW";

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.SelectCommand.CommandTimeout = 120;
                    da.Fill(dt);
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return dt;
        }

        [HttpGet]
        public DataTable AvailableAllotments()
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            string query = "select * from LeaseAllotments_VW";

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.SelectCommand.CommandTimeout = 120;
                    da.Fill(dt);
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return dt;
        }


        [HttpGet]
        public IEnumerable<LeaseRevision> GetLeaseRevisions(int Id)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            return db.LeaseRevision().Where(o => o.LeaseId == Id).AsEnumerable();
        }

        [HttpGet]
        public IEnumerable<LeaseCropPlan> GetCropPlanRevisions(int Id)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            return db.LeaseCropPlan().Where(o => o.LeaseId == Id).OrderBy(o => o.SequenceId).ThenBy(o => o.LeaseYear).AsEnumerable();
        }


        [HttpPost]
        public DataTable GetInspectionViolations(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            dynamic json = jsonData;

            //params
            //DateTime FromDate = json.QueryParams.FromDate.ToObject<DateTime>(); //removed per colette
            Boolean ShowResolved = json.QueryParams.ShowResolved.ToObject<Boolean>();

            var query = @"select 
                    ls.*, li.*, li.Notes as InspectionNotes, li.Id as InspectionId
                    from leaseinspections li
                    join leases ls on ls.Id = li.LeaseId
                    where li.outofcompliance = 1 ORDER BY InspectionDateTime DESC"; // and inspectiondatetime > @FromDate";

            //SqlParameter fromDateParam = new SqlParameter("@FromDate", SqlDbType.DateTime);
            //fromDateParam.Value = FromDate;

            if (!ShowResolved)
                query += " and li.violationisresolved = 0";

            logger.Debug(query);

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(query, con);
                //  cmd.Parameters.Add(fromDateParam);

                cmd.CommandTimeout = 120; // 2 minutes in seconds.
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.SelectCommand.CommandTimeout = 120;
                    da.Fill(dt);
                }
                catch (SqlException e)
                {
                    logger.Debug("Query sql command timed out..." + e.Message);
                    logger.Debug(e.InnerException);
                }
            }

            return dt;
        }

        [HttpGet]
        public HttpResponseMessage ExpireLeases()
        {
            string query = "update Leases set Status = 5 where Id in (select Id from Leases where [level] = 4 AND Status = 1 and LeaseEnd < getdate())";

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ServicesContext"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    logger.Debug(query);
                    cmd.ExecuteNonQuery();
                }
            }

            return new HttpResponseMessage(HttpStatusCode.OK);

        }

        [HttpPost]
        public HttpResponseMessage SaveLease(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            dynamic json = jsonData;
            Lease lease = json.Lease.ToObject<Lease>();

            string changed_reason = "";
            JToken jt_changed_reason = json.SelectToken("Lease.ChangedReason");
            if (jt_changed_reason != null)
                changed_reason = json.Lease.ChangedReason.ToObject<string>();

            int[] fields_to_link = null;

            JToken jt_fields_to_link = json.SelectToken("Lease.FieldsToLink");
            if (jt_fields_to_link != null)
            {
                fields_to_link = json.Lease.FieldsToLink.ToObject<int[]>();
            }

            if (lease.Id == 0)
            {
                db.Lease().Add(lease);
                db.SaveChanges();

                //if this is a brand new lease, it should have FieldsToLink array of ids
                if (fields_to_link != null && fields_to_link.Length > 0)
                {
                    logger.Debug(" incoming fields to link: "+ JsonConvert.SerializeObject(fields_to_link));


                    lease.LeaseFields = new List<LeaseField>();

                    foreach (int fieldid in fields_to_link)
                    {
                        logger.Debug("Adding field: " + fieldid + " to " + lease.Id);
                        LeaseField field = db.LeaseField().Find(fieldid);
                        lease.LeaseFields.Add(field);
                    }

                    //logger.Debug(JsonConvert.SerializeObject(lease));

                    db.Entry(lease).State = EntityState.Modified;
                    db.SaveChanges();
                }
            }
            else
            {
                db.Entry(lease).State = EntityState.Modified;
                
                try
                {
                    foreach (var lcs in lease.LeaseCropShares) {
                        if (lcs.Id != 0)
                            db.Entry(lcs).State = EntityState.Modified;
                        else
                            db.Entry(lcs).State = EntityState.Added;
                    }

                    db.SaveChanges();
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
                }
            }

            LeaseRevision rev = lease.getRevision(me, changed_reason);
            db.LeaseRevision().Add(rev);
            db.SaveChanges();

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, lease);
            return response;

        }

        [HttpPost]
        public HttpResponseMessage SaveCropPlan(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;
            dynamic json = jsonData;

            string changed_reason = "";
            JToken jt_changed_reason = json.SelectToken("Lease.ChangedReason");
            if (jt_changed_reason != null)
                changed_reason = json.Lease.ChangedReason.ToObject<string>();


            Lease lease = json.Lease.ToObject<Lease>();

            int sequenceid = 1;

            LeaseCropPlan first_one = db.Lease().Find(lease.Id).LeaseCropPlans.FirstOrDefault(); //TODO: is this returning the LAST one (highest sequence #?)
            if (first_one != null)
                sequenceid = first_one.SequenceId;

            foreach (var item in json.CropPlan)
            {
                var plan = new LeaseCropPlan();
                plan.SequenceId = sequenceid + 1;
                plan.LeaseId = lease.Id;
                plan.LeaseYear = item.LeaseYear;
                plan.CropRequirement = item.CropRequirement;
                plan.OptionAlternateCrop = item.OptionAlternateCrop;
                plan.ChangedBy = me.Fullname;
                plan.ChangedDate = DateTime.Now;
                plan.ChangedReason = changed_reason;
                db.LeaseCropPlan().Add(plan);
            }

            db.SaveChanges();

            //save a revision to mark this change
            LeaseRevision rev = lease.getRevision(me, "crop plan changed; " + changed_reason);
            db.LeaseRevision().Add(rev);
            db.SaveChanges();

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, lease);

            return response;

        }


        [HttpPost]
        public HttpResponseMessage SaveInspection(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            dynamic json = jsonData;
            LeaseInspection inspection = json.Inspection.ToObject<LeaseInspection>();

            if (inspection.Id == 0)
            {
                db.LeaseInspection().Add(inspection);
                db.SaveChanges();
            }
            else
            {
                db.Entry(inspection).State = EntityState.Modified;
                try
                {
                    db.SaveChanges();
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
                }
            }

            Lease lease = db.Lease().Find(inspection.LeaseId);

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, lease);
            return response;

        }

        [HttpPost]
        public HttpResponseMessage SaveInspectionViolation(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            dynamic json = jsonData;
            LeaseInspection incoming = json.Inspection.ToObject<LeaseInspection>();

            //find the one and we'll update just the violation fields
            LeaseInspection inspection = db.LeaseInspection().Find(json.Inspection.InspectionId.ToObject<int>());

            inspection.ViolationComments = incoming.ViolationComments;
            inspection.ViolationDateFeeCollected = incoming.ViolationDateFeeCollected;
            inspection.ViolationFeeCollected = incoming.ViolationFeeCollected;
            inspection.ViolationFeeCollectedBy = incoming.ViolationFeeCollectedBy;
            inspection.ViolationHoursSpent = incoming.ViolationHoursSpent;
            inspection.ViolationIsResolved = incoming.ViolationIsResolved;
            inspection.ViolationResolution = incoming.ViolationResolution;
            inspection.ViolationType = incoming.ViolationType;
            inspection.ViolationOwnerType = incoming.ViolationOwnerType;

            db.Entry(inspection).State = EntityState.Modified;
            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
            }

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, inspection);
            return response;

        }


        [HttpPost]
        public HttpResponseMessage SaveProduction(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            dynamic json = jsonData;
            LeaseProduction production = json.Production.ToObject<LeaseProduction>();

            if (production.Id == 0)
            {
                db.LeaseProduction().Add(production);
                db.SaveChanges();
            }
            else
            {
                db.Entry(production).State = EntityState.Modified;
                try
                {
                    db.SaveChanges();
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
                }
            }

            Lease lease = db.Lease().Find(production.LeaseId);

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, lease);
            return response;

        }

        [HttpPost]
        public HttpResponseMessage SaveOperator(JObject jsonData)
        {
            User me = AuthorizationManager.getCurrentUser();
            if (!me.hasRole(ROLE_REQUIRED))
                throw new Exception("Not Authorized.");

            var db = ServicesContext.Current;

            dynamic json = jsonData;
            LeaseOperator loperator = json.LeaseOperator.ToObject<LeaseOperator>();

            if (loperator.Id == 0)
            {
                db.LeaseOperator().Add(loperator);
                db.SaveChanges();
            }
            else
            {
                db.Entry(loperator).State = EntityState.Modified;
                try
                {
                    db.SaveChanges();
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.NotFound, ex);
                }
            }

            HttpResponseMessage response = Request.CreateResponse(HttpStatusCode.Created, loperator);
            return response;
        }

    }
}
