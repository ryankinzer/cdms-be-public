CREATE TABLE [dbo].[EHSViolations] (
    [Id] [int] NOT NULL IDENTITY,
    [Name] [nvarchar](max),
    [FileNumber] [nvarchar](max),
    [FileType] [nvarchar](max),
    [CreateDate] [datetime] NOT NULL,
    [Reviewer] [nvarchar](max),
    [ViolationStartDate] [datetime],
    [ViolationResolvedDate] [datetime],
    [ViolationOffenses] [nvarchar](max),
    [ViolationDescription] [nvarchar](max),
    [ViolationStatus] [nvarchar](max),
    [StatusUpdatedBy] [nvarchar](max),
    [StatusUpdateDate] [datetime],
    [Comments] [nvarchar](max),
    [ComplainantName] [nvarchar](max),
    [ComplainantType] [nvarchar](max),
    [ComplainantAddress] [nvarchar](max),
    [ComplainantCity] [nvarchar](max),
    [ComplainantState] [nvarchar](max),
    [ComplainantZip] [nvarchar](max),
    [ComplainantPhone] [nvarchar](max),
    [ComplainantEmail] [nvarchar](max),
    [ComplaintDate] [nvarchar](max),
    [ComplaintDescription] [nvarchar](max),
    [ComplaintReceivedBy] [nvarchar](max),
    [SiteName] [nvarchar](max),
    [SiteAddress] [nvarchar](max),
    [SiteCity] [nvarchar](max),
    [SiteState] [nvarchar](max),
    [SiteZip] [nvarchar](max),
    [NotifyRoutes] [nvarchar](max),
    CONSTRAINT [PK_dbo.EHSViolations] PRIMARY KEY ([Id])
)
CREATE TABLE [dbo].[EHSViolationContacts] (
    [EHSViolationId] [int] NOT NULL,
    [PermitPersonId] [int] NOT NULL,
    [IsPrimary] [bit] NOT NULL,
    [ContactType] [nvarchar](max),
    CONSTRAINT [PK_dbo.EHSViolationContacts] PRIMARY KEY ([EHSViolationId], [PermitPersonId])
)
CREATE INDEX [IX_EHSViolationId] ON [dbo].[EHSViolationContacts]([EHSViolationId])
CREATE INDEX [IX_PermitPersonId] ON [dbo].[EHSViolationContacts]([PermitPersonId])
CREATE TABLE [dbo].[EHSViolationParcels] (
    [Id] [int] NOT NULL IDENTITY,
    [EHSViolationId] [int] NOT NULL,
    [ObjectId] [int],
    [ParcelId] [nvarchar](max),
    [PLSS] [nvarchar](max),
    [CreateDate] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.EHSViolationParcels] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_EHSViolationId] ON [dbo].[EHSViolationParcels]([EHSViolationId])
CREATE INDEX [IX_ObjectId] ON [dbo].[EHSViolationParcels]([ObjectId])
ALTER TABLE [dbo].[EHSViolationContacts] ADD CONSTRAINT [FK_dbo.EHSViolationContacts_dbo.EHSViolations_EHSViolationId] FOREIGN KEY ([EHSViolationId]) REFERENCES [dbo].[EHSViolations] ([Id])
ALTER TABLE [dbo].[EHSViolationContacts] ADD CONSTRAINT [FK_dbo.EHSViolationContacts_dbo.PermitPersons_PermitPersonId] FOREIGN KEY ([PermitPersonId]) REFERENCES [dbo].[PermitPersons] ([Id])
ALTER TABLE [dbo].[EHSViolationParcels] ADD CONSTRAINT [FK_dbo.EHSViolationParcels_dbo.EHSViolations_EHSViolationId] FOREIGN KEY ([EHSViolationId]) REFERENCES [dbo].[EHSViolations] ([Id])

