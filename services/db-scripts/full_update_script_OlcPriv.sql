-- Add the tables
CREATE TABLE [dbo].[Subproject_Olc] (
    [Id] [int] NOT NULL IDENTITY,
    [CatalogNumber] [nvarchar](max),
    [RecordGroup] [nvarchar](max),
    [SeriesTitle] [nvarchar](max),
    [FacilityHoused] [nvarchar](max),
    [Box] [nvarchar](max),
    [BoxLocation] [nvarchar](max),
    [CategoryTitle] [nvarchar](max),
    [CategoryIndex] [nvarchar](max),
    [SignatoryTitle] [nvarchar](max),
    [SignatoryAgency] [nvarchar](max),
    [SignatoryName] [nvarchar](max),
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.Subproject_Olc] PRIMARY KEY ([Id])
)
CREATE TABLE [dbo].[OlcEvents] (
    [Id] [int] NOT NULL IDENTITY,
    [SubprojectId] [int] NOT NULL,
    [DocumentType] [nvarchar](max),
    [DocumentDate] [datetime],
    [FileName] [nvarchar](max),
    [Author] [nvarchar](max),
    [AuthorAgency] [nvarchar](max),
    [Boundary] [nvarchar](max),
    [SignificantArea] [nvarchar](max),
    [MiscelleneousContext] [nvarchar](max),
    [Description] [nvarchar](max),
    [TwnRngSec] [nvarchar](max),
    [NumberItems] [int],
    [DateDiscovered] [datetime],
    [PersonDiscovered] [nvarchar](max),
    [Reference] [nvarchar](max),
    [EventComments] [nvarchar](max),
    [FileAttach] [nvarchar](max),
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.OlcEvents] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_SubprojectId] ON [dbo].[OlcEvents]([SubprojectId])
ALTER TABLE [dbo].[OlcEvents] ADD CONSTRAINT [FK_dbo.OlcEvents_dbo.Subproject_Olc_SubprojectId] FOREIGN KEY ([SubprojectId]) REFERENCES [dbo].[Subproject_Olc] ([Id])
--ALTER TABLE [dbo].[MetadataValues] ADD [SubprojectId] [int]
go

-- Add the views
--drop view OlcEvents_vw
--go
create view OlcEvents_vw
AS
SELECT        e.Id, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.Author, e.AuthorAgency, e.Boundary, e.SignificantArea, e.MiscelleneousContext, e.Description, e.TwnRngSec, e.NumberItems, e.DateDiscovered, 
                         e.PersonDiscovered, e.Reference
FROM            dbo.Subproject_Olc AS sp INNER JOIN
                         dbo.OlcEvents AS e ON sp.Id = e.SubprojectId
go

--Note:  The update above this line has already been put into Prod.
--However, the data part (below) was not put in yet.
--Update field name
ALTER TABLE [dbo].[OlcEvents] ADD [MiscellaneousContext] [nvarchar](max)
DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.OlcEvents')
AND col_name(parent_object_id, parent_column_id) = 'MiscelleneousContext';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[OlcEvents] DROP CONSTRAINT [' + @var0 + ']')
ALTER TABLE [dbo].[OlcEvents] DROP COLUMN [MiscelleneousContext]

--Update the views
drop view OlcEvents_vw
go
create view OlcEvents_vw
AS
SELECT        e.Id, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.Author, e.AuthorAgency, e.Boundary, e.SignificantArea, e.MiscellaneousContext, e.Description, e.TwnRngSec, e.NumberItems, e.DateDiscovered, 
                         e.PersonDiscovered, e.Reference
FROM            dbo.Subproject_Olc AS sp INNER JOIN
                         dbo.OlcEvents AS e ON sp.Id = e.SubprojectId
go

-- Add the data
-- Add the project
declare @datasetBaseName as varchar(max) = 'OLC'
declare @categoryName as varchar(max) = @datasetBaseName
declare @datastoreName as varchar(max) = 'Office of Legal Counsel'

-- If the project DOES NOT already exist
create table #NewProjectIds (id int)

insert into dbo.Projects (ProjectTypeId, OrganizationId, [Name], [Description], OwnerId, CreateDateTime)
output INSERTED.id into #NewProjectIds
values (15, 1, 'Office of Legal Counsel', 'Office of Legal Counsel', 1081, CONVERT(VARCHAR(23), GETDATE(), 121))

