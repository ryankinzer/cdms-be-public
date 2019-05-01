using services.Models;
using services.Models.Data;
using services.Resources.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;
using System.Web;

public static class LeaseInspectionPlanExtensions
{
    //Extension method to give ServicesContext this property.
    public static DbSet<LeaseInspection> LeaseInspection(this ServicesContext ctx)
    {
        return ctx.GetDbSet("LeaseInspection").Cast<LeaseInspection>();
    }
}

namespace services.Models.Data
{
    public class LeaseInspection : DataEntity
    {
        public int Id { get; set; }
        public int LeaseId { get; set; }
        public string LeaseYear { get; set; }
        public string InspectionType { get; set; }
        public DateTime? InspectionDateTime { get; set; }
        public string InspectedBy { get; set; }
        public string CropPresent { get; set; }
        public string Weeds1 { get; set; }
        public string Weeds2 { get; set; }
        public string Weeds3 { get; set; }
        public int? CropResiduePct { get; set; }
        public int? GreenCoverPct { get; set; }
        public int? ClodPct { get; set; }
        public string ResidueType { get; set; }
        public string SubstitutePractices { get; set; }
        public string ImprovementTresspass { get; set; }
        public Boolean? OutOfCompliance { get; set; }
        public Boolean? FieldRecordsReceived{ get; set; }
        public string Animals { get; set; }
        public string Notes { get; set; }

        //violations fields
        public string ViolationLandAreaCode { get; set; }
        public string ViolationOwnerType { get; set; }
        public string ViolationType { get; set; }
        public Boolean ViolationIsResolved { get; set; }
        public string ViolationResolution { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? ViolationFeeCollected { get; set; }
        public DateTime? ViolationDateFeeCollected { get; set; }
        public string ViolationFeeCollectedBy { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? ViolationHoursSpent { get; set; }
        public string ViolationComments { get; set; }

    }
}