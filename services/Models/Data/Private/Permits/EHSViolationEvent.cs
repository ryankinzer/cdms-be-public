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
    public static class EHSViolationEventExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<EHSViolationEvent> EHSViolationEvents(this ServicesContext ctx)
        {
            return ctx.GetDbSet("EHSViolationEvent").Cast<EHSViolationEvent>();
        }
    }
}


namespace services.Models.Data
{
    public class EHSViolationEvent : DataEntity
    {
        public int Id { get; set; }
        public int EHSViolationId { get; set; }
        public int ByUser { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime EventDate { get; set; }
        public string EventType { get; set; }
        public DateTime? CompletedDate { get; set; }
        public DateTime? ComplianceDate { get; set; }
        public string Comments { get; set; }
        public string Responder { get; set; }
        public string Respondents { get; set; }
        public string OthersPresent { get; set; }
        public string Files { get; set; }


    }
}