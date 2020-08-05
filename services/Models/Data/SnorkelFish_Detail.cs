using services.Resources.Attributes;

namespace services.Models.Data
{
    public class SnorkelFish_Detail : DataDetail
    {
        public string NoSnorklers { get; set; } 
        public int? FishID { get; set; }
        public int? ChannelUnitNumber { get; set; }
        public string ChannelUnitType { get; set; }
        public int? Lane { get; set; }
        public string Type { get; set; } 
        public double? ChannelAverageDepth { get; set; } 
        public double? ChannelLength { get; set; } 
        public double? ChannelWidth { get; set; } 
        public double? ChannelMaxDepth { get; set; } 
        public int? FishCount { get; set; }
        public string Species { get; set; }
        public string SizeClass { get; set; }
        public string UnidentifiedSalmonID { get; set; } 
        public string OtherSpeciesPres { get; set; } 
        public string NaturalWoodUsed { get; set; }
        public string PlacedWoodUsed { get; set; }
        public string NaturalBoulderUsed { get; set; }
        public string PlacedBoulderUsed { get; set; }
        public string NaturalOffChannelUsed { get; set; }
        public string CreatedOffChannelUsed { get; set; }
        public string NewSideChannelUsed { get; set; }
        public string NoStructureUsed { get; set; }
        public double? AmbientTemp { get; set; } 
        public double? MinimumTemp { get; set; } 
        public string FieldNotes { get; set; }
        public string AEMHabitatType { get; set; }
        public int? AEMLength { get; set; }

        public string Unit { get; set; }
        [DecimalPrecision(18, 8)]
        public decimal? GPSEasting { get; set; }
        [DecimalPrecision(18, 8)]
        public decimal? GPSNorthing { get; set; }

        public int? WaypointNumber { get; set; }
    }
}