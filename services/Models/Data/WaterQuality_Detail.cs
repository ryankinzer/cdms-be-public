using services.Resources.Attributes;
using System;

namespace services.Models.Data
{
    public class WaterQuality_Detail : DataDetail
    {
        public string CharacteristicName { get; set; }

        [DecimalPrecision(9, 3)]
        public decimal? Result { get; set; }

        public string ResultUnits { get; set; }
        public string LabDuplicate { get; set; }
        public string Comments { get; set; }
        public string MdlResults { get; set; }
        public DateTime? SampleDate { get; set; }
        public string SampleID { get; set; }

        public string SampleFraction { get; set; }
        public string MethodSpeciation { get; set; }
        public string DetectionLimit { get; set; }
        public string ContextID { get; set; }
        public string MethodID { get; set; }
        public string LabName { get; set; }
        public string CharactDetected { get; set; }
    }
}