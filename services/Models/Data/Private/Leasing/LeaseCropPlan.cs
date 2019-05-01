using services.Models;
using services.Models.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

public static class LeaseCropPlanExtensions
{
    //Extension method to give ServicesContext this property.
    public static DbSet<LeaseCropPlan> LeaseCropPlan(this ServicesContext ctx)
    {
        return ctx.GetDbSet("LeaseCropPlan").Cast<LeaseCropPlan>();
    }
}

namespace services.Models.Data
{
    public class LeaseCropPlan : DataEntity
    {
        public int Id { get; set; }
        public int SequenceId { get; set; } //incremented for each crop plan revision: all crop plan rows have same seqid for each revision
        public int LeaseId { get; set; }
        public int LeaseYear { get; set; }
        public string CropRequirement { get; set; }
        public Boolean? OptionAlternateCrop { get; set; }
        public DateTime? ChangedDate { get; set; }
        public string ChangedBy { get; set; }
        public string ChangedReason { get; set; }
        
    }
}