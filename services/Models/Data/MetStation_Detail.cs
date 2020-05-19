using services.Resources.Attributes;
using System;

namespace services.Models.Data
{
    public class MetStation_Detail : DataDetail
    {
        public string CharacteristicName { get; set; }

        [DecimalPrecision(9, 3)]
        public decimal? Result { get; set; }

        public string ResultUnits { get; set; }
        public string Comments { get; set; }
        public DateTime? SampleDate { get; set; }
    }
}