-- add two options to Review Item Type on Permits

update fields set possiblevalues = '[{"Id":"CRPP","Label":"CRPP","Group":"Review"},{"Id":"WRP","Label":"WRP","Group":"Review"},{"Id":"BldgCode","Label":"Bldg Code","Group":"Review"},{"Id":"Env","Label":"Env. Health","Group":"Review"},{"Id":"PubWrks","Label":"Pub. Works","Group":"Review"},{"Id":"TERO","Label":"TERO","Group":"Review"},{"Id":"Roads","Label":"County","Group":"Review"},{"Id":"Fire","Label":"Fire Dept.","Group":"Review"},{"Id":"TSRC","Label":"TSRC","Group":"Review"},{"Id":"LPPC Hearing","Label":"LPPC Hearing","Group":"Review"},{"Id":"BOT Resolution","Label":"BOT Resolution","Group":"Review"},{"Id":"SitePlan","Label":"Site Plan","Group":"Document"},{"Id":"OwnerAuth","Label":"Owner Auth","Group":"Document"},{"Id":"Survey","Label":"Survey","Group":"Document"},{"Id":"PhoneCall","Label":"Phone Call","Group":"Correspondence"},{"Id":"Email","Label":"Email","Group":"Correspondence"},{"Id":"InPerson","Label":"In Person","Group":"Correspondence"},{"Id":"Finance","Label":"Finance","Group":"Finance"},{"Id":"Structural/Mechanical","Label":"Structural/Mechanical","Group":"Inspection"},{"Id":"Structural/Mechanical + Plumbing","Label":"Structural/Mechanical + Plumbing","Group":"Inspection"},{"Id":"Electrical","Label":"Electrical","Group":"Inspection"},{"Id":"Final","Label":"Final","Group":"Inspection"},{"Id":"Other","Label":"Other","Group":"Other"}]' 
where datastoreid = 34 and dbcolumnname = 'ItemType';



-- biomonitoring changes ----------------

-- VISIT METRICS

-- remove 2 fields from visit metrics header
alter table BiomVisitMetrics_Header drop column LWVBankfull_FT;
alter table BiomVisitMetrics_Header drop column LWVWetted_SW;

-- add 1 col to detail (note: it is already present as a cdms field/dataset field...)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD LWVWetted_SW [decimal](16, 8)

-- add 2 columns to visit metrics detail (also need cdms fields)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD ChannelPattern [nvarchar](max)
ALTER TABLE [dbo].[BiomVisitMetrics_Detail] ADD ConstrainingFeatureType [nvarchar](max)
go



DECLARE @datastoreid int = 29; --visit metrics
DECLARE @datasetid int = 1277; --visit metrics dataset

CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1530,10) )    

INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, [Rule], FieldRoleId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType , INSERTED.[Rule], INSERTED.FieldRoleId INTO #NewFieldInfo

SELECT   
        Name = 'ChannelPattern',
        Description = 'ChannelPattern',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["One Channel","Braided Channel"]',
        DbColumnName = 'ChannelPattern',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT

        Name = 'ConstrainingFeatureType',
        Description = 'ConstrainingFeatureType',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Hillslope","No Constraining Features","Human Bank Alterations","Terrace"]',
        DbColumnName = 'ConstrainingFeatureType',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2


-- Bulk add the new fields to the dataset -- this will insert a new row for each combination of datasetId and fieldId for the records inserted above
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT
    DatasetId      = @datasetid,
    FieldId        = f.id,
    FieldRoleId    = f.FieldRoleId,
    CreateDateTime = GETDATE(),
    Label          = f.fieldName,
    DbColumnName   = f.DbColumnName,
    Validation     = f.Validation,
    SourceId       = 1,
    InstrumentId   = NULL,
    OrderIndex     = f.OrderIndex ,     -- x10 to make it easier to insert intermediate orders
    ControlType    = f.ControlType,
    [Rule]         = f.[Rule]
FROM #NewFieldInfo as f

drop table #NewFieldInfo
go

-- CHANNEL UNIT METRICS

ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfBrooktrout] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfBulltrout] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfChinook] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfCoho] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfCutthroat] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfLamprey] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfOmykiss] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfOtherSpecies] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfPink] [decimal](16, 8)
ALTER TABLE [dbo].[BiomChannelUnitMetrics_Detail] ADD [DensityOfSockeye] [decimal](16, 8)

ALTER TABLE [dbo].[BiomChannelUnitMetrics_Header] ADD [ProtocolID] [int]

go

