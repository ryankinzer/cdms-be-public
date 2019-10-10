using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class BiomVisitMetrics_Header : DataHeader
    {
        public int? AemChampID { get; set; }
        public int? VisitYear { get; set; }
        public string ProtocolID { get; set; }
        public string SiteName { get; set; }
        public int? VisitID { get; set; }
    }
}