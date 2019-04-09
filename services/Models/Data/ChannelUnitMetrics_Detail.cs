﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class ChannelUnitMetrics_Detail : DataDetail
    {
        public int? ChUnitID { get; set; }
        public int? ChUnitNum { get; set; }
        public int? Tier1 { get; set; }
        public int? Tier2 { get; set; }
        public decimal? AreaTotal { get; set; }
        public decimal? PolyArea { get; set; }
        public decimal? TotalVol { get; set; }
        public decimal? DpthMax { get; set; }
        public decimal? DpthThlwgExit { get; set; }
        public decimal? DpthResid { get; set; }
        public int? CountOfLWD { get; set; }
    }
}