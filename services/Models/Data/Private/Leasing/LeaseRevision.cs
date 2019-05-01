using services.Models;
using services.Models.Data;
using services.Resources.Attributes;
using services.ExtensionMethods;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;
using System.Web;

//this class is a copy of Lease with a couple of additional fields for the sake of audit tracking.

namespace services.ExtensionMethods
{
    public static class LeaseRevisionExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<LeaseRevision> LeaseRevision(this ServicesContext ctx)
        {
            return ctx.GetDbSet("LeaseRevision").Cast<LeaseRevision>();
        }
    }
}

namespace services.Models.Data
{
    public class LeaseRevision : DataEntity
    {
        //our audit columns
        public int Id { get; set; }
        public string ChangedBy { get; set; }
        public string ChangedReason { get; set; }
        public DateTime? ChangedDate { get; set; }

        //our lease columns
        public int LeaseId { get; set; }
        public string AllotmentName { get; set; }
        public string LeaseNumber { get; set; }
        public string FarmNumber { get; set; } //?
        public string FSATractNumber { get; set; }
        public string LeaseType { get; set; }
        public DateTime? NegotiateDate { get; set; }
        public int? LeaseOperatorId { get; set; }
        public DateTime? TransactionDate { get; set; }

        [DecimalPrecision(9, 3)]
        public decimal? LeaseAcres { get; set; }

        [DecimalPrecision(9, 3)]
        public decimal? ProductiveAcres { get; set; }

        public string LeaseDuration { get; set; }
        public DateTime? LeaseStart { get; set; }
        public DateTime? LeaseEnd { get; set; }
        public string DueDate { get; set; }

        [DecimalPrecision(9, 2)] 
        public decimal? DollarPerAnnum{ get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? DollarAdvance { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? DollarBond { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? LeaseFee { get; set; }

        public DateTime? ApprovedDate { get; set; }
        public DateTime? WithdrawlDate { get; set; }
        public int? Level { get; set; }
        public int? Status { get; set; }
        public DateTime? StatusDate { get; set; }
        public string StatusBy { get; set; }
        public Boolean? UnderInternalReview { get; set; }
        public DateTime? InternalReviewStartDate { get; set; }


        public int? ResidueRequiredPct { get; set; }
        public int? GreenCoverRequiredPct { get; set; }
        public int? ClodRequiredPct { get; set; }

        public Boolean? OptionalAlternativeCrop { get; set; }
        public Boolean? HEL { get; set; }
        public DateTime? GrazeStart { get; set; }
        public DateTime? GrazeEnd { get; set; }

        public int? AUMs { get; set; }
        public string GrazeAnimal { get; set; }
        public string Notes { get; set; }
        public string TAAMSNumber { get; set; }

        public virtual LeaseOperator LeaseOperator { get; set; }

        public string PaymentDueType { get; set; }
        public string PaymentDueDescription { get; set; }

        public int? FieldNumber { get; set; }

        public string PaymentUnit { get; set; }


        //public string LeaseLength { get; set; }


    }


}