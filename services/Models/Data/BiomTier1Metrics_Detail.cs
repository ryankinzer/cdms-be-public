using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class BiomTier1Metrics_Detail : DataDetail
    {
        public string Tier1 { get; set; }
        public decimal? Area { get; set; }
        public int? Ct { get; set; }
        public decimal? UnitSpacing { get; set; }
        public decimal? Freq { get; set; }
        public decimal? Vol { get; set; }
        public decimal? Pct { get; set; }
        public decimal? DpthThlwgMaxAvg { get; set; }
        public decimal? DpthThlwgExit { get; set; }
        public decimal? DpthResid { get; set; }
        public decimal? SubEstBldr { get; set; }
        public decimal? SubEstCbl { get; set; }
        public decimal? SubEstGrvl { get; set; }
        public decimal? SubEstSandFines { get; set; }
        public decimal? FishCovLW { get; set; }
        public decimal? FishCovTVeg { get; set; }
        public decimal? FishCovUcut { get; set; }
        public decimal? FishCovArt { get; set; }
        public decimal? FishCovAqVeg { get; set; }
        public decimal? FishCovNone { get; set; }
        public decimal? FishCovTotal { get; set; }
        public decimal? LWVolWetTier1 { get; set; }
        public decimal? LWVolBfTier1 { get; set; }
        public int? CountOfLWD { get; set; }
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
        public decimal? DensityOfChinook { get; set; }
        public decimal? DensityOfCoho { get; set; }
        public decimal? DensityOfSockeye { get; set; }
        public decimal? DensityOfChum { get; set; }
        public decimal? DensityOfOmykiss { get; set; }
        public decimal? DensityOfPink { get; set; }
        public decimal? DensityOfCutthroat { get; set; }
        public decimal? DensityOfBulltrout { get; set; }
        public decimal? DensityOfBrooktrout { get; set; }
        public decimal? DensityOfLamprey { get; set; }
        public decimal? DensityOfOtherSpecies { get; set; }
    }
}