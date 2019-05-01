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
using System.ComponentModel.DataAnnotations;

namespace services.ExtensionMethods
{
    public static class LeaseExtensions
    {
        //Extension method to give ServicesContext this property.
        public static DbSet<Lease> Lease(this ServicesContext ctx)
        {
            return ctx.GetDbSet("Lease").Cast<Lease>();
        }
    }
}

namespace services.Models.Data
{
    public class Lease : DataEntity
    {
        public static int STATUS_ACTIVE = 1;
        public static int STATUS_INACTIVE = 2;
        public static int STATUS_PENDING = 3;
        public static int STATUS_WITHDRAWN = 4;
        public static int STATUS_EXPIRED = 5;
        public static int STATUS_CANCELLED = 6;

        [Key]
        public int Id { get; set; }
        public string AllotmentName { get; set; }
        public string LeaseNumber { get; set; }
        public string FarmNumber { get; set; } 
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
        public decimal? DollarPerAnnum { get; set; }

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

        //from Candice/Stevie

        public string PaymentDueType { get; set; }
        public string PaymentDueDescription { get; set; }
        
        public string PaymentUnit { get; set; }

        public int? FieldNumber { get; set; }

        //public string LeaseLength { get; set; }




        //relationships
        public virtual LeaseOperator LeaseOperator { get; set; }
        public virtual List<LeaseProduction> LeaseProductions { get; set; }
        public virtual List<LeaseInspection> LeaseInspections { get; set; }
        public virtual List<LeaseComplianceAction> LeaseComplianceActions { get; set; }
        public virtual List<LeaseCropShare> LeaseCropShares { get; set; }

        //relationship to a view-backed entity
        public virtual List<LeaseField> LeaseFields { get; set; }

        //get the CURRENT lease crop plan (need to do it on our own because we need the latest sequence #'d ones)
        public IEnumerable<LeaseCropPlan> LeaseCropPlans
        {
            get
            {
                var db = ServicesContext.Current;

                var LeaseCropPlans = db.GetDbSet("LeaseCropPlan").Cast<LeaseCropPlan>();

                var crops = from p in LeaseCropPlans
                            where p.LeaseId == this.Id
                            where p.SequenceId == (LeaseCropPlans.Where(o => o.LeaseId == p.LeaseId).Max(o => o.SequenceId))
                            select p;

                return crops.AsEnumerable();

            }
            set { throw new NotImplementedException(); }
        }

        public LeaseRevision getRevision(User me, string in_reason)
        {
            LeaseRevision rev = new LeaseRevision();
            rev.ChangedBy = me.Fullname;
            rev.ChangedDate = DateTime.Now;
            rev.ChangedReason = in_reason;
            rev.LeaseId = this.Id;
            rev.AllotmentName = this.AllotmentName;
            rev.LeaseNumber = this.LeaseNumber;
            rev.FarmNumber = this.FarmNumber;
            rev.FSATractNumber = this.FSATractNumber;
            rev.LeaseType = this.LeaseType;
            rev.TransactionDate = this.TransactionDate;
            rev.NegotiateDate = this.NegotiateDate;
            rev.LeaseOperatorId = this.LeaseOperatorId;
            rev.LeaseAcres = this.LeaseAcres;
            rev.ProductiveAcres = this.ProductiveAcres;
            rev.LeaseDuration = this.LeaseDuration;
            rev.LeaseStart = this.LeaseStart;
            rev.LeaseEnd = this.LeaseEnd;
            rev.DueDate = this.DueDate;
            rev.DollarAdvance = this.DollarAdvance;
            rev.DollarBond = this.DollarBond;
            rev.DollarPerAnnum = this.DollarPerAnnum;
            rev.LeaseFee = this.LeaseFee;
            rev.ApprovedDate = this.ApprovedDate;
            rev.WithdrawlDate = this.WithdrawlDate;
            rev.Level = this.Level;
            rev.Status = this.Status;
            rev.StatusDate = this.StatusDate;
            rev.StatusBy = this.StatusBy;
            rev.UnderInternalReview = this.UnderInternalReview;
            rev.InternalReviewStartDate = this.InternalReviewStartDate;
            rev.ResidueRequiredPct = this.ResidueRequiredPct;
            rev.GreenCoverRequiredPct = this.GreenCoverRequiredPct;
            rev.ClodRequiredPct = this.ClodRequiredPct;
            rev.OptionalAlternativeCrop = this.OptionalAlternativeCrop;
            rev.GrazeStart = this.GrazeStart;
            rev.GrazeEnd = this.GrazeEnd;
            rev.AUMs = this.AUMs;
            rev.GrazeAnimal = this.GrazeAnimal;
            rev.Notes = this.Notes;
            rev.TAAMSNumber = this.TAAMSNumber;
            rev.PaymentDueType = this.PaymentDueType;
            rev.PaymentDueDescription = this.PaymentDueDescription;
            rev.FieldNumber = this.FieldNumber;
            rev.PaymentUnit = this.PaymentUnit;
            rev.HEL = this.HEL;

            return rev;
        }
    }

    
}