-- These are predefined project IDs -- the records for them should already exist
CREATE TABLE #ProjectInfo (id int, name varchar(max))
INSERT INTO #ProjectInfo (id) 
          SELECT id = (select Id from dbo.Projects where [Name] =  'Office of Legal Counsel')

-- Grab the project names
update #ProjectInfo set name = (select name from projects where projects.id = #ProjectInfo.id)

create table #NewLocationTypeIds (id int)

-- Add record to LocationTypes
INSERT into dbo.LocationTypes([Name], [Description])
OUTPUT INSERTED.id into #NewLocationTypeIds
values (@datasetBaseName, @datastoreName)

-- Add records to the Datastores
INSERT INTO dbo.Datastores (Name, Description, TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig) 
SELECT
	Name               = @datastoreName, 
	Description        = NULL, 
	TablePrefix        = @datasetBaseName, --REPLACE(@datastoreName, ' ', ''), -- Strip spaces 
	OwnerUserId        = 1081,      -- George
	LocationTypeId     = lt.id,
	DefaultConfig	   = '{}'
from #NewLocationTypeIds as lt


CREATE TABLE #NewDatasetIds (id int)        -- This will contain a list of ids of all dataset records inserted below

-- Add record to the Datasets --> will create one record per project
INSERT INTO	Datasets (ProjectId, DefaultRowQAStatusId, StatusId, CreateDateTime, Name, Description, DefaultActivityQAStatusId, DatastoreId, Config)
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
    Config                    = '{"ActivitiesPage":{"Route":"olcevents"}}'
FROM #ProjectInfo as p

-- Cleanup
drop table #NewProjectIds
drop table #ProjectInfo
drop table #NewLocationTypeIds
drop table #NewDatasetIds
--drop table #NewFieldInfo
--drop table #QaStatusIds


-- Add the new Metadata entity
insert into dbo.MetadataEntities ([Name], [Description])
values ('OLC', 'Office of Legal Counsel')
go

declare @Entity as int;
set @Entity = (select Id from dbo.MetadataEntities where [Name] = 'OLC');

-- Add the Metadata properties
insert into dbo.MetadataProperties(MetadataEntityId, [Name], [Description], DataType, PossibleValues, ControlType)
values
(@Entity, 'DocumentType', 'Document Type', 'string', '["Correspondence", "Survey", "Federal Acts", "Appropriation", "Book", "Journal", "Report"]', 'select'),
(@Entity, 'Boundary', 'Related to Boundary despute', 'string', '["East", "West", "North","South", "Other"]', 'select'),
(@Entity, 'SignificantArea', 'Significant Area referred to', 'string', '["NW Reservation","NE Reservation","SE Reservation","SW Reservation", "East Reservation","Wildhorse Creek","Lee''s Encampment-Cayuse Summer Camp","Lee''s Encampment-Meacham","McKay Creek","Birch Creek", "West McKay Land Claim", "City of Pendleton-Notch Act"]', 'select'),
(@Entity, 'MiscellaneousContext', 'Other Related Context', 'string', '["Allotments","Timber","Trespass","Agriculture","Theft","Railroad","Road","Complaint","Contracts","Case"]', 'select'),
(@Entity, 'PersonDiscovered', 'Person who discovered the information', 'string', '["Naomi Stacy","Alanna Nanegos","Teara Farrow Ferman"]', 'select'),
(@Entity, 'FacilityHoused', 'Facility the box or file is located in', 'string', '["NGC","TCI","NARA Sandpoint","Other"]', 'select')
go

--Add the reference record.
insert into dbo.Subproject_Olc(CatalogNumber, RecordGroup, SeriesTitle, FacilityHoused, Box, BoxLocation, CategoryTitle, CategoryIndex, SignatoryTitle, SignatoryAgency, SignatoryName, ByUserId, EffDt)
values ('ReferenceRecord', null, null, null, null, null, null, null, null, null, null, 1081, CONVERT(VARCHAR(23), GETDATE(), 121))

--Add Organization for new user.
insert into dbo.Organizations ([Name], [Description]) values ('TCI', 'Tamastslikt Cultural Institute')

declare @intOrgId AS int;
set @intOrgId = (select Id from dbo.Organizations where [Name] = 'TCI');

--Add Department for new user.
insert into dbo.Departments (OrganizationId, [Name], [Description])
values ((select Id from dbo.Organizations where [Name] = 'TCI'),'TCI', 'Tamastslikt Cultural Institute')

