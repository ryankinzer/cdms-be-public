using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class Metrics_Detail : DataDetail
    {
        //public int? YearReported { get; set; }
        public string WorkElementName { get; set; }
        //public string WorkElementTitle;
        public string Measure { get; set; }
        public double? PlannedValue { get; set; }
        public double? ActualValue { get; set; }
        public string Comments { get; set; }
        public string RVTouchstone { get; set; }
        public string ReportingLevel  { get; set; }
        public string ReportingMetric { get; set; }
    }
}