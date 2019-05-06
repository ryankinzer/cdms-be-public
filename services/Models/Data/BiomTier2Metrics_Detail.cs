using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class BiomTier2Metrics_Detail : DataDetail
    {
        public string Tier2 { get; set; }
        public decimal? Area { get; set; }
        public int? Ct { get; set; }
        public decimal? UnitSpacing { get; set; }
        public decimal? Freq { get; set; }
        public decimal? Vol { get; set; }
        public decimal? Pct { get; set; }
        public decimal? DpthThlwgMaxAvg { get; set; }
        public decimal? DpthThlwgExit { get; set; }
        public decimal? DpthResid { get; set; }
    }
}