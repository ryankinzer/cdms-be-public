use PALUUT_DEV_GEO
GO

-- Add the tables
CREATE TABLE [dbo].[CreelPhone_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [StreamName] [int],
    [Trips] [int],
    [HoursFished] [decimal](18, 2),
    [CreelInterviews] [int],
    [Species] [nvarchar](max),
    [NumberCaught] [int],
    [Disposition] [nvarchar](max),
    [LifeStage] [nvarchar](max),
    [Sex] [nvarchar](max),
    [Origin] [nvarchar](max),
    [MethodCaught] [nvarchar](max),
    [FishComments] [nvarchar](max),
    [RowId] [int] NOT NULL,
    [RowStatusId] [int] NOT NULL,
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [QAStatusId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.CreelPhone_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[CreelPhone_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[CreelPhone_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[CreelPhone_Detail]([QAStatusId])
CREATE TABLE [dbo].[CreelPhone_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [FishermanId] [int] NOT NULL,
    [Fished] [nvarchar](max),
    [InterviewComments] [nvarchar](max),
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.CreelPhone_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[CreelPhone_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[CreelPhone_Header]([ByUserId])
ALTER TABLE [dbo].[CreelPhone_Detail] ADD CONSTRAINT [FK_dbo.CreelPhone_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[CreelPhone_Detail] ADD CONSTRAINT [FK_dbo.CreelPhone_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[CreelPhone_Detail] ADD CONSTRAINT [FK_dbo.CreelPhone_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[CreelPhone_Header] ADD CONSTRAINT [FK_dbo.CreelPhone_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[CreelPhone_Header] ADD CONSTRAINT [FK_dbo.CreelPhone_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
GO


--Add the views
--DROP VIEW CreelPhone_Header_VW
--GO
CREATE VIEW CreelPhone_Header_VW
AS
SELECT Id, FishermanId, Fished, InterviewComments, ActivityId, ByUserId, EffDt
FROM dbo.CreelPhone_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.CreelPhone_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))
GO

--DROP VIEW CreelPhone_Detail_VW
--GO
CREATE VIEW CreelPhone_Detail_VW
AS
SELECT Id, StreamName, Trips, HoursFished, CreelInterviews, Species, NumberCaught, Disposition, LifeStage, Sex, Origin, MethodCaught, FishComments, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt
FROM dbo.CreelPhone_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.CreelPhone_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
GO

--DROP VIEW CreelPhone_vw
--GO
CREATE VIEW CreelPhone_vw
AS
SELECT a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.FishermanId, h.Fished, h.InterviewComments, h.ByUserId, h.EffDt, d.Id AS CreelPhone_Detail_Id, d.StreamName, d.Trips, d.HoursFished, d.CreelInterviews, d.Species, d.NumberCaught, d.Disposition, d.LifeStage, d.Sex, d.Origin, d.MethodCaught, d.FishComments, d.RowId, d.ByUserId AS CreelPhone_Detail_ByUserId, d.QAStatusId, d.EffDt AS CreelPhone_Detail_EffDt, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.CreelPhone_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.CreelPhone_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id 
GO


--Add the data
declare @datasetBaseName as varchar(max) = 'CreelPhone'
declare @categoryName as varchar(max) = @datasetBaseName
declare @datastoreName as varchar(max) = @datasetBaseName

-- These are predefined project IDs -- the records for them should already exist
CREATE TABLE #ProjectInfo (id int, name varchar(max))
INSERT INTO #ProjectInfo (id)
	SELECT id = 1217
-- Grab the project names
update #ProjectInfo set name = (select name from projects where projects.id = #ProjectInfo.id)

create table #NewLocationTypeIds (id int)

-- Add record to LocationTypes
INSERT into dbo.LocationTypes([Name], [Description])
OUTPUT INSERTED.id into #NewLocationTypeIds
values (@datasetBaseName, @datasetBaseName)

-- Add records to the Datastores
INSERT INTO dbo.Datastores (Name, Description, TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig) 
SELECT
	Name               = @datastoreName, 
	Description        = NULL, 
	TablePrefix        = REPLACE(@datastoreName, ' ', ''), -- Strip spaces 
	OwnerUserId        = 1081,      -- George
	LocationTypeId     = lt.id,
	DefaultConfig	   = '{}'
from #NewLocationTypeIds as lt


CREATE TABLE #NewDatasetIds (id int)    -- This will contain a list of ids of all dataset records inserted below

-- Add record to the Datasets --> will create one record per project
INSERT INTO Datasets (ProjectId, DefaultRowQAStatusId, StatusId, CreateDateTime, Name, Description, DefaultActivityQAStatusId, DatastoreId, Config)
OUTPUT INSERTED.id into #NewDatasetIds
SELECT
	ProjectId                 = p.id,
	DefaultRowQAStatusId      = 1,
	StatusId                  = 1,
	CreateDateTime            = GetDate(),
	Name                      = 'Harvest-Phone Interview',
	Description               = 'Harvest Phone Interview',
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
--SELECT
--		Name = 'ContactDate',
--		Description = 'Date the fisherman was called (ActivityDate)',
--		Units = NULL,
--		Validation = NULL,
--		DataType = 'datetime',
--		PossibleValues = NULL,
--		[Rule] = NULL,
--		DbColumnName = 'ContactDate',
--		ControlType = 'datetime',
--		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

--UNION ALL SELECT
SELECT
		Name = 'Fisherman',
		Description = 'Select from fisherman list (lookup from fisherman table)',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishermanId',
		ControlType = 'select-number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Fished',
		Description = 'Did the fisherman fish this season',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Yes","No"]',
		[Rule] = NULL,
		DbColumnName = 'Fished',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'InterviewComments',
		Description = 'General comments about the phone interview',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'InterviewComments',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 1 where FieldRoleId is NULL   -- 1 == header
--update #NewFieldInfo set FieldRoleId = 1 where FieldRoleId = 0   -- 1 == header


--Details Fields

INSERT INTO dbo.Fields(Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'StreamName',
		Description = 'Name of the stream where fishing was done (select from Waterbodies table)',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'StreamName',
		ControlType = 'select-number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Trips',
		Description = 'Number of Trips to the stream',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'Trips',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'HoursFished',
		Description = 'Total hours fished at the stream (round to nearest half hour)',
		Units = NULL,
		Validation = NULL,
		DataType = 'float',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'HoursFished',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'CreelInterviews',
		Description = 'Number of stream side creel interviews the fisherman participated in',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'CreelInterviews',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Species',
		Description = 'Species of fish caught: Fall Chinook (CHF), Spring Chinook (CHS), Summer Steelhead (STS), Bull Trout (BUT), Rainbow Trout (RBT), Pacific Lamprey (PL), Mountain White Fish (MWF), Northern Pike Minnow (NPM), Sucker (SUCKER), Sockeye (SCK)',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["STS","CHF","CHS","CO","BUT","RBT","PL","MWF","SUCKER","NPM","SCK"]',
		[Rule] = NULL,
		DbColumnName = 'Species',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'NumberCaught',
		Description = 'Total number of fish caught',
		Units = NULL,
		Validation = NULL,
		DataType = 'int',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'NumberCaught',
		ControlType = 'number',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Disposition',
		Description = 'Was the fish caught kept or released',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Kept","Released"]',
		[Rule] = NULL,
		DbColumnName = 'Disposition',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'LifeStage',
		Description = 'The approximate age of the fish: Adult (A), Jack (J), Mini Sub-jack(SJ), One salt year (S1), Two salt years (S2), Kelt (K), Unknown (UNK)',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["A","J","SJ","S1","S2","K","UNK"]',
		[Rule] = NULL,
		DbColumnName = 'LifeStage',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Sex',
		Description = 'Sex of the fish',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["Male","Female","Unknown"]',
		[Rule] = NULL,
		DbColumnName = 'Sex',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'Origin',
		Description = 'Does the fish appear to be a Natural or Hatchery or Unknown origin?',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["","HAT","NAT","UNK"]',
		[Rule] = NULL,
		DbColumnName = 'Origin',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'MethodCaught',
		Description = 'Method used to catch the fish.  Hook and Line (HL); Gaff hook (GAFF); Dip net (DN); Hoop net (HN); Spear (SPEAR);',
		Units = NULL,
		Validation = NULL,
		DataType = 'select',
		PossibleValues = '["HL","GAFF","DN","HN","SPEAR"]',
		[Rule] = NULL,
		DbColumnName = 'MethodCaught',
		ControlType = 'select',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))

UNION ALL SELECT
		Name = 'FishComments',
		Description = 'Comments about the fish or the trip',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = NULL,
		[Rule] = NULL,
		DbColumnName = 'FishComments',
		ControlType = 'text',
		DatastoreId = (SELECT IDENT_CURRENT('dbo.Datastores'))


update #NewFieldInfo set FieldRoleId = 2 where FieldRoleId is NULL   -- 2 == details
--update #NewFieldInfo set FieldRoleId = 2 where FieldRoleId = 0   -- 2 == details


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
set @DatasetId = (select Id from dbo.Datasets where [Name] = 'Harvest-Phone Interview'); 

set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and [DbColumnName] = 'ActivityDate'); 

insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Contact Date', 'ActivityDate', null, 1, null, 3, 'activity-date'); 


set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where [Name] like '%ActivitySystem%') and DbColumnName = 'LocationId'); 
insert into DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType) 
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Location', 'LocationId', null, 1, null, 5, 'location-select');


-- Any other adjustments
insert into dbo.LookupTables([Name], Label, [Description], DatasetId)
values('Fishermen', 'Fishermen', 'Fishermen Lookup Table', (select Id from dbo.Datasets where [Name] = 'Harvest-Phone Interview'))

update dbo.Datasets set Config = '{"DataEntryPage": {"HiddenFields": ["Instrument","BulkQaChange"]},"LookupTable":"Fishermen"}'
where [Name] = 'Harvest-Phone Interview'

update dbo.Fields set DataSource = 'select Id, fullname as Label from Fishermen'
where DatastoreId in (select Id from dbo.Datastores where [Name] = 'CreelPhone') and DbColumnName = 'FishermanId'

update dbo.Fields set DataSource = 'SELECT Id, Name as Label from Waterbodies'
where DatastoreId in (select Id from dbo.Datastores where [Name] = 'CreelPhone') and DbColumnName = 'StreamName'

update dbo.Fields set ControlType = 'multiselect'
where DatastoreId in (select Id from dbo.Datastores where [Name] = 'CreelPhone') and DbColumnName = 'MethodCaught'

update dbo.DatasetFields set ControlType = 'multiselect'
where DbColumnName = 'MethodCaught' and DatasetId in (select Id from dbo.Datasets where [Name] = 'Harvest-Phone Interview') 

update dbo.DatasetFields set ControlType = 'hidden' where DatasetId in (select Id from dbo.Datasets where [Name] = 'Harvest-Phone Interview') and DbColumnName = 'LocationId'

update dbo.DatasetFields set ControlType = 'fisherman-select' where DatasetId in (select Id from dbo.Datasets where [Name] = 'Harvest-Phone Interview') and DbColumnName = 'FishermanId'
update dbo.Fields set ControlType = 'fisherman-select' where DatastoreId in (select Id from dbo.Datastores where [Name] = 'CreelPhone' and DbColumnName = 'FishermanId')

--Note:  The update above this line has already been put into Test, and other updates stacked on top of it.
ALTER TABLE [dbo].[CreelPhone_Header] ADD [Season] [int] NOT NULL DEFAULT 0

insert into dbo.Fields ([Name], [Description], DataType, DbColumnName, ControlType, DataSource, DatastoreId)
values ('Season', 'Fishing season year', 'int', 'Season', 'number', null, (select Id from dbo.Datastores where TablePrefix = 'CreelPhone'))

set @FieldId = (select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'CreelPhone') and DbColumnName = 'Season');

insert into dbo.DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, SourceId, InstrumentId, OrderIndex, ControlType)
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Season', 'Season', 1, null, 15, 'number')
GO

--Update CreelPhone views for new property
DROP VIEW CreelPhone_Header_VW
GO
CREATE VIEW CreelPhone_Header_VW
AS
SELECT Id, FishermanId, Fished, InterviewComments, ActivityId, ByUserId, EffDt, Season
FROM dbo.CreelPhone_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.CreelPhone_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))
GO

