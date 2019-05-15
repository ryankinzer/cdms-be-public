using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using NLog; // For the logger.Debug
using services.Models;
using System.Data.Entity;
using services.Models.Data;
using services.ExtensionMethods;

/*
 * These extension methods make it possible to use linq with ctx.SomeEntity_Header(). See below for example use.
 */
namespace services.ExtensionMethods
{
    public static class Subproject_OLCExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<Subproject_OLC> Subproject_OLC(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Subproject_OLC").Cast<Subproject_OLC>();
        }

        public static DbSet<OLCEvent> OLCEvent(this ServicesContext ctx)
        {
            return ctx.GetDbSet("OLCEvent").Cast<OLCEvent>();
        }
    }
}
namespace services.Models.Data
{
    public class Subproject_OLC : Subproject
    {
        public string CatalogNumber { get; set; }
        public string RecordGroup { get; set; }
        public string SeriesTitle { get; set; }
        public string FacilityHoused { get; set; }
        public string Box { get; set; }
        public string BoxLocation { get; set; }
        public string CategoryTitle { get; set; }
        public string CategoryIndex { get; set; }
        public string SignatoryTitle { get; set; }
        public string SignatoryAgency { get; set; }
        public string SignatoryName { get; set; }
    }

    public class OLCEvent : Subproject
    {
        public int SubprojectId { get; set; }
        public string DocumentType { get; set; }
        public DateTime? DocumentDate { get; set; }
        public string FileName { get; set; }
        public string Author { get; set; }
        public string AuthorAgency { get; set; }
        public string Boundary { get; set; }
        public string SignificantArea { get; set; }
        public string MiscelleneousContext { get; set; }
        public string Description { get; set; }
        public string TwnRngSec { get; set; }
        public int? NumberItems { get; set; }
        public DateTime? DateDiscovered { get; set; }
        public string PersonDiscovered { get; set; }
        public string Reference { get; set; }
        public string Comments { get; set; }
        public string FileAttach { get; set; }

        [JsonIgnore]
        public virtual Subproject_OLC Subproject { get; set; }

    }

}