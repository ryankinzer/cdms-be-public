-- Add Visit Metrics tables
CREATE TABLE [dbo].[VisitMetrics_Detail] (
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
    CONSTRAINT [PK_dbo.VisitMetrics_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[VisitMetrics_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[VisitMetrics_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[VisitMetrics_Detail]([QAStatusId])
CREATE TABLE [dbo].[VisitMetrics_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [AemChampID] [int],
    [VisitYear] [int],
    [ProtocolID] [int],
    [SiteName] [nvarchar](max),
    [VisitID] [int],
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.VisitMetrics_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[VisitMetrics_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[VisitMetrics_Header]([ByUserId])

ALTER TABLE [dbo].[VisitMetrics_Detail] ADD CONSTRAINT [FK_dbo.VisitMetrics_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[VisitMetrics_Detail] ADD CONSTRAINT [FK_dbo.VisitMetrics_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[VisitMetrics_Detail] ADD CONSTRAINT [FK_dbo.VisitMetrics_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[VisitMetrics_Header] ADD CONSTRAINT [FK_dbo.VisitMetrics_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[VisitMetrics_Header] ADD CONSTRAINT [FK_dbo.VisitMetrics_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
go


-- Add Visit Metrics Views
--Up
Drop view dbo.VisitMetrics_Detail_VW
go
create view dbo.VisitMetrics_Detail_VW
as
SELECT        Id, Alkalinity, BankErosion, BankfullArea, BankfullChannelBraidedness, BankfullChannelCount, BankfullChannelIslandCount, BankfullChannelQualifyingIslandArea, BankfullChannelQualifyingIslandCount, 
                         BankfullChannelTotalLength, BankfullDepthAvg, BankfullDepthMax, BankfullMainChannelPartCount, BankfullSideChannelWidth, BankfullSideChannelWidthCV, BankfullSideChannelWidthToDepthRatioAvg, 
                         BankfullSideChannelWidthToMaxDepthRatioAvg, BankfullSideChannelWidthToMaxDepthRatioCV, BankfullSiteLength, BankfullVolume, BankfullWidthAvg, BankfullWidthCV, BankfullWidthIntegrated, 
                         BankfullWidthToDepthRatioAvg, BankfullWidthToDepthRatioCV, BankfullWidthToMaxDepthRatioAvg, BankfullWidthToMaxDepthRatioCV, BraidChannelRatio, Conductivity, ConstrainingFeatureHeightAverage, CountOfBrooktrout, 
                         CountOfBulltrout, CountOfChinook, CountOfChum, CountOfCoho, CountOfCutthroat, CountOfJamLargeWoodyPieces, CountOfKeyLargeWoodyPieces, CountOfLamprey, CountOfLargeWoodyPieces, 
                         CountOfLeftBankLargeWoodyPieces, CountOfMidChannelLargeWoodyPieces, CountOfOmykiss, CountOfOtherSpecies, CountOfPink, CountOfPoolFormingLargeWoodyPieces, CountOfRightBankLargeWoodyPieces, 
                         CountOfSockeye, DensityOfBrooktrout, DensityOfBulltrout, DensityOfChinook, DensityOfChum, DensityOfCoho, DensityOfCutthroat, DensityOfLamprey, DensityOfOmykiss, DensityOfPink, DensityOfSockeye, 
                         DetrendedElevationSD, Discharge, DriftBiomass, FastNonTurbulentArea, FastNonTurbulentCount, FastNonTurbulentFrequency, FastNonTurbulentPercent, FastNonTurbulentVolume, FastTurbulentArea, FastTurbulentCount, 
                         FastTurbulentFrequency, FastTurbulentPercent, FastTurbulentVolume, FishCoverAquaticVegetation, FishCoverArtificial, FishCoverLW, FishCoverNone, FishCoverTerrestrialVegetation, FishCoverTotal, FloodProneWidthAverage, 
                         Gradient, LargeWoodFrequencyBankfull, LargeWoodFrequencyWetted, PercentConstrained, PoolToTurbulentAreaRatio, PercentUndercutByArea, PercentUndercutByLength, ResidualPoolDepth, RiparianCoverBigTree, 
                         RiparianCoverConiferous, RiparianCoverGround, RiparianCoverNoCanopy, RiparianCoverNonWoody, RiparianCoverUnderstory, RiparianCoverWoody, Sinuosity, SinuosityViaCenterline, SlowWaterArea, SlowWaterCount, 
                         SlowWaterFrequency, SlowWaterPercent, SlowWaterVolume, SolarAccessSummerAvg, SubstrateLt2mm, SubstrateLt6mm, SubstrateEstBoulders, SubstrateEstCoarseAndFineGravel, SubstrateEstCobbles, 
                         SubstrateEstSandAndFines, SubstrateD16, SubstrateD50, SubstrateD84, SubstrateEmbeddednessAvg, SubstrateEmbeddednessSD, ThalwegDepthAvg, ThalwegDepthCV, ThalwegSiteLength, TotalUnderCutArea, ValleyWidth, 
                         WettedArea, WettedChannelBraidedness, WettedChannelIslandCount, WettedChannelMainstemArea, WettedChannelMainstemLength, WettedChannelMainstemSinuosity, WettedChannelQualifyingIslandArea, 
                         WettedChannelQualifyingIslandCount, WettedChannelTotalLength, WettedDepthSD, WettedLargeSideChannelArea, WettedMainChannelPartCount, WettedSideChannelPercentByArea, WettedSideChannelWidth, 
                         WettedSideChannelWidthCV, WettedSideChannelWidthToDepthRatioAvg, WettedSideChannelWidthToDepthRatioCV, WettedSideChannelWidthToMaxDepthRatioAvg, WettedSideChannelWidthToMaxDepthRatioCV, 
                         WettedSiteLength, WettedSmallSideChannelArea, WettedVolume, WettedWidthAvg, WettedWidthCV, WettedWidthIntegrated, WettedWidthToDepthRatioAvg, WettedWidthToDepthRatioCv, 
                         WettedWidthToMaxDepthRatioAvg, WettedWidthToMaxDepthRatioCV, RowId, RowStatusId, ActivityId, ByUserId, EffDt, QAStatusId
FROM            dbo.VisitMetrics_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.VisitMetrics_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
go


drop view dbo.VisitMetrics_Header_VW
go
create view dbo.VisitMetrics_Header_VW
AS
SELECT        Id, AemChampID, VisitYear, ProtocolID, SiteName, VisitID, ByUserId, EffDt, ActivityId
FROM            dbo.VisitMetrics_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.VisitMetrics_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


drop view dbo.VisitMetrics_vw
go
create view dbo.VisitMetrics_vw
AS
SELECT        a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, aq.QAStatusId AS ActivityQAStatusId, h.Id, 
                         h.AemChampID, h.VisitYear, h.ProtocolID, h.SiteName, h.VisitID, h.ByUserId, h.EffDt, d.Id AS VisitMetrics_Detail_Id, d.Alkalinity, d.BankErosion, d.BankfullArea, d.BankfullChannelBraidedness, d.BankfullChannelCount, 
                         d.BankfullChannelIslandCount, d.BankfullChannelQualifyingIslandArea, d.BankfullChannelQualifyingIslandCount, d.BankfullChannelTotalLength, d.BankfullDepthAvg, d.BankfullDepthMax, d.BankfullMainChannelPartCount, 
                         d.BankfullSideChannelWidth, d.BankfullSideChannelWidthCV, d.BankfullSideChannelWidthToDepthRatioAvg, d.BankfullSideChannelWidthToMaxDepthRatioAvg, d.BankfullSideChannelWidthToMaxDepthRatioCV, 
                         d.BankfullSiteLength, d.BankfullVolume, d.BankfullWidthAvg, d.BankfullWidthCV, d.BankfullWidthIntegrated, d.BankfullWidthToDepthRatioAvg, d.BankfullWidthToDepthRatioCV, d.BankfullWidthToMaxDepthRatioAvg, 
                         d.BankfullWidthToMaxDepthRatioCV, d.BraidChannelRatio, d.Conductivity, d.ConstrainingFeatureHeightAverage, d.CountOfBrooktrout, d.CountOfBulltrout, d.CountOfChinook, d.CountOfChum, d.CountOfCoho, d.CountOfCutthroat, 
                         d.CountOfJamLargeWoodyPieces, d.CountOfKeyLargeWoodyPieces, d.CountOfLamprey, d.CountOfLargeWoodyPieces, d.CountOfLeftBankLargeWoodyPieces, d.CountOfMidChannelLargeWoodyPieces, d.CountOfOmykiss, 
                         d.CountOfOtherSpecies, d.CountOfPink, d.CountOfPoolFormingLargeWoodyPieces, d.CountOfRightBankLargeWoodyPieces, d.CountOfSockeye, d.DensityOfBrooktrout, d.DensityOfBulltrout, d.DensityOfChinook, d.DensityOfChum, 
                         d.DensityOfCoho, d.DensityOfCutthroat, d.DensityOfLamprey, d.DensityOfOmykiss, d.DensityOfPink, d.DensityOfSockeye, d.DetrendedElevationSD, d.Discharge, d.DriftBiomass, d.FastNonTurbulentArea, 
                         d.FastNonTurbulentCount, d.FastNonTurbulentFrequency, d.FastNonTurbulentPercent, d.FastNonTurbulentVolume, d.FastTurbulentArea, d.FastTurbulentCount, d.FastTurbulentFrequency, d.FastTurbulentPercent, 
                         d.FastTurbulentVolume, d.FishCoverAquaticVegetation, d.FishCoverArtificial, d.FishCoverLW, d.FishCoverNone, d.FishCoverTerrestrialVegetation, d.FishCoverTotal, d.FloodProneWidthAverage, d.Gradient, 
                         d.LargeWoodFrequencyBankfull, d.LargeWoodFrequencyWetted, d.PercentConstrained, d.PoolToTurbulentAreaRatio, d.PercentUndercutByArea, d.PercentUndercutByLength, d.ResidualPoolDepth, d.RiparianCoverBigTree, 
                         d.RiparianCoverConiferous, d.RiparianCoverGround, d.RiparianCoverNoCanopy, d.RiparianCoverNonWoody, d.RiparianCoverUnderstory, d.RiparianCoverWoody, d.Sinuosity, d.SinuosityViaCenterline, d.SlowWaterArea, 
                         d.SlowWaterCount, d.SlowWaterFrequency, d.SlowWaterPercent, d.SlowWaterVolume, d.SolarAccessSummerAvg, d.SubstrateLt2mm, d.SubstrateLt6mm, d.SubstrateEstBoulders, d.SubstrateEstCoarseAndFineGravel, 
                         d.SubstrateEstCobbles, d.SubstrateEstSandAndFines, d.SubstrateD16, d.SubstrateD50, d.SubstrateD84, d.SubstrateEmbeddednessAvg, d.SubstrateEmbeddednessSD, d.ThalwegDepthAvg, d.ThalwegDepthCV, 
                         d.ThalwegSiteLength, d.TotalUnderCutArea, d.ValleyWidth, d.WettedArea, d.WettedChannelBraidedness, d.WettedChannelIslandCount, d.WettedChannelMainstemArea, d.WettedChannelMainstemLength, 
                         d.WettedChannelMainstemSinuosity, d.WettedChannelQualifyingIslandArea, d.WettedChannelQualifyingIslandCount, d.WettedChannelTotalLength, d.WettedDepthSD, d.WettedLargeSideChannelArea, 
                         d.WettedMainChannelPartCount, d.WettedSideChannelPercentByArea, d.WettedSideChannelWidth, d.WettedSideChannelWidthCV, d.WettedSideChannelWidthToDepthRatioAvg, d.WettedSideChannelWidthToDepthRatioCV, 
                         d.WettedSideChannelWidthToMaxDepthRatioAvg, d.WettedSideChannelWidthToMaxDepthRatioCV, d.WettedSiteLength, d.WettedSmallSideChannelArea, d.WettedVolume, d.WettedWidthAvg, d.WettedWidthCV, 
                         d.WettedWidthIntegrated, d.WettedWidthToDepthRatioAvg, d.WettedWidthToDepthRatioCv, d.WettedWidthToMaxDepthRatioAvg, d.WettedWidthToMaxDepthRatioCV, d.RowId, d.ByUserId AS VisitMetrics_Detail_ByUserId, 
                         d.EffDt AS VisitMetrics_Detail_EffDt, d.QAStatusId, l.Label
FROM            dbo.Activities AS a INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId INNER JOIN
                         dbo.VisitMetrics_Header_VW AS h ON a.Id = h.ActivityId LEFT OUTER JOIN
                         dbo.VisitMetrics_Detail_VW AS d ON h.ActivityId = d.ActivityId INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id			   
go					   


-- Add Channel Unit Metrics tables
CREATE TABLE [dbo].[ChannelUnitMetrics_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [ChUnitID] [int],
    [ChUnitNum] [int],
    [Tier1] [int],
    [Tier2] [int],
    [AreaTotal] [decimal](18, 2),
    [PolyArea] [decimal](18, 2),
    [TotalVol] [decimal](18, 2),
    [DpthMax] [decimal](18, 2),
    [DpthThlwgExit] [decimal](18, 2),
    [DpthResid] [decimal](18, 2),
    [CountOfLWD] [int],
    [RowId] [int] NOT NULL,
    [RowStatusId] [int] NOT NULL,
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [QAStatusId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.ChannelUnitMetrics_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[ChannelUnitMetrics_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[ChannelUnitMetrics_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[ChannelUnitMetrics_Detail]([QAStatusId])
CREATE TABLE [dbo].[ChannelUnitMetrics_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [ProgramSiteID] [int],
    [SiteName] [nvarchar](max),
    [WatershedID] [int],
    [WatershedName] [nvarchar](max),
    [SampleDate] [nvarchar](max),
    [HitchName] [nvarchar](max),
    [CrewName] [nvarchar](max),
    [VisitYear] [int],
    [IterationID] [int],
    [CategoryName] [nvarchar](max),
    [PanelName] [nvarchar](max),
    [VisitID] [int],
    [VisitDate] [int],
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.ChannelUnitMetrics_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[ChannelUnitMetrics_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[ChannelUnitMetrics_Header]([ByUserId])
ALTER TABLE [dbo].[ChannelUnitMetrics_Detail] ADD CONSTRAINT [FK_dbo.ChannelUnitMetrics_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[ChannelUnitMetrics_Detail] ADD CONSTRAINT [FK_dbo.ChannelUnitMetrics_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[ChannelUnitMetrics_Detail] ADD CONSTRAINT [FK_dbo.ChannelUnitMetrics_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[ChannelUnitMetrics_Header] ADD CONSTRAINT [FK_dbo.ChannelUnitMetrics_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[ChannelUnitMetrics_Header] ADD CONSTRAINT [FK_dbo.ChannelUnitMetrics_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
go


-- Add Channel Units Metrics views
Drop view dbo.ChannelUnitMetrics_Detail_VW
go
create view dbo.ChannelUnitMetrics_Detail_VW
as
SELECT        Id, ChUnitID, ChUnitNum, Tier1, Tier2, AreaTotal, PolyArea, TotalVol, DpthMax, DpthThlwgExit, DpthResid, CountOfLWD, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt
FROM            dbo.ChannelUnitMetrics_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.ChannelUnitMetrics_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
go


Drop view dbo.ChannelUnitMetrics_Header_VW
go
create view dbo.ChannelUnitMetrics_Header_VW
as
SELECT        Id, ProgramSiteID, SiteName, WatershedID, WatershedName, SampleDate, HitchName, CrewName, VisitYear, IterationID, CategoryName, PanelName, VisitID, VisitDate, ActivityId, ByUserId, EffDt
FROM            dbo.ChannelUnitMetrics_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.ChannelUnitMetrics_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


Drop view dbo.ChannelUnitMetrics_vw
go
create view dbo.ChannelUnitMetrics_vw
as
SELECT        a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ProgramSiteID, h.SiteName, h.WatershedID, h.WatershedName, h.SampleDate, h.HitchName, h.CrewName, 
                         h.VisitYear, h.IterationID, h.CategoryName, h.PanelName, h.VisitID, h.VisitDate, h.ByUserId, h.EffDt, d.Id AS ChannelUnitMetrics_Detail_Id, d.ChUnitID, d.ChUnitNum, d.Tier1, d.Tier2, d.AreaTotal, d.PolyArea, d.TotalVol, 
                         d.DpthMax, d.DpthThlwgExit, d.DpthResid, d.CountOfLWD, d.RowId, d.ByUserId AS ChannelUnitMetrics_Detail_ByUserId, d.QAStatusId, d.EffDt AS ChannelUnitMetrics_Detail_EffDt, l.Label, l.Status, l.GPSEasting, l.GPSNorthing, 
                         l.Projection, l.UTMZone, l.Latitude, l.Longitude, l.OtherAgencyId, l.ImageLink, l.WettedWidth, l.WettedDepth, l.RiverMile, l.WaterBodyId, l.ProjectId, l.SubprojectId, l.StudyDesign, aq.QAStatusId AS ActivityQAStatusId, 
                         aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName
FROM            dbo.Activities AS a INNER JOIN
                         dbo.ChannelUnitMetrics_Header AS h ON h.ActivityId = a.Id LEFT OUTER JOIN
                         dbo.ChannelUnitMetrics_Detail_VW AS d ON d.ActivityId = a.Id INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id
go


-- Add Tier1 tables
CREATE TABLE [dbo].[Tier1_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [Tier1] [int],
    [Area] [decimal](18, 2),
    [Ct] [int],
    [UnitSpacing] [decimal](18, 2),
    [Freq] [decimal](18, 2),
    [Vol] [decimal](18, 2),
    [Pct] [decimal](18, 2),
    [DpthThlwgMaxAvg] [decimal](18, 2),
    [DpthThlwgExit] [decimal](18, 2),
    [DpthResid] [decimal](18, 2),
    [SubEstBldr] [decimal](18, 2),
    [SubEstCbl] [decimal](18, 2),
    [SubEstGrvl] [decimal](18, 2),
    [SubEstSandFines] [decimal](18, 2),
    [FishCovLW] [decimal](18, 2),
    [FishCovTVeg] [decimal](18, 2),
    [FishCovUcut] [decimal](18, 2),
    [FishCovArt] [decimal](18, 2),
    [FishCovAqVeg] [decimal](18, 2),
    [FishCovNone] [decimal](18, 2),
    [FishCovTotal] [decimal](18, 2),
    [LWVolWetTier1] [decimal](18, 2),
    [LWVolBfTier1] [decimal](18, 2),
    [CountOfLWD] [int],
    [CountOfChinook] [int],
    [CountOfCoho] [int],
    [CountOfSockeye] [int],
    [CountOfChum] [int],
    [CountOfOmykiss] [int],
    [CountOfPink] [int],
    [CountOfCutthroat] [int],
    [CountOfBulltrout] [int],
    [CountOfBrooktrout] [int],
    [CountOfLamprey] [int],
    [CountOfOtherSpecies] [int],
    [DensityOfChinook] [decimal](18, 2),
    [DensityOfCoho] [decimal](18, 2),
    [DensityOfSockeye] [decimal](18, 2),
    [DensityOfChum] [decimal](18, 2),
    [DensityOfOmykiss] [decimal](18, 2),
    [DensityOfPink] [decimal](18, 2),
    [DensityOfCutthroat] [decimal](18, 2),
    [DensityOfBulltrout] [decimal](18, 2),
    [DensityOfBrooktrout] [decimal](18, 2),
    [DensityOfLamprey] [decimal](18, 2),
    [DensityOfOtherSpecies] [decimal](18, 2),
    [RowId] [int] NOT NULL,
    [RowStatusId] [int] NOT NULL,
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [QAStatusId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.Tier1_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[Tier1_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[Tier1_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[Tier1_Detail]([QAStatusId])

CREATE TABLE [dbo].[Tier1_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [ProgramSiteID] [int],
    [SiteName] [nvarchar](max),
    [WatershedID] [int],
    [WatershedName] [nvarchar](max),
    [SampleDate] [nvarchar](max),
    [HitchName] [nvarchar](max),
    [CrewName] [nvarchar](max),
    [VisitYear] [int],
    [IterationID] [int],
    [CategoryName] [nvarchar](max),
    [PanelName] [nvarchar](max),
    [VisitID] [int],
    [VisitDate] [int],
    [ProtocolID] [int],
    [ProgramID] [int],
    [AEM] [int],
    [Effectiveness] [int],
    [HasFishData] [int],
    [PrimaryVisit] [int],
    [QCVisit] [int],
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.Tier1_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[Tier1_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[Tier1_Header]([ByUserId])
ALTER TABLE [dbo].[Tier1_Detail] ADD CONSTRAINT [FK_dbo.Tier1_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[Tier1_Detail] ADD CONSTRAINT [FK_dbo.Tier1_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[Tier1_Detail] ADD CONSTRAINT [FK_dbo.Tier1_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[Tier1_Header] ADD CONSTRAINT [FK_dbo.Tier1_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[Tier1_Header] ADD CONSTRAINT [FK_dbo.Tier1_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
go


-- Add Tier1 views
drop view Tier1_Detail_VW
go
create view Tier1_Detail_VW
AS
SELECT        Id, Tier1, Area, Ct, UnitSpacing, Freq, Vol, Pct, DpthThlwgMaxAvg, DpthThlwgExit, DpthResid, SubEstBldr, SubEstCbl, SubEstGrvl, SubEstSandFines, FishCovLW, FishCovTVeg, FishCovUcut, FishCovArt, FishCovAqVeg, 
                         FishCovNone, FishCovTotal, LWVolWetTier1, LWVolBfTier1, CountOfLWD, CountOfChinook, CountOfCoho, CountOfSockeye, CountOfChum, CountOfOmykiss, CountOfPink, CountOfCutthroat, CountOfBulltrout, CountOfBrooktrout, 
                         CountOfLamprey, CountOfOtherSpecies, DensityOfChinook, DensityOfCoho, DensityOfSockeye, DensityOfChum, DensityOfOmykiss, DensityOfPink, DensityOfCutthroat, DensityOfBulltrout, DensityOfBrooktrout, 
                         DensityOfLamprey, DensityOfOtherSpecies, RowStatusId, ActivityId, RowId, ByUserId, QAStatusId, EffDt
FROM            dbo.Tier1_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.Tier1_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
go


drop view Tier1_Header_VW
go
create view Tier1_Header_VW
AS
SELECT        Id, ProgramSiteID, SiteName, WatershedID, WatershedName, SampleDate, HitchName, CrewName, VisitYear, IterationID, CategoryName, PanelName, VisitID, VisitDate, ProtocolID, ProgramID, AEM, Effectiveness, HasFishData, 
                         PrimaryVisit, QCVisit, ActivityId, ByUserId, EffDt
FROM            dbo.Tier1_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.Tier1_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


drop view Tier1_vw
go
create view Tier1_vw
AS
SELECT        a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.CreateDate, a.ActivityTypeId, a.ActivityDate, h.Id, h.ProgramSiteID, h.SiteName, h.WatershedID, h.WatershedName, h.SampleDate, h.HitchName, h.CrewName, 
                         h.VisitYear, h.IterationID, h.CategoryName, h.PanelName, h.VisitID, h.VisitDate, h.ProtocolID, h.ProgramID, h.AEM, h.Effectiveness, h.HasFishData, h.PrimaryVisit, h.QCVisit, h.ByUserId, h.EffDt, d.Id AS Tier1_Detail_Id, d.Tier1, 
                         d.Area, d.Ct, d.UnitSpacing, d.Freq, d.Vol, d.Pct, d.DpthThlwgMaxAvg, d.DpthThlwgExit, d.DpthResid, d.SubEstBldr, d.SubEstCbl, d.SubEstGrvl, d.SubEstSandFines, d.FishCovLW, d.FishCovTVeg, d.FishCovUcut, d.FishCovAqVeg, 
                         d.FishCovNone, d.FishCovArt, d.FishCovTotal, d.LWVolWetTier1, d.LWVolBfTier1, d.CountOfLWD, d.CountOfChinook, d.CountOfCoho, d.CountOfSockeye, d.CountOfChum, d.CountOfOmykiss, d.CountOfPink, d.CountOfCutthroat, 
                         d.CountOfBulltrout, d.CountOfBrooktrout, d.CountOfLamprey, d.CountOfOtherSpecies, d.DensityOfChinook, d.DensityOfCoho, d.DensityOfSockeye, d.DensityOfChum, d.DensityOfOmykiss, d.DensityOfPink, d.DensityOfCutthroat, 
                         d.DensityOfBulltrout, d.DensityOfBrooktrout, d.DensityOfLamprey, d.DensityOfOtherSpecies, d.ByUserId AS Tier1_Detail_ByUserId, d.QAStatusId, d.EffDt AS Tier1_Detail_EffDt, aq.QAStatusId AS ActivityQAStatusId, 
                         aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM            dbo.Activities AS a INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id INNER JOIN
                         dbo.Tier1_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId LEFT OUTER JOIN
                         dbo.Tier1_Detail_VW AS d ON a.Id = d.ActivityId
go


-- Add Tier2 tables
CREATE TABLE [dbo].[Tier2_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [Tier2] [nvarchar](max),
    [Area] [decimal](18, 2),
    [Ct] [int],
    [UnitSpacing] [decimal](18, 2),
    [Freq] [decimal](18, 2),
    [Vol] [decimal](18, 2),
    [Pct] [decimal](18, 2),
    [DpthThlwgMaxAvg] [decimal](18, 2),
    [DpthThlwgExit] [decimal](18, 2),
    [DpthResid] [decimal](18, 2),
    [RowId] [int] NOT NULL,
    [RowStatusId] [int] NOT NULL,
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [QAStatusId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.Tier2_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[Tier2_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[Tier2_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[Tier2_Detail]([QAStatusId])
CREATE TABLE [dbo].[Tier2_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [ProgramSiteID] [int],
    [SiteName] [nvarchar](max),
    [WatershedID] [int],
    [WatershedName] [nvarchar](max),
    [SampleDate] [nvarchar](max),
    [HitchName] [nvarchar](max),
    [CrewName] [nvarchar](max),
    [VisitYear] [int],
    [IterationID] [int],
    [CategoryName] [nvarchar](max),
    [PanelName] [nvarchar](max),
    [VisitID] [int],
    [VisitDate] [int],
    [ProtocolID] [int],
    [ProgramID] [int],
    [AEM] [nvarchar](max),
    [Effectiveness] [nvarchar](max),
    [HasFishData] [nvarchar](max),
    [PrimaryVisit] [nvarchar](max),
    [QCVisit] [nvarchar](max),
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.Tier2_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[Tier2_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[Tier2_Header]([ByUserId])
ALTER TABLE [dbo].[Tier2_Detail] ADD CONSTRAINT [FK_dbo.Tier2_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[Tier2_Detail] ADD CONSTRAINT [FK_dbo.Tier2_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[Tier2_Detail] ADD CONSTRAINT [FK_dbo.Tier2_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[Tier2_Header] ADD CONSTRAINT [FK_dbo.Tier2_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[Tier2_Header] ADD CONSTRAINT [FK_dbo.Tier2_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
go


-- Add Tier2 Views
drop view Tier2_Detail_VW
go
create view Tier2_Detail_VW
AS
SELECT        Id, Tier2, Area, Ct, UnitSpacing, Freq, Vol, Pct, DpthThlwgMaxAvg, DpthThlwgExit, DpthResid, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt
FROM            dbo.Tier2_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.Tier2_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
go


drop view Tier2_Header_VW
go
create view Tier2_Header_VW
AS
SELECT        Id, ProgramSiteID, SiteName, WatershedID, WatershedName, SampleDate, HitchName, CrewName, VisitYear, IterationID, CategoryName, PanelName, VisitID, VisitDate, ProtocolID, ProgramID, AEM, HasFishData, Effectiveness, 
                         PrimaryVisit, QCVisit, ActivityId, ByUserId, EffDt
FROM            dbo.Tier2_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.Tier2_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


drop view Tier2_vw
go
create view Tier2_vw
AS
SELECT        a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ProgramSiteID, h.SiteName, h.WatershedID, h.WatershedName, h.SampleDate, h.HitchName, h.CrewName, 
                         h.VisitYear, h.IterationID, h.CategoryName, h.PanelName, h.VisitID, h.VisitDate, h.ProtocolID, h.ProgramID, h.AEM, h.HasFishData, h.Effectiveness, h.PrimaryVisit, h.QCVisit, h.ByUserId, h.EffDt, d.Id AS Tier2_Detail_Id, d.Tier2, 
                         d.Area, d.Ct, d.UnitSpacing, d.Freq, d.Vol, d.Pct, d.DpthThlwgMaxAvg, d.DpthThlwgExit, d.DpthResid, d.RowId, d.ByUserId AS Tier2_Detail_ByUserId, d.QAStatusId, d.EffDt AS Tier2_Detail_EffDt, 
                         aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM            dbo.Activities AS a INNER JOIN
                         dbo.Tier2_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.Tier2_Detail_VW AS d ON a.Id = d.ActivityId LEFT OUTER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId
go