DROP VIEW CreelPhone_vw
GO
CREATE VIEW CreelPhone_vw
AS
SELECT a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.FishermanId, h.Fished, h.InterviewComments, h.ByUserId, h.EffDt, h.Season, d.Id AS CreelPhone_Detail_Id, d.StreamName, d.Trips, d.HoursFished, d.CreelInterviews, d.Species, d.NumberCaught, d.Disposition, d.LifeStage, d.Sex, d.Origin, d.MethodCaught, d.FishComments, d.RowId, d.ByUserId AS CreelPhone_Detail_ByUserId, d.QAStatusId, d.EffDt AS CreelPhone_Detail_EffDt, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.CreelPhone_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.CreelPhone_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id 
GO

-- Update ProjectId for Harvest Primary Project Location.
update dbo.Locations
set ProjectId = r.Project_Id
from
(
select Location_Id, Project_Id, Id from dbo.LocationProjects lp
inner join dbo.Locations as l on l.Id = lp.Location_Id
where Project_Id in (select Id from dbo.Projects where [Name] = 'Harvest') and LocationTypeId in (select Id from dbo.LocationTypes where [Name] = 'Primary Project Location')
) as r
where dbo.Locations.[Id] = r.Location_Id

-- All the above are on Paluuttest 20190731

-- Adjustments
update dbo.Fields set PossibleValues = '["M","F","UNK"]' where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'CreelPhone') and DbColumnName = 'Sex'
update dbo.Fields set PossibleValues = '["Kept","Released","NC"]' where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'CreelPhone') and DbColumnName = 'Disposition'
update dbo.Fields set PossibleValues = '["HL","GAFF","DN","HN","SPEAR","Fly","Gill"]' where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'CreelPhone') and DbColumnName = 'MethodCaught'
update dbo.Fields set PossibleValues = '["STS","CHF","CHS","CO","BUT","RBT","PL","MWF","SUCKER","NPM","SCK","Other"]' where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'CreelPhone') and DbColumnName = 'Species'

insert into dbo.Fishermen(FirstName, LastName, DateAdded, FullName, StatusId, OkToCallId)
values 
('Jesse', 'Bevis Sr', CONVERT(VARCHAR(23), GETDATE(), 121), 'Jesse Bevis Sr', 0, 0),
('Eugena', 'Stacona', CONVERT(VARCHAR(23), GETDATE(), 121), 'Eugena Stacona', 0, 0)