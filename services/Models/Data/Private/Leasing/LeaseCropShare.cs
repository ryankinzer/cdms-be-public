using services.Models;
using services.Models.Data;
using services.Resources.Attributes;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

public static class LeaseCropSharePlanExtensions
{
    //Extension method to give ServicesContext this property.
    public static DbSet<LeaseCropShare> LeaseCropShare(this ServicesContext ctx)
    {
        return ctx.GetDbSet("LeaseCropShare").Cast<LeaseCropShare>();
    }
}

namespace services.Models.Data
{
    public class LeaseCropShare
    {
        public int Id { get; set; }
        public int LeaseId { get; set; }
        public string Crop { get; set; }
        public string CropShareType { get; set; }
        public string Comment { get; set; }

        [DecimalPrecision(5, 2)]
        public decimal? CropSharePercent { get; set; }

        [DecimalPrecision(5, 2)]
        public decimal? CostSharePercent { get; set; }
    }
}