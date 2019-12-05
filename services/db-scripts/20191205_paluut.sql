-- add two options to Review Item Type 

update fields set possiblevalues = '[{"Id":"CRPP","Label":"CRPP","Group":"Review"},{"Id":"WRP","Label":"WRP","Group":"Review"},{"Id":"BldgCode","Label":"Bldg Code","Group":"Review"},{"Id":"Env","Label":"Env. Health","Group":"Review"},{"Id":"PubWrks","Label":"Pub. Works","Group":"Review"},{"Id":"TERO","Label":"TERO","Group":"Review"},{"Id":"Roads","Label":"County","Group":"Review"},{"Id":"Fire","Label":"Fire Dept.","Group":"Review"},{"Id":"TSRC","Label":"TSRC","Group":"Review"},{"Id":"LPPC Hearing","Label":"LPPC Hearing","Group":"Review"},{"Id":"BOT Resolution","Label":"BOT Resolution","Group":"Review"},{"Id":"SitePlan","Label":"Site Plan","Group":"Document"},{"Id":"OwnerAuth","Label":"Owner Auth","Group":"Document"},{"Id":"Survey","Label":"Survey","Group":"Document"},{"Id":"PhoneCall","Label":"Phone Call","Group":"Correspondence"},{"Id":"Email","Label":"Email","Group":"Correspondence"},{"Id":"InPerson","Label":"In Person","Group":"Correspondence"},{"Id":"Finance","Label":"Finance","Group":"Finance"},{"Id":"Structural/Mechanical","Label":"Structural/Mechanical","Group":"Inspection"},{"Id":"Structural/Mechanical + Plumbing","Label":"Structural/Mechanical + Plumbing","Group":"Inspection"},{"Id":"Electrical","Label":"Electrical","Group":"Inspection"},{"Id":"Final","Label":"Final","Group":"Inspection"},{"Id":"Other","Label":"Other","Group":"Other"}]' 
where datastoreid = 34 and dbcolumnname = 'ItemType';


-- ABOVE already run on PALUUT_TEST 




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





