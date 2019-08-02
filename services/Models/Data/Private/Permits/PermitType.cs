using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;


namespace services.ExtensionMethods
{
    public static class PermitTypeExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<PermitType> PermitType(this ServicesContext ctx)
        {
            return ctx.GetDbSet("PermitType").Cast<PermitType>();
        }
    }
}

namespace services.Models.Data
{
    public class PermitType : DataEntity
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int PermitTypeStatus { get; set; }
        public string PermitNumberPrefix { get; set; }
        public double FeeRequired { get; set; }
        public string TemplateFile { get; set; }
        public bool StampRequired { get; set; }
        public string InspectionsRequired { get; set; }
        public string ApprovalsRequired { get; set; }
        //public int CurrentPermitYear { get; set; } -- don't think we need this.
        public int CurrentPermitNumber { get; set; }

        public string generatePermitNumber(){
            return PermitNumberPrefix + "-" + DateTime.Now.ToString("yy") + "-" + CurrentPermitNumber;
        }

    }
}