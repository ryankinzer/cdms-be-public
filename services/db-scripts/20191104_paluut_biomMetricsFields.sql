
-- new fields for visitmetrics

DECLARE @datastoreid int = 29; --visit metrics
DECLARE @datasetid int = 1277; --visit metrics dataset

CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1) )    

INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, [Rule], FieldRoleId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType , INSERTED.[Rule], INSERTED.FieldRoleId INTO #NewFieldInfo

SELECT   
        Name = 'MetricSchemaCanonicalName',
        Description = 'MetricSchemaCanonicalName',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["fish-abundance-per-sample","large-woody-pieces-per-sample","cover-per-sample","pebble-per-sample","reach-per-sample"]',
        DbColumnName = 'MetricSchemaCanonicalName',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'SampleID',
        Description = 'SampleID',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'SampleID',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'WettedLWDVolumeStdDev',
        Description = 'WettedLWDVolumeStdDev',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'WettedLWDVolumeStdDev',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'BankfullLWDVolumeStdDev',
        Description = 'BankfullLWDVolumeStdDev',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'BankfullLWDVolumeStdDev',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'Characteristic',
        Description = 'Name of Characteristic',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'CharacteristicName',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'WettedLargeWoodVolumeBySite',
        Description = 'WettedLargeWoodVolumeBySite',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'WettedLargeWoodVolumeBySite',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'BankfullLargeWoodVolumeBySite',
        Description = 'BankfullLargeWoodVolumeBySite',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'BankfullLargeWoodVolumeBySite',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'BankfullLargeWoodVolumeInPools',
        Description = 'BankfullLargeWoodVolumeInPools',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'BankfullLargeWoodVolumeInPools',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'WettedLargeWoodVolumeInFastTurbulent',
        Description = 'WettedLargeWoodVolumeInFastTurbulent',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'WettedLargeWoodVolumeInFastTurbulent',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'BankfullLargeWoodVolumeInFastTurbulent',
        Description = 'BankfullLargeWoodVolumeInFastTurbulent',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'BankfullLargeWoodVolumeInFastTurbulent',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'WettedLargeWoodVolumeInFastNonTurbulent',
        Description = 'WettedLargeWoodVolumeInFastNonTurbulent',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'WettedLargeWoodVolumeInFastNonTurbulent',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'BankfullLargeWoodVolumeInFastNonTurbulent',
        Description = 'BankfullLargeWoodVolumeInFastNonTurbulent',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'BankfullLargeWoodVolumeInFastNonTurbulent',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'DensityOfOtherSpecies',
        Description = 'DensityOfOtherSpecies',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'DensityOfOtherSpecies',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'LWVBankfull_SW',
        Description = 'LWVBankfull_SW',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'LWVBankfull_SW',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'RiparianPercentGroundCoverNoCover',
        Description = 'RiparianPercentGroundCoverNoCover',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'RiparianPercentGroundCoverNoCover',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'FastWaterCobbleEmbeddednessAvg',
        Description = 'FastWaterCobbleEmbeddednessAvg',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'FastWaterCobbleEmbeddednessAvg',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'FastWaterCobbleEmbeddednessStdDev',
        Description = 'FastWaterCobbleEmbeddednessStdDev',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'FastWaterCobbleEmbeddednessStdDev',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'SiteLength',
        Description = 'SiteLength',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'SiteLength',
        ControlType = 'number',
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
    OrderIndex     = f.OrderIndex * 10,     -- x10 to make it easier to insert intermediate orders
    ControlType    = f.ControlType,
    [Rule]         = f.[Rule]
FROM #NewFieldInfo as f

drop table #NewFieldInfo


-- fields to rename

create table #changedfields(
	fieldFrom	varchar(255),
	fieldTo		varchar(255)
);

insert into #changedfields (fieldTo, fieldFrom) values
('LargeWoodyPiecesCountPoolForming','CountOfPoolFormingLargeWoodyPieces'),
('LargeWoodyPiecesCountIsKey','CountOfKeyLargeWoodyPieces'),
('LargeWoodyPiecesCountIsJam','CountOfJamLargeWoodyPieces'),
('LargeWoodyPiecesCountLeftBank','CountOfLeftBankLargeWoodyPieces'),
('LargeWoodyPiecesCountMidChannel','CountOfMidChannelLargeWoodyPieces'),
('LargeWoodyPiecesCountRightBank','CountOfRightBankLargeWoodyPieces'),
('LargeWoodyPiecesCount','CountOfLargeWoodyPieces'),
('RiparianPercentBigTreeCover','RiparianCoverBigTree'),
('RiparianPercentCanopyNoCover','RiparianCoverNoCanopy'),
('RiparianPercentGroundCover','RiparianCoverGround'),
('RiparianPercentUnderstoryCover','RiparianCoverUnderstory'),
('RiparianPercentUnderstoryNoCover','RiparianCoverNoCanopy'),
('RiparianPercentWoodyCover','RiparianCoverWoody'),
('RiparianPercentNonWoodyGroundCover','RiparianCoverNonWoody'),
('RiparianPercentConiferousCover','RiparianCoverConiferous'),
('MeasurementOfD16','SubstrateD16'),
('MeasurementOfD50','SubstrateD50'),
('MeasurementOfD84','SubstrateD84'),
('BankfullWidthAvg','BankfullWidthAvg'),
('TotalUndercutArea','TotalUndercutArea'),
('SiteDischarge','Discharge'),
('SiteMeasurementOfConductivity','Conductivity'),
('SiteMeasurementOfAlkalinity','Alkalinity'),
('PercentOfObservationsLessThan2mm','SubstrateLt2mm'),
('PercentOfObservationsLessThan6mm','SubstrateLt6mm');


