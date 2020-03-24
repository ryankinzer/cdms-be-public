using System;

namespace services.Models.Data
{
    public class StreamNet_NOSA_Detail : DataDetail
    {
        public StreamNet_NOSA_Detail()
        {
            ShadowId = Guid.NewGuid().ToString();
        }

        public string CommonName { get; set; }
        public string Run { get; set; }
        public string PopFit { get; set; }
        public string WaterBody { get; set; }
        public string SpawningYear { get; set; }
        public string TRTmethod { get; set; }
        public string MethodNumber { get; set; }
        public string NOSAIJ { get; set; }
        public string NOSAEJ { get; set; }
        public string Comment { get; set; }
        public string NullRecord { get; set; }
        public string DataStatus { get; set; }
        public string ContactPersonFirst { get; set; }
        public string ContactPersonLast { get; set; }
        public string ContactPhone { get; set; }
        public string ContactEmail { get; set; }

        // Extra fields not exposed in the UI, but required for StreamNet. 

        public string Age10Prop { get; set; }
        public string Age10PropLowerLimit { get; set; }
        public string Age10PropUpperLimit { get; set; }
        public string Age11PlusProp { get; set; }
        public string Age11PlusPropLowerLimit { get; set; }
        public string Age11PlusPropUpperLimit { get; set; }
        public string Age2Prop { get; set; }
        public string Age2PropLowerLimit { get; set; }
        public string Age2PropUpperLimit { get; set; }
        public string Age3Prop { get; set; }
        public string Age3PropLowerLimit { get; set; }
        public string Age3PropUpperLimit { get; set; }
        public string Age4Prop { get; set; }
        public string Age4PropLowerLimit { get; set; }
        public string Age4PropUpperLimit { get; set; }
        public string Age5Prop { get; set; }
        public string Age5PropLowerLimit { get; set; }
        public string Age5PropUpperLimit { get; set; }
        public string Age6Prop { get; set; }
        public string Age6PropLowerLimit { get; set; }
        public string Age6PropUpperLimit { get; set; }
        public string Age7Prop { get; set; }
        public string Age7PropLowerLimit { get; set; }
        public string Age7PropUpperLimit { get; set; }
        public string Age8Prop { get; set; }
        public string Age8PropLowerLimit { get; set; }
        public string Age8PropUpperLimit { get; set; }
        public string Age9Prop { get; set; }
        public string Age9PropLowerLimit { get; set; }
        public string Age9PropUpperLimit { get; set; }
        public string AgePropAlpha { get; set; }
        public string BestValue { get; set; }
        public string CBFWApopName { get; set; }
        public string Comments { get; set; }
        public string CommonPopName { get; set; }
        public string CompilerRecordID { get; set; }
        public string DataEntry { get; set; }
        public string DataEntryNotes { get; set; }
        public string ESU_DPS { get; set; }
        public string HOSJF { get; set; }
        public string IndicatorLocation { get; set; }
        public string LastUpdated { get; set; }
        public string MajorPopGroup { get; set; }
        public string MeasureLocation { get; set; }
        public string MetaComments { get; set; }
        public string MethodAdjustments { get; set; }
        public string MetricLocation { get; set; }
        public string NOBroodStockRemoved { get; set; }
        public string NOSAEJAlpha { get; set; }
        public string NOSAEJLowerLimit { get; set; }
        public string NOSAEJUpperLimit { get; set; }
        public string NOSAIJAlpha { get; set; }
        public string NOSAIJLowerLimit { get; set; }
        public string NOSAIJUpperLimit { get; set; }
        public string NOSJF { get; set; }
        public string NOSJFAlpha { get; set; }
        public string NOSJFLowerLimit { get; set; }
        public string NOSJFUpperLimit { get; set; }
        public string OtherDataSources { get; set; }
        public string PopFitNotes { get; set; }
        public string PopID { get; set; }
        public string ProtMethDocumentation { get; set; }
        public string ProtMethName { get; set; }
        public string ProtMethURL { get; set; }
        public string Publish { get; set; }
        public string RecoveryDomain { get; set; }
        public string RefID { get; set; }
        public string SubmitAgency { get; set; }
        public string TSAEJ { get; set; }
        public string TSAEJAlpha { get; set; }
        public string TSAEJLowerLimit { get; set; }
        public string TSAEJUpperLimit { get; set; }
        public string TSAIJ { get; set; }
        public string TSAIJAlpha { get; set; }
        public string TSAIJLowerLimit { get; set; }
        public string TSAIJUpperLimit { get; set; }
        public string UpdDate { get; set; }
        public string pHOSej { get; set; }
        public string pHOSejAlpha { get; set; }
        public string pHOSejLowerLimit { get; set; }
        public string pHOSejUpperLimit { get; set; }
        public string pHOSij { get; set; }
        public string pHOSijAlpha { get; set; }
        public string pHOSijLowerLimit { get; set; }
        public string pHOSijUpperLimit { get; set; }

        public string ContactAgency { get; set; }
        public String ShadowId { get; set; } 
        public string EstimateType { get; set; }
        public string EstimateTypeNotes { get; set; }
    }
}