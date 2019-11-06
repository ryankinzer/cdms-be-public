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
    public static class PermitParcelExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<PermitParcel> PermitParcels(this ServicesContext ctx)
        {
            return ctx.GetDbSet("PermitParcel").Cast<PermitParcel>();
        }
    }
}


namespace services.Models.Data
{
    public class PermitParcel : DataEntity
    {
        public int Id { get; set; }

        public int PermitId { get; set; }
        public int? ObjectId { get; set; }

        public string ParcelId { get; set; }
        public string PLSS { get; set; }
        public DateTime CreateDate { get; set; }

        //relationships

        [JsonIgnore]
        public virtual Permit Permit { get; set; }

        public virtual PermitCadasterView Object { get; set; }

        public PermitParcel(){
            CreateDate = DateTime.Now;
        }

    }
}

