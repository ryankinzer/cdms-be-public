-- Create the tables
CREATE TABLE [dbo].[BiomVisitMetrics_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [Alkalinity] [int],
    [BankErosion] [decimal](18, 2),
    [BankfullArea] [decimal](18, 2),
    [BankfullChannelBraidedness] [decimal](18, 2),
    [BankfullChannelCount] [int],
    [BankfullChannelIslandCount] [int],
    [BankfullChannelQualifyingIslandArea] [decimal](18, 2),
    [BankfullChannelQualifyingIslandCount] [int],
    [BankfullChannelTotalLength] [decimal](18, 2),
    [BankfullDepthAvg] [decimal](18, 2),
    [BankfullDepthMax] [decimal](18, 2),
    [BankfullMainChannelPartCount] [int],
    [BankfullSideChannelWidth] [decimal](18, 2),
    [BankfullSideChannelWidthCV] [decimal](18, 2),
    [BankfullSideChannelWidthToDepthRatioAvg] [decimal](18, 2),
    [BankfullSideChannelWidthToDepthRatioCV] [decimal](18, 2),
    [BankfullSideChannelWidthToMaxDepthRatioAvg] [decimal](18, 2),
    [BankfullSideChannelWidthToMaxDepthRatioCV] [decimal](18, 2),
    [BankfullSiteLength] [decimal](18, 2),
    [BankfullVolume] [decimal](18, 2),
    [BankfullWidthAvg] [decimal](18, 2),
    [BankfullWidthCV] [decimal](18, 2),
    [BankfullWidthIntegrated] [decimal](18, 2),
    [BankfullWidthToDepthRatioAvg] [decimal](18, 2),
    [BankfullWidthToDepthRatioCV] [decimal](18, 2),
    [BankfullWidthToMaxDepthRatioAvg] [decimal](18, 2),
    [BankfullWidthToMaxDepthRatioCV] [decimal](18, 2),
    [BraidChannelRatio] [decimal](18, 2),
    [Conductivity] [decimal](18, 2),
    [ConstrainingFeatureHeightAverage] [decimal](18, 2),
    [CountOfBrooktrout] [int],
    [CountOfBulltrout] [int],
    [CountOfChinook] [int],
    [CountOfChum] [int],
    [CountOfCoho] [int],
    [CountOfCutthroat] [int],
    [CountOfJamLargeWoodyPieces] [int],
    [CountOfKeyLargeWoodyPieces] [int],
    [CountOfLamprey] [int],
    [CountOfLargeWoodyPieces] [int],
    [CountOfLeftBankLargeWoodyPieces] [int],
    [CountOfMidChannelLargeWoodyPieces] [int],
    [CountOfOmykiss] [int],
    [CountOfOtherSpecies] [int],
    [CountOfPink] [int],
    [CountOfPoolFormingLargeWoodyPieces] [int],
    [CountOfRightBankLargeWoodyPieces] [int],
    [CountOfSockeye] [int],
    [DensityOfBrooktrout] [decimal](18, 2),
    [DensityOfBulltrout] [decimal](18, 2),
    [DensityOfChinook] [decimal](18, 2),
    [DensityOfChum] [decimal](18, 2),
    [DensityOfCoho] [decimal](18, 2),
    [DensityOfCutthroat] [decimal](18, 2),
    [DensityOfLamprey] [decimal](18, 2),
    [DensityOfOmykiss] [decimal](18, 2),
    [DensityOfPink] [decimal](18, 2),
    [DensityOfSockeye] [decimal](18, 2),
    [DetrendedElevationSD] [decimal](18, 2),
    [Discharge] [decimal](18, 2),
    [DriftBiomass] [decimal](18, 2),
    [FastNonTurbulentArea] [decimal](18, 2),
    [FastNonTurbulentCount] [int],
    [FastNonTurbulentFrequency] [decimal](18, 2),
    [FastNonTurbulentPercent] [decimal](18, 2),
    [FastNonTurbulentVolume] [decimal](18, 2),
    [FastTurbulentArea] [decimal](18, 2),
    [FastTurbulentCount] [int],
    [FastTurbulentFrequency] [decimal](18, 2),
    [FastTurbulentPercent] [decimal](18, 2),
    [FastTurbulentVolume] [decimal](18, 2),
    [FishCoverAquaticVegetation] [decimal](18, 2),
    [FishCoverArtificial] [decimal](18, 2),
    [FishCoverLW] [decimal](18, 2),
    [FishCoverNone] [decimal](18, 2),
    [FishCoverTerrestrialVegetation] [decimal](18, 2),
    [FishCoverTotal] [decimal](18, 2),
    [FloodProneWidthAverage] [decimal](18, 2),
    [Gradient] [decimal](18, 2),
    [LargeWoodFrequencyBankfull] [decimal](18, 2),
    [LargeWoodFrequencyWetted] [decimal](18, 2),
    [PercentConstrained] [int],
    [PoolToTurbulentAreaRatio] [decimal](18, 2),
    [PercentUndercutByArea] [decimal](18, 2),
    [PercentUndercutByLength] [decimal](18, 2),
    [ResidualPoolDepth] [decimal](18, 2),
    [RiparianCoverBigTree] [decimal](18, 2),
    [RiparianCoverConiferous] [decimal](18, 2),
    [RiparianCoverGround] [decimal](18, 2),
    [RiparianCoverNoCanopy] [decimal](18, 2),
    [RiparianCoverNonWoody] [decimal](18, 2),
    [RiparianCoverUnderstory] [decimal](18, 2),
    [RiparianCoverWoody] [decimal](18, 2),
    [Sinuosity] [decimal](18, 2),
    [SinuosityViaCenterline] [decimal](18, 2),
    [SlowWaterArea] [decimal](18, 2),
    [SlowWaterCount] [int],
    [SlowWaterFrequency] [decimal](18, 2),
    [SlowWaterPercent] [decimal](18, 2),
    [SlowWaterVolume] [decimal](18, 2),
    [SolarAccessSummerAvg] [decimal](18, 2),
    [SubstrateLt2mm] [decimal](18, 2),
    [SubstrateLt6mm] [decimal](18, 2),
    [SubstrateEstBoulders] [decimal](18, 2),
    [SubstrateEstCoarseAndFineGravel] [decimal](18, 2),
    [SubstrateEstCobbles] [decimal](18, 2),
    [SubstrateEstSandAndFines] [decimal](18, 2),
    [SubstrateD16] [decimal](18, 2),
    [SubstrateD50] [decimal](18, 2),
    [SubstrateD84] [decimal](18, 2),
    [SubstrateEmbeddednessAvg] [decimal](18, 2),
    [SubstrateEmbeddednessSD] [decimal](18, 2),
    [ThalwegDepthAvg] [decimal](18, 2),
    [ThalwegDepthCV] [decimal](18, 2),
    [ThalwegSiteLength] [decimal](18, 2),
    [TotalUndercutArea] [decimal](18, 2),
    [ValleyWidth] [decimal](18, 2),
    [WettedArea] [decimal](18, 2),
    [WettedChannelBraidedness] [decimal](18, 2),
    [WettedChannelCount] [int],
    [WettedChannelIslandCount] [int],
    [WettedChannelMainstemArea] [decimal](18, 2),
    [WettedChannelMainstemLength] [decimal](18, 2),
    [WettedChannelMainstemSinuosity] [decimal](18, 2),
    [WettedChannelQualifyingIslandArea] [decimal](18, 2),
    [WettedChannelQualifyingIslandCount] [int],
    [WettedChannelTotalLength] [decimal](18, 2),
    [WettedDepthSD] [decimal](18, 2),
    [WettedLargeSideChannelArea] [decimal](18, 2),
    [WettedMainChannelPartCount] [int],
    [WettedSideChannelPercentByArea] [decimal](18, 2),
    [WettedSideChannelWidth] [decimal](18, 2),
    [WettedSideChannelWidthCV] [decimal](18, 2),
    [WettedSideChannelWidthToDepthRatioAvg] [decimal](18, 2),
    [WettedSideChannelWidthToDepthRatioCV] [decimal](18, 2),
    [WettedSideChannelWidthToMaxDepthRatioAvg] [decimal](18, 2),
    [WettedSideChannelWidthToMaxDepthRatioCV] [decimal](18, 2),
    [WettedSiteLength] [decimal](18, 2),
    [WettedSmallSideChannelArea] [decimal](18, 2),
    [WettedVolume] [decimal](18, 2),
    [WettedWidthAvg] [decimal](18, 2),
    [WettedWidthCV] [decimal](18, 2),
    [WettedWidthIntegrated] [decimal](18, 2),
    [WettedWidthToDepthRatioAvg] [decimal](18, 2),
    [WettedWidthToDepthRatioCV] [decimal](18, 2),
    [WettedWidthToMaxDepthRatioAvg] [decimal](18, 2),
    [WettedWidthToMaxDepthRatioCV] [decimal](18, 2),
    [RowId] [int] NOT NULL,
    [RowStatusId] [int] NOT NULL,
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [QAStatusId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.BiomVisitMetrics_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[BiomVisitMetrics_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[BiomVisitMetrics_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[BiomVisitMetrics_Detail]([QAStatusId])
CREATE TABLE [dbo].[BiomVisitMetrics_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [AemChampID] [int],
    [VisitYear] [int],
    [ProtocolID] [nvarchar](max),
    [SiteName] [nvarchar](max),
    [VisitID] [int],
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.BiomVisitMetrics_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[BiomVisitMetrics_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[BiomVisitMetrics_Header]([ByUserId])
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD CONSTRAINT [FK_dbo.BiomVisitMetrics_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD CONSTRAINT [FK_dbo.BiomVisitMetrics_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD CONSTRAINT [FK_dbo.BiomVisitMetrics_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[BiomVisitMetrics_Header] ADD CONSTRAINT [FK_dbo.BiomVisitMetrics_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[BiomVisitMetrics_Header] ADD CONSTRAINT [FK_dbo.BiomVisitMetrics_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
GO


-- Create the views
--DROP VIEW BiomVisitMetrics_Header_VW
--GO
CREATE VIEW BiomVisitMetrics_Header_VW
AS
SELECT Id, AemChampID, VisitYear, ProtocolID, SiteName, VisitID, ActivityId, ByUserId, EffDt
FROM dbo.BiomVisitMetrics_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomVisitMetrics_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))
GO

--DROP VIEW BiomVisitMetrics_Detail_VW
--GO
CREATE VIEW BiomVisitMetrics_Detail_VW
AS
SELECT Id, Alkalinity, BankErosion, BankfullArea, BankfullChannelBraidedness, BankfullChannelCount, BankfullChannelIslandCount, BankfullChannelQualifyingIslandArea, BankfullChannelQualifyingIslandCount, BankfullChannelTotalLength, BankfullDepthAvg, BankfullDepthMax, BankfullMainChannelPartCount, BankfullSideChannelWidth, BankfullSideChannelWidthCV, BankfullSideChannelWidthToDepthRatioAvg, BankfullSideChannelWidthToDepthRatioCV, BankfullSideChannelWidthToMaxDepthRatioAvg, BankfullSideChannelWidthToMaxDepthRatioCV, BankfullSiteLength, BankfullVolume, BankfullWidthAvg, BankfullWidthCV, BankfullWidthIntegrated, BankfullWidthToDepthRatioAvg, BankfullWidthToDepthRatioCV, BankfullWidthToMaxDepthRatioAvg, BankfullWidthToMaxDepthRatioCV, BraidChannelRatio, Conductivity, ConstrainingFeatureHeightAverage, CountOfBrooktrout, CountOfBulltrout, CountOfChinook, CountOfChum, CountOfCoho, CountOfCutthroat, CountOfJamLargeWoodyPieces, CountOfKeyLargeWoodyPieces, CountOfLamprey, CountOfLargeWoodyPieces, CountOfLeftBankLargeWoodyPieces, CountOfMidChannelLargeWoodyPieces, CountOfOmykiss, CountOfOtherSpecies, CountOfPink, CountOfPoolFormingLargeWoodyPieces, CountOfRightBankLargeWoodyPieces, CountOfSockeye, DensityOfBrooktrout, DensityOfBulltrout, DensityOfChinook, DensityOfChum, DensityOfCoho, DensityOfCutthroat, DensityOfLamprey, DensityOfOmykiss, DensityOfPink, DensityOfSockeye, DetrendedElevationSD, Discharge, DriftBiomass, FastNonTurbulentArea, FastNonTurbulentCount, FastNonTurbulentFrequency, FastNonTurbulentPercent, FastNonTurbulentVolume, FastTurbulentArea, FastTurbulentCount, FastTurbulentFrequency, FastTurbulentPercent, FastTurbulentVolume, FishCoverAquaticVegetation, FishCoverArtificial, FishCoverLW, FishCoverNone, FishCoverTerrestrialVegetation, FishCoverTotal, FloodProneWidthAverage, Gradient, LargeWoodFrequencyBankfull, LargeWoodFrequencyWetted, PercentConstrained, PoolToTurbulentAreaRatio, PercentUndercutByArea, PercentUndercutByLength, ResidualPoolDepth, RiparianCoverBigTree, RiparianCoverConiferous, RiparianCoverGround, RiparianCoverNoCanopy, RiparianCoverNonWoody, RiparianCoverUnderstory, RiparianCoverWoody, Sinuosity, SinuosityViaCenterline, SlowWaterArea, SlowWaterCount, SlowWaterFrequency, SlowWaterPercent, SlowWaterVolume, SolarAccessSummerAvg, SubstrateLt2mm, SubstrateLt6mm, SubstrateEstBoulders, SubstrateEstCoarseAndFineGravel, SubstrateEstCobbles, SubstrateEstSandAndFines, SubstrateD16, SubstrateD50, SubstrateD84, SubstrateEmbeddednessAvg, SubstrateEmbeddednessSD, ThalwegDepthAvg, ThalwegDepthCV, ThalwegSiteLength, TotalUndercutArea, ValleyWidth, WettedArea, WettedChannelBraidedness, WettedChannelCount, WettedChannelIslandCount, WettedChannelMainstemArea, WettedChannelMainstemLength, WettedChannelMainstemSinuosity, WettedChannelQualifyingIslandArea, WettedChannelQualifyingIslandCount, WettedChannelTotalLength, WettedDepthSD, WettedLargeSideChannelArea, WettedMainChannelPartCount, WettedSideChannelPercentByArea, WettedSideChannelWidth, WettedSideChannelWidthCV, WettedSideChannelWidthToDepthRatioAvg, WettedSideChannelWidthToDepthRatioCV, WettedSideChannelWidthToMaxDepthRatioAvg, WettedSideChannelWidthToMaxDepthRatioCV, WettedSiteLength, WettedSmallSideChannelArea, WettedVolume, WettedWidthAvg, WettedWidthCV, WettedWidthIntegrated, WettedWidthToDepthRatioAvg, WettedWidthToDepthRatioCV, WettedWidthToMaxDepthRatioAvg, WettedWidthToMaxDepthRatioCV, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt
FROM dbo.BiomVisitMetrics_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomVisitMetrics_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
GO

--DROP VIEW BiomVisitMetrics_vw
--GO
CREATE VIEW BiomVisitMetrics_vw
AS
SELECT a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.AemChampID, h.VisitYear, h.ProtocolID, h.SiteName, h.VisitID, h.ByUserId, h.EffDt, d.Id AS BiomVisitMetrics_Detail_Id, d.Alkalinity, d.BankErosion, d.BankfullArea, d.BankfullChannelBraidedness, d.BankfullChannelCount, d.BankfullChannelIslandCount, d.BankfullChannelQualifyingIslandArea, d.BankfullChannelQualifyingIslandCount, d.BankfullChannelTotalLength, d.BankfullDepthAvg, d.BankfullDepthMax, d.BankfullMainChannelPartCount, d.BankfullSideChannelWidth, d.BankfullSideChannelWidthCV, d.BankfullSideChannelWidthToDepthRatioAvg, d.BankfullSideChannelWidthToDepthRatioCV, d.BankfullSideChannelWidthToMaxDepthRatioAvg, d.BankfullSideChannelWidthToMaxDepthRatioCV, d.BankfullSiteLength, d.BankfullVolume, d.BankfullWidthAvg, d.BankfullWidthCV, d.BankfullWidthIntegrated, d.BankfullWidthToDepthRatioAvg, d.BankfullWidthToDepthRatioCV, d.BankfullWidthToMaxDepthRatioAvg, d.BankfullWidthToMaxDepthRatioCV, d.BraidChannelRatio, d.Conductivity, d.ConstrainingFeatureHeightAverage, d.CountOfBrooktrout, d.CountOfBulltrout, d.CountOfChinook, d.CountOfChum, d.CountOfCoho, d.CountOfCutthroat, d.CountOfJamLargeWoodyPieces, d.CountOfKeyLargeWoodyPieces, d.CountOfLamprey, d.CountOfLargeWoodyPieces, d.CountOfLeftBankLargeWoodyPieces, d.CountOfMidChannelLargeWoodyPieces, d.CountOfOmykiss, d.CountOfOtherSpecies, d.CountOfPink, d.CountOfPoolFormingLargeWoodyPieces, d.CountOfRightBankLargeWoodyPieces, d.CountOfSockeye, d.DensityOfBrooktrout, d.DensityOfBulltrout, d.DensityOfChinook, d.DensityOfChum, d.DensityOfCoho, d.DensityOfCutthroat, d.DensityOfLamprey, d.DensityOfOmykiss, d.DensityOfPink, d.DensityOfSockeye, d.DetrendedElevationSD, d.Discharge, d.DriftBiomass, d.FastNonTurbulentArea, d.FastNonTurbulentCount, d.FastNonTurbulentFrequency, d.FastNonTurbulentPercent, d.FastNonTurbulentVolume, d.FastTurbulentArea, d.FastTurbulentCount, d.FastTurbulentFrequency, d.FastTurbulentPercent, d.FastTurbulentVolume, d.FishCoverAquaticVegetation, d.FishCoverArtificial, d.FishCoverLW, d.FishCoverNone, d.FishCoverTerrestrialVegetation, d.FishCoverTotal, d.FloodProneWidthAverage, d.Gradient, d.LargeWoodFrequencyBankfull, d.LargeWoodFrequencyWetted, d.PercentConstrained, d.PoolToTurbulentAreaRatio, d.PercentUndercutByArea, d.PercentUndercutByLength, d.ResidualPoolDepth, d.RiparianCoverBigTree, d.RiparianCoverConiferous, d.RiparianCoverGround, d.RiparianCoverNoCanopy, d.RiparianCoverNonWoody, d.RiparianCoverUnderstory, d.RiparianCoverWoody, d.Sinuosity, d.SinuosityViaCenterline, d.SlowWaterArea, d.SlowWaterCount, d.SlowWaterFrequency, d.SlowWaterPercent, d.SlowWaterVolume, d.SolarAccessSummerAvg, d.SubstrateLt2mm, d.SubstrateLt6mm, d.SubstrateEstBoulders, d.SubstrateEstCoarseAndFineGravel, d.SubstrateEstCobbles, d.SubstrateEstSandAndFines, d.SubstrateD16, d.SubstrateD50, d.SubstrateD84, d.SubstrateEmbeddednessAvg, d.SubstrateEmbeddednessSD, d.ThalwegDepthAvg, d.ThalwegDepthCV, d.ThalwegSiteLength, d.TotalUndercutArea, d.ValleyWidth, d.WettedArea, d.WettedChannelBraidedness, d.WettedChannelCount, d.WettedChannelIslandCount, d.WettedChannelMainstemArea, d.WettedChannelMainstemLength, d.WettedChannelMainstemSinuosity, d.WettedChannelQualifyingIslandArea, d.WettedChannelQualifyingIslandCount, d.WettedChannelTotalLength, d.WettedDepthSD, d.WettedLargeSideChannelArea, d.WettedMainChannelPartCount, d.WettedSideChannelPercentByArea, d.WettedSideChannelWidth, d.WettedSideChannelWidthCV, d.WettedSideChannelWidthToDepthRatioAvg, d.WettedSideChannelWidthToDepthRatioCV, d.WettedSideChannelWidthToMaxDepthRatioAvg, d.WettedSideChannelWidthToMaxDepthRatioCV, d.WettedSiteLength, d.WettedSmallSideChannelArea, d.WettedVolume, d.WettedWidthAvg, d.WettedWidthCV, d.WettedWidthIntegrated, d.WettedWidthToDepthRatioAvg, d.WettedWidthToDepthRatioCV, d.WettedWidthToMaxDepthRatioAvg, d.WettedWidthToMaxDepthRatioCV, d.RowId, d.ByUserId AS BiomVisitMetrics_Detail_ByUserId, d.QAStatusId, d.EffDt AS BiomVisitMetrics_Detail_EffDt, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.BiomVisitMetrics_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.BiomVisitMetrics_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id 
GO
