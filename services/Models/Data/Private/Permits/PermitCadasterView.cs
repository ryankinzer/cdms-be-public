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

    public static class PermitCadasterViewExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<PermitCadasterView> PermitCadasterView(this ServicesContext ctx)
        {
            return ctx.GetDbSet("PermitCadasterView").Cast<PermitCadasterView>();
        }
    }

    [Table("PermitCadaster_VW")]
    public class PermitCadasterView : DataEntity
    {
        //directly from cadaster table

        [Key]
        public int ObjectId { get; set; } //objectid from field table
        
        public string Allotment { get; set; }
        public string ParcelId { get; set; }
        public string Ownerships { get; set; }
        public string Taxlot { get; set; }
        public string Geosource { get; set; }
        public string Datasource { get; set; }
        public string Comment { get; set; }
        public string Address { get; set; }
        public decimal? Acres_GIS { get; set; }
        public decimal? Acres_Cty { get; set; }
        public string PLSS { get; set; }
        public string PLSS2 { get; set; }
        public string PLSS3 { get; set; }
        public string PLSS_Label { get; set; }
        public DateTime? Last_Edited_Date { get; set; }

    }
}