declare @intDepId as int;
set @intDepId = (select Id from dbo.Departments where [Name] = 'TCI');

--Add OLC user
insert into dbo.Users(OrganizationId, Username, [Description], LastLogin, DepartmentId, Fullname, Roles)
values(@intOrgId,'BobbieC','TCI Director', (select convert(varchar, getdate(), 121)), @intDepId, 'Bobbie Conner', '["OLC"]')

--Update project owner
update dbo.Projects set OwnerId = 3140 where [Name] = 'Office of Legal Counsel' --Owner is Naomi Stacy

--Add OLC roles to those needing it.
update dbo.Users set [Roles] = '["Admin","DECD","CRPP","WRS","Leasing","LeasingEditor","OLC"]' where Username = 'georgec'
update dbo.Users set [Roles] = '["CRPP","OLC"]' where Username = 'TearaF'
update dbo.Users set [Roles] = '["WRS","OLC"]' where Username = 'AlannaN'
update dbo.Users set [Roles] = '["WRS","OLC"]' where Username = 'NaomiS'
update dbo.Users set [Roles] = '["Admin","DECD","CRPP","Leasing","LeasingEditor","LeaseCropAdmin","OLC"]' where Username = 'colettec'


--Add restriction to project and dataset
--Add Config entry to make the Lookup tables work.
update dbo.Projects set Config = '{"Lookups":[{"Id":11,"Label":"OLC","Type":"Metafields"}],"RestrictRoles":"OLC"}'
where [Name] = 'Office of Legal Counsel' -- This must be a string.

update dbo.Datasets set [Name] = 'Eastern Boundary Research', [Description] = 'Eastern Boundary Research Project', Config = '{"RestrictRoles":["OLC"],"ActivitiesPage":{"Route":"olcevents"}}' where [Name] = 'OLC' -- This must be an array.
-- Entered down to here --

-- Update table properties
ALTER TABLE [dbo].[Subproject_Olc] ADD [Agency] [nvarchar](max)
ALTER TABLE [dbo].[Subproject_Olc] ADD [AgencyLocation] [nvarchar](max)
ALTER TABLE [dbo].[Subproject_Olc] ADD [CategorySubtitle] [nvarchar](max)
ALTER TABLE [dbo].[Subproject_Olc] ADD [OtherFacilityHoused] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [SignatoryTitle] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [SignatoryName] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [AgencyDivision] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [RecipientName] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [RecipientTitle] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [RecipientAgency] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [RecipientLocation] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [SurveyNumber] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [SurveyContractNumber] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [SurveyorName] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [SurveyAuthorizingAgency] [nvarchar](max)
--ALTER TABLE [dbo].[OlcEvents] ADD [SurveyDates] [datetime]
ALTER TABLE [dbo].[OlcEvents] ADD [SurveyDates] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [Tasks] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [OtherBoundary] [nvarchar](max)

--Drop columns
DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Subproject_Olc')
AND col_name(parent_object_id, parent_column_id) = 'CatalogNumber';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Subproject_Olc] DROP CONSTRAINT [' + @var0 + ']')
ALTER TABLE [dbo].[Subproject_Olc] DROP COLUMN [CatalogNumber]

DECLARE @var1 nvarchar(128)
SELECT @var1 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Subproject_Olc')
AND col_name(parent_object_id, parent_column_id) = 'BoxLocation';
IF @var1 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Subproject_Olc] DROP CONSTRAINT [' + @var1 + ']')
ALTER TABLE [dbo].[Subproject_Olc] DROP COLUMN [BoxLocation]

DECLARE @var2 nvarchar(128)
SELECT @var2 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Subproject_Olc')
AND col_name(parent_object_id, parent_column_id) = 'CategoryIndex';
IF @var2 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Subproject_Olc] DROP CONSTRAINT [' + @var2 + ']')
ALTER TABLE [dbo].[Subproject_Olc] DROP COLUMN [CategoryIndex]

DECLARE @var3 nvarchar(128)
SELECT @var3 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Subproject_Olc')
AND col_name(parent_object_id, parent_column_id) = 'SignatoryTitle';
IF @var3 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Subproject_Olc] DROP CONSTRAINT [' + @var3 + ']')
ALTER TABLE [dbo].[Subproject_Olc] DROP COLUMN [SignatoryTitle]

