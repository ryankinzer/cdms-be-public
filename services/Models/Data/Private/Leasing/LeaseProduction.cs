using services.Models;
using services.Models.Data;
using services.Resources.Attributes;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

public static class LeaseProductionExtensions
{
    //Extension method to give ServicesContext this property.
    public static DbSet<LeaseProduction> LeaseProduction(this ServicesContext ctx)
    {
        return ctx.GetDbSet("LeaseProduction").Cast<LeaseProduction>();
    }
}

namespace services.Models.Data
{
    public class LeaseProduction : DataEntity
    {
        public int Id { get; set; }
        public int LeaseId { get; set; }
        public int LeaseYear { get; set; }
        public DateTime? IncomeDate { get; set; }
        public string IncomePostedBy { get; set; }
        public string HarvestedCrop { get; set; }
        public string CropType { get; set; }
        public string CropVariety { get; set; }
        public string CropGrade { get; set; }
        public DateTime? HarvestDate { get; set; }
        public string DeliveryPoint { get; set; }
        public string DeliveryLocation { get; set; }
        public string DeliveryUnit { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? Gross { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? Net { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? YieldAcre { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? CropAcres { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? MarketPrice { get; set; }

        public string MarketUnit { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? CropShareDollar { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? Deduction { get; set; }
        public string DeductionType { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? PaymentAmount { get; set; }
        public string PaymentType { get; set; }

        [DecimalPrecision(9, 2)]
        public decimal? TotalPaymentAmount { get; set; }

        public string Comments { get; set; }
    }
}