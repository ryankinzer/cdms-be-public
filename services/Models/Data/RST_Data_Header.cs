using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class RST_Data_Header : DataHeader
    {
        public string MRRProject { get; set; }
        public string SessionNote { get; set; }
        public string EventSite { get; set; }

      //User-defined Fields
        public float RSTrpm { get; set; }
        public string OperationalCondition { get; set; }
        public float StaffGauge { get; set; }
        public string Weather { get; set; }
        public string WaterClarity { get; set; }
        public float SillDepth { get; set; }
        public string TrapPosition { get; set; }
        public DateTime TrapStartDateTime { get; set; }
        public DateTime TrapEndDateTime { get; set; }
        public float HoursSampled { get; set; }

    }
}