DECLARE @var4 nvarchar(128)
SELECT @var4 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Subproject_Olc')
AND col_name(parent_object_id, parent_column_id) = 'SignatoryAgency';
IF @var4 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Subproject_Olc] DROP CONSTRAINT [' + @var4 + ']')
ALTER TABLE [dbo].[Subproject_Olc] DROP COLUMN [SignatoryAgency]

DECLARE @var5 nvarchar(128)
SELECT @var5 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Subproject_Olc')
AND col_name(parent_object_id, parent_column_id) = 'SignatoryName';
IF @var5 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Subproject_Olc] DROP CONSTRAINT [' + @var5 + ']')
ALTER TABLE [dbo].[Subproject_Olc] DROP COLUMN [SignatoryName]

DECLARE @var6 nvarchar(128)
SELECT @var6 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.OlcEvents')
AND col_name(parent_object_id, parent_column_id) = 'AuthorAgency';
IF @var6 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[OlcEvents] DROP CONSTRAINT [' + @var6 + ']')
ALTER TABLE [dbo].[OlcEvents] DROP COLUMN [AuthorAgency]

DECLARE @var7 nvarchar(128)
SELECT @var7 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.OlcEvents')
AND col_name(parent_object_id, parent_column_id) = 'EventComments';
IF @var7 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[OlcEvents] DROP CONSTRAINT [' + @var7 + ']')
ALTER TABLE [dbo].[OlcEvents] DROP COLUMN [EventComments]
go

-- Update the views
drop view dbo.OlcEvents_vw
go
create view dbo.OlcEvents_vw
AS
SELECT        e.Id, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.Author, e.Boundary, e.SignificantArea, e.MiscellaneousContext, e.Description, e.TwnRngSec, e.NumberItems, e.DateDiscovered, 
                         e.PersonDiscovered, e.Reference, e.FileAttach, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, e.SurveyNumber, e.SurveyContractNumber, e.SurveyorName, e.OtherBoundary,
                         e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks
FROM            dbo.Subproject_Olc AS sp INNER JOIN
                         dbo.OlcEvents AS e ON sp.Id = e.SubprojectId
go

--Update the data
update dbo.MetadataProperties
set PossibleValues = '["East", "West", "North","South", "Other"]'
where MetadataEntityId in (select Id from dbo.MetadataEntities where [Name] = 'OLC') and [Name] = 'Boundary'

update dbo.MetadataProperties
set PossibleValues = '["Allotments","Timber","Trespass","Agriculture","Theft","Railroad","Road","Complaint","Contracts","Case"]'
where MetadataEntityId in (select Id from dbo.MetadataEntities where [Name] = 'OLC') and [Name] = 'MiscellaneousContext'

update dbo.MetadataProperties
set PossibleValues = '["NGC","TCI","NARA Sandpoint","Other"]'
where MetadataEntityId in (select Id from dbo.MetadataEntities where [Name] = 'OLC') and [Name] = 'FacilityHoused'
go

-- Add views for Search page
--drop view Subproject_Olc_Search_VW
--go
create view dbo.Subproject_Olc_Search_VW
AS
SELECT        Id, RecordGroup, SeriesTitle, FacilityHoused, Box, CategoryTitle, Agency, AgencyLocation, CategorySubtitle, OtherFacilityHoused, ByUserId, EffDt
FROM            dbo.Subproject_Olc
go

--drop view dbo.OlcEvents_Search_VW
--go
create view dbo.OlcEvents_Search_VW
AS
SELECT        Id, SubprojectId, DocumentType, DocumentDate, FileName, Author, Boundary, SignificantArea, Description, TwnRngSec, NumberItems, DateDiscovered, PersonDiscovered, Reference, FileAttach, MiscellaneousContext, 
                         SignatoryTitle, SignatoryName, AgencyDivision, RecipientName, RecipientTitle, RecipientAgency, RecipientLocation, SurveyNumber, SurveyContractNumber, SurveyorName, SurveyAuthorizingAgency, SurveyDates, Tasks, 
                         OtherBoundary, ByUserId, EffDt
FROM            dbo.OlcEvents
go

