using services.Resources.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace services.Models.Data
{
    public class BiomVisitMetrics_Detail : DataDetail
    {
        //added 11/4/19 kb
        public string MetricSchemaCanonicalName { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedLWDVolumeStdDev { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullLWDVolumeStdDev { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedLargeWoodVolumeBySite { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullLargeWoodVolumeBySite { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedLargeWoodVolumeInPools { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullLargeWoodVolumeInPools { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedLargeWoodVolumeInFastTurbulent { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullLargeWoodVolumeInFastTurbulent { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedLargeWoodVolumeInFastNonTurbulent { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullLargeWoodVolumeInFastNonTurbulent { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfOtherSpecies { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? LWVBankfull_SW { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? RiparianPercentGroundCoverNoCover { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastWaterCobbleEmbeddednessAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastWaterCobbleEmbeddednessStdDev { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SiteLength { get; set; }
        // end added

        public int? SiteMeasurementOfAlkalinity { get; set; } //renamed
        public int? BankfullChannelCount { get; set; }
        public int? BankfullChannelIslandCount { get; set; }
        public int? BankfullChannelQualifyingIslandCount { get; set; }
        public int? BankfullMainChannelPartCount { get; set; }
        public int? CountOfBrooktrout { get; set; }
        public int? CountOfBulltrout { get; set; }
        public int? CountOfChinook { get; set; }
        public int? CountOfChum { get; set; }
        public int? CountOfCoho { get; set; }
        public int? CountOfCutthroat { get; set; }
        public int? CountOfOmykiss { get; set; }
        public int? CountOfOtherSpecies { get; set; }
        public int? CountOfPink { get; set; }
        public int? CountOfSockeye { get; set; }
        public int? CountOfLamprey { get; set; }
        public int? LargeWoodyPiecesCountPoolForming { get; set; } //renamed
        public int? LargeWoodyPiecesCountRightBank { get; set; } //renamed
        public int? LargeWoodyPiecesCountIsJam { get; set; } //renamed
        public int? LargeWoodyPiecesCountIsKey { get; set; } //renamed
        public int? LargeWoodyPiecesCount { get; set; } //renamed
        public int? LargeWoodyPiecesCountLeftBank { get; set; } //renamed
        public int? LargeWoodyPiecesCountMidChannel { get; set; } //renamed
        public int? FastNonTurbulentCount { get; set; }
        public int? FastTurbulentCount { get; set; }
        public int? PercentConstrained { get; set; }
        public int? SlowWaterCount { get; set; }
        public int? WettedChannelCount { get; set; }
        public int? WettedChannelIslandCount { get; set; }
        public int? WettedChannelQualifyingIslandCount { get; set; }
        public int? WettedMainChannelPartCount { get; set; }


        [DecimalPrecision(16, 8)]
        public decimal? BankfullChannelQualifyingIslandArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullChannelTotalLength { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullDepthAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullDepthMax { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankErosion { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullChannelBraidedness { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullSideChannelWidth { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullSideChannelWidthCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullSideChannelWidthToDepthRatioAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullSideChannelWidthToDepthRatioCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullSideChannelWidthToMaxDepthRatioAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullSideChannelWidthToMaxDepthRatioCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullSiteLength { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullVolume { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullWidthAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullWidthCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullWidthIntegrated { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullWidthToDepthRatioAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullWidthToDepthRatioCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullWidthToMaxDepthRatioAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BankfullWidthToMaxDepthRatioCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? BraidChannelRatio { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SiteMeasurementOfConductivity { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? ConstrainingFeatureHeightAverage { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfBrooktrout { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfBulltrout { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfChinook { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfChum { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfCoho { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfCutthroat { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfLamprey { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfOmykiss { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfPink { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DensityOfSockeye { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? DetrendedElevationSD { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SiteDischarge { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? DriftBiomass { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastNonTurbulentArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastNonTurbulentFrequency { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastNonTurbulentPercent { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastNonTurbulentVolume { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastTurbulentArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastTurbulentFrequency { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastTurbulentPercent { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FastTurbulentVolume { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCoverAquaticVegetation { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCoverArtificial { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCoverLW { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCoverNone { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCoverTerrestrialVegetation { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FishCoverTotal { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? FloodProneWidthAverage { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? Gradient { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? LargeWoodFrequencyBankfull { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? LargeWoodFrequencyWetted { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? PoolToTurbulentAreaRatio { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? PercentUndercutByArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? PercentUndercutByLength { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? ResidualPoolDepth { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? RiparianPercentBigTreeCover { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? RiparianPercentConiferousCover { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? RiparianPercentGroundCover { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? RiparianPercentCanopyNoCover { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? RiparianPercentNonWoodyGroundCover { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? RiparianPercentUnderstoryCover { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? RiparianPercentWoodyCover { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? Sinuosity { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SinuosityViaCenterline { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SlowWaterArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SlowWaterFrequency { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SlowWaterPercent { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SlowWaterVolume { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SolarAccessSummerAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? PercentOfObservationsLessThan2mm { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? PercentOfObservationsLessThan6mm { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? SubstrateEstBoulders { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SubstrateEstCoarseAndFineGravel { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SubstrateEstCobbles { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SubstrateEstSandAndFines { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? MeasurementOfD16 { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? MeasurementOfD50 { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? MeasurementOfD84 { get; set; } //renamed

        [DecimalPrecision(16, 8)]
        public decimal? SubstrateEmbeddednessAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? SubstrateEmbeddednessSD { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? ThalwegDepthAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? ThalwegDepthCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? ThalwegSiteLength { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? TotalUndercutArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? ValleyWidth { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedChannelBraidedness { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedChannelMainstemArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedChannelMainstemLength { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedChannelMainstemSinuosity { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedChannelQualifyingIslandArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedChannelTotalLength { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedDepthSD { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedLargeSideChannelArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSideChannelPercentByArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSideChannelWidth { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSideChannelWidthCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSideChannelWidthToDepthRatioAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSideChannelWidthToDepthRatioCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSideChannelWidthToMaxDepthRatioAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSideChannelWidthToMaxDepthRatioCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSiteLength { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedSmallSideChannelArea { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedVolume { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedWidthAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedWidthCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedWidthIntegrated { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedWidthToDepthRatioAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedWidthToDepthRatioCV { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedWidthToMaxDepthRatioAvg { get; set; }

        [DecimalPrecision(16, 8)]
        public decimal? WettedWidthToMaxDepthRatioCV { get; set; }


    }
}