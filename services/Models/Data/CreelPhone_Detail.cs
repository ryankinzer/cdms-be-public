using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class CreelPhone_Detail : DataDetail
    {
        public int? StreamName { get; set; }
        public int? Trips { get; set; }
        public decimal? HoursFished { get; set; }
        public int? CreelInterviews { get; set; }
        public string Species { get; set; }
        public int? NumberCaught { get; set; }
        public string Disposition { get; set; }
        public string LifeStage { get; set; }
        public string Sex { get; set; }
        public string Origin { get; set; }
        public string MethodCaught { get; set; }
        public string FishComments { get; set; }
    }
}