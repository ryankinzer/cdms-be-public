CREATE TABLE [dbo].[PermitViolations] (
    [Id] [int] NOT NULL IDENTITY,
    [Name] [nvarchar](max),
    [FileNumber] [nvarchar](max),
    [FileType] [nvarchar](max),
    [CreateDate] [datetime] NOT NULL,
    [ReviewerId] [int] NOT NULL,
    [ViolationStartDate] [datetime],
    [ViolationResolvedDate] [datetime],
    [ViolationOffenses] [nvarchar](max),
    [ViolationDescription] [nvarchar](max),
    [ViolationStatus] [nvarchar](max),
    [StatusUpdatedBy] [int] NOT NULL,
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
    [ComplaintReceivedBy] [int] NOT NULL,
    [SiteName] [nvarchar](max),
    [SiteAddress] [nvarchar](max),
    [SiteCity] [nvarchar](max),
    [SiteState] [nvarchar](max),
    [SiteZip] [nvarchar](max),
    [NotifyRoutes] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitViolations] PRIMARY KEY ([Id])
)
CREATE TABLE [dbo].[PermitViolationContacts] (
    [PermitViolationId] [int] NOT NULL,
    [PermitPersonId] [int] NOT NULL,
    [IsPrimary] [bit] NOT NULL,
    [ContactType] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitViolationContacts] PRIMARY KEY ([PermitViolationId], [PermitPersonId])
)
CREATE INDEX [IX_PermitViolationId] ON [dbo].[PermitViolationContacts]([PermitViolationId])
CREATE INDEX [IX_PermitPersonId] ON [dbo].[PermitViolationContacts]([PermitPersonId])
CREATE TABLE [dbo].[PermitViolationParcels] (
    [Id] [int] NOT NULL IDENTITY,
    [PermitViolationId] [int] NOT NULL,
    [ObjectId] [int],
    [ParcelId] [nvarchar](max),
    [PLSS] [nvarchar](max),
    [CreateDate] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.PermitViolationParcels] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_PermitViolationId] ON [dbo].[PermitViolationParcels]([PermitViolationId])
CREATE INDEX [IX_ObjectId] ON [dbo].[PermitViolationParcels]([ObjectId])
ALTER TABLE [dbo].[PermitViolationContacts] ADD CONSTRAINT [FK_dbo.PermitViolationContacts_dbo.PermitPersons_PermitPersonId] FOREIGN KEY ([PermitPersonId]) REFERENCES [dbo].[PermitPersons] ([Id])
ALTER TABLE [dbo].[PermitViolationContacts] ADD CONSTRAINT [FK_dbo.PermitViolationContacts_dbo.PermitViolations_PermitViolationId] FOREIGN KEY ([PermitViolationId]) REFERENCES [dbo].[PermitViolations] ([Id])
ALTER TABLE [dbo].[PermitViolationParcels] ADD CONSTRAINT [FK_dbo.PermitViolationParcels_dbo.PermitCadaster_VW_ObjectId] FOREIGN KEY ([ObjectId]) REFERENCES [dbo].[PermitCadaster_VW] ([ObjectId])
ALTER TABLE [dbo].[PermitViolationParcels] ADD CONSTRAINT [FK_dbo.PermitViolationParcels_dbo.PermitViolations_PermitViolationId] FOREIGN KEY ([PermitViolationId]) REFERENCES [dbo].[PermitViolations] ([Id])

