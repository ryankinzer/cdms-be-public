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
    public static class PermitExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<Permit> Permit(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Permit").Cast<Permit>();
        }
    }
}


namespace services.Models.Data
{
    public class Permit : DataEntity
    {
        public int Id { get; set; }
        public string AllotmentName { get; set; }

        public string ProjectName { get; set; }
        public string PermitNumber { get; set; }
        public int? PermitType { get; set; }
        public DateTime? ApplicationDate { get; set; }
        public string ImprovementType { get; set; }
        public DateTime? IssueDate { get; set; }
        public string IssuedBy { get; set; }
        public string ReviewedBy { get; set; }
        public DateTime? ExpireDate { get; set; }
        public DateTime? CloseDate { get; set; }

        public string PermitStatus { get; set; }
        public DateTime? StatusDate { get; set; }
        public string StatusBy { get; set; } 
        public string StatusNotes { get; set; }

        public string PermitConditions { get; set; }
        public string PermitFile { get; set; }
        public string FileStatus { get; set; }
        
        public decimal? Fee { get; set; }
        public DateTime? FeePaymentDate { get; set; }
        public decimal? FeePaymentAmount{ get; set; }
        public string FeePaymentType { get; set; }
        public string FeePaymentMethod { get; set; }
        public string FeePaymentReference { get; set; }
        public string FeePaidBy { get; set; }
        public string FeeReceivedBy { get; set; }
        public DateTime? FeeNotificationDate { get; set; }

        public string Zoning { get; set; }
        public bool? GISUpdateRequired { get; set; }
        public bool? GISUpdateComplete { get; set; }
        public string Comments { get; set; }

        public string SiteAddress { get; set; }
        public string SquareFeet { get; set; }
        public string SiteCity { get; set; }
        public string SiteState { get; set; }
        public string SiteZip { get; set; }
        public string SiteTownship { get; set; }
        public string SiteRange { get; set; }
        public string SiteSection { get; set; }
        public string SiteQuarter { get; set; }
        public string SiteSixteenth { get; set; }
        public decimal? Valuation { get; set; }
        public string BuildingUse { get; set; }
        public string LegalDescription { get; set; }

        public bool? IsVoid { get; set; }
        public bool? IsFloodHazardOverlay { get; set; }
        public string OccupancyGroup { get; set; }
        public string ConstructionType { get; set; }
        public string BusinessName { get; set; }

        public string COStatus { get; set; }
        public DateTime? COIssueDate { get; set; }
        public string COConditions { get; set; }


        public string ReviewsRequired { get; set; }
        public string ScopeOfWork { get; set; }

        public string Route_BldgCode { get; set; }
        public string Route_WRP { get; set; }
        public string Route_Env { get; set; }
        public string Route_PubWrks { get; set; }
        public string Route_TERO { get; set; }
        public string Route_CRPP { get; set; }
        public string Route_Roads { get; set; }


    }
}