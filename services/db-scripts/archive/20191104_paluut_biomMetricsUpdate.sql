ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [MetricSchemaCanonicalName] [nvarchar](max)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [SampleID] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfBrooktrout] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfBulltrout] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfChinook] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfCoho] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfCutthroat] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfOmykiss] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfOtherSpecies] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfPink] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfSockeye] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [CountOfLamprey] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [LargeWoodyPiecesCount] [int]
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [TierOneType] [nvarchar](max)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [TierTwoType] [nvarchar](max)
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD [MetricSchemaCanonicalName] [nvarchar](max)
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD [SampleID] [int]
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD [WettedLWDVolumeStdDev] [decimal](16, 8)
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD [BankfullLWDVolumeStdDev] [decimal](16, 8)
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD [TierOneType] [nvarchar](max)
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD [LargeWoodyPiecesCount] [int]
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD [WettedLargeWoodVolumeByTier1] [decimal](16, 8)
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ADD [BankfullLargeWoodVolumeByTier1] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [MetricSchemaCanonicalName] [nvarchar](max)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [WettedLWDVolumeStdDev] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [BankfullLWDVolumeStdDev] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [WettedLargeWoodVolumeBySite] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [BankfullLargeWoodVolumeBySite] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [WettedLargeWoodVolumeInPools] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [BankfullLargeWoodVolumeInPools] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [WettedLargeWoodVolumeInFastTurbulent] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [BankfullLargeWoodVolumeInFastTurbulent] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [WettedLargeWoodVolumeInFastNonTurbulent] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [BankfullLargeWoodVolumeInFastNonTurbulent] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [DensityOfOtherSpecies] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [LWVBankfull_SW] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [RiparianPercentGroundCoverNoCover] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [FastWaterCobbleEmbeddednessAvg] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [FastWaterCobbleEmbeddednessStdDev] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [SiteLength] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [SiteMeasurementOfAlkalinity] [int]
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [LargeWoodyPiecesCountPoolForming] [int]
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [LargeWoodyPiecesCountRightBank] [int]
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [LargeWoodyPiecesCountIsJam] [int]
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [LargeWoodyPiecesCountIsKey] [int]
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [LargeWoodyPiecesCount] [int]
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [LargeWoodyPiecesCountLeftBank] [int]
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [LargeWoodyPiecesCountMidChannel] [int]
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [SiteMeasurementOfConductivity] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [SiteDischarge] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [RiparianPercentBigTreeCover] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [RiparianPercentConiferousCover] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [RiparianPercentGroundCover] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [RiparianPercentCanopyNoCover] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [RiparianPercentNonWoodyGroundCover] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [RiparianPercentUnderstoryCover] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [RiparianPercentWoodyCover] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [PercentOfObservationsLessThan2mm] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [PercentOfObservationsLessThan6mm] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [MeasurementOfD16] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [MeasurementOfD50] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD [MeasurementOfD84] [decimal](16, 8)
ALTER TABLE [dbo].[BiomVisitMetrics_Header] ADD [SampleID] [nvarchar](max)
DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'AreaTotal';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var0 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ALTER COLUMN [AreaTotal] [decimal](16, 8) NULL
DECLARE @var1 nvarchar(128)
SELECT @var1 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'PolyArea';
IF @var1 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var1 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ALTER COLUMN [PolyArea] [decimal](16, 8) NULL
DECLARE @var2 nvarchar(128)
SELECT @var2 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'TotalVol';
IF @var2 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var2 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ALTER COLUMN [TotalVol] [decimal](16, 8) NULL
DECLARE @var3 nvarchar(128)
SELECT @var3 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DpthMax';
IF @var3 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var3 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ALTER COLUMN [DpthMax] [decimal](16, 8) NULL
DECLARE @var4 nvarchar(128)
SELECT @var4 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DpthThlwgExit';
IF @var4 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var4 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ALTER COLUMN [DpthThlwgExit] [decimal](16, 8) NULL
DECLARE @var5 nvarchar(128)
SELECT @var5 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DpthResid';
IF @var5 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var5 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ALTER COLUMN [DpthResid] [decimal](16, 8) NULL
DECLARE @var6 nvarchar(128)
SELECT @var6 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Area';
IF @var6 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var6 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [Area] [decimal](16, 8) NULL
DECLARE @var7 nvarchar(128)
SELECT @var7 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'UnitSpacing';
IF @var7 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var7 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [UnitSpacing] [decimal](16, 8) NULL
DECLARE @var8 nvarchar(128)
SELECT @var8 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Freq';
IF @var8 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var8 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [Freq] [decimal](16, 8) NULL
DECLARE @var9 nvarchar(128)
SELECT @var9 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Vol';
IF @var9 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var9 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [Vol] [decimal](16, 8) NULL
DECLARE @var10 nvarchar(128)
SELECT @var10 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Pct';
IF @var10 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var10 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [Pct] [decimal](16, 8) NULL
DECLARE @var11 nvarchar(128)
SELECT @var11 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DpthThlwgMaxAvg';
IF @var11 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var11 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DpthThlwgMaxAvg] [decimal](16, 8) NULL
DECLARE @var12 nvarchar(128)
SELECT @var12 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DpthThlwgExit';
IF @var12 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var12 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DpthThlwgExit] [decimal](16, 8) NULL
DECLARE @var13 nvarchar(128)
SELECT @var13 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DpthResid';
IF @var13 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var13 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DpthResid] [decimal](16, 8) NULL
DECLARE @var14 nvarchar(128)
SELECT @var14 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubEstBldr';
IF @var14 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var14 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [SubEstBldr] [decimal](16, 8) NULL
DECLARE @var15 nvarchar(128)
SELECT @var15 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubEstCbl';
IF @var15 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var15 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [SubEstCbl] [decimal](16, 8) NULL
DECLARE @var16 nvarchar(128)
SELECT @var16 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubEstGrvl';
IF @var16 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var16 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [SubEstGrvl] [decimal](16, 8) NULL
DECLARE @var17 nvarchar(128)
SELECT @var17 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubEstSandFines';
IF @var17 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var17 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [SubEstSandFines] [decimal](16, 8) NULL
DECLARE @var18 nvarchar(128)
SELECT @var18 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCovLW';
IF @var18 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var18 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [FishCovLW] [decimal](16, 8) NULL
DECLARE @var19 nvarchar(128)
SELECT @var19 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCovTVeg';
IF @var19 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var19 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [FishCovTVeg] [decimal](16, 8) NULL
DECLARE @var20 nvarchar(128)
SELECT @var20 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCovUcut';
IF @var20 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var20 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [FishCovUcut] [decimal](16, 8) NULL
DECLARE @var21 nvarchar(128)
SELECT @var21 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCovArt';
IF @var21 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var21 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [FishCovArt] [decimal](16, 8) NULL
DECLARE @var22 nvarchar(128)
SELECT @var22 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCovAqVeg';
IF @var22 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var22 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [FishCovAqVeg] [decimal](16, 8) NULL
DECLARE @var23 nvarchar(128)
SELECT @var23 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCovNone';
IF @var23 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var23 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [FishCovNone] [decimal](16, 8) NULL
DECLARE @var24 nvarchar(128)
SELECT @var24 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCovTotal';
IF @var24 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var24 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [FishCovTotal] [decimal](16, 8) NULL
DECLARE @var25 nvarchar(128)
SELECT @var25 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfChinook';
IF @var25 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var25 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfChinook] [decimal](16, 8) NULL
DECLARE @var26 nvarchar(128)
SELECT @var26 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfCoho';
IF @var26 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var26 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfCoho] [decimal](16, 8) NULL
DECLARE @var27 nvarchar(128)
SELECT @var27 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfSockeye';
IF @var27 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var27 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfSockeye] [decimal](16, 8) NULL
DECLARE @var28 nvarchar(128)
SELECT @var28 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfChum';
IF @var28 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var28 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfChum] [decimal](16, 8) NULL
DECLARE @var29 nvarchar(128)
SELECT @var29 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfOmykiss';
IF @var29 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var29 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfOmykiss] [decimal](16, 8) NULL
DECLARE @var30 nvarchar(128)
SELECT @var30 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfPink';
IF @var30 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var30 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfPink] [decimal](16, 8) NULL
DECLARE @var31 nvarchar(128)
SELECT @var31 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfCutthroat';
IF @var31 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var31 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfCutthroat] [decimal](16, 8) NULL
DECLARE @var32 nvarchar(128)
SELECT @var32 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfBulltrout';
IF @var32 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var32 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfBulltrout] [decimal](16, 8) NULL
DECLARE @var33 nvarchar(128)
SELECT @var33 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfBrooktrout';
IF @var33 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var33 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfBrooktrout] [decimal](16, 8) NULL
DECLARE @var34 nvarchar(128)
SELECT @var34 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfLamprey';
IF @var34 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var34 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfLamprey] [decimal](16, 8) NULL
DECLARE @var35 nvarchar(128)
SELECT @var35 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfOtherSpecies';
IF @var35 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var35 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] ALTER COLUMN [DensityOfOtherSpecies] [decimal](16, 8) NULL
DECLARE @var36 nvarchar(128)
SELECT @var36 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankErosion';
IF @var36 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var36 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankErosion] [decimal](16, 8) NULL
DECLARE @var37 nvarchar(128)
SELECT @var37 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullArea';
IF @var37 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var37 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullArea] [decimal](16, 8) NULL
DECLARE @var38 nvarchar(128)
SELECT @var38 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullChannelBraidedness';
IF @var38 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var38 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullChannelBraidedness] [decimal](16, 8) NULL
DECLARE @var39 nvarchar(128)
SELECT @var39 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullChannelQualifyingIslandArea';
IF @var39 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var39 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullChannelQualifyingIslandArea] [decimal](16, 8) NULL
DECLARE @var40 nvarchar(128)
SELECT @var40 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullChannelTotalLength';
IF @var40 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var40 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullChannelTotalLength] [decimal](16, 8) NULL
DECLARE @var41 nvarchar(128)
SELECT @var41 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullDepthAvg';
IF @var41 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var41 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullDepthAvg] [decimal](16, 8) NULL
DECLARE @var42 nvarchar(128)
SELECT @var42 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullDepthMax';
IF @var42 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var42 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullDepthMax] [decimal](16, 8) NULL
DECLARE @var43 nvarchar(128)
SELECT @var43 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullSideChannelWidth';
IF @var43 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var43 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullSideChannelWidth] [decimal](16, 8) NULL
DECLARE @var44 nvarchar(128)
SELECT @var44 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullSideChannelWidthCV';
IF @var44 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var44 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullSideChannelWidthCV] [decimal](16, 8) NULL
DECLARE @var45 nvarchar(128)
SELECT @var45 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullSideChannelWidthToDepthRatioAvg';
IF @var45 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var45 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullSideChannelWidthToDepthRatioAvg] [decimal](16, 8) NULL
DECLARE @var46 nvarchar(128)
SELECT @var46 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullSideChannelWidthToDepthRatioCV';
IF @var46 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var46 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullSideChannelWidthToDepthRatioCV] [decimal](16, 8) NULL
DECLARE @var47 nvarchar(128)
SELECT @var47 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullSideChannelWidthToMaxDepthRatioAvg';
IF @var47 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var47 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullSideChannelWidthToMaxDepthRatioAvg] [decimal](16, 8) NULL
DECLARE @var48 nvarchar(128)
SELECT @var48 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullSideChannelWidthToMaxDepthRatioCV';
IF @var48 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var48 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullSideChannelWidthToMaxDepthRatioCV] [decimal](16, 8) NULL
DECLARE @var49 nvarchar(128)
SELECT @var49 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullSiteLength';
IF @var49 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var49 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullSiteLength] [decimal](16, 8) NULL
DECLARE @var50 nvarchar(128)
SELECT @var50 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullVolume';
IF @var50 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var50 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullVolume] [decimal](16, 8) NULL
DECLARE @var51 nvarchar(128)
SELECT @var51 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullWidthAvg';
IF @var51 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var51 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullWidthAvg] [decimal](16, 8) NULL
DECLARE @var52 nvarchar(128)
SELECT @var52 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullWidthCV';
IF @var52 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var52 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullWidthCV] [decimal](16, 8) NULL
DECLARE @var53 nvarchar(128)
SELECT @var53 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullWidthIntegrated';
IF @var53 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var53 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullWidthIntegrated] [decimal](16, 8) NULL
DECLARE @var54 nvarchar(128)
SELECT @var54 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullWidthToDepthRatioAvg';
IF @var54 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var54 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullWidthToDepthRatioAvg] [decimal](16, 8) NULL
DECLARE @var55 nvarchar(128)
SELECT @var55 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullWidthToDepthRatioCV';
IF @var55 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var55 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullWidthToDepthRatioCV] [decimal](16, 8) NULL
DECLARE @var56 nvarchar(128)
SELECT @var56 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullWidthToMaxDepthRatioAvg';
IF @var56 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var56 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullWidthToMaxDepthRatioAvg] [decimal](16, 8) NULL
DECLARE @var57 nvarchar(128)
SELECT @var57 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BankfullWidthToMaxDepthRatioCV';
IF @var57 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var57 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BankfullWidthToMaxDepthRatioCV] [decimal](16, 8) NULL
DECLARE @var58 nvarchar(128)
SELECT @var58 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'BraidChannelRatio';
IF @var58 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var58 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [BraidChannelRatio] [decimal](16, 8) NULL
DECLARE @var59 nvarchar(128)
SELECT @var59 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'ConstrainingFeatureHeightAverage';
IF @var59 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var59 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [ConstrainingFeatureHeightAverage] [decimal](16, 8) NULL
DECLARE @var60 nvarchar(128)
SELECT @var60 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfBrooktrout';
IF @var60 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var60 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfBrooktrout] [decimal](16, 8) NULL
DECLARE @var61 nvarchar(128)
SELECT @var61 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfBulltrout';
IF @var61 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var61 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfBulltrout] [decimal](16, 8) NULL
DECLARE @var62 nvarchar(128)
SELECT @var62 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfChinook';
IF @var62 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var62 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfChinook] [decimal](16, 8) NULL
DECLARE @var63 nvarchar(128)
SELECT @var63 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfChum';
IF @var63 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var63 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfChum] [decimal](16, 8) NULL
DECLARE @var64 nvarchar(128)
SELECT @var64 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfCoho';
IF @var64 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var64 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfCoho] [decimal](16, 8) NULL
DECLARE @var65 nvarchar(128)
SELECT @var65 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfCutthroat';
IF @var65 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var65 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfCutthroat] [decimal](16, 8) NULL
DECLARE @var66 nvarchar(128)
SELECT @var66 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfLamprey';
IF @var66 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var66 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfLamprey] [decimal](16, 8) NULL
DECLARE @var67 nvarchar(128)
SELECT @var67 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfOmykiss';
IF @var67 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var67 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfOmykiss] [decimal](16, 8) NULL
DECLARE @var68 nvarchar(128)
SELECT @var68 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfPink';
IF @var68 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var68 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfPink] [decimal](16, 8) NULL
DECLARE @var69 nvarchar(128)
SELECT @var69 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DensityOfSockeye';
IF @var69 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var69 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DensityOfSockeye] [decimal](16, 8) NULL
DECLARE @var70 nvarchar(128)
SELECT @var70 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DetrendedElevationSD';
IF @var70 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var70 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DetrendedElevationSD] [decimal](16, 8) NULL
DECLARE @var71 nvarchar(128)
SELECT @var71 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'DriftBiomass';
IF @var71 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var71 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [DriftBiomass] [decimal](16, 8) NULL
DECLARE @var72 nvarchar(128)
SELECT @var72 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FastNonTurbulentArea';
IF @var72 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var72 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FastNonTurbulentArea] [decimal](16, 8) NULL
DECLARE @var73 nvarchar(128)
SELECT @var73 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FastNonTurbulentFrequency';
IF @var73 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var73 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FastNonTurbulentFrequency] [decimal](16, 8) NULL
DECLARE @var74 nvarchar(128)
SELECT @var74 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FastNonTurbulentPercent';
IF @var74 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var74 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FastNonTurbulentPercent] [decimal](16, 8) NULL
DECLARE @var75 nvarchar(128)
SELECT @var75 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FastNonTurbulentVolume';
IF @var75 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var75 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FastNonTurbulentVolume] [decimal](16, 8) NULL
DECLARE @var76 nvarchar(128)
SELECT @var76 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FastTurbulentArea';
IF @var76 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var76 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FastTurbulentArea] [decimal](16, 8) NULL
DECLARE @var77 nvarchar(128)
SELECT @var77 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FastTurbulentFrequency';
IF @var77 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var77 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FastTurbulentFrequency] [decimal](16, 8) NULL
DECLARE @var78 nvarchar(128)
SELECT @var78 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FastTurbulentPercent';
IF @var78 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var78 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FastTurbulentPercent] [decimal](16, 8) NULL
DECLARE @var79 nvarchar(128)
SELECT @var79 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FastTurbulentVolume';
IF @var79 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var79 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FastTurbulentVolume] [decimal](16, 8) NULL
DECLARE @var80 nvarchar(128)
SELECT @var80 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCoverAquaticVegetation';
IF @var80 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var80 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FishCoverAquaticVegetation] [decimal](16, 8) NULL
DECLARE @var81 nvarchar(128)
SELECT @var81 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCoverArtificial';
IF @var81 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var81 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FishCoverArtificial] [decimal](16, 8) NULL
DECLARE @var82 nvarchar(128)
SELECT @var82 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCoverLW';
IF @var82 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var82 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FishCoverLW] [decimal](16, 8) NULL
DECLARE @var83 nvarchar(128)
SELECT @var83 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCoverNone';
IF @var83 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var83 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FishCoverNone] [decimal](16, 8) NULL
DECLARE @var84 nvarchar(128)
SELECT @var84 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCoverTerrestrialVegetation';
IF @var84 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var84 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FishCoverTerrestrialVegetation] [decimal](16, 8) NULL
DECLARE @var85 nvarchar(128)
SELECT @var85 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FishCoverTotal';
IF @var85 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var85 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FishCoverTotal] [decimal](16, 8) NULL
DECLARE @var86 nvarchar(128)
SELECT @var86 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'FloodProneWidthAverage';
IF @var86 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var86 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [FloodProneWidthAverage] [decimal](16, 8) NULL
DECLARE @var87 nvarchar(128)
SELECT @var87 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Gradient';
IF @var87 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var87 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [Gradient] [decimal](16, 8) NULL
DECLARE @var88 nvarchar(128)
SELECT @var88 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'LargeWoodFrequencyBankfull';
IF @var88 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var88 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [LargeWoodFrequencyBankfull] [decimal](16, 8) NULL
DECLARE @var89 nvarchar(128)
SELECT @var89 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'LargeWoodFrequencyWetted';
IF @var89 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var89 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [LargeWoodFrequencyWetted] [decimal](16, 8) NULL
DECLARE @var90 nvarchar(128)
SELECT @var90 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'PoolToTurbulentAreaRatio';
IF @var90 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var90 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [PoolToTurbulentAreaRatio] [decimal](16, 8) NULL
DECLARE @var91 nvarchar(128)
SELECT @var91 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'PercentUndercutByArea';
IF @var91 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var91 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [PercentUndercutByArea] [decimal](16, 8) NULL
DECLARE @var92 nvarchar(128)
SELECT @var92 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'PercentUndercutByLength';
IF @var92 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var92 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [PercentUndercutByLength] [decimal](16, 8) NULL
DECLARE @var93 nvarchar(128)
SELECT @var93 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'ResidualPoolDepth';
IF @var93 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var93 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [ResidualPoolDepth] [decimal](16, 8) NULL
DECLARE @var94 nvarchar(128)
SELECT @var94 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Sinuosity';
IF @var94 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var94 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [Sinuosity] [decimal](16, 8) NULL
DECLARE @var95 nvarchar(128)
SELECT @var95 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SinuosityViaCenterline';
IF @var95 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var95 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SinuosityViaCenterline] [decimal](16, 8) NULL
DECLARE @var96 nvarchar(128)
SELECT @var96 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SlowWaterArea';
IF @var96 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var96 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SlowWaterArea] [decimal](16, 8) NULL
DECLARE @var97 nvarchar(128)
SELECT @var97 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SlowWaterFrequency';
IF @var97 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var97 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SlowWaterFrequency] [decimal](16, 8) NULL
DECLARE @var98 nvarchar(128)
SELECT @var98 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SlowWaterPercent';
IF @var98 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var98 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SlowWaterPercent] [decimal](16, 8) NULL
DECLARE @var99 nvarchar(128)
SELECT @var99 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SlowWaterVolume';
IF @var99 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var99 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SlowWaterVolume] [decimal](16, 8) NULL
DECLARE @var100 nvarchar(128)
SELECT @var100 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SolarAccessSummerAvg';
IF @var100 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var100 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SolarAccessSummerAvg] [decimal](16, 8) NULL
DECLARE @var101 nvarchar(128)
SELECT @var101 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateEstBoulders';
IF @var101 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var101 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SubstrateEstBoulders] [decimal](16, 8) NULL
DECLARE @var102 nvarchar(128)
SELECT @var102 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateEstCoarseAndFineGravel';
IF @var102 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var102 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SubstrateEstCoarseAndFineGravel] [decimal](16, 8) NULL
DECLARE @var103 nvarchar(128)
SELECT @var103 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateEstCobbles';
IF @var103 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var103 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SubstrateEstCobbles] [decimal](16, 8) NULL
DECLARE @var104 nvarchar(128)
SELECT @var104 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateEstSandAndFines';
IF @var104 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var104 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SubstrateEstSandAndFines] [decimal](16, 8) NULL
DECLARE @var105 nvarchar(128)
SELECT @var105 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateEmbeddednessAvg';
IF @var105 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var105 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SubstrateEmbeddednessAvg] [decimal](16, 8) NULL
DECLARE @var106 nvarchar(128)
SELECT @var106 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateEmbeddednessSD';
IF @var106 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var106 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [SubstrateEmbeddednessSD] [decimal](16, 8) NULL
DECLARE @var107 nvarchar(128)
SELECT @var107 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'ThalwegDepthAvg';
IF @var107 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var107 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [ThalwegDepthAvg] [decimal](16, 8) NULL
DECLARE @var108 nvarchar(128)
SELECT @var108 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'ThalwegDepthCV';
IF @var108 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var108 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [ThalwegDepthCV] [decimal](16, 8) NULL
DECLARE @var109 nvarchar(128)
SELECT @var109 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'ThalwegSiteLength';
IF @var109 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var109 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [ThalwegSiteLength] [decimal](16, 8) NULL
DECLARE @var110 nvarchar(128)
SELECT @var110 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'TotalUndercutArea';
IF @var110 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var110 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [TotalUndercutArea] [decimal](16, 8) NULL
DECLARE @var111 nvarchar(128)
SELECT @var111 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'ValleyWidth';
IF @var111 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var111 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [ValleyWidth] [decimal](16, 8) NULL
DECLARE @var112 nvarchar(128)
SELECT @var112 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedArea';
IF @var112 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var112 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedArea] [decimal](16, 8) NULL
DECLARE @var113 nvarchar(128)
SELECT @var113 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedChannelBraidedness';
IF @var113 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var113 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedChannelBraidedness] [decimal](16, 8) NULL
DECLARE @var114 nvarchar(128)
SELECT @var114 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedChannelMainstemArea';
IF @var114 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var114 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedChannelMainstemArea] [decimal](16, 8) NULL
DECLARE @var115 nvarchar(128)
SELECT @var115 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedChannelMainstemLength';
IF @var115 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var115 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedChannelMainstemLength] [decimal](16, 8) NULL
DECLARE @var116 nvarchar(128)
SELECT @var116 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedChannelMainstemSinuosity';
IF @var116 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var116 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedChannelMainstemSinuosity] [decimal](16, 8) NULL
DECLARE @var117 nvarchar(128)
SELECT @var117 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedChannelQualifyingIslandArea';
IF @var117 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var117 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedChannelQualifyingIslandArea] [decimal](16, 8) NULL
DECLARE @var118 nvarchar(128)
SELECT @var118 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedChannelTotalLength';
IF @var118 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var118 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedChannelTotalLength] [decimal](16, 8) NULL
DECLARE @var119 nvarchar(128)
SELECT @var119 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedDepthSD';
IF @var119 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var119 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedDepthSD] [decimal](16, 8) NULL
DECLARE @var120 nvarchar(128)
SELECT @var120 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedLargeSideChannelArea';
IF @var120 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var120 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedLargeSideChannelArea] [decimal](16, 8) NULL
DECLARE @var121 nvarchar(128)
SELECT @var121 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSideChannelPercentByArea';
IF @var121 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var121 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSideChannelPercentByArea] [decimal](16, 8) NULL
DECLARE @var122 nvarchar(128)
SELECT @var122 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSideChannelWidth';
IF @var122 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var122 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSideChannelWidth] [decimal](16, 8) NULL
DECLARE @var123 nvarchar(128)
SELECT @var123 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSideChannelWidthCV';
IF @var123 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var123 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSideChannelWidthCV] [decimal](16, 8) NULL
DECLARE @var124 nvarchar(128)
SELECT @var124 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSideChannelWidthToDepthRatioAvg';
IF @var124 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var124 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSideChannelWidthToDepthRatioAvg] [decimal](16, 8) NULL
DECLARE @var125 nvarchar(128)
SELECT @var125 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSideChannelWidthToDepthRatioCV';
IF @var125 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var125 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSideChannelWidthToDepthRatioCV] [decimal](16, 8) NULL
DECLARE @var126 nvarchar(128)
SELECT @var126 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSideChannelWidthToMaxDepthRatioAvg';
IF @var126 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var126 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSideChannelWidthToMaxDepthRatioAvg] [decimal](16, 8) NULL
DECLARE @var127 nvarchar(128)
SELECT @var127 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSideChannelWidthToMaxDepthRatioCV';
IF @var127 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var127 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSideChannelWidthToMaxDepthRatioCV] [decimal](16, 8) NULL
DECLARE @var128 nvarchar(128)
SELECT @var128 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSiteLength';
IF @var128 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var128 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSiteLength] [decimal](16, 8) NULL
DECLARE @var129 nvarchar(128)
SELECT @var129 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedSmallSideChannelArea';
IF @var129 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var129 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedSmallSideChannelArea] [decimal](16, 8) NULL
DECLARE @var130 nvarchar(128)
SELECT @var130 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedVolume';
IF @var130 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var130 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedVolume] [decimal](16, 8) NULL
DECLARE @var131 nvarchar(128)
SELECT @var131 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedWidthAvg';
IF @var131 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var131 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedWidthAvg] [decimal](16, 8) NULL
DECLARE @var132 nvarchar(128)
SELECT @var132 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedWidthCV';
IF @var132 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var132 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedWidthCV] [decimal](16, 8) NULL
DECLARE @var133 nvarchar(128)
SELECT @var133 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedWidthIntegrated';
IF @var133 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var133 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedWidthIntegrated] [decimal](16, 8) NULL
DECLARE @var134 nvarchar(128)
SELECT @var134 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedWidthToDepthRatioAvg';
IF @var134 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var134 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedWidthToDepthRatioAvg] [decimal](16, 8) NULL
DECLARE @var135 nvarchar(128)
SELECT @var135 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedWidthToDepthRatioCV';
IF @var135 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var135 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedWidthToDepthRatioCV] [decimal](16, 8) NULL
DECLARE @var136 nvarchar(128)
SELECT @var136 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedWidthToMaxDepthRatioAvg';
IF @var136 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var136 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedWidthToMaxDepthRatioAvg] [decimal](16, 8) NULL
DECLARE @var137 nvarchar(128)
SELECT @var137 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'WettedWidthToMaxDepthRatioCV';
IF @var137 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var137 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ALTER COLUMN [WettedWidthToMaxDepthRatioCV] [decimal](16, 8) NULL
DECLARE @var138 nvarchar(128)
SELECT @var138 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Tier1';
IF @var138 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var138 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP COLUMN [Tier1]
DECLARE @var139 nvarchar(128)
SELECT @var139 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Tier2';
IF @var139 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var139 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP COLUMN [Tier2]
DECLARE @var140 nvarchar(128)
SELECT @var140 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomChannelUnitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfLWD';
IF @var140 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP CONSTRAINT [' + @var140 + ']')
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] DROP COLUMN [CountOfLWD]
DECLARE @var141 nvarchar(128)
SELECT @var141 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Tier1';
IF @var141 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var141 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP COLUMN [Tier1]
DECLARE @var142 nvarchar(128)
SELECT @var142 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'LWVolWetTier1';
IF @var142 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var142 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP COLUMN [LWVolWetTier1]
DECLARE @var143 nvarchar(128)
SELECT @var143 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'LWVolBfTier1';
IF @var143 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var143 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP COLUMN [LWVolBfTier1]
DECLARE @var144 nvarchar(128)
SELECT @var144 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomTier1Metrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfLWD';
IF @var144 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP CONSTRAINT [' + @var144 + ']')
ALTER TABLE [dbo].[BiomTier1Metrics_Detail] DROP COLUMN [CountOfLWD]
DECLARE @var145 nvarchar(128)
SELECT @var145 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Alkalinity';
IF @var145 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var145 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [Alkalinity]
DECLARE @var146 nvarchar(128)
SELECT @var146 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Conductivity';
IF @var146 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var146 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [Conductivity]
DECLARE @var147 nvarchar(128)
SELECT @var147 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfJamLargeWoodyPieces';
IF @var147 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var147 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [CountOfJamLargeWoodyPieces]
DECLARE @var148 nvarchar(128)
SELECT @var148 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfKeyLargeWoodyPieces';
IF @var148 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var148 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [CountOfKeyLargeWoodyPieces]
DECLARE @var149 nvarchar(128)
SELECT @var149 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfLargeWoodyPieces';
IF @var149 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var149 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [CountOfLargeWoodyPieces]
DECLARE @var150 nvarchar(128)
SELECT @var150 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfLeftBankLargeWoodyPieces';
IF @var150 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var150 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [CountOfLeftBankLargeWoodyPieces]
DECLARE @var151 nvarchar(128)
SELECT @var151 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfMidChannelLargeWoodyPieces';
IF @var151 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var151 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [CountOfMidChannelLargeWoodyPieces]
DECLARE @var152 nvarchar(128)
SELECT @var152 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfPoolFormingLargeWoodyPieces';
IF @var152 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var152 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [CountOfPoolFormingLargeWoodyPieces]
DECLARE @var153 nvarchar(128)
SELECT @var153 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'CountOfRightBankLargeWoodyPieces';
IF @var153 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var153 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [CountOfRightBankLargeWoodyPieces]
DECLARE @var154 nvarchar(128)
SELECT @var154 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Discharge';
IF @var154 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var154 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [Discharge]
DECLARE @var155 nvarchar(128)
SELECT @var155 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'RiparianCoverBigTree';
IF @var155 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var155 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [RiparianCoverBigTree]
DECLARE @var156 nvarchar(128)
SELECT @var156 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'RiparianCoverConiferous';
IF @var156 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var156 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [RiparianCoverConiferous]
DECLARE @var157 nvarchar(128)
SELECT @var157 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'RiparianCoverGround';
IF @var157 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var157 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [RiparianCoverGround]
DECLARE @var158 nvarchar(128)
SELECT @var158 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'RiparianCoverNoCanopy';
IF @var158 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var158 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [RiparianCoverNoCanopy]
DECLARE @var159 nvarchar(128)
SELECT @var159 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'RiparianCoverNonWoody';
IF @var159 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var159 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [RiparianCoverNonWoody]
DECLARE @var160 nvarchar(128)
SELECT @var160 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'RiparianCoverUnderstory';
IF @var160 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var160 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [RiparianCoverUnderstory]
DECLARE @var161 nvarchar(128)
SELECT @var161 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'RiparianCoverWoody';
IF @var161 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var161 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [RiparianCoverWoody]
DECLARE @var162 nvarchar(128)
SELECT @var162 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateLt2mm';
IF @var162 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var162 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [SubstrateLt2mm]
DECLARE @var163 nvarchar(128)
SELECT @var163 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateLt6mm';
IF @var163 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var163 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [SubstrateLt6mm]
DECLARE @var164 nvarchar(128)
SELECT @var164 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateD16';
IF @var164 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var164 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [SubstrateD16]
DECLARE @var165 nvarchar(128)
SELECT @var165 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateD50';
IF @var165 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var165 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [SubstrateD50]
DECLARE @var166 nvarchar(128)
SELECT @var166 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.BiomVisitMetrics_Detail')
AND col_name(parent_object_id, parent_column_id) = 'SubstrateD84';
IF @var166 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP CONSTRAINT [' + @var166 + ']')
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] DROP COLUMN [SubstrateD84]
