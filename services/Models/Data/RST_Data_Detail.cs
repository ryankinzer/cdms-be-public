using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class RST_Data_Detail : DataDetail
    {
        public int BroodYear { get; set; }
        public string ConditionalComments { get; set; }
        public string EventType { get; set; }
        public float Length { get; set; }
        public string Lifestage { get; set; }
        public string MarkMethod { get; set; }
        public float MarkTemperature { get; set; }
        public int MigrationYear { get; set; }
        public string PITTag { get; set; }
        public DateTime ReleaseDate { get; set; }
        public string ReleaseSite { get; set; }
        public float ReleaseTemperature { get; set; }
        public string SpeciesRun { get; set; }
        public string Origin { get; set; }
        //public string SpeciesRunRearType { get; set; }  -- P4 field that can be parsed into SpeciesRun and Origin
        public string Tagger { get; set; }
        public string TextComments { get; set; }
        public float Weight { get; set; }

      //User-defined Fields
        public string AdditionalPositional { get; set; }
        public int NFish { get; set; }
        public string Disposition { get; set; }
        public float Girth { get; set; }
        public string InterDorsal { get; set; }
        public string SampleType { get; set; }

    }
}