-- note: cdms fields are already present in a different datastore (31), just need to copy into Channel Unit (30)
INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, [Rule], FieldRoleId)
select Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, 30, [Rule], FieldRoleId
from fields where dbcolumnname in 
('DensityOfBrooktrout','DensityOfBulltrout','DensityOfChinook','DensityOfCoho','DensityOfCutthroat','DensityOfLamprey','DensityOfOmykiss','DensityOfOtherSpecies','DensityOfPink','DensityOfSockeye','ProtocolID')
and datastoreid = 31

go

-- same with datasetfields - copy from visitmetrics 1277 to channel unit 1278
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT 1278, FieldId, FieldRoleId, getdate(), Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule]
from datasetfields where dbcolumnname in 
('DensityOfBrooktrout','DensityOfBulltrout','DensityOfChinook','DensityOfCoho','DensityOfCutthroat','DensityOfLamprey','DensityOfOmykiss','DensityOfOtherSpecies','DensityOfPink','DensityOfSockeye','ProtocolID')
and datasetid = 1277

go




-- update views

ALTER VIEW BiomTier1Metrics_Header_VW
AS
SELECT h.*
FROM dbo.BiomTier1Metrics_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomTier1Metrics_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))

go


ALTER VIEW BiomTier1Metrics_Detail_VW
AS
SELECT *
FROM dbo.BiomTier1Metrics_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomTier1Metrics_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)

go


ALTER VIEW BiomTier1Metrics_vw
AS
SELECT 
a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, 
h.*,
d.Id AS BiomTier1Metrics_Detail_Id, 
d.Area, 
d.Ct, 
d.UnitSpacing, 
d.Freq, 
d.Vol, 
d.Pct, d.DpthThlwgMaxAvg, d.DpthThlwgExit, d.DpthResid, d.SubEstBldr, d.SubEstCbl, d.SubEstGrvl, d.SubEstSandFines, 
d.FishCovLW, d.FishCovTVeg, d.FishCovUcut, d.FishCovArt, d.FishCovAqVeg, d.FishCovNone, d.FishCovTotal, 
d.CountOfChinook, d.CountOfCoho, d.CountOfSockeye, d.CountOfChum, d.CountOfOmykiss, d.CountOfPink, d.CountOfCutthroat, d.CountOfBulltrout, d.CountOfBrooktrout, d.CountOfLamprey, d.CountOfOtherSpecies, 
d.DensityOfChinook, d.DensityOfCoho, d.DensityOfSockeye, d.DensityOfChum, d.DensityOfOmykiss, d.DensityOfPink, d.DensityOfCutthroat, d.DensityOfBulltrout, d.DensityOfBrooktrout, d.DensityOfLamprey, d.DensityOfOtherSpecies, 
d.RowId, d.RowStatusId,
d.ByUserId AS BiomTier1Metrics_Detail_ByUserId, 
d.QAStatusId, 
d.EffDt AS BiomTier1Metrics_Detail_EffDt,
d.MetricSchemaCanonicalName,
d.SampleID,
d.WettedLWDVolumeStdDev,
d.BankfullLWDVolumeStdDev,
d.TierOneType,
d.LargeWoodyPiecesCount,
d.WettedLargeWoodVolumeByTier1,
d.BankfullLargeWoodVolumeByTier1,
aq.QAStatusId AS ActivityQAStatusId, 
aq.UserId AS ActivityQAUserId, 
aq.Comments, aq.QAStatusName, 
l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.BiomTier1Metrics_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.BiomTier1Metrics_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id

go




ALTER VIEW BiomChannelUnitMetrics_Header_VW
AS
SELECT *
FROM dbo.BiomChannelUnitMetrics_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomChannelUnitMetrics_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))

go

ALTER VIEW BiomChannelUnitMetrics_Detail_VW
AS
SELECT *
FROM dbo.BiomChannelUnitMetrics_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomChannelUnitMetrics_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)

go


ALTER VIEW BiomChannelUnitMetrics_vw
AS
SELECT 
a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, 
h.*, 
d.Id as BiomChannelUnitMetrics_Detail_Id,
d.ChUnitID,
d.AreaTotal,
d.TotalVol,
d.DpthMax,
d.DpthThlwgExit,
d.DpthResid,
d.RowId,
d.RowStatusId,
d.MetricSchemaCanonicalName,
d.SampleID,
d.CountOfBrooktrout,
d.CountOfBulltrout,
d.CountOfChinook,
d.CountOfCoho,
d.CountOfCutthroat,
d.CountOfOmykiss,
d.CountOfOtherSpecies,
d.CountOfPink,
d.CountOfSockeye,
d.CountOfLamprey,
d.LargeWoodyPiecesCount,
d.TierOneType,
d.TierTwoType,
d.ChannelUnitID,
d.DensityOfBrooktrout,
d.DensityOfBulltrout,
d.DensityOfChinook,
d.DensityOfCoho,
d.DensityOfCutthroat,
d.DensityOfLamprey,
d.DensityOfOmykiss,
d.DensityOfOtherSpecies,
d.DensityOfPink,
d.DensityOfSockeye,
aq.QAStatusId AS ActivityQAStatusId, 
aq.UserId AS ActivityQAUserId, 
aq.Comments, aq.QAStatusName, 
l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.BiomChannelUnitMetrics_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.BiomChannelUnitMetrics_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id


