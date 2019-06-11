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
(@Entity, 'MiscelleneousContext', 'Other Related Context', 'string', '["Allotments","Timber","Trespass","Agriculture","Theft","Railroad","Road","Complaint","Contracts"]', 'select'),
(@Entity, 'PersonDiscovered', 'Person who discovered the information', 'string', '["Naomi Stacy", "Malena Pinkham", "Alanna Nanegos", "Teara Farrow Ferman"]', 'select'),
(@Entity, 'FacilityHoused', 'Facility the box or file is located in', 'string', '["NGC","TCI","NARA Sandpoint"]', 'select')
go

--Add the reference record.
insert into dbo.Subproject_Olc(CatalogNumber, RecordGroup, SeriesTitle, FacilityHoused, Box, BoxLocation, CategoryTitle, CategoryIndex, SignatoryTitle, SignatoryAgency, SignatoryName, ByUserId, EffDt)
values ('ReferenceRecord', null, null, null, null, null, null, null, null, null, null, 1081, CONVERT(VARCHAR(23), GETDATE(), 121))

--Add OLC roles to those needing it.
update dbo.Users
set [Roles] = '["Admin","DECD","CRPP","WRS","Leasing","LeasingEditor","OLC"]'
where Username = 'georgec'

--Add restriction to project and dataset
--Add Config entry to make the Lookup tables work.
update dbo.Projects set Config = '{"Lookups":[{"Id":11,"Label":"OLC","Type":"Metafields"}],"RestrictRoles":"OLC"}'
where [Name] = 'Office of Legal Counsel' -- This must be a string.

update dbo.Datasets set Config = '{"RestrictRoles":["OLC"],"ActivitiesPage":{"Route":"olcevents"}}' where [Name] = 'OLC' -- This must be an array.