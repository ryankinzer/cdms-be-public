
using System;

namespace services.Models.Data
{
    public class SnorkelFish_Header : DataHeader
    {
        public string Team { get; set; }
        public string NoteTaker { get; set; } 
        public string StartTime { get; set; } 
        public string EndTime { get; set; } 
        public double? StartWaterTemp { get; set; } 
        public string Visibility { get; set; }
        public string WeatherConditions{ get; set; } 
        public int? VisitId { get; set; }
        public string Comments { get; set; }
        public string CollectionType { get; set; }
        public string DominantSpecies { get; set; } 
        public string CommonSpecies { get; set; } 
        public string RareSpecies { get; set; } 
        public string IsAEM { get; set; }

        public int? HabitatVisitId { get; set; }
        public double? EndWaterTemp { get; set; }
        public string Protocol { get; set; }

        public string FieldSheetFile { get; set; }
    }
}

