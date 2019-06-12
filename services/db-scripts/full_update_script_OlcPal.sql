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