go

ALTER VIEW BiomTier2Metrics_Header_VW
AS
SELECT * FROM dbo.BiomTier2Metrics_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomTier2Metrics_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))

go

ALTER VIEW BiomTier2Metrics_Detail_VW
AS
SELECT *
FROM dbo.BiomTier2Metrics_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomTier2Metrics_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)

go

ALTER VIEW BiomTier2Metrics_vw
AS
SELECT 
a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, 
h.*,
d.Id AS BiomTier2Metrics_Detail_Id, d.Tier2, d.Area, d.Ct, d.UnitSpacing, d.Freq, d.Vol, d.Pct, d.DpthThlwgMaxAvg, d.DpthThlwgExit, d.DpthResid, 
d.RowId, d.RowStatusId,
d.ByUserId AS BiomTier2Metrics_Detail_ByUserId, d.QAStatusId, d.EffDt AS BiomTier2Metrics_Detail_EffDt, 
aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.BiomTier2Metrics_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.BiomTier2Metrics_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id

go

ALTER VIEW BiomVisitMetrics_Header_VW
AS
SELECT *
FROM dbo.BiomVisitMetrics_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.BiomVisitMetrics_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))

go


ALTER VIEW BiomVisitMetrics_Detail_VW AS
SELECT        *
FROM            dbo.BiomVisitMetrics_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.BiomVisitMetrics_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)


go

