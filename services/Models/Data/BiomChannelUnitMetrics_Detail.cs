using services.Resources.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class BiomChannelUnitMetrics_Detail : DataDetail
    {

        //added 11/04/2019 kb
        public string MetricSchemaCanonicalName { get; set; } 
        public int? SampleID { get; set; }
        public int? CountOfBrooktrout { get; set; }
        public int? CountOfBulltrout { get; set; }
        public int? CountOfChinook { get; set; }
        public int? CountOfCoho { get; set; }
        public int? CountOfCutthroat { get; set; }
        public int? CountOfOmykiss { get; set; }
        public int? CountOfOtherSpecies { get; set; }
        public int? CountOfPink { get; set; }
        public int? CountOfSockeye { get; set; }
        public int? CountOfLamprey { get; set; }
        // end added

        //added 12/5/2019 kb
        [DecimalPrecision(16, 8)]
        public decimal? DensityOfBrooktrout { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfBulltrout { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfChinook { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfCoho { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfCutthroat { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfLamprey { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfOmykiss { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfOtherSpecies { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfPink { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfSockeye { get; set; }
        //end added


        public int? ChUnitID { get; set; }
        public int? ChannelUnitID { get; set; } //renamed
        public int? LargeWoodyPiecesCount { get; set; } //renamed

        public string TierOneType { get; set; } //renamed
        public string TierTwoType { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? AreaTotal { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? PolyArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? TotalVol { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DpthMax { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DpthThlwgExit { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DpthResid { get; set; }
        


    }
}