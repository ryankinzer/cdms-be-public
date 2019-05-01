using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class LeaseComplianceAction : DataEntity
    {
        public int Id { get; set; }
        public int InspectionId { get; set; }
        public int LeaseId { get; set; }
        public string ViolationType { get; set; }
        public string Resolution { get; set; }
        public decimal? FeeAmount { get; set; }
        public decimal? HoursSpent { get; set; }

        

    }
}