using Newtonsoft.Json;
using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;
using System.Web;


namespace services.ExtensionMethods
{
    public static class EHSViolationContactExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<EHSViolationContact> EHSViolationContacts(this ServicesContext ctx)
        {
            return ctx.GetDbSet("EHSViolationContact").Cast<EHSViolationContact>();
        }
    }
}


namespace services.Models.Data
{
    public class EHSViolationContact : DataEntity
    {
        [Key, Column(Order = 0)]
        public int EHSViolationId { get; set; }

        [Key, Column(Order = 1)]
        public int PermitPersonId { get; set; }

        public bool IsPrimary { get; set; }
        public string ContactType { get; set; }

        //relationships

        [JsonIgnore]
        public virtual EHSViolation EHSViolation { get; set; }

        public virtual PermitPerson PermitPerson { get; set; }

    }
}