--drop view dbo.OlcSubprojectsAndEvents_vw
--go
create view dbo.OlcSubprojectsAndEvents_vw
AS
SELECT        e.Id AS EventId, e.SubprojectId AS EventSubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.Author, e.Boundary, e.SignificantArea, e.Description, e.TwnRngSec, e.NumberItems, e.DateDiscovered, 
                         e.PersonDiscovered, e.Reference, e.FileAttach, e.MiscellaneousContext, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, e.SurveyNumber, 
                         e.SurveyContractNumber, e.SurveyorName, e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks, e.OtherBoundary, e.ByUserId AS EventByUserId, e.EffDt AS EventEffDt, s.Id AS SubprojectId, s.RecordGroup, s.SeriesTitle, 
                         s.FacilityHoused, s.Box, s.CategoryTitle, s.Agency, s.AgencyLocation, s.CategorySubtitle, s.OtherFacilityHoused, s.ByUserId AS SubprojectByUserId, s.EffDt AS SubprojectEffDt
FROM            dbo.Subproject_Olc_Search_VW AS s LEFT OUTER JOIN
                         dbo.OlcEvents_Search_VW AS e ON s.Id = e.SubprojectId
go

-- Add ArchiveId
ALTER TABLE [dbo].[Subproject_Olc] ADD [SourceArchiveId] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [EventArchiveId] [nvarchar](max)

-- Update views for Search page, adding ArchiveId
drop view dbo.Subproject_Olc_Search_VW
go
create view dbo.Subproject_Olc_Search_VW
AS
SELECT        Id, RecordGroup, SeriesTitle, FacilityHoused, Box, CategoryTitle, Agency, AgencyLocation, CategorySubtitle, OtherFacilityHoused, ByUserId, EffDt, SourceArchiveId
FROM            dbo.Subproject_Olc
go

drop view dbo.OlcEvents_Search_VW
go
create view dbo.OlcEvents_Search_VW
AS
SELECT        Id, SubprojectId, DocumentType, DocumentDate, FileName, Author, Boundary, SignificantArea, Description, TwnRngSec, NumberItems, DateDiscovered, PersonDiscovered, Reference, FileAttach, MiscellaneousContext, 
                         SignatoryTitle, SignatoryName, AgencyDivision, RecipientName, RecipientTitle, RecipientAgency, RecipientLocation, SurveyNumber, SurveyContractNumber, SurveyorName, SurveyAuthorizingAgency, SurveyDates, Tasks, 
                         EventArchiveId, ByUserId, EffDt, OtherBoundary
FROM            dbo.OlcEvents
go

drop view dbo.OlcSubprojectsAndEvents_vw
go
create view dbo.OlcSubprojectsAndEvents_vw
AS
SELECT        e.Id AS EventId, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.Author, e.Boundary, e.SignificantArea, e.Description, e.NumberItems, e.DateDiscovered, e.TwnRngSec, e.PersonDiscovered, e.Reference, 
                         e.FileAttach, e.MiscellaneousContext, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, e.SurveyNumber, e.SurveyContractNumber, 
                         e.SurveyorName, e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks, e.OtherBoundary, e.EventArchiveId, e.ByUserId AS EventByUserId, e.EffDt AS EventEffDt, s.Id, s.RecordGroup, s.SeriesTitle, s.FacilityHoused, s.Box, s.CategoryTitle, 
                         s.Agency, s.AgencyLocation, s.CategorySubtitle, s.OtherFacilityHoused, s.ByUserId AS SubprojectByUserId, s.EffDt AS SubprojectEffDt, s.SourceArchiveId
FROM            dbo.OlcEvents_Search_VW AS e LEFT OUTER JOIN
                         dbo.Subproject_Olc_Search_VW AS s ON e.SubprojectId = s.Id
go
-- Entered down to here 20190710 --

-- Add update/add new properties
sp_RENAME 'dbo.OlcEvents.Author', 'EventAgency', 'COLUMN'
ALTER TABLE [dbo].[OlcEvents] ADD [EventAgencyLocation] [nvarchar](max)
ALTER TABLE [dbo].[OlcEvents] ADD [PageNumber] [nvarchar](max)
go

-- Update the views
drop view dbo.Subproject_Olc_Search_VW
go
create view dbo.Subproject_Olc_Search_VW
AS
SELECT        Id, RecordGroup, SeriesTitle, FacilityHoused, Box, CategoryTitle, Agency, AgencyLocation, FileUnit, OtherFacilityHoused, ByUserId, EffDt, SourceArchiveId
FROM            dbo.Subproject_Olc
go