ALTER VIEW dbo.BiomVisitMetrics_vw
AS
SELECT        
a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, 
h.*,
d.Id as BiomVisitMetrics_Detail_Id,
d.BankErosion,
d.BankfullArea,
d.BankfullChannelBraidedness,
d.BankfullChannelCount,
d.BankfullChannelIslandCount,
d.BankfullChannelQualifyingIslandArea,
d.BankfullChannelQualifyingIslandCount,
d.BankfullChannelTotalLength,
d.BankfullDepthAvg,
d.BankfullDepthMax,
d.BankfullMainChannelPartCount,
d.BankfullSideChannelWidth,
d.BankfullSideChannelWidthCV,
d.BankfullSideChannelWidthToDepthRatioAvg,
d.BankfullSideChannelWidthToDepthRatioCV,
d.BankfullSideChannelWidthToMaxDepthRatioAvg,
d.BankfullSideChannelWidthToMaxDepthRatioCV,
d.BankfullSiteLength,
d.BankfullVolume,
d.BankfullWidthAvg,
d.BankfullWidthCV,
d.BankfullWidthIntegrated,
d.BankfullWidthToDepthRatioAvg,
d.BankfullWidthToDepthRatioCV,
d.BankfullWidthToMaxDepthRatioAvg,
d.BankfullWidthToMaxDepthRatioCV,
d.BraidChannelRatio,
d.ConstrainingFeatureHeightAverage,
d.CountOfBrooktrout,
d.CountOfBulltrout,
d.CountOfChinook,
d.CountOfChum,
d.CountOfCoho,
d.CountOfCutthroat,
d.CountOfLamprey,
d.CountOfOmykiss,
d.CountOfOtherSpecies,
d.CountOfPink,
d.CountOfSockeye,
d.DensityOfBrooktrout,
d.DensityOfBulltrout,
d.DensityOfChinook,
d.DensityOfChum,
d.DensityOfCoho,
d.DensityOfCutthroat,
d.DensityOfLamprey,
d.DensityOfOmykiss,
d.DensityOfPink,
d.DensityOfSockeye,
d.DetrendedElevationSD,
d.DriftBiomass,
d.FastNonTurbulentArea,
d.FastNonTurbulentCount,
d.FastNonTurbulentFrequency,
d.FastNonTurbulentPercent,
d.FastNonTurbulentVolume,
d.FastTurbulentArea,
d.FastTurbulentCount,
d.FastTurbulentFrequency,
d.FastTurbulentPercent,
d.FastTurbulentVolume,
d.FishCoverAquaticVegetation,
d.FishCoverArtificial,
d.FishCoverLW,
d.FishCoverNone,
d.FishCoverTerrestrialVegetation,
d.FishCoverTotal,
d.FloodProneWidthAverage,
d.Gradient,
d.LargeWoodFrequencyBankfull,
d.LargeWoodFrequencyWetted,
d.PercentConstrained,
d.PoolToTurbulentAreaRatio,
d.PercentUndercutByArea,
d.PercentUndercutByLength,
d.ResidualPoolDepth,
d.Sinuosity,
d.SinuosityViaCenterline,
d.SlowWaterArea,
d.SlowWaterCount,
d.SlowWaterFrequency,
d.SlowWaterPercent,
d.SlowWaterVolume,
d.SolarAccessSummerAvg,
d.SubstrateEstBoulders,
d.SubstrateEstCoarseAndFineGravel,
d.SubstrateEstCobbles,
d.SubstrateEstSandAndFines,
d.SubstrateEmbeddednessAvg,
d.SubstrateEmbeddednessSD,
d.ThalwegDepthAvg,
d.ThalwegDepthCV,
d.ThalwegSiteLength,
d.TotalUndercutArea,
d.ValleyWidth,
d.WettedArea,
d.WettedChannelBraidedness,
d.WettedChannelCount,
d.WettedChannelIslandCount,
d.WettedChannelMainstemArea,
d.WettedChannelMainstemLength,
d.WettedChannelMainstemSinuosity,
d.WettedChannelQualifyingIslandArea,
d.WettedChannelQualifyingIslandCount,
d.WettedChannelTotalLength,
d.WettedDepthSD,
d.WettedLargeSideChannelArea,
d.WettedMainChannelPartCount,
d.WettedSideChannelPercentByArea,
d.WettedSideChannelWidth,
d.WettedSideChannelWidthCV,
d.WettedSideChannelWidthToDepthRatioAvg,
d.WettedSideChannelWidthToDepthRatioCV,
d.WettedSideChannelWidthToMaxDepthRatioAvg,
d.WettedSideChannelWidthToMaxDepthRatioCV,
d.WettedSiteLength,
d.WettedSmallSideChannelArea,
d.WettedVolume,
d.WettedWidthAvg,
d.WettedWidthCV,
d.WettedWidthIntegrated,
d.WettedWidthToDepthRatioAvg,
d.WettedWidthToDepthRatioCV,
d.WettedWidthToMaxDepthRatioAvg,
d.WettedWidthToMaxDepthRatioCV,
d.RowId,
d.RowStatusId,
d.QAStatusId,
d.MetricSchemaCanonicalName,
d.WettedLWDVolumeStdDev,
d.BankfullLWDVolumeStdDev,
d.WettedLargeWoodVolumeBySite,
d.BankfullLargeWoodVolumeBySite,
d.WettedLargeWoodVolumeInPools,
d.BankfullLargeWoodVolumeInPools,
d.WettedLargeWoodVolumeInFastTurbulent,
d.BankfullLargeWoodVolumeInFastTurbulent,
d.WettedLargeWoodVolumeInFastNonTurbulent,
d.BankfullLargeWoodVolumeInFastNonTurbulent,
d.DensityOfOtherSpecies,
d.LWVBankfull_SW,
d.RiparianPercentGroundCoverNoCover,
d.FastWaterCobbleEmbeddednessAvg,
d.FastWaterCobbleEmbeddednessStdDev,
d.SiteLength,
d.SiteMeasurementOfAlkalinity,
d.LargeWoodyPiecesCountPoolForming,
d.LargeWoodyPiecesCountRightBank,
d.LargeWoodyPiecesCountIsJam,
d.LargeWoodyPiecesCountIsKey,
d.LargeWoodyPiecesCount,
d.LargeWoodyPiecesCountLeftBank,
d.LargeWoodyPiecesCountMidChannel,
d.SiteMeasurementOfConductivity,
d.SiteDischarge,
d.RiparianPercentBigTreeCover,
d.RiparianPercentConiferousCover,
d.RiparianPercentGroundCover,
d.RiparianPercentCanopyNoCover,
d.RiparianPercentNonWoodyGroundCover,
d.RiparianPercentUnderstoryCover,
d.RiparianPercentWoodyCover,
d.PercentOfObservationsLessThan2mm,
d.PercentOfObservationsLessThan6mm,
d.MeasurementOfD16,
d.MeasurementOfD50,
d.MeasurementOfD84,
d.LWVWetted_SW,
d.ChannelPattern,
d.ConstrainingFeatureType,
aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM            dbo.Activities AS a INNER JOIN
                         dbo.BiomVisitMetrics_Header_VW AS h ON a.Id = h.ActivityId LEFT OUTER JOIN
                         dbo.BiomVisitMetrics_Detail_VW AS d ON h.ActivityId = d.ActivityId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id

go

-- ABOVE already run on PALUUT_TEST (12/9)