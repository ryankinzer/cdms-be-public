using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace services.Models.Data
{

    public static class LeaseFieldExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<LeaseField> LeaseField(this ServicesContext ctx)
        {
            return ctx.GetDbSet("LeaseField").Cast<LeaseField>();
        }
    }

    [Table("LeaseFields_VW")] 
    public class LeaseField : DataEntity
    {
        [Key]
        public int FieldId { get; set; } //objectid from field table

        //directly from cadaster table
        public string AllotmentName { get; set; }
        public decimal? AcresGIS { get; set; }
        public decimal? AcresCty { get; set; }
        //public string Comment { get; set; }
        public string ParcelId { get; set; }
        public string PLSS { get; set; }
        public string PLSS2 { get; set; }
        public string PLSS3 { get; set; }
        public string PLSSLabel { get; set; }
        public DateTime? LastEditedDate { get; set; }

        //directly from field tract table
        public string FieldLandUse { get; set; }
        public decimal? FieldAcres { get; set; }


        //missing from all tables

        //public string Township { get; set; }
        //public string Range { get; set; }
        //public string LegalDescription { get; set; }
        //public int RangeUnit { get; set; }
        //public int Section1 { get; set; }
        //public int Section2 { get; set; }
        //public decimal FSAAcres { get; set; }
        //public int FSATractNumber { get; set; }
        //public Boolean IsHighlyErodableLand { get; set; }
        //public Boolean Inactive { get; set; }

        [JsonIgnore]
        public virtual List<Lease> Leases { get; set; }

    }
}