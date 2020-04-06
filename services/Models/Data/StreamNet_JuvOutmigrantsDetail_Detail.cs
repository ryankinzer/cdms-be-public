using System;

namespace services.Models.Data
{
    public class StreamNet_JuvOutmigrantsDetail_Detail : DataDetail
    {
        //public StreamNet_JuvOutmigrantsDetail_Detail()
        //{
        //    ShadowId = Guid.NewGuid().ToString();
        //}

        public string JuvenileOutmigrantsID { get; set; }
        public string Location { get; set; }
        public string LocPTcode { get; set; }
        public string LifeStage { get; set; }
        public string TotalNatural { get; set; }
        public string TotalNaturalLowerLimit { get; set; }
        public string TotalNaturalUpperLimit { get; set; }
        public string TotalNaturalAlpha { get; set; }
        public string SurvivalRate { get; set; }
        public string SurvivalRateLowerLimit { get; set; }
        public string SurvivalRateUpperLimit { get; set; }
        public string SurvivalRateAlpha { get; set; }
        public string ContactAgency { get; set; }
        public string Comments { get; set; }
        public string JMXID { get; set; }
        public string NullRecord { get; set; }
        public string LastUpdated { get; set; }
        public string MetricLocation { get; set; }
        public string MeasureLocation { get; set; }
        // the following fields are needed for all submitted cax datasets
        public string SubmitAgency { get; set; }
        public string RefID { get; set; }
        public string UpdDate { get; set; }
        public string DataEntry { get; set; }
        public string DataEntryNotes { get; set; }
        public string CompilerRecordID { get; set; }
        public string Publish { get; set; }

        public String ShadowId { get; set; }
    }
}