-- CDMS: add two new fields

-- add columnindex field to datasetfields for grouping fields in the UI
ALTER TABLE [dbo].[DatasetFields] ADD [ColumnIndex] [int]
go

-- add itemid to file for cross-referencing permitnumber and in the future, correspondenceitems, etc.
ALTER TABLE [dbo].[Files] ADD [ItemId] [int]
go

-- Above updated on TEST previously

alter table leases
alter column GrazeStart [nvarchar](max);

alter table leases
alter column GrazeEnd [nvarchar](max);
go

alter table leaserevisions
alter column GrazeStart [nvarchar](max);

alter table leaserevisions
alter column GrazeEnd [nvarchar](max);
go

update leases set GrazeStart=FORMAT(try_convert(Date,GrazeStart),'MM/dd/yyyy');
update leases set GrazeEnd=FORMAT(try_convert(Date,GrazeStart),'MM/dd/yyyy'); 
go

alter table LeaseProductions add GrazingRentalRate [decimal](9, 2);
go

CREATE TABLE [dbo].[Feedbacks] (
    [Id] [int] NOT NULL IDENTITY,
    [Title] [nvarchar](max),
    [Message] [nvarchar](max),
    [Module] [nvarchar](max),
    [SubmitterName] [nvarchar](max),
    [SubmitDate] [datetime] NOT NULL,
    [ResponseMessage] [nvarchar](max),
    [ResponseDate] [datetime],
    [Status] [nvarchar](max),
    CONSTRAINT [PK_dbo.Feedbacks] PRIMARY KEY ([Id])
)

CREATE TABLE [dbo].[NotificationLogs] (
    [Id] [int] NOT NULL IDENTITY,
    [ByUser] [int] NOT NULL,
    [Recipient] [nvarchar](max),
    [Sender] [nvarchar](max),
    [Subject] [nvarchar](max),
    [Body] [nvarchar](max),
    [SentDate] [datetime] NOT NULL,
    [Result] [nvarchar](max),
    CONSTRAINT [PK_dbo.NotificationLogs] PRIMARY KEY ([Id])
)

go

-- above applied to CDMS_TEST - 7/2

alter table LeaseProductions drop column GrazingRentalRate;
alter table Leases add GrazingRentalRate [decimal](9, 2);
alter table LeaseRevisions add GrazingRentalRate [decimal](9, 2);

go

CREATE TABLE [dbo].[PermitRoutes] (
    [Id] [int] NOT NULL IDENTITY,
    [EventType] [nvarchar](max),
    [ItemType] [nvarchar](max),
    [Rank] [int] NOT NULL,
    [Email] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitRoutes] PRIMARY KEY ([Id])
)
go
