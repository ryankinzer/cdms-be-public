using System;

namespace services.Models.Data
{
    public class WaterQuality_Header : DataHeader
    {
        public string DataType { get; set; }
        public string FieldsheetLink { get; set; }
        public string HeaderComments { get; set; }
        public string DataSource { get; set; }
    }
}