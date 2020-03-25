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
    public static class EHSViolationCodeExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<EHSViolationCode> EHSViolationCodes(this ServicesContext ctx)
        {
            return ctx.GetDbSet("EHSViolationCode").Cast<EHSViolationCode>();
        }
    }
}


namespace services.Models.Data
{
    public class EHSViolationCode : DataEntity
    {
        public int Id { get; set; }
        public int EHSViolationId { get; set; }
        public int ByUser { get; set; }
        public string CodeSection { get; set; }
        public string CodeParagraph { get; set; }
        public string CodeSubParagraph { get; set; }
        public string Comments { get; set; }
        public string Description { get; set; }
        public string Files { get; set; }

    }
}