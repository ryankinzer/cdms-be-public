using System;

namespace services.Models.Data
{
    public class SpawningGroundSurvey_Header : DataHeader
    {
        public string TargetSpecies { get; set; }
        public string Technicians { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public float? StartTemperature { get; set; }
        public float? EndTemperature { get; set; }
        public double? StartEasting { get; set; }
        public double? StartNorthing { get; set; }
        public double? EndEasting { get; set; }
        public double? EndNorthing { get; set; }
        public string Flow { get; set; }
        public string WaterVisibility { get; set; }
        public string Weather { get; set; }
        public int? FlaggedRedds { get; set; }
        public int? NewRedds { get; set; }
        public string HeaderComments { get; set; }
        public string FieldsheetLink { get; set; }
        public string StrandingIssues { get; set; }
        public string StrandingComments { get; set; }
    }
}