update fields set name = #changedfields.fieldTo, DbColumnName = #changedfields.fieldTo 
from #changedfields
where DbColumnName = #changedfields.fieldFrom and datastoreid = @datastoreid;

update datasetfields set DbColumnName = #changedfields.fieldTo 
from #changedfields
where DbColumnName = #changedfields.fieldFrom and datasetid = @datasetid;

drop table #changedfields;

go

----------------------------------------
------------- now channel unit



DECLARE @datastoreid int = 30; --channel unit
DECLARE @datasetid int = 1278; --channel unit dataset

CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1) )    

INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, [Rule], FieldRoleId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType , INSERTED.[Rule], INSERTED.FieldRoleId INTO #NewFieldInfo

SELECT   
        Name = 'MetricSchemaCanonicalName',
        Description = 'MetricSchemaCanonicalName',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["fish-abundance-per-sample","large-woody-pieces-per-sample","cover-per-sample","pebble-per-sample","reach-per-sample"]',
        DbColumnName = 'MetricSchemaCanonicalName',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'SampleID',
        Description = 'SampleID',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'SampleID',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfBrooktrout',
        Description = 'CountOfBrooktrout',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfBrooktrout',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfBulltrout',
        Description = 'CountOfBulltrout',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfBulltrout',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfChinook',
        Description = 'CountOfChinook',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfChinook',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfCoho',
        Description = 'CountOfCoho',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfCoho',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfCutthroat',
        Description = 'CountOfCutthroat',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfCutthroat',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfLamprey',
        Description = 'CountOfLamprey',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfLamprey',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfOmykiss',
        Description = 'CountOfOmykiss',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfOmykiss',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfOtherSpecies',
        Description = 'CountOfOtherSpecies',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfOtherSpecies',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfPink',
        Description = 'CountOfPink',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfPink',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'CountOfSockeye',
        Description = 'CountOfSockeye',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'CountOfSockeye',
        ControlType = 'number',
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
    OrderIndex     = f.OrderIndex * 10,     -- x10 to make it easier to insert intermediate orders
    ControlType    = f.ControlType,
    [Rule]         = f.[Rule]
FROM #NewFieldInfo as f

drop table #NewFieldInfo

--- rename fields


create table #changedfields(
	fieldFrom	varchar(255),
	fieldTo		varchar(255)
);

insert into #changedfields (fieldTo, fieldFrom) values
('ChannelUnitID','ChUnitNum'),
('TierOneType','Tier1'),
('TierTwoType','Tier2'),
('LargeWoodyPiecesCount','CountOfLWD');

update fields set name = #changedfields.fieldTo, DbColumnName = #changedfields.fieldTo 
from #changedfields
where DbColumnName = #changedfields.fieldFrom and datastoreid = @datastoreid;

update datasetfields set DbColumnName = #changedfields.fieldTo 
from #changedfields
where DbColumnName = #changedfields.fieldFrom and datasetid = @datasetid;

drop table #changedfields;

go

--------------------------------
-- new fields for tierone



DECLARE @datastoreid int = 31; --tier one
DECLARE @datasetid int = 1279; --tier one dataset

CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1) )    

INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, [Rule], FieldRoleId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType , INSERTED.[Rule], INSERTED.FieldRoleId INTO #NewFieldInfo

SELECT   
        Name = 'MetricSchemaCanonicalName',
        Description = 'MetricSchemaCanonicalName',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["fish-abundance-per-sample","large-woody-pieces-per-sample","cover-per-sample","pebble-per-sample","reach-per-sample"]',
        DbColumnName = 'MetricSchemaCanonicalName',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'SampleID',
        Description = 'SampleID',
        Units = NULL,
        Validation = NULL,
        DataType = 'int',
        PossibleValues = null,
        DbColumnName = 'SampleID',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'WettedLWDVolumeStdDev',
        Description = 'WettedLWDVolumeStdDev',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'WettedLWDVolumeStdDev',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'BankfullLWDVolumeStdDev',
        Description = 'BankfullLWDVolumeStdDev',
        Units = NULL,
        Validation = NULL,
        DataType = 'float',
        PossibleValues = null,
        DbColumnName = 'BankfullLWDVolumeStdDev',
        ControlType = 'number',
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
    OrderIndex     = f.OrderIndex * 10,     -- x10 to make it easier to insert intermediate orders
    ControlType    = f.ControlType,
    [Rule]         = f.[Rule]
FROM #NewFieldInfo as f

drop table #NewFieldInfo

-- rename fields


create table #changedfields(
	fieldFrom	varchar(255),
	fieldTo		varchar(255)
);

insert into #changedfields (fieldTo, fieldFrom) values
('TierOneType','Tier1'),
('WettedLargeWoodVolumeByTier1','LWVolWetTier1'),
('BankfullLargeWoodVolumeByTier1','LWVolBfTier1');

update fields set name = #changedfields.fieldTo, DbColumnName = #changedfields.fieldTo 
from #changedfields
where DbColumnName = #changedfields.fieldFrom and datastoreid = @datastoreid;

update datasetfields set DbColumnName = #changedfields.fieldTo 
from #changedfields
where DbColumnName = #changedfields.fieldFrom and datasetid = @datasetid;

drop table #changedfields;

go
