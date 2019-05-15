use CDMS_DEV_GEO
go

-- Add the tables
CREATE TABLE [dbo].[Subproject_OLC] (
    [Id] [int] NOT NULL IDENTITY,
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
    [DateDiscovered] [datetime] NOT NULL,
    [PersonDiscovered] [nvarchar](max),
    [Reference] [nvarchar](max),
    [Comments] [nvarchar](max),
    [FileAttach] [nvarchar](max),
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
    CONSTRAINT [PK_dbo.Subproject_OLC] PRIMARY KEY ([Id])
)
CREATE TABLE [dbo].[OLCEvents] (
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
    [Comments] [nvarchar](max),
    [FileAttach] [nvarchar](max),
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.OLCEvents] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_SubprojectId] ON [dbo].[OLCEvents]([SubprojectId])
ALTER TABLE [dbo].[OLCEvents] ADD CONSTRAINT [FK_dbo.OLCEvents_dbo.Subproject_OLC_SubprojectId] FOREIGN KEY ([SubprojectId]) REFERENCES [dbo].[Subproject_OLC] ([Id])
go

-- Add the views
SELECT        dbo.OLCEvents.Id, dbo.OLCEvents.SubprojectId, dbo.OLCEvents.DocumentType, dbo.OLCEvents.DocumentDate, dbo.OLCEvents.FileName, dbo.OLCEvents.Author, dbo.OLCEvents.AuthorAgency, dbo.OLCEvents.Boundary, 
                         dbo.OLCEvents.SignificantArea, dbo.OLCEvents.MiscelleneousContext, dbo.OLCEvents.Description, dbo.OLCEvents.TwnRngSec, dbo.OLCEvents.NumberItems, dbo.OLCEvents.DateDiscovered, 
                         dbo.OLCEvents.PersonDiscovered, dbo.OLCEvents.Reference
FROM            dbo.Subproject_OLC INNER JOIN
                         dbo.OLCEvents ON dbo.Subproject_OLC.Id = dbo.OLCEvents.SubprojectId
go

-- Add the data
-- Add the project
insert into dbo.Projects (ProjectTypeId, OrganizationId, [Name], [Description], CreateDateTime)
values (15, 1, 'Office of Legal Counsel', 'Office of Legal Counsel', CONVERT(VARCHAR(23), GETDATE(), 121))
go

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