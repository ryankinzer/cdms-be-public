use CDMS_DEV_GEO
go

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
drop view dbo.OlcEvents_vw
go
create view dbo.OlcEvents_vw
AS
SELECT        e.Id, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.Author, e.AuthorAgency, e.Boundary, e.SignificantArea, e.MiscellaneousContext, e.Description, e.TwnRngSec, e.NumberItems, e.DateDiscovered, 
                         e.PersonDiscovered, e.Reference
FROM            dbo.Subproject_Olc AS sp INNER JOIN
                         dbo.OlcEvents AS e ON sp.Id = e.SubprojectId
go
-- Entered down to here before 20190710 --

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

-- Add views for Search page
--drop view dbo.Subproject_Olc_Search_VW
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

--drop view OlcSubprojectsAndEvents_vw
--go
create view OlcSubprojectsAndEvents_vw
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
drop view dbo.OlcEvents_Search_VW
go
create view dbo.OlcEvents_Search_VW
AS
SELECT        Id, SubprojectId, DocumentType, DocumentDate, FileName, EventAgency, Boundary, SignificantArea, Description, TwnRngSec, NumberItems, PageNumber, DateDiscovered, PersonDiscovered, Reference, FileAttach, 
                         MiscellaneousContext, SignatoryTitle, SignatoryName, AgencyDivision, EventAgencyLocation, RecipientName, RecipientTitle, RecipientAgency, RecipientLocation, SurveyNumber, SurveyContractNumber, SurveyorName, 
                         SurveyAuthorizingAgency, SurveyDates, Tasks, EventArchiveId, ByUserId, EffDt, OtherBoundary
FROM            dbo.OlcEvents
go

drop view dbo.OlcSubprojectsAndEvents_vw
go
create view dbo.OlcSubprojectsAndEvents_vw
AS
SELECT        e.Id AS EventId, e.SubprojectId, e.DocumentType, e.DocumentDate, e.FileName, e.EventAgency, e.Boundary, e.SignificantArea, e.Description, e.NumberItems, e.PageNumber, e.DateDiscovered, e.TwnRngSec, e.PersonDiscovered, e.Reference, 
                         e.FileAttach, e.MiscellaneousContext, e.SignatoryTitle, e.SignatoryName, e.AgencyDivision, e.EventAgencyLocation, e.RecipientName, e.RecipientTitle, e.RecipientAgency, e.RecipientLocation, e.SurveyNumber, e.SurveyContractNumber, 
                         e.SurveyorName, e.SurveyAuthorizingAgency, e.SurveyDates, e.Tasks, e.OtherBoundary, e.EventArchiveId, e.ByUserId AS EventByUserId, e.EffDt AS EventEffDt, s.Id, s.RecordGroup, s.SeriesTitle, s.FacilityHoused, s.Box, s.CategoryTitle, 
                         s.Agency, s.AgencyLocation, s.CategorySubtitle, s.OtherFacilityHoused, s.ByUserId AS SubprojectByUserId, s.EffDt AS SubprojectEffDt, s.SourceArchiveId
FROM            dbo.OlcEvents_Search_VW AS e LEFT OUTER JOIN
                         dbo.Subproject_Olc_Search_VW AS s ON e.SubprojectId = s.Id
go

-- Entered down to here 20190712 --

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