using services.Resources.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class BiomTier1Metrics_Detail : DataDetail
    {
        //added 11/04/19 kb
        public string MetricSchemaCanonicalName { get; set; }
        public int? SampleID { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedLWDVolumeStdDev { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullLWDVolumeStdDev { get; set; }
        // end added

        public string TierOneType { get; set; } //renamed

        public int? Ct { get; set; }
        public int? LargeWoodyPiecesCount { get; set; } //renamed
        public int? CountOfChinook { get; set; }
        public int? CountOfCoho { get; set; }
        public int? CountOfSockeye { get; set; }
        public int? CountOfChum { get; set; }
        public int? CountOfOmykiss { get; set; }
        public int? CountOfPink { get; set; }
        public int? CountOfCutthroat { get; set; }
        public int? CountOfBulltrout { get; set; }
        public int? CountOfBrooktrout { get; set; }
        public int? CountOfLamprey { get; set; }
        public int? CountOfOtherSpecies { get; set; }


        [DecimalPrecision(16, 8)]
        public decimal? Area { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? UnitSpacing { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? Freq { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? Vol { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? Pct { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DpthThlwgMaxAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DpthThlwgExit { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DpthResid { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SubEstBldr { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SubEstCbl { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SubEstGrvl { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SubEstSandFines { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCovLW { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCovTVeg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCovUcut { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCovArt { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCovAqVeg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCovNone { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCovTotal { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedLargeWoodVolumeByTier1 { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? BankfullLargeWoodVolumeByTier1 { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfChinook { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfCoho { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfSockeye { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfChum { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfOmykiss { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfPink { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfCutthroat { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfBulltrout { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfBrooktrout { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfLamprey { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfOtherSpecies { get; set; }


    }
}