drop view dbo.OlcSubprojectsAndEvents_vw
go
create view dbo.OlcSubprojectsAndEvents_vw
AS
SELECT        e.Id AS EventId, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.EventAgency, e.Boundary, e.SignificantArea, e.Description, e.NumberItems, e.PageNumber, e.DateDiscovered, e.TwnRngSec, e.PersonDiscovered, e.Reference, 
                         e.FileAttach, e.MiscellaneousContext, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.EventAgencyLocation, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, e.SurveyNumber, e.SurveyContractNumber, 
                         e.SurveyorName, e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks, e.OtherBoundary, e.EventArchiveId, e.ByUserId AS EventByUserId, e.EffDt AS EventEffDt, s.Id, s.RecordGroup, s.SeriesTitle, s.FacilityHoused, s.Box, s.CategoryTitle, 
                         s.Agency, s.AgencyLocation, s.FileUnit, s.OtherFacilityHoused, s.ByUserId AS SubprojectByUserId, s.EffDt AS SubprojectEffDt, s.SourceArchiveId
FROM            dbo.OlcEvents_Search_VW AS e LEFT OUTER JOIN
                         dbo.Subproject_Olc_Search_VW AS s ON e.SubprojectId = s.Id
go

-- Entered down to here 20190712 --

--Update data
update dbo.MetadataProperties
set PossibleValues = '["Correspondence", "Survey", "Federal Acts", "Appropriation", "Book", "Journal", "Report", "Maps"]'
where MetadataEntityId in (select Id from dbo.MetadataEntities where [Name] = 'OLC') and [Name] = 'DocumentType'
go

--Rename column
sp_RENAME 'dbo.Subproject_Olc.CategorySubtitle', 'FileUnit', 'COLUMN'

-- Update views, renaming CatagorySubtitle
drop view dbo.Subproject_Olc_Search_VW
go
create view dbo.Subproject_Olc_Search_VW
AS
SELECT        Id, RecordGroup, SeriesTitle, FacilityHoused, Box, CategoryTitle, Agency, AgencyLocation, FileUnit, OtherFacilityHoused, ByUserId, EffDt, SourceArchiveId
FROM            dbo.Subproject_Olc
go

drop view dbo.OlcSubprojectsAndEvents_vw
go
create view dbo.OlcSubprojectsAndEvents_vw
AS
SELECT        e.Id AS EventId, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.EventAgency, e.Boundary, e.SignificantArea, e.Description, e.NumberItems, e.PageNumber, e.DateDiscovered, e.TwnRngSec, e.PersonDiscovered, e.Reference, 
                         e.FileAttach, e.MiscellaneousContext, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.EventAgencyLocation, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, e.SurveyNumber, e.SurveyContractNumber, 
                         e.SurveyorName, e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks, e.OtherBoundary, e.EventArchiveId, e.ByUserId AS EventByUserId, e.EffDt AS EventEffDt, s.Id, s.RecordGroup, s.SeriesTitle, s.FacilityHoused, s.Box, s.CategoryTitle, 
                         s.Agency, s.AgencyLocation, s.FileUnit, s.OtherFacilityHoused, s.ByUserId AS SubprojectByUserId, s.EffDt AS SubprojectEffDt, s.SourceArchiveId
FROM            dbo.OlcEvents_Search_VW AS e LEFT OUTER JOIN
                         dbo.Subproject_Olc_Search_VW AS s ON e.SubprojectId = s.Id
go


-- Update views to add User FullName for ByUserId
drop view dbo.Subproject_Olc_Search_VW
go
create view dbo.Subproject_Olc_Search_VW
AS
SELECT        sp.Id, sp.RecordGroup, sp.SeriesTitle, sp.FacilityHoused, sp.Box, sp.CategoryTitle, sp.Agency, sp.AgencyLocation, sp.FileUnit, sp.OtherFacilityHoused, sp.ByUserId, sp.EffDt, sp.SourceArchiveId, u.Fullname
FROM            dbo.Subproject_Olc AS sp INNER JOIN
                         dbo.Users AS u ON u.Id = sp.ByUserId
go

