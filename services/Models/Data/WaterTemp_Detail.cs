using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class WaterTemp_Detail : DataDetail
    {
        public DateTime ReadingDateTime { get; set; }
        public DateTime? GMTReadingDateTime { get; set; }
        public double? WaterTemperature { get; set; }
        public double? WaterTemperatureF { get; set; }
        public double? AirTemperature { get; set; }
        public double? AirTemperatureF { get; set; }
        public double? WaterLevel { get; set; }
        public double? TempAToD { get; set; }
        public double? BatteryVolts { get; set; }
        public double? Conductivity { get; set; }
        public double? PSI { get; set; }
        public double? AbsolutePressure { get; set; }
        public double? Depth { get; set; }
        public double? Discharge { get; set; }
        public double? MinWaterTemperatureC { get; set; }
        public double? MaxWaterTemperatureC { get; set; }
        public double? MeanWaterTemperatureC { get; set; }
        public double? MinAirTemperatureC { get; set; }
        public double? MaxAirTemperatureC { get; set; }
        public double? MeanAirTempratureC { get; set; }
        public double? MinWaterTemperatureF { get; set; }
        public double? MaxWaterTemperatureF { get; set; }
        public double? MeanWaterTemperatureF { get; set; }
        public double? MinAirTemperatureF { get; set; }
        public double? MaxAirTemperatureF { get; set; }
        public double? MeanAirTempratureF { get; set; }

    }
}