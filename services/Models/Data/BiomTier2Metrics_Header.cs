using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class BiomTier2Metrics_Header : DataHeader
    {
        public int? ProgramSiteID { get; set; }
        public string SiteName { get; set; }
        public int? WatershedID { get; set; }
        public string WatershedName { get; set; }
        public DateTime? SampleDate { get; set; }
        public string HitchName { get; set; }
        public string CrewName { get; set; }
        public int? VisitYear { get; set; }
        public int? IterationID { get; set; }
        public string CategoryName { get; set; }
        public string PanelName { get; set; }
        public int? VisitID { get; set; }
        public DateTime? VisitDate { get; set; }
        public string ProtocolID { get; set; }
        public int? ProgramID { get; set; }
        public string AEM { get; set; }
        public string Effectiveness { get; set; }
        public string HasFishData { get; set; }
        public string PrimaryVisit { get; set; }
        public string QCVisit { get; set; }
    }
}