drop view dbo.OlcEvents_Search_VW
go
create view dbo.OlcEvents_Search_VW
AS
SELECT        e.Id, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.EventAgency, e.Boundary, e.SignificantArea, e.Description, e.TwnRngSec, e.NumberItems, e.PageNumber, e.DateDiscovered, e.PersonDiscovered, 
                         e.Reference, e.FileAttach, e.MiscellaneousContext, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.EventAgencyLocation, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, e.SurveyNumber, 
                         e.SurveyContractNumber, e.SurveyorName, e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks, e.EventArchiveId, e.ByUserId, e.EffDt, e.OtherBoundary, u.Fullname
FROM            dbo.OlcEvents AS e INNER JOIN
                         dbo.Users AS u ON e.ByUserId = u.Id
go

drop view dbo.OlcSubprojectsAndEvents_vw
go
create view dbo.OlcSubprojectsAndEvents_vw
AS
SELECT        e.Id AS EventId, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.EventAgency, e.Boundary, e.SignificantArea, e.Description, e.NumberItems, e.PageNumber, e.DateDiscovered, e.TwnRngSec, 
                         e.PersonDiscovered, e.Reference, e.FileAttach, e.MiscellaneousContext, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.EventAgencyLocation, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, 
                         e.SurveyNumber, e.SurveyContractNumber, e.SurveyorName, e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks, e.OtherBoundary, e.EventArchiveId, e.ByUserId AS EventByUserId, e.EffDt AS EventEffDt, 
                         e.Fullname AS EventByUserFullName, s.Id, s.RecordGroup, s.SeriesTitle, s.FacilityHoused, s.Box, s.CategoryTitle, s.Agency, s.AgencyLocation, s.FileUnit, s.OtherFacilityHoused, s.ByUserId AS SubprojectByUserId, 
                         s.EffDt AS SubprojectEffDt, s.SourceArchiveId, s.Fullname AS SpByUserFullName
FROM            dbo.OlcEvents_Search_VW AS e LEFT OUTER JOIN
                         dbo.Subproject_Olc_Search_VW AS s ON e.SubprojectId = s.Id
go

sp_RENAME 'dbo.Subproject_Olc.CategoryTitle', 'LitigationCategory', 'COLUMN'

-- Update views to add User FullName for ByUserId
drop view dbo.Subproject_Olc_Search_VW
go
create view dbo.Subproject_Olc_Search_VW
AS
SELECT        sp.Id, sp.RecordGroup, sp.SeriesTitle, sp.FacilityHoused, sp.Box, sp.LitigationCategory, sp.Agency, sp.AgencyLocation, sp.FileUnit, sp.OtherFacilityHoused, sp.ByUserId, sp.EffDt, sp.SourceArchiveId, u.Fullname
FROM            dbo.Subproject_Olc AS sp INNER JOIN
                         dbo.Users AS u ON u.Id = sp.ByUserId
go

drop view dbo.OlcSubprojectsAndEvents_vw
go
create view dbo.OlcSubprojectsAndEvents_vw
AS
SELECT        e.Id AS EventId, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.EventAgency, e.Boundary, e.SignificantArea, e.Description, e.NumberItems, e.PageNumber, e.DateDiscovered, e.TwnRngSec, 
                         e.PersonDiscovered, e.Reference, e.FileAttach, e.MiscellaneousContext, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.EventAgencyLocation, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, 
                         e.SurveyNumber, e.SurveyContractNumber, e.SurveyorName, e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks, e.OtherBoundary, e.EventArchiveId, e.ByUserId AS EventByUserId, e.EffDt AS EventEffDt, 
                         e.Fullname AS EventByUserFullName, s.Id, s.RecordGroup, s.SeriesTitle, s.FacilityHoused, s.Box, s.LitigationCategory, s.Agency, s.AgencyLocation, s.FileUnit, s.OtherFacilityHoused, s.ByUserId AS SubprojectByUserId, 
                         s.EffDt AS SubprojectEffDt, s.SourceArchiveId, s.Fullname AS SpByUserFullName
FROM            dbo.OlcEvents_Search_VW AS e LEFT OUTER JOIN
                         dbo.Subproject_Olc_Search_VW AS s ON e.SubprojectId = s.Id
go

--Update data
update dbo.MetadataProperties
set PossibleValues = '["Correspondence", "Survey", "Federal Acts", "Appropriation", "Book", "Journal", "Report", "Maps", "Case", "Other"]'
where MetadataEntityId in (select Id from dbo.MetadataEntities where [Name] = 'OLC') and [Name] = 'DocumentType'
go