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
    public static class PermitViolationContactExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<PermitViolationContact> PermitViolationContacts(this ServicesContext ctx)
        {
            return ctx.GetDbSet("PermitViolationContact").Cast<PermitViolationContact>();
        }
    }
}


namespace services.Models.Data
{
    public class PermitViolationContact : DataEntity
    {
        [Key, Column(Order = 0)]
        public int PermitViolationId { get; set; }

        [Key, Column(Order = 1)]
        public int PermitPersonId { get; set; }

        public bool IsPrimary { get; set; }
        public string ContactType { get; set; }

        //relationships

        [JsonIgnore]
        public virtual PermitViolation PermitViolation { get; set; }

        public virtual PermitPerson PermitPerson { get; set; }

    }
}