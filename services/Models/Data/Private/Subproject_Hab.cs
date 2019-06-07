using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using services.Models;
using System.Data.Entity;
using services.Models.Data;
using services.ExtensionMethods;

/* 
 * These extension methods make it possible to use linq with ctx.SomeEntity(). See below for example use.
 */
namespace services.ExtensionMethods
{
    public static class Subproject_HabExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<Subproject_Hab> Subproject_Hab(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Subproject_Hab").Cast<Subproject_Hab>();
        }

        public static DbSet<HabitatItem> HabitatItem(this ServicesContext ctx)
        {
            return ctx.GetDbSet("HabitatItem").Cast<HabitatItem>();
        }
        
    }
}

namespace services.Models.Data
{
    public class Subproject_Hab : Subproject
    {
        public string ProjectName { get; set; }
        public string ProjectLead { get; set; }
        public string ProjectSummary { get; set; }
        public string ProjectDescription { get; set; }
        public DateTime? ProjectStartDate { get; set; }
        public DateTime? ProjectEndDate { get; set; }
        public string FirstFoods { get; set; }
        public string RiverVisionTouchstone { get; set; }
        public string HabitatObjectives { get; set; }
        public string NoaaEcologicalConcernsSubcategories { get; set; }
        public string NoaaEcologicalConcerns { get; set; }
        public string LimitingFactors { get; set; }
        //public string Funding { get; set; }
        public string Staff { get; set; }
        public string Collaborators { get; set; }
        public string Comments { get; set; }
        public int ProjectId { get; set; }
        public int? LocationId { get; set; }
        //public string OtherFundingAgency { get; set; }
        public string OtherCollaborators { get; set; }

        public virtual List<HabitatItem> HabitatItems { get; set; }

        //public virtual List<Funding> Funding { get; set; }
        public string FeatureImage { get; set; }
    }

    public class HabitatItem : Subproject
    {
        public const int SHARINGLEVEL_PRIVATE = 1;
        public const int SHARINGLEVEL_GROUPREAD = 2;
        public const int SHARINGLEVEL_PUBLICREAD = 3;
        public const int SHARINGLEVEL_GROUPWRITE = 4;
        public const int SHARINGLEVEL_PUBLICWRITE = 5;

        public int SubprojectId { get; set; }
        public string ItemName { get; set; }
        public string ItemFiles { get; set; }
        public string ExternalLinks { get; set; }
        public string ItemType { get; set; }
        public int SharingLevel { get; set; }

        [JsonIgnore]
        public virtual Subproject_Hab Subproject { get; set; }

    }
}