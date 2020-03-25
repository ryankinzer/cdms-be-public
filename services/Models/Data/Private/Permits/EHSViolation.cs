using Newtonsoft.Json;
using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace services.ExtensionMethods
{
    public static class EHSViolationExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<EHSViolation> EHSViolations(this ServicesContext ctx)
        {
            return ctx.GetDbSet("EHSViolation").Cast<EHSViolation>();
        }
    }
}

namespace services.Models.Data
{
    public class EHSViolation : DataEntity
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string FileNumber { get; set; }
        public string FileType { get; set; }
        public DateTime CreateDate { get; set; }
        public string Reviewer { get; set; }

        public DateTime? ViolationStartDate { get; set; }
        public DateTime? ViolationResolvedDate { get; set; }
        public string ViolationOffenses { get; set; }
        public string ViolationDescription { get; set; }

        public string ViolationStatus { get; set; }
        public string StatusUpdatedBy { get; set; }
        public DateTime? StatusUpdateDate { get; set; }
        
        public string Comments { get; set; }

        public string ComplainantName { get; set; }
        public string ComplainantType { get; set; }
        public string ComplainantAddress { get; set; }
        public string ComplainantCity { get; set; }
        public string ComplainantState { get; set; }
        public string ComplainantZip { get; set; }
        public string ComplainantPhone { get; set; }
        public string ComplainantEmail { get; set; }

        public string ComplaintDate { get; set; }
        public string ComplaintDescription { get; set; }
        public string ComplaintReceivedBy { get; set; }

        public string SiteName { get; set; }
        public string SiteAddress { get; set; }
        public string SiteCity { get; set; }
        public string SiteState { get; set; }
        public string SiteZip { get; set; }

        public string NotifyRoutes { get; set; }


    }
}