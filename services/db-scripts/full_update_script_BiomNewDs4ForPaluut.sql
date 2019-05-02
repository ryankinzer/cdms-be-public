use PALUUT2_DEV
go

declare @datasetBaseName as varchar(max);
declare @categoryName as varchar(max);
declare @datastoreName as varchar(max);
declare @DatasetId as int; 
declare @FieldId as int; 

-- Create the tables for all the datasets
CREATE TABLE [dbo].[BiomChannelUnitMetrics_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [ChUnitID] [int],
    [ChUnitNum] [int],
    [Tier1] [nvarchar](max),
    [Tier2] [nvarchar](max),
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
    CONSTRAINT [PK_dbo.BiomChannelUnitMetrics_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[BiomChannelUnitMetrics_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[BiomChannelUnitMetrics_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[BiomChannelUnitMetrics_Detail]([QAStatusId])
CREATE TABLE [dbo].[BiomChannelUnitMetrics_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [ProgramSiteID] [int],
    [SiteName] [nvarchar](max),
    [WatershedID] [int],
    [WatershedName] [nvarchar](max),
    [SampleDate] [datetime],
    [HitchName] [nvarchar](max),
    [CrewName] [nvarchar](max),
    [VisitYear] [int],
    [IterationID] [int],
    [CategoryName] [nvarchar](max),
    [PanelName] [nvarchar](max),
    [VisitID] [int],
    [VisitDate] [datetime],
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.BiomChannelUnitMetrics_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[BiomChannelUnitMetrics_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[BiomChannelUnitMetrics_Header]([ByUserId])
CREATE TABLE [dbo].[BiomTier1Metrics_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [Tier1] [nvarchar](max),
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
    CONSTRAINT [PK_dbo.BiomTier1Metrics_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[BiomTier1Metrics_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[BiomTier1Metrics_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[BiomTier1Metrics_Detail]([QAStatusId])
CREATE TABLE [dbo].[BiomTier1Metrics_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [ProgramSiteID] [int],
    [SiteName] [nvarchar](max),
    [WatershedID] [int],
    [WatershedName] [nvarchar](max),
    [SampleDate] [datetime],
    [HitchName] [nvarchar](max),
    [CrewName] [nvarchar](max),
    [VisitYear] [int],
    [IterationID] [int],
    [CategoryName] [nvarchar](max),
    [PanelName] [nvarchar](max),
    [VisitID] [int],
    [VisitDate] [datetime],
    [ProtocolID] [nvarchar](max),
    [ProgramID] [int],
    [AEM] [nvarchar](max),
    [Effectiveness] [nvarchar](max),
    [HasFishData] [nvarchar](max),
    [PrimaryVisit] [nvarchar](max),
    [QCVisit] [nvarchar](max),
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.BiomTier1Metrics_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[BiomTier1Metrics_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[BiomTier1Metrics_Header]([ByUserId])
CREATE TABLE [dbo].[BiomTier2Metrics_Detail] (
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
    CONSTRAINT [PK_dbo.BiomTier2Metrics_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[BiomTier2Metrics_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[BiomTier2Metrics_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[BiomTier2Metrics_Detail]([QAStatusId])
CREATE TABLE [dbo].[BiomTier2Metrics_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [ProgramSiteID] [int],
    [SiteName] [nvarchar](max),
    [WatershedID] [int],
    [WatershedName] [nvarchar](max),
    [SampleDate] [datetime],
    [HitchName] [nvarchar](max),
    [CrewName] [nvarchar](max),
    [VisitYear] [int],
    [IterationID] [int],
    [CategoryName] [nvarchar](max),
    [PanelName] [nvarchar](max),
    [VisitID] [int],
    [VisitDate] [datetime],
    [ProtocolID] [nvarchar](max),
    [ProgramID] [int],
    [AEM] [nvarchar](max),
    [Effectiveness] [nvarchar](max),
    [HasFishData] [nvarchar](max),
    [PrimaryVisit] [nvarchar](max),
    [QCVisit] [nvarchar](max),
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.BiomTier2Metrics_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[BiomTier2Metrics_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[BiomTier2Metrics_Header]([ByUserId])
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

ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD CONSTRAINT [FK_dbo.BiomChannelUnitMetrics_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD CONSTRAINT [FK_dbo.BiomChannelUnitMetrics_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD CONSTRAINT [FK_dbo.BiomChannelUnitMetrics_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Header] ADD CONSTRAINT [FK_dbo.BiomChannelUnitMetrics_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Header] ADD CONSTRAINT [FK_dbo.BiomChannelUnitMetrics_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD CONSTRAINT [FK_dbo.BiomTier1Metrics_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD CONSTRAINT [FK_dbo.BiomTier1Metrics_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD CONSTRAINT [FK_dbo.BiomTier1Metrics_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[BiomTier1Metrics_Header] ADD CONSTRAINT [FK_dbo.BiomTier1Metrics_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[BiomTier1Metrics_Header] ADD CONSTRAINT [FK_dbo.BiomTier1Metrics_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[BiomTier2Metrics_Detail] ADD CONSTRAINT [FK_dbo.BiomTier2Metrics_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[BiomTier2Metrics_Detail] ADD CONSTRAINT [FK_dbo.BiomTier2Metrics_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[BiomTier2Metrics_Detail] ADD CONSTRAINT [FK_dbo.BiomTier2Metrics_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[BiomTier2Metrics_Header] ADD CONSTRAINT [FK_dbo.BiomTier2Metrics_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[BiomTier2Metrics_Header] ADD CONSTRAINT [FK_dbo.BiomTier2Metrics_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
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


-- Add the data
declare @datasetBaseName as varchar(max);
declare @categoryName as varchar(max);
declare @datastoreName as varchar(max);

set @datasetBaseName = 'BiomVisitMetrics'
set @categoryName = @datasetBaseName
set @datastoreName = @datasetBaseName

-- These are predefined project IDs -- the records for them should already exist
CREATE TABLE #ProjectInfo (id int, name varchar(max))
INSERT INTO #ProjectInfo (id)
	SELECT id = 2249
-- Grab the project names
update #ProjectInfo set name = (select name from projects where projects.id = #ProjectInfo.id)

create table #NewLocationTypeIds (id int)

-- Add record to LocationTypes
INSERT into dbo.LocationTypes([Name], [Description])
OUTPUT INSERTED.id into #NewLocationTypeIds
values (@datasetBaseName, @datasetBaseName)


CREATE TABLE #NewDatasetIds (id int)    -- This will contain a list of ids of all dataset records inserted below

-- Add record to the Datasets --> will create one record per project
INSERT INTO Datasets (ProjectId, DefaultRowQAStatusId, StatusId, CreateDateTime, Name, Description, DefaultActivityQAStatusId, DatastoreId, Config)
OUTPUT INSERTED.id into #NewDatasetIds
SELECT
	ProjectId                 = p.id,
	DefaultRowQAStatusId      = 1,
	StatusId                  = 1,
	CreateDateTime            = GetDate(),
	Name                      = @datasetBaseName,
	Description               = @datasetBaseName + ': ' + p.name,
	DefaultActivityQAStatusId = 6,
	DatastoreId               = (SELECT IDENT_CURRENT('dbo.Datastores')),
	Config                    = '{"DataEntryPage": {"HiddenFields": ["Instrument","BulkQaChange"]}}'
FROM #ProjectInfo as p


-- This will info about field records inserted below
CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1))


-- Insert any new fields we'll need (don't reuse fields)
-- Header Fields
INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'AemChampID',
		Description = 'AEM Champ Ident',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'AemChampID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitYear',
		Description = 'Year of the activity',
		Units = 'YYYY',
		Validation = 'i4',
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitYear',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'ProtocolID',
		Description = 'Number of the protocol used for that visit',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '[413,806,1870,1875,1877,1955,1966,2020,2030,2038,2044,9999,10001]',
		[Rule] = NULL,
		DbColumnName = 'ProtocolID',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SiteName',
		Description = 'AEM Champ Number plus Ctuir site name',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SiteName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitID',
		Description = 'Number assigned to the activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 1 where FieldRoleId is NULL   -- 1 == header


--Details Fields

INSERT INTO dbo.Fields(Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'Alkalinity',
		Description = 'Measure of the capacity of water to neutralize an acid (buffering capacity).',
		Units = 'ppm',
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Alkalinity',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bank Erosion',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankErosion',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Area',
		Description = 'The total bankfull area of a site.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Channel Braidedness',
		Description = 'Ratio of the total length of the bankfull mainstem plus side channels and the length of the mainstem channel.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullChannelBraidedness',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Channel Count',
		Description = 'Total number of channel segments (mainstem + side channels) identified in the bankfull channel.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullChannelCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Channel Island Count',
		Description = 'The total number of islands in the bankfull polygon.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullChannelIslandCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Channel Qualifying Island Area',
		Description = 'The total area of all qualifying islands in the bankfull  polygon.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullChannelQualifyingIslandArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Channel Qualifying Island Count',
		Description = 'The number of qualifying islands in the bankfull polygon.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullChannelQualifyingIslandCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Channel Total Length',
		Description = 'Total length of the main channel and all side channels at bankfull.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullChannelTotalLength',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Depth Avg',
		Description = 'Average depth of the bankfull channel.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullDepthAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Depth Max',
		Description = 'Maximum depth of the bankfull channel.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullDepthMax',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Main Channel Part Count',
		Description = 'Total count of bankfull mainstem channel segments.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullMainChannelPartCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Side Channel Width',
		Description = 'Average bankfull width of side channel(s) measured from cross-sections.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullSideChannelWidth',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Side Channel Width CV',
		Description = 'Coefficient of Variation of qualifying side channel bankfull widths measured from cross-sections.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullSideChannelWidthCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Side Channel Width to Depth Ratio Avg',
		Description = 'Width to average depth ratio in side channels at bankfull.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullSideChannelWidthToDepthRatioAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Side Channel Width to Depth Ratio CV',
		Description = 'Coefficient of Variation of width to average depth ratio in side channels at bankfull.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullSideChannelWidthToDepthRatioCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Side Channel Width to Max Depth Ratio Avg',
		Description = 'Width to max depth ratio in side channels at bankfull.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullSideChannelWidthToMaxDepthRatioAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Side Channel Width to Max Depth Ratio CV',
		Description = 'Coefficient of Variation of width to max depth ratio in side channels at bankfull.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullSideChannelWidthToMaxDepthRatioCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Site Length',
		Description = 'The total length of the bankfull centerline derived from the bankfull polygon.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullSiteLength',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Volume',
		Description = 'Total bankfull volume at a site.',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullVolume',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Width Avg',
		Description = 'Average width of the bankfull channel measured from cross-sections.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullWidthAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Width CV',
		Description = 'Coefficient of Variation of the bankfull channel width measured from cross-sections.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullWidthCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Width Integrated',
		Description = 'Average width of the bankfull polygon for a site.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullWidthIntegrated',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Width To Depth Ratio Avg',
		Description = 'Average width to depth ratios of the bankfull channel measured from cross-sections. Depths represent an average of 10 depths along each cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullWidthToDepthRatioAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Width To Depth Ratio CV',
		Description = 'Coefficient of Variation of width to depth ratios of the bankfull channel measured from cross-sections. Depths represent an average of 10 depths along each cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullWidthToDepthRatioCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Width to Max Depth Ratio Avg',
		Description = 'Average width to depth ratios of the bankfull channel measured from cross-sections. Depth represents the maximum depth along a cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullWidthToMaxDepthRatioAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Bankfull Width to Max Depth Ratio CV',
		Description = 'Coefficient of Variation of width to depth ratios of the bankfull channel measured from cross-sections. Depth represents the maximum depth along a cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BankfullWidthToMaxDepthRatioCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Braid Channel Ratio',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'BraidChannelRatio',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Conductivity',
		Description = 'Measure of the concentration of ionized materials in water, or the ability of water to conduct electrical current.',
		Units = 'µS/m',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Conductivity',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Constraining Feature Height Average',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ConstrainingFeatureHeightAverage',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Brooktrout',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfBrooktrout',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Bulltrout',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfBulltrout',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Chinook',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfChinook',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Chum',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfChum',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Coho',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfCoho',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Cutthroat',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfCutthroat',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Jam Large Woody Pieces',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfJamLargeWoodyPieces',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Key Large Woody Pieces',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfKeyLargeWoodyPieces',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Lamprey',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfLamprey',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Large Woody Pieces',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfLargeWoodyPieces',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Left Bank Large Woody Pieces',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfLeftBankLargeWoodyPieces',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Mid Channel Large Woody Pieces',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfMidChannelLargeWoodyPieces',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Omykiss',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfOmykiss',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Other Species',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfOtherSpecies',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Pink',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfPink',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Pool Forming Large Woody Pieces',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfPoolFormingLargeWoodyPieces',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Right Bank Large Woody Pieces',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfRightBankLargeWoodyPieces',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Count of Sockeye',
		Description = 'from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfSockeye',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Brooktrout',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfBrooktrout',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Bulltrout',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfBulltrout',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Chinook',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfChinook',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Chum',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfChum',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Coho',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfCoho',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Cutthroat',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfCutthroat',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Lamprey',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfLamprey',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Omykiss',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfOmykiss',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Pink',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfPink',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Density of Sockeye',
		Description = 'calculated from Snorkel',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfSockeye',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Detrended Elevation SD',
		Description = 'Standard Deviation of all cells for the detrended DEM.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DetrendedElevationSD',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Discharge',
		Description = 'The sum of station discharge across all  stations.  Station discharge is calculated as depth x velocity x station increment for all stations except first and last.  Station discharge for first and last station is 0.5 x station width x depth x velocity.',
		Units = 'm3/s',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Discharge',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Drift Biomass',
		Description = 'Total biomass of invertebrates from drift samples.',
		Units = 'g/m3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DriftBiomass',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast NonTurbulent Area',
		Description = 'Total wetted surface area identified as Fast Water Non-Turbulent channel units.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastNonTurbulentArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast NonTurbulent Count',
		Description = 'Number of  Fast Water Non-Turbulent channel units at a site.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastNonTurbulentCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast NonTurbulent Frequency',
		Description = 'Number of Fast Water Non-Turbulent channel units per 100 meters.',
		Units = 'count/100m',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastNonTurbulentFrequency',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast NonTurbulent Percent',
		Description = 'Percent of wetted area identified as Fast Water Non-Turbulent channel units.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastNonTurbulentPercent',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast NonTurbulent Volume',
		Description = 'Total wetted volume of all Fast Water Non-Turbulent channel units at a site.',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastNonTurbulentVolume',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast Turbulent Area',
		Description = 'Total wetted surface area identified as Fast Water Turbulent channel units.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastTurbulentArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast Turbulent Count',
		Description = 'Number of  Fast Water Turbulent channel units at a site.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastTurbulentCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast Turbulent Frequency',
		Description = 'Number of Fast Water Turbulent channel units per 100 meters.',
		Units = 'count/100m',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastTurbulentFrequency',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast Turbulent Percent',
		Description = 'Percent of wetted area identified as Fast Water Turbulent channel units.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastTurbulentPercent',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fast Turbulent Volume',
		Description = 'Total wetted volume of all Fast Water Turbulent channel units at a site.',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FastTurbulentVolume',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fish Cover: Aquatic Vegetation',
		Description = 'Percent of wetted area that has aquatic vegetation as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCoverAquaticVegetation',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fish Cover: Artificial',
		Description = 'Percent of wetted area that has artificial structure as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCoverArtificial',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fish Cover: LW',
		Description = 'Percent of wetted area that has woody debris as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCoverLW',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fish Cover: None',
		Description = 'Percent of channel unit with no fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCoverNone',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fish Cover: Terrestrial Vegetation',
		Description = 'Percent of wetted area that has live terrestrial vegetation as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCoverTerrestrialVegetation',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fish Cover: Total',
		Description = 'Percent of wetted area with the following types of cover: aquatic vegetation, artificial, woody debris, and terrestrial vegetation.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCoverTotal',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Flood Prone Width Average',
		Description = 'The Stream width at a discharge level defined as twice the maximum Bankfull Depth',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FloodProneWidthAverage',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Gradient',
		Description = 'Site water surface gradient is calculated as the difference between the top of site (upstream) and bottom of site (downstream) water surface elevations divided by thalweg length.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Gradient',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Large Wood Frequency: Bankfull',
		Description = 'Number of  large wood pieces per 100 meters within the bankfull channel.',
		Units = 'count/100m',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'LargeWoodFrequencyBankfull',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Large Wood Frequency: Wetted',
		Description = 'Number of  large wood pieces per 100 meters within the wetted channel.',
		Units = 'count/100m',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'LargeWoodFrequencyWetted',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Percent Constrained',
		Description = 'Need definition',
		Units = '%',
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'PercentConstrained',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Pool-To-Turbulent Area Ratio',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'PoolToTurbulentAreaRatio',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Percent Undercut by Area',
		Description = 'The percent of the wetted channel area with undercut banks.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'PercentUndercutByArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Percent Undercut by Length',
		Description = 'The percent of the wetted streambank length that is undercut.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'PercentUndercutByLength',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Residual Pool Depth',
		Description = 'The average difference between the maximum depth and downstream end depth of all Slow Water Pool channel units.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ResidualPoolDepth',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Riparian Cover: Big Tree',
		Description = 'Percent aerial coverage from big trees (>0.3 m DBH) in the canopy.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'RiparianCoverBigTree',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Riparian Cover: Coniferous',
		Description = 'Percent of coniferous cover in the canopy and understory.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'RiparianCoverConiferous',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Riparian Cover: Ground',
		Description = 'Percent  of groundcover vegetation.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'RiparianCoverGround',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Riparian Cover: No Canopy',
		Description = 'Percent of riparian canopy devoid of vegetation.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'RiparianCoverNoCanopy',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Riparian Cover: Non-Woody',
		Description = 'Percent of non-woody vegetation cover in the understory and groundcover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'RiparianCoverNonWoody',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Riparian Cover: Understory',
		Description = 'Percent of understory vegetation cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'RiparianCoverUnderstory',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Riparian Cover: Woody',
		Description = 'Percent of woody vegetation cover in the canopy, understory, and groundcover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'RiparianCoverWoody',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Sinuosity',
		Description = 'Ratio of the thalweg length to the straight line distance between the start and end points of the thalweg.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Sinuosity',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Sinuosity Via Centerline',
		Description = 'Ratio of the wetted centerline length (Site Length Wetted) and the straight line distance between the start and end points of the wetted centerline. Generated by the River Bathymetry Toolkit (RBT)',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SinuosityViaCenterline',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Slow Water Area',
		Description = 'Total wetted surface area identified as Slow Water Pool channel units.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SlowWaterArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Slow Water Count',
		Description = 'Number of  Slow Water Pool channel units at a site.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SlowWaterCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Slow Water Frequency',
		Description = 'Number of Slow Water Poolt channel units per 100 meters.',
		Units = 'count/100m',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SlowWaterFrequency',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Slow Water Percent',
		Description = 'Percent of wetted area identified asSlow Water Pool channel units.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SlowWaterPercent',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Slow Water Volume',
		Description = 'Total wetted volume of all Slow Water Pool channel units at a site.',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SlowWaterVolume',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Solar Access: Summer Avg',
		Description = 'Average available solar radiation from July-September.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SolarAccessSummerAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate < 2mm',
		Description = 'Average percentage of pool tail substrates comprised of fine sediment <2 mm.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateLt2mm',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate < 6mm',
		Description = 'Average percentage of pool tail substrates comprised of sediment <6 mm.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateLt6mm',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate Est: Boulders',
		Description = 'Percent of boulders (256-4000 mm) within the wetted site area.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateEstBoulders',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate Est: Coarse and Fine Gravel',
		Description = 'Percent of coarse and fine gravel (2-64 mm) within the wetted site area.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateEstCoarseAndFineGravel',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate Est: Cobbles',
		Description = 'Percent of cobbles (64-256 mm) within the wetted site area.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateEstCobbles',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate Est: Sand and Fines',
		Description = 'Percent of sand and fine sediment (0.01-2 mm) within the wetted site area.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateEstSandAndFines',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate: D16',
		Description = 'Diameter of the 16th percentile particle derived from pebble counts.',
		Units = 'mm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateD16',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate: D50',
		Description = 'Diameter of the 50th percentile particle derived from pebble counts.',
		Units = 'mm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateD50',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate: D84',
		Description = 'Diameter of the 84th percentile particle derived from pebble counts.',
		Units = 'mm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateD84',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate: Embeddedness Avg',
		Description = 'Average cobble embeddedness.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateEmbeddednessAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Substrate: Embeddedness SD',
		Description = 'Standard Deviation of cobble embeddedness.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubstrateEmbeddednessSD',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Thalweg Depth Avg',
		Description = 'Average thalweg depth of the wetted channel.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ThalwegDepthAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Thalweg Depth CV',
		Description = 'Coefficient of Variation (CV) of thalweg depths at a site.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ThalwegDepthCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Thalweg Site Length',
		Description = 'The total length of the thalweg at a site.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ThalwegSiteLength',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Total Undercut Area',
		Description = 'The total area of undercut banks.  Measured as the length*width of each undercut, then summed across the site',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'TotalUndercutArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Valley Width',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ValleyWidth',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Area',
		Description = 'The total wetted area of a site.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Braidedness',
		Description = 'Ratio of the total length of the wetted mainstem channel plus side channels and the length of the mainstem channel.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelBraidedness',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Count',
		Description = 'Total number of channel segments (mainstem + side channels) identified in the wetted channel.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Island Count',
		Description = 'The total number of islands in the wetted polygon.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelIslandCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Mainstem Area',
		Description = 'Sum of the wetted channel unit areas for all channel units that do not possess a type of "small side channel" or "large side channel".',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelMainstemArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Mainstem Length',
		Description = 'Length of the main wetted channel.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelMainstemLength',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Mainstem Sinuosity',
		Description = 'Length of the wetted main channel divided by the straight line length between the top and bottom endpoints of the wetted main channel centerline.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelMainstemSinuosity',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Qualifying Island Area',
		Description = 'The total area of all qualifying islands in the wetted polygon.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelQualifyingIslandArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Qualifying Island Count',
		Description = 'The number of qualifying islands in the wetted polygon.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelQualifyingIslandCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Channel Total Length',
		Description = 'Total length of wetted main and side channels.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedChannelTotalLength',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Depth SD',
		Description = 'Standard Deviation of water depths within the wetted channel.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedDepthSD',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Large Side Channel Area',
		Description = 'Sum of the large side channel unit areas.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedLargeSideChannelArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Main Channel Part Count',
		Description = 'Total count of wetted mainstem channel segments.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedMainChannelPartCount',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Side Channel Percent By Area',
		Description = 'Ratio of the total area of side channel unit areas (both small and large) divided by the total area of channel unit polygons.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSideChannelPercentByArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Side Channel Width',
		Description = 'Average wetted width of side channel(s)  measured from cross-sections.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSideChannelWidth',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Side Channel Width CV',
		Description = 'Coefficient of Variation of qualifying side channel wetted widths measured from cross-sections.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSideChannelWidthCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Side Channel Width to Depth Ratio Avg',
		Description = 'Average wetted width to depth ratio of qualifying side channels measured from from cross-sections.  Depths represent the average depth of 10 stations along each cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSideChannelWidthToDepthRatioAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Side Channel Width to Depth Ratio CV',
		Description = 'Coefficient of variation of qualifying wetted side channel width to average depth ratios measured from cross sections.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSideChannelWidthToDepthRatioCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Side Channel Width to Max Depth Ratio Avg',
		Description = 'Average wetted width to max depth ratio of qualifying side channels measured from cross-sections. Depths represent the max depth of 10 stations along each cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSideChannelWidthToMaxDepthRatioAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Side Channel Width to Max Depth Ratio CV',
		Description = 'Coefficient of variation of  qualifying wetted width to max depth ratios of side channels measured from cross-sections.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSideChannelWidthToMaxDepthRatioCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Site Length',
		Description = 'The total length of the wetted centerline derived from the wetted polygon.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSiteLength',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Small Side Channel Area',
		Description = 'Sum of all small side channel unit areas at a site.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedSmallSideChannelArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Volume',
		Description = 'Total wetted volume at a site.',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedVolume',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Width Avg',
		Description = 'Average width of the wetted channel measured from cross-sections.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedWidthAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Width CV',
		Description = 'Coefficient of Variation of the wetted channel width measured from cross-sections.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedWidthCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Width Integrated',
		Description = 'Average width of the wetted polygon for a site.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedWidthIntegrated',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Width To Depth Ratio Avg',
		Description = 'Average width to depth ratio of the wetted channel measured from cross-sections. Depths represent an average of depths along each cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedWidthToDepthRatioAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Width To Depth Ratio CV',
		Description = 'Retired. Coefficient of Variation of wetted width to depth ratios derived from cross-sections.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedWidthToDepthRatioCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Width to Max Depth Ratio Avg',
		Description = 'Average width to depth ratios of the wetted channel measured from cross-sections. Depth represents the maximum depth along a cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedWidthToMaxDepthRatioAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Wetted Width to Max Depth Ratio CV',
		Description = 'Coefficient of Variation of width to depth ratios of the wetted channel measured from cross-sections. Depth represents the maximum depth along a cross-section.',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WettedWidthToMaxDepthRatioCV',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 2 where FieldRoleId is NULL   -- 2 == details


-- Assign new fields to the datasets -- this will insert a new row for each combination of datasetId and fieldId for the records inserted above
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT
	DatasetId      = d.id,
	FieldId        = f.id,
	FieldRoleId    = f.FieldRoleId,
	CreateDateTime = GetDate(),
	Label          = f.fieldName,
	DbColumnName   = f.DbColumnName,
	Validation     = f.Validation,
	SourceId       = 1,
	InstrumentId   = NULL,
	OrderIndex     = f.OrderIndex * 10,     -- x10 to make it easier to insert intermediate orders
	ControlType    = f.ControlType,
	[Rule]         = f.[Rule]
FROM #NewDatasetIds as d, #NewFieldInfo as f

-- Add some new DatasetQAStatus records for our new datasets
CREATE TABLE #QaStatusIds (id int)
INSERT INTO #QaStatusIds (id)
	SELECT id = 5     -- Approved
UNION ALL SELECT id = 6     -- Ready for QA


INSERT INTO dbo.DatasetQAStatus(Dataset_Id, QAStatus_id)
SELECT
	Dataset_Id  = d.id,
	QAStatus_id = q.id
FROM #NewDatasetIds as d, #QaStatusIds as q

-- Cleanup
drop table #ProjectInfo
drop table #NewLocationTypeIds
drop table #NewFieldInfo
drop table #QaStatusIds
drop table #NewDatasetIds
go


-- Add system activity fields to DatasetFields 
declare @DatasetId as int; 
declare @FieldId as int;
set @DatasetId = (select Id from dbo.Datasets where [Name] like '%Visit%'); 

set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and [DbColumnName] = 'ActivityDate'); 

insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Activity Date', 'ActivityDate', null, 1, null, 3, 'hidden'); 


set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and DbColumnName = 'LocationId'); 
insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Location', 'LocationId', null, 1, null, 5, 'location-select');
GO

-- Channel Unit Metrics
-- Add the views
--DROP VIEW BiomChannelUnitMetrics_Header_VW
--GO
CREATE VIEW BiomChannelUnitMetrics_Header_VW
AS
SELECT Id, ProgramSiteID, SiteName, WatershedID, WatershedName, SampleDate, HitchName, CrewName, VisitYear, IterationID, CategoryName, PanelName, VisitID, VisitDate, ActivityId, ByUserId, EffDt
FROM dbo.BiomChannelUnitMetrics_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomChannelUnitMetrics_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))
GO

--DROP VIEW BiomChannelUnitMetrics_Detail_VW
--GO
CREATE VIEW BiomChannelUnitMetrics_Detail_VW
AS
SELECT Id, ChUnitID, ChUnitNum, Tier1, Tier2, AreaTotal, PolyArea, TotalVol, DpthMax, DpthThlwgExit, DpthResid, CountOfLWD, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt
FROM dbo.BiomChannelUnitMetrics_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomChannelUnitMetrics_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
GO

--DROP VIEW BiomChannelUnitMetrics_vw
--GO
CREATE VIEW BiomChannelUnitMetrics_vw
AS
SELECT a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ProgramSiteID, h.SiteName, h.WatershedID, h.WatershedName, h.SampleDate, h.HitchName, h.CrewName, h.VisitYear, h.IterationID, h.CategoryName, h.PanelName, h.VisitID, h.VisitDate, h.ByUserId, h.EffDt, d.Id AS BiomChannelUnitMetrics_Detail_Id, d.ChUnitID, d.ChUnitNum, d.Tier1, d.Tier2, d.AreaTotal, d.PolyArea, d.TotalVol, d.DpthMax, d.DpthThlwgExit, d.DpthResid, d.CountOfLWD, d.RowId, d.ByUserId AS BiomChannelUnitMetrics_Detail_ByUserId, d.QAStatusId, d.EffDt AS BiomChannelUnitMetrics_Detail_EffDt, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.BiomChannelUnitMetrics_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.BiomChannelUnitMetrics_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id 
GO


-- Add the data
declare @datasetBaseName as varchar(max);
declare @categoryName as varchar(max);
declare @datastoreName as varchar(max);

set @datasetBaseName = 'BiomChannelUnitMetrics' 
set @categoryName = @datasetBaseName
set @datastoreName = @datasetBaseName

-- These are predefined project IDs -- the records for them should already exist
CREATE TABLE #ProjectInfo (id int, name varchar(max))
INSERT INTO #ProjectInfo (id)
	SELECT id = 2249
-- Grab the project names
update #ProjectInfo set name = (select name from projects where projects.id = #ProjectInfo.id)

create table #NewLocationTypeIds (id int)

-- Add record to LocationTypes
INSERT into dbo.LocationTypes([Name], [Description])
OUTPUT INSERTED.id into #NewLocationTypeIds
values (@datasetBaseName, @datasetBaseName)


CREATE TABLE #NewDatasetIds (id int)    -- This will contain a list of ids of all dataset records inserted below

-- Add record to the Datasets --> will create one record per project
INSERT INTO Datasets (ProjectId, DefaultRowQAStatusId, StatusId, CreateDateTime, Name, Description, DefaultActivityQAStatusId, DatastoreId, Config)
OUTPUT INSERTED.id into #NewDatasetIds
SELECT
	ProjectId                 = p.id,
	DefaultRowQAStatusId      = 1,
	StatusId                  = 1,
	CreateDateTime            = GetDate(),
	Name                      = @datasetBaseName,
	Description               = @datasetBaseName + ': ' + p.name,
	DefaultActivityQAStatusId = 6,
	DatastoreId               = (SELECT IDENT_CURRENT('dbo.Datastores')),
	Config                    = '{"DataEntryPage": {"HiddenFields": ["Instrument","BulkQaChange"]}}'
FROM #ProjectInfo as p


-- This will info about field records inserted below
CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1))


-- Insert any new fields we'll need (don't reuse fields)
-- Header Fields
INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'ProgramSiteID',
		Description = 'AEM Champ Number Assigned by Program',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ProgramSiteID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SiteName',
		Description = 'AEM Champ Number plus Ctuir site name',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SiteName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'WatershedID',
		Description = 'AEM Champ Number assigned to watershed',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WatershedID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'WatershedName',
		Description = 'Watershed Name',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WatershedName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SampleDate',
		Description = 'Date of Activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'datetime',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SampleDate',
		ControlType = 'datetime',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'HitchName',
		Description = 'Name created for Hitch',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'HitchName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CrewName',
		Description = 'Name of the technician who collect the data',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CrewName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitYear',
		Description = 'Year of the activity',
		Units = 'yyyy',
		Validation = 'i4',
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitYear',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'IterationID',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'IterationID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CategoryName',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CategoryName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'PanelName',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["All","Annual","CTUIR Annual","Default","Rotating Panel 1","Rotating Panel 2","Rotating Panel 3"]',
		[Rule] = NULL,
		DbColumnName = 'PanelName',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitID',
		Description = 'Number assigned to the activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitDate',
		Description = 'Date of Activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'datetime',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitDate',
		ControlType = 'datetime',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 1 where FieldRoleId is NULL   -- 1 == header


--Details Fields

INSERT INTO dbo.Fields(Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'ChUnitID',
		Description = 'Unique identifier of a Channel Unit.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ChUnitID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'ChUnitNum',
		Description = 'Channel Unit Number within a site as identified during field data collection.',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ChUnitNum',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Tier1',
		Description = 'Tier 1 channel unit type.',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Fast-NonTurbulent/Glide","Fast-Turbulent","Slow/Pool","Small Side Channel"]',
		[Rule] = NULL,
		DbColumnName = 'Tier1',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Tier2',
		Description = 'Tier 2 channel unit type.',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Dam Pool","Fast-NonTurbulent/Glide","Off Channel","Plunge Pool","Rapid","Riffle","Scour Pool","Small Side Channel"]',
		[Rule] = NULL,
		DbColumnName = 'Tier2',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'AreaTotal',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'AreaTotal',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'PolyArea',
		Description = 'Area of the channel unit after clipped to the wetted extent.',
		Units = 'm2',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'PolyArea',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'TotalVol',
		Description = 'Total volume of channel unit type.',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'TotalVol',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Dpth_Max',
		Description = 'Maximum depth of the wetted channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthMax',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DpthThlwgExit',
		Description = 'Depth of the thalweg at the downstream edge of the channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthThlwgExit',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DpthResid',
		Description = 'Average residual depth of the channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthResid',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfLWD',
		Description = 'Number of Large woody debry in side of the channel unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfLWD',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 2 where FieldRoleId is NULL   -- 2 == details


-- Assign new fields to the datasets -- this will insert a new row for each combination of datasetId and fieldId for the records inserted above
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT
	DatasetId      = d.id,
	FieldId        = f.id,
	FieldRoleId    = f.FieldRoleId,
	CreateDateTime = GetDate(),
	Label          = f.fieldName,
	DbColumnName   = f.DbColumnName,
	Validation     = f.Validation,
	SourceId       = 1,
	InstrumentId   = NULL,
	OrderIndex     = f.OrderIndex * 10,     -- x10 to make it easier to insert intermediate orders
	ControlType    = f.ControlType,
	[Rule]         = f.[Rule]
FROM #NewDatasetIds as d, #NewFieldInfo as f

-- Add some new DatasetQAStatus records for our new datasets
CREATE TABLE #QaStatusIds (id int)
INSERT INTO #QaStatusIds (id)
	SELECT id = 5     -- Approved
UNION ALL SELECT id = 6     -- Ready for QA


INSERT INTO dbo.DatasetQAStatus(Dataset_Id, QAStatus_id)
SELECT
	Dataset_Id  = d.id,
	QAStatus_id = q.id
FROM #NewDatasetIds as d, #QaStatusIds as q

-- Cleanup
drop table #ProjectInfo
drop table #NewLocationTypeIds
drop table #NewFieldInfo
drop table #QaStatusIds
drop table #NewDatasetIds


-- Add system activity fields to DatasetFields
declare @DatasetId as int; 
declare @FieldId as int; 
set @DatasetId = (select Id from dbo.Datasets where [Name] like '%ChannelUnit%'); 

set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and [DbColumnName] = 'ActivityDate'); 

insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Activity Date', 'ActivityDate', null, 1, null, 3, 'activity-date'); 


set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and DbColumnName = 'LocationId'); 
insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Location', 'LocationId', null, 1, null, 5, 'location-select');
GO

-- Tier1
-- Add the views
--DROP VIEW BiomTier1Metrics_Header_VW
--GO
CREATE VIEW BiomTier1Metrics_Header_VW
AS
SELECT Id, ProgramSiteID, SiteName, WatershedID, WatershedName, SampleDate, HitchName, CrewName, VisitYear, IterationID, CategoryName, PanelName, VisitID, VisitDate, ProtocolID, ProgramID, AEM, Effectiveness, HasFishData, PrimaryVisit, QCVisit, ActivityId, ByUserId, EffDt
FROM dbo.BiomTier1Metrics_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomTier1Metrics_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))
GO

--DROP VIEW BiomTier1Metrics_Detail_VW
--GO
CREATE VIEW BiomTier1Metrics_Detail_VW
AS
SELECT Id, Tier1, Area, Ct, UnitSpacing, Freq, Vol, Pct, DpthThlwgMaxAvg, DpthThlwgExit, DpthResid, SubEstBldr, SubEstCbl, SubEstGrvl, SubEstSandFines, FishCovLW, FishCovTVeg, FishCovUcut, FishCovArt, FishCovAqVeg, FishCovNone, FishCovTotal, LWVolWetTier1, LWVolBfTier1, CountOfLWD, CountOfChinook, CountOfCoho, CountOfSockeye, CountOfChum, CountOfOmykiss, CountOfPink, CountOfCutthroat, CountOfBulltrout, CountOfBrooktrout, CountOfLamprey, CountOfOtherSpecies, DensityOfChinook, DensityOfCoho, DensityOfSockeye, DensityOfChum, DensityOfOmykiss, DensityOfPink, DensityOfCutthroat, DensityOfBulltrout, DensityOfBrooktrout, DensityOfLamprey, DensityOfOtherSpecies, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt
FROM dbo.BiomTier1Metrics_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomTier1Metrics_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
GO

--DROP VIEW BiomTier1Metrics_vw
--GO
CREATE VIEW BiomTier1Metrics_vw
AS
SELECT a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ProgramSiteID, h.SiteName, h.WatershedID, h.WatershedName, h.SampleDate, h.HitchName, h.CrewName, h.VisitYear, h.IterationID, h.CategoryName, h.PanelName, h.VisitID, h.VisitDate, h.ProtocolID, h.ProgramID, h.AEM, h.Effectiveness, h.HasFishData, h.PrimaryVisit, h.QCVisit, h.ByUserId, h.EffDt, d.Id AS BiomTier1Metrics_Detail_Id, d.Tier1, d.Area, d.Ct, d.UnitSpacing, d.Freq, d.Vol, d.Pct, d.DpthThlwgMaxAvg, d.DpthThlwgExit, d.DpthResid, d.SubEstBldr, d.SubEstCbl, d.SubEstGrvl, d.SubEstSandFines, d.FishCovLW, d.FishCovTVeg, d.FishCovUcut, d.FishCovArt, d.FishCovAqVeg, d.FishCovNone, d.FishCovTotal, d.LWVolWetTier1, d.LWVolBfTier1, d.CountOfLWD, d.CountOfChinook, d.CountOfCoho, d.CountOfSockeye, d.CountOfChum, d.CountOfOmykiss, d.CountOfPink, d.CountOfCutthroat, d.CountOfBulltrout, d.CountOfBrooktrout, d.CountOfLamprey, d.CountOfOtherSpecies, d.DensityOfChinook, d.DensityOfCoho, d.DensityOfSockeye, d.DensityOfChum, d.DensityOfOmykiss, d.DensityOfPink, d.DensityOfCutthroat, d.DensityOfBulltrout, d.DensityOfBrooktrout, d.DensityOfLamprey, d.DensityOfOtherSpecies, d.RowId, d.ByUserId AS BiomTier1Metrics_Detail_ByUserId, d.QAStatusId, d.EffDt AS BiomTier1Metrics_Detail_EffDt, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.BiomTier1Metrics_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.BiomTier1Metrics_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id 
GO


-- Add the data
declare @datasetBaseName as varchar(max);
declare @categoryName as varchar(max);
declare @datastoreName as varchar(max);

set @datasetBaseName = 'BiomTier1Metrics'
set @categoryName = @datasetBaseName
set @datastoreName = @datasetBaseName

-- These are predefined project IDs -- the records for them should already exist
CREATE TABLE #ProjectInfo (id int, name varchar(max))
INSERT INTO #ProjectInfo (id)
	SELECT id = 2249
-- Grab the project names
update #ProjectInfo set name = (select name from projects where projects.id = #ProjectInfo.id)

create table #NewLocationTypeIds (id int)

-- Add record to LocationTypes
INSERT into dbo.LocationTypes([Name], [Description])
OUTPUT INSERTED.id into #NewLocationTypeIds
values (@datasetBaseName, @datasetBaseName)


CREATE TABLE #NewDatasetIds (id int)    -- This will contain a list of ids of all dataset records inserted below

-- Add record to the Datasets --> will create one record per project
INSERT INTO Datasets (ProjectId, DefaultRowQAStatusId, StatusId, CreateDateTime, Name, Description, DefaultActivityQAStatusId, DatastoreId, Config)
OUTPUT INSERTED.id into #NewDatasetIds
SELECT
	ProjectId                 = p.id,
	DefaultRowQAStatusId      = 1,
	StatusId                  = 1,
	CreateDateTime            = GetDate(),
	Name                      = @datasetBaseName,
	Description               = @datasetBaseName + ': ' + p.name,
	DefaultActivityQAStatusId = 6,
	DatastoreId               = (SELECT IDENT_CURRENT('dbo.Datastores')),
	Config                    = '{"DataEntryPage": {"HiddenFields": ["Instrument","BulkQaChange"]}}'
FROM #ProjectInfo as p


-- This will info about field records inserted below
CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1))


-- Insert any new fields we'll need (don't reuse fields)
-- Header Fields
INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'ProgramSiteID',
		Description = 'AEM Champ Number Assigned by Program',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ProgramSiteID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SiteName',
		Description = 'AEM Champ Number plus Ctuir site name',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SiteName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'WatershedID',
		Description = 'AEM Champ Number assigned to watershed',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WatershedID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'WatershedName',
		Description = 'Watershed Name',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WatershedName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SampleDate',
		Description = 'Date of Activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'datetime',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SampleDate',
		ControlType = 'datetime',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'HitchName',
		Description = 'Name created for Hitch',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'HitchName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CrewName',
		Description = 'Name of the technician who collect the data',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CrewName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitYear',
		Description = 'Year of the activity',
		Units = 'yyyy',
		Validation = 'i4',
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitYear',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'IterationID',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'IterationID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CategoryName',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CategoryName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'PanelName',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["All","Annual","CTUIR Annual","Default","Rotating Panel 1","Rotating Panel 2","Rotating Panel 3"]',
		[Rule] = NULL,
		DbColumnName = 'PanelName',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitID',
		Description = 'Number assigned to the activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitDate',
		Description = 'Date of Activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'datetime',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitDate',
		ControlType = 'datetime',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'ProtocolID',
		Description = 'Number of the protocol used for that visit',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '[413,806,1870,1875,1877,1955,1966,2020,2030,2038,2044,9999,10001]',
		[Rule] = NULL,
		DbColumnName = 'ProtocolID',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'ProgramID',
		Description = 'AEM Champ Number Assigned by Program',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ProgramID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'AEM',
		Description = 'is this an AEM Site',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'AEM',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Effectiveness',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'Effectiveness',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Has Fish Data',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'HasFishData',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Primary Visit',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'PrimaryVisit',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'QC Visit',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'QCVisit',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 1 where FieldRoleId is NULL   -- 1 == header


--Details Fields

INSERT INTO dbo.Fields(Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'Tier1',
		Description = 'Tier 1 channel unit type.',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Fast-NonTurbulent/Glide","Fast-Turbulent","Slow/Pool","Small Side Channel"]',
		[Rule] = NULL,
		DbColumnName = 'Tier1',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Area',
		Description = 'Area of this type of unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Area',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Ct',
		Description = 'Count of this type of unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Ct',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'UnitSpacing',
		Description = 'Need definition',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'UnitSpacing',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Freq',
		Description = 'Frequency of channel unit ',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Freq',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Vol',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Vol',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Pct',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Pct',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DpthThlwgMax_Avg',
		Description = 'Maximum depth of the thalweg within the channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthThlwgMaxAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DpthThlwgExit',
		Description = 'Depth of the thalweg at the downstream edge of the channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthThlwgExit',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DpthResid',
		Description = 'Average residual depth of the channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthResid',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SubEstBldr',
		Description = 'Percent of boulders (256-4000 mm) within the wetted site area.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubEstBldr',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SubEstCbl',
		Description = 'Percent of cobbles (64-256 mm) within the wetted site area.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubEstCbl',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SubEstGrvl',
		Description = 'Percent of coarse and fine gravel (2-64 mm) within the wetted site area.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubEstGrvl',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SubEstSandFines',
		Description = 'Percent of sand and fine sediment (0.01-2 mm) within the wetted site area.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SubEstSandFines',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'FishCovLW',
		Description = 'Percent of wetted area that has woody debris as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCovLW',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'FishCovTVeg',
		Description = 'Percent of wetted area that has live terrestrial vegetation as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCovTVeg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'FishCovUcut',
		Description = 'Retired metric. Percent of wetted area that has Undercut as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCovUcut',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'FishCovArt',
		Description = 'Percent of wetted area that has artificial structure as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCovArt',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'FishCovAqVeg',
		Description = 'Percent of wetted area that has aquatic vegetation as fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCovAqVeg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'FishCovNone',
		Description = 'Percent of channel unit with no fish cover.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCovNone',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'FishCovTotal',
		Description = 'Percent of wetted area with the following types of cover: aquatic vegetation, artificial, woody debris, and terrestrial vegetation.',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishCovTotal',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'LWVol_WetTier1',
		Description = 'Total volume of  large wood pieces  within the wetted channel and Slow Water Pool channel units.',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'LWVolWetTier1',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'LWVol_BfTier1',
		Description = 'Total volume of  large wood pieces  within the wetted channel.',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'LWVolBfTier1',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfLWD',
		Description = 'Count of Large Wood Debry in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfLWD',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfChinook',
		Description = 'Count of Chinook in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfChinook',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfCoho',
		Description = 'Count of Coho in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfCoho',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfSockeye',
		Description = 'Count of Sockeye in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfSockeye',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfChum',
		Description = 'Count of Chum in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfChum',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfOmykiss',
		Description = 'Count of Omykiss in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfOmykiss',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfPink',
		Description = 'Count of Pink in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfPink',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfCutthroat',
		Description = 'Count of Cutthroat in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfCutthroat',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfBulltrout',
		Description = 'Count of Bulltrout in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfBulltrout',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfBrooktrout',
		Description = 'Count of Brooktrout in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfBrooktrout',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfLamprey',
		Description = 'Count of Lamprey in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfLamprey',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CountOfOtherSpecies',
		Description = 'Count of Other Species in Unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CountOfOtherSpecies',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfChinook',
		Description = 'Density of Chinook in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfChinook',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfCoho',
		Description = 'Density of Coho in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfCoho',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfSockeye',
		Description = 'Density of Sockeye in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfSockeye',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfChum',
		Description = 'Density of Chum in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfChum',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfOmykiss',
		Description = 'Density of Omykiss in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfOmykiss',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfPink',
		Description = 'Density of Pink in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfPink',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfCutthroat',
		Description = 'Density of Cutthroat in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfCutthroat',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfBulltrout',
		Description = 'Density of Bulltrout in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfBulltrout',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfBrooktrout',
		Description = 'Density of Brooktrout in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfBrooktrout',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfLamprey',
		Description = 'Density of Lamprey in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfLamprey',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DensityOfOtherSpecies',
		Description = 'Density of Other Species in unit',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DensityOfOtherSpecies',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 2 where FieldRoleId is NULL   -- 2 == details


-- Assign new fields to the datasets -- this will insert a new row for each combination of datasetId and fieldId for the records inserted above
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT
	DatasetId      = d.id,
	FieldId        = f.id,
	FieldRoleId    = f.FieldRoleId,
	CreateDateTime = GetDate(),
	Label          = f.fieldName,
	DbColumnName   = f.DbColumnName,
	Validation     = f.Validation,
	SourceId       = 1,
	InstrumentId   = NULL,
	OrderIndex     = f.OrderIndex * 10,     -- x10 to make it easier to insert intermediate orders
	ControlType    = f.ControlType,
	[Rule]         = f.[Rule]
FROM #NewDatasetIds as d, #NewFieldInfo as f

-- Add some new DatasetQAStatus records for our new datasets
CREATE TABLE #QaStatusIds (id int)
INSERT INTO #QaStatusIds (id)
	SELECT id = 5     -- Approved
UNION ALL SELECT id = 6     -- Ready for QA


INSERT INTO dbo.DatasetQAStatus(Dataset_Id, QAStatus_id)
SELECT
	Dataset_Id  = d.id,
	QAStatus_id = q.id
FROM #NewDatasetIds as d, #QaStatusIds as q

-- Cleanup
drop table #ProjectInfo
drop table #NewLocationTypeIds
drop table #NewFieldInfo
drop table #QaStatusIds
drop table #NewDatasetIds


-- Add system activity fields to DatasetFields 
declare @DatasetId as int; 
declare @FieldId as int;
set @DatasetId = (select Id from dbo.Datasets where [Name] like '%Tier1%'); 

set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and [DbColumnName] = 'ActivityDate'); 

insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Activity Date', 'ActivityDate', null, 1, null, 3, 'activity-date'); 


set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and DbColumnName = 'LocationId'); 
insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Location', 'LocationId', null, 1, null, 5, 'location-select');
GO


-- Tier2
-- Add the views
--DROP VIEW BiomTier2Metrics_Header_VW
--GO
CREATE VIEW BiomTier2Metrics_Header_VW
AS
SELECT Id, ProgramSiteID, SiteName, WatershedID, WatershedName, SampleDate, HitchName, CrewName, VisitYear, IterationID, CategoryName, PanelName, VisitID, VisitDate, ProtocolID, ProgramID, AEM, Effectiveness, HasFishData, PrimaryVisit, QCVisit, ActivityId, ByUserId, EffDt
FROM dbo.BiomTier2Metrics_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomTier2Metrics_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))
GO

--DROP VIEW BiomTier2Metrics_Detail_VW
--GO
CREATE VIEW BiomTier2Metrics_Detail_VW
AS
SELECT Id, Tier2, Area, Ct, UnitSpacing, Freq, Vol, Pct, DpthThlwgMaxAvg, DpthThlwgExit, DpthResid, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt
FROM dbo.BiomTier2Metrics_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomTier2Metrics_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
GO

--DROP VIEW BiomTier2Metrics_vw
--GO
CREATE VIEW BiomTier2Metrics_vw
AS
SELECT a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ProgramSiteID, h.SiteName, h.WatershedID, h.WatershedName, h.SampleDate, h.HitchName, h.CrewName, h.VisitYear, h.IterationID, h.CategoryName, h.PanelName, h.VisitID, h.VisitDate, h.ProtocolID, h.ProgramID, h.AEM, h.Effectiveness, h.HasFishData, h.PrimaryVisit, h.QCVisit, h.ByUserId, h.EffDt, d.Id AS BiomTier2Metrics_Detail_Id, d.Tier2, d.Area, d.Ct, d.UnitSpacing, d.Freq, d.Vol, d.Pct, d.DpthThlwgMaxAvg, d.DpthThlwgExit, d.DpthResid, d.RowId, d.ByUserId AS BiomTier2Metrics_Detail_ByUserId, d.QAStatusId, d.EffDt AS BiomTier2Metrics_Detail_EffDt, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.BiomTier2Metrics_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.BiomTier2Metrics_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id 
GO


-- Add the data
declare @datasetBaseName as varchar(max);
declare @categoryName as varchar(max);
declare @datastoreName as varchar(max);

set @datasetBaseName = 'BiomTier2Metrics'
set @categoryName = @datasetBaseName
set @datastoreName = @datasetBaseName

-- These are predefined project IDs -- the records for them should already exist
CREATE TABLE #ProjectInfo (id int, name varchar(max))
INSERT INTO #ProjectInfo (id)
	SELECT id = 2249
-- Grab the project names
update #ProjectInfo set name = (select name from projects where projects.id = #ProjectInfo.id)

create table #NewLocationTypeIds (id int)

-- Add record to LocationTypes
INSERT into dbo.LocationTypes([Name], [Description])
OUTPUT INSERTED.id into #NewLocationTypeIds
values (@datasetBaseName, @datasetBaseName)


CREATE TABLE #NewDatasetIds (id int)    -- This will contain a list of ids of all dataset records inserted below

-- Add record to the Datasets --> will create one record per project
INSERT INTO Datasets (ProjectId, DefaultRowQAStatusId, StatusId, CreateDateTime, Name, Description, DefaultActivityQAStatusId, DatastoreId, Config)
OUTPUT INSERTED.id into #NewDatasetIds
SELECT
	ProjectId                 = p.id,
	DefaultRowQAStatusId      = 1,
	StatusId                  = 1,
	CreateDateTime            = GetDate(),
	Name                      = @datasetBaseName,
	Description               = @datasetBaseName + ': ' + p.name,
	DefaultActivityQAStatusId = 6,
	DatastoreId               = (SELECT IDENT_CURRENT('dbo.Datastores')),
	Config                    = '{"DataEntryPage": {"HiddenFields": ["Instrument","BulkQaChange"]}}'
FROM #ProjectInfo as p


-- This will info about field records inserted below
CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1))


-- Insert any new fields we'll need (don't reuse fields)
-- Header Fields
INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'ProgramSiteID',
		Description = 'AEM Champ Number Assigned by Program',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ProgramSiteID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SiteName',
		Description = 'AEM Champ Number plus Ctuir site name',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SiteName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'WatershedID',
		Description = 'AEM Champ Number assigned to watershed',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WatershedID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'WatershedName',
		Description = 'Watershed Name',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'WatershedName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'SampleDate',
		Description = 'Date of Activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'datetime',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'SampleDate',
		ControlType = 'datetime',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'HitchName',
		Description = 'Name created for Hitch',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'HitchName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CrewName',
		Description = 'Name of the technician who collect the data',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CrewName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitYear',
		Description = 'Year of the activity',
		Units = 'yyyy',
		Validation = 'i4',
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitYear',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'IterationID',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'IterationID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CategoryName',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CategoryName',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'PanelName',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["All","Annual","CTUIR Annual","Default","Rotating Panel 1","Rotating Panel 2","Rotating Panel 3"]',
		[Rule] = NULL,
		DbColumnName = 'PanelName',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitID',
		Description = 'Number assigned to the activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'VisitDate',
		Description = 'Date of Activity',
		Units = NULL,
		Validation = NULL,
		DataType = 'datetime',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'VisitDate',
		ControlType = 'datetime',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'ProtocolID',
		Description = 'Number of the protocol used for that visit',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '[413,806,1870,1875,1877,1955,1966,2020,2030,2038,2044,9999,10001]',
		[Rule] = NULL,
		DbColumnName = 'ProtocolID',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'ProgramID',
		Description = 'AEM Champ Number Assigned by Program',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'ProgramID',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'AEM',
		Description = 'is this an AEM Site',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'AEM',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Effectiveness',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'Effectiveness',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Has Fish Data',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'HasFishData',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Primary Visit',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'PrimaryVisit',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'QC Visit',
		Description = 'Need definition',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'QCVisit',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 1 where FieldRoleId is NULL   -- 1 == header


--Details Fields

INSERT INTO dbo.Fields(Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'Tier2',
		Description = 'Teir 2 channel unit type',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Dam Pool","Fast-NonTurbulent-Glide","Off Channel","Plunge Pool","Rapid","Riffle","Scour Pool","Small Side Channel"]',
		[Rule] = NULL,
		DbColumnName = 'Tier2',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Area',
		Description = 'Area of this type of unit through out site',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Area',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Ct',
		Description = 'Count of this type of unit through out site',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Ct',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'UnitSpacing',
		Description = 'Need definition',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'UnitSpacing',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Freq',
		Description = 'Frequency of channel unit ',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Freq',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Vol',
		Description = 'Need definition',
		Units = 'm3',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Vol',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Pct',
		Description = 'Need definition',
		Units = '%',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Pct',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DpthThlwgMax_Avg',
		Description = 'Maximum depth of the thalweg within the channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthThlwgMaxAvg',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DpthThlwgExit',
		Description = 'Depth of the thalweg at the downstream edge of the channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthThlwgExit',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'DpthResid',
		Description = 'Average residual depth of the channel unit.',
		Units = 'm',
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'DpthResid',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 2 where FieldRoleId is NULL   -- 2 == details


-- Assign new fields to the datasets -- this will insert a new row for each combination of datasetId and fieldId for the records inserted above
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT
	DatasetId      = d.id,
	FieldId        = f.id,
	FieldRoleId    = f.FieldRoleId,
	CreateDateTime = GetDate(),
	Label          = f.fieldName,
	DbColumnName   = f.DbColumnName,
	Validation     = f.Validation,
	SourceId       = 1,
	InstrumentId   = NULL,
	OrderIndex     = f.OrderIndex * 10,     -- x10 to make it easier to insert intermediate orders
	ControlType    = f.ControlType,
	[Rule]         = f.[Rule]
FROM #NewDatasetIds as d, #NewFieldInfo as f

-- Add some new DatasetQAStatus records for our new datasets
CREATE TABLE #QaStatusIds (id int)
INSERT INTO #QaStatusIds (id)
	SELECT id = 5     -- Approved
UNION ALL SELECT id = 6     -- Ready for QA


INSERT INTO dbo.DatasetQAStatus(Dataset_Id, QAStatus_id)
SELECT
	Dataset_Id  = d.id,
	QAStatus_id = q.id
FROM #NewDatasetIds as d, #QaStatusIds as q

-- Cleanup
drop table #ProjectInfo
drop table #NewLocationTypeIds
drop table #NewFieldInfo
drop table #QaStatusIds
drop table #NewDatasetIds


-- Add system activity fields to DatasetFields
declare @DatasetId as int; 
declare @FieldId as int; 
set @DatasetId = (select Id from dbo.Datasets where [Name] like '%Tier2%'); 

set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and [DbColumnName] = 'ActivityDate'); 

insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Activity Date', 'ActivityDate', null, 1, null, 3, 'activity-date'); 


set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and DbColumnName = 'LocationId'); 
insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Location', 'LocationId', null, 1, null, 5, 'location-select');
