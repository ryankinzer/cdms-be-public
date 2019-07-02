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
    public static class Subproject_OlcExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<Subproject_Olc> Subproject_Olc(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Subproject_Olc").Cast<Subproject_Olc>();
        }

        public static DbSet<OlcEvents> OlcEvents(this ServicesContext ctx)
        {
            return ctx.GetDbSet("OlcEvents").Cast<OlcEvents>();
        }
    }
}
namespace services.Models.Data
{
    public class Subproject_Olc : Subproject
    {
        //public string CatalogNumber { get; set; }
        public string RecordGroup { get; set; }
        public string SeriesTitle { get; set; }
        public string FacilityHoused { get; set; }
        public string Box { get; set; }
        //public string BoxLocation { get; set; }
        public string CategoryTitle { get; set; }
        //public string CategoryIndex { get; set; }
        //public string SignatoryTitle { get; set; }
        //public string SignatoryAgency { get; set; }
        //public string SignatoryName { get; set; }

        public string Agency { get; set; }
        public string AgencyLocation { get; set; }
        public string CategorySubtitle { get; set; }
        public string OtherFacilityHoused { get; set; }


        public virtual List<OlcEvents> OlcEvents { get; set; }
    }

    public class OlcEvents : Subproject
    {
        public int SubprojectId { get; set; }
        public string DocumentType { get; set; }
        public DateTime? DocumentDate { get; set; }
        public string FileName { get; set; }
        public string Author { get; set; }
        //public string AuthorAgency { get; set; }
        public string Boundary { get; set; }
        public string SignificantArea { get; set; }
        public string MiscellaneousContext { get; set; }
        public string Description { get; set; }
        public string TwnRngSec { get; set; }
        public int? NumberItems { get; set; }
        public DateTime? DateDiscovered { get; set; }
        public string PersonDiscovered { get; set; }
        public string Reference { get; set; }
        //public string EventComments { get; set; }
        public string FileAttach { get; set; }

        public string SignatoryTitle { get; set; }
        public string SignatoryName { get; set; }
        public string AgencyDivision { get; set; }
        public string RecipientName { get; set; }
        public string RecipientTitle { get; set; }
        public string RecipientAgency { get; set; }
        public string RecipientLocation { get; set; }
        public string SurveyNumber { get; set; }
        public string SurveyContractNumber { get; set; }
        public string SurveyorName { get; set; }
        public string SurveyAuthorizingAgency { get; set; }
        public string SurveyDates { get; set; }
        public string Tasks { get; set; }
        public string OtherBoundary { get; set; }

        [JsonIgnore]
        public virtual Subproject_Olc Subproject { get; set; }

    }

}