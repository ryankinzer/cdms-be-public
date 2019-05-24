using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace services.ExtensionMethods
{
    public static class PermitEventExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<PermitEvent> PermitEvent(this ServicesContext ctx)
        {
            return ctx.GetDbSet("PermitEvent").Cast<PermitEvent>();
        }
    }
}


namespace services.Models.Data
{
    public class PermitEvent : DataEntity
    {
        public int Id { get; set; }
        public int PermitId { get; set; }
        public int ByUser { get; set; }
        public DateTime EventDate { get; set; }
        public string EventType { get; set; }
        public string ItemType { get; set; }
        public DateTime? RequestDate { get; set; }
        public DateTime? ResponseDate { get; set; }
        public string Reviewer { get; set; }
        public string Result { get; set; }
        public string Reference { get; set; }
        public string Comments { get; set; }
        public string Files { get; set; }



    }
}