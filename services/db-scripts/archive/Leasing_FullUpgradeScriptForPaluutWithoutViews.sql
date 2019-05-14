CREATE TABLE [dbo].[Leases] (
    [Id] [int] NOT NULL IDENTITY,
    [AllotmentName] [nvarchar](max),
    [LeaseNumber] [nvarchar](max),
    [FarmNumber] [nvarchar](max),
    [FSATractNumber] [nvarchar](max),
    [LeaseType] [nvarchar](max),
    [NegotiateDate] [datetime],
    [LeaseOperatorId] [int],
    [LeaseAcres] [decimal](9, 3),
    [ProductiveAcres] [decimal](9, 3),
    [LeaseDuration] [nvarchar](max),
    [LeaseStart] [datetime] NOT NULL,
    [LeaseEnd] [datetime],
    [DueDate] [datetime],
    [DollarPerAnnum] [decimal](9, 2),
    [DollarAdvance] [decimal](9, 2),
    [DollarBond] [decimal](9, 2),
    [LeaseFee] [decimal](9, 2),
    [ApprovedDate] [datetime],
    [WithdrawlDate] [datetime],
    [Level] [int],
    [Status] [int],
    [StatusDate] [datetime],
    [StatusBy] [nvarchar](max),
    [ResidueRequiredPct] [int],
    [GreenCoverRequiredPct] [int],
    [ClodRequiredPct] [int],
    [OptionalAlternativeCrop] [bit],
    [GrazeStart] [datetime],
    [GrazeEnd] [datetime],
    [AUMs] [int],
    [GrazeAnimal] [nvarchar](max),
    [Notes] [nvarchar](max),
    [TAAMSNumber] [nvarchar](max),
    CONSTRAINT [PK_dbo.Leases] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_LeaseOperatorId] ON [dbo].[Leases]([LeaseOperatorId])
CREATE TABLE [dbo].[LeaseComplianceActions] (
    [Id] [int] NOT NULL IDENTITY,
    [InspectionId] [int] NOT NULL,
    [LeaseId] [int] NOT NULL,
    [ViolationType] [nvarchar](max),
    [Resolution] [nvarchar](max),
    [FeeAmount] [decimal](18, 2),
    [HoursSpent] [decimal](18, 2),
    CONSTRAINT [PK_dbo.LeaseComplianceActions] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_LeaseId] ON [dbo].[LeaseComplianceActions]([LeaseId])
CREATE TABLE [dbo].[LeaseCropPlans] (
    [Id] [int] NOT NULL IDENTITY,
    [SequenceId] [int] NOT NULL,
    [LeaseId] [int] NOT NULL,
    [LeaseYear] [int] NOT NULL,
    [CropRequirement] [nvarchar](max),
    [OptionAlternateCrop] [bit],
    CONSTRAINT [PK_dbo.LeaseCropPlans] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_LeaseId] ON [dbo].[LeaseCropPlans]([LeaseId])

CREATE TABLE [dbo].[LeaseInspections] (
    [Id] [int] NOT NULL IDENTITY,
    [LeaseId] [int] NOT NULL,
    [CropPlanId] [int] NOT NULL,
    [InspectionType] [nvarchar](max),
    [InspectionDateTime] [datetime],
    [InspectedBy] [nvarchar](max),
    [CropPresent] [nvarchar](max),
    [Weeds1] [nvarchar](max),
    [Weeds2] [nvarchar](max),
    [Weeds3] [nvarchar](max),
    [CropResiduePct] [int],
    [GreenCoverPct] [int],
    [ClodPct] [int],
    [ResidueType] [nvarchar](max),
    [SubstitutePractices] [nvarchar](max),
    [ImprovementTresspass] [nvarchar](max),
    [OutOfCompliance] [bit],
    [Notes] [nvarchar](max),
    CONSTRAINT [PK_dbo.LeaseInspections] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_LeaseId] ON [dbo].[LeaseInspections]([LeaseId])
CREATE TABLE [dbo].[LeaseOperators] (
    [Id] [int] NOT NULL IDENTITY,
    [Organization] [nvarchar](max),
    [Prefix] [nvarchar](max),
    [FirstName] [nvarchar](max),
    [LastName] [nvarchar](max),
    [Suffix] [nvarchar](max),
    [MailingAddress1] [nvarchar](max),
    [MailingAddress2] [nvarchar](max),
    [MailingCity] [nvarchar](max),
    [MailingState] [nvarchar](max),
    [MailingZip] [nvarchar](max),
    [PhysicalAddress1] [nvarchar](max),
    [PhysicalAddress2] [nvarchar](max),
    [PhysicalCity] [nvarchar](max),
    [PhysicalState] [nvarchar](max),
    [PhysicalZip] [nvarchar](max),
    [IsMailingDifferent] [bit],
    [Phone] [nvarchar](max),
    [Cell] [nvarchar](max),
    [Fax] [nvarchar](max),
    [Email] [nvarchar](max),
    [LastUpdated] [datetime],
    [UpdatedBy] [nvarchar](max),
    CONSTRAINT [PK_dbo.LeaseOperators] PRIMARY KEY ([Id])
)
CREATE TABLE [dbo].[LeaseProductions] (
    [Id] [int] NOT NULL IDENTITY,
    [LeaseId] [int] NOT NULL,
    [LeaseYear] [int] NOT NULL,
    [IncomeDate] [datetime],
    [HarvestedCrop] [nvarchar](max),
    [CropType] [nvarchar](max),
    [CropVariety] [nvarchar](max),
    [CropGrade] [nvarchar](max),
    [HarvestDate] [datetime],
    [DeliveryPoint] [nvarchar](max),
    [DeliveryLocation] [nvarchar](max),
    [DeliveryUnit] [nvarchar](max),
    [Gross] [decimal](9, 2),
    [Net] [decimal](9, 2),
    [YieldAcre] [decimal](9, 2),
    [MarketPrice] [decimal](9, 2),
    [MarketUnit] [nvarchar](max),
    [CropShareDollar] [decimal](9, 2),
    [Deduction] [decimal](9, 2),
    [DeductionType] [nvarchar](max),
    [PaymentAmount] [decimal](9, 2),
    [PaymentType] [nvarchar](max),
    [TotalPaymentAmount] [decimal](9, 2),
    CONSTRAINT [PK_dbo.LeaseProductions] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_LeaseId] ON [dbo].[LeaseProductions]([LeaseId])
CREATE TABLE [dbo].[LeaseFieldLeases] (
    [LeaseField_FieldId] [int] NOT NULL,
    [Lease_Id] [int] NOT NULL,
    CONSTRAINT [PK_dbo.LeaseFieldLeases] PRIMARY KEY ([LeaseField_FieldId], [Lease_Id])
)
CREATE INDEX [IX_LeaseField_FieldId] ON [dbo].[LeaseFieldLeases]([LeaseField_FieldId])
CREATE INDEX [IX_Lease_Id] ON [dbo].[LeaseFieldLeases]([Lease_Id])
ALTER TABLE [dbo].[Leases] ADD CONSTRAINT [FK_dbo.Leases_dbo.LeaseOperators_LeaseOperatorId] FOREIGN KEY ([LeaseOperatorId]) REFERENCES [dbo].[LeaseOperators] ([Id])
ALTER TABLE [dbo].[LeaseComplianceActions] ADD CONSTRAINT [FK_dbo.LeaseComplianceActions_dbo.Leases_LeaseId] FOREIGN KEY ([LeaseId]) REFERENCES [dbo].[Leases] ([Id])
ALTER TABLE [dbo].[LeaseCropPlans] ADD CONSTRAINT [FK_dbo.LeaseCropPlans_dbo.Leases_LeaseId] FOREIGN KEY ([LeaseId]) REFERENCES [dbo].[Leases] ([Id])
ALTER TABLE [dbo].[LeaseInspections] ADD CONSTRAINT [FK_dbo.LeaseInspections_dbo.Leases_LeaseId] FOREIGN KEY ([LeaseId]) REFERENCES [dbo].[Leases] ([Id])
ALTER TABLE [dbo].[LeaseProductions] ADD CONSTRAINT [FK_dbo.LeaseProductions_dbo.Leases_LeaseId] FOREIGN KEY ([LeaseId]) REFERENCES [dbo].[Leases] ([Id])
ALTER TABLE [dbo].[LeaseFieldLeases] ADD CONSTRAINT [FK_dbo.LeaseFieldLeases_dbo.Leases_Lease_Id] FOREIGN KEY ([Lease_Id]) REFERENCES [dbo].[Leases] ([Id]) ON DELETE CASCADE

go

IF object_id(N'[dbo].[FK_dbo.LeaseCropPlans_dbo.Leases_LeaseId]', N'F') IS NOT NULL
    ALTER TABLE [dbo].[LeaseCropPlans] DROP CONSTRAINT [FK_dbo.LeaseCropPlans_dbo.Leases_LeaseId]
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_LeaseId' AND object_id = object_id(N'[dbo].[LeaseCropPlans]', N'U'))
    DROP INDEX [IX_LeaseId] ON [dbo].[LeaseCropPlans]
ALTER TABLE [dbo].[LeaseInspections] ADD [LeaseYear] [nvarchar](max)
ALTER TABLE [dbo].[LeaseInspections] ADD [FieldRecordsReceived] [bit]
DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.LeaseInspections')
AND col_name(parent_object_id, parent_column_id) = 'CropPlanId';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[LeaseInspections] DROP CONSTRAINT [' + @var0 + ']')
ALTER TABLE [dbo].[LeaseInspections] DROP COLUMN [CropPlanId]

ALTER TABLE [dbo].[LeaseProductions] ADD [IncomePostedBy] [nvarchar](max)
ALTER TABLE [dbo].[LeaseProductions] ADD [CropAcres] [decimal](9, 2)
ALTER TABLE [dbo].[LeaseProductions] ADD [Comments] [nvarchar](max)

GO

    

ALTER TABLE [dbo].[LeaseOperators] ADD [Inactive] [bit] NOT NULL DEFAULT 0

ALTER TABLE [dbo].[LeaseInspections] ADD [Animals] [nvarchar](max)

CREATE TABLE [dbo].[LeaseRevisions] (
    [Id] [int] NOT NULL IDENTITY,
    [ChangedBy] [nvarchar](max),
    [ChangedReason] [nvarchar](max),
    [ChangedDate] [datetime],
    [LeaseId] [int] NOT NULL,
    [AllotmentName] [nvarchar](max),
    [LeaseNumber] [nvarchar](max),
    [FarmNumber] [nvarchar](max),
    [FSATractNumber] [nvarchar](max),
    [LeaseType] [nvarchar](max),
    [NegotiateDate] [datetime],
    [LeaseOperatorId] [int],
    [LeaseAcres] [decimal](9, 3),
    [ProductiveAcres] [decimal](9, 3),
    [LeaseDuration] [nvarchar](max),
    [LeaseStart] [datetime] NOT NULL,
    [LeaseEnd] [datetime],
    [DueDate] [datetime],
    [DollarPerAnnum] [decimal](9, 2),
    [DollarAdvance] [decimal](9, 2),
    [DollarBond] [decimal](9, 2),
    [LeaseFee] [decimal](9, 2),
    [ApprovedDate] [datetime],
    [WithdrawlDate] [datetime],
    [Level] [int],
    [Status] [int],
    [StatusDate] [datetime],
    [StatusBy] [nvarchar](max),
    [ResidueRequiredPct] [int],
    [GreenCoverRequiredPct] [int],
    [ClodRequiredPct] [int],
    [OptionalAlternativeCrop] [bit],
    [GrazeStart] [datetime],
    [GrazeEnd] [datetime],
    [AUMs] [int],
    [GrazeAnimal] [nvarchar](max),
    [Notes] [nvarchar](max),
    [TAAMSNumber] [nvarchar](max),
    CONSTRAINT [PK_dbo.LeaseRevisions] PRIMARY KEY ([Id])
)
go

ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationIsResolved] [bit] NOT NULL DEFAULT 0
ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationResolution] [nvarchar](max)
ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationFeeCollected] [decimal](9, 2)
ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationDateFeeCollected] [datetime]
ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationFeeCollectedBy] [nvarchar](max)
ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationHoursSpent] [decimal](9, 2)
ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationComments] [nvarchar](max)

ALTER TABLE [dbo].[LeaseCropPlans] ADD [ChangedDate] [datetime]
ALTER TABLE [dbo].[LeaseCropPlans] ADD [ChangedBy] [nvarchar](max)
ALTER TABLE [dbo].[LeaseCropPlans] ADD [ChangedReason] [nvarchar](max)

ALTER TABLE [dbo].[Leases] ADD [UnderInternalReview] [bit]
ALTER TABLE [dbo].[Leases] ADD [InternalReviewStartDate] [datetime]

ALTER TABLE [dbo].[LeaseRevisions] ADD [UnderInternalReview] [bit]
ALTER TABLE [dbo].[LeaseRevisions] ADD [InternalReviewStartDate] [datetime]

ALTER TABLE [dbo].[LeaseRevisions] ADD [TransactionDate] [datetime]
ALTER TABLE [dbo].[Leases] ADD [TransactionDate] [datetime]

go

DECLARE @var1 nvarchar(128)
SELECT @var1 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.LeaseRevisions')
AND col_name(parent_object_id, parent_column_id) = 'DueDate';
IF @var1 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[LeaseRevisions] DROP CONSTRAINT [' + @var1 + ']')
ALTER TABLE [dbo].[LeaseRevisions] ALTER COLUMN [DueDate] [nvarchar](max) NULL
DECLARE @var2 nvarchar(128)
SELECT @var2 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Leases')
AND col_name(parent_object_id, parent_column_id) = 'DueDate';
IF @var2 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Leases] DROP CONSTRAINT [' + @var2 + ']')
ALTER TABLE [dbo].[Leases] ALTER COLUMN [DueDate] [nvarchar](max) NULL

go

CREATE TABLE [dbo].[LeaseCropShares] (
    [Id] [int] NOT NULL IDENTITY,
    [LeaseId] [int] NOT NULL,
    [Crop] [nvarchar](max),
    [CropShareType] [nvarchar](max),
    [CropSharePercent] [decimal](5, 2),
    [CostSharePercent] [decimal](5, 2),
    CONSTRAINT [PK_dbo.LeaseCropShares] PRIMARY KEY ([Id])
)

go

CREATE INDEX [IX_LeaseId] ON [dbo].[LeaseCropShares]([LeaseId])
ALTER TABLE [dbo].[LeaseRevisions] ADD [PaymentDueType] [nvarchar](max)
ALTER TABLE [dbo].[LeaseRevisions] ADD [PaymentDueDescription] [nvarchar](max)
ALTER TABLE [dbo].[LeaseRevisions] ADD [FieldNumber] [int]
ALTER TABLE [dbo].[Leases] ADD [PaymentDueType] [nvarchar](max)
ALTER TABLE [dbo].[Leases] ADD [PaymentDueDescription] [nvarchar](max)
ALTER TABLE [dbo].[Leases] ADD [FieldNumber] [int]
ALTER TABLE [dbo].[LeaseCropShares] ADD CONSTRAINT [FK_dbo.LeaseCropShares_dbo.Leases_LeaseId] FOREIGN KEY ([LeaseId]) REFERENCES [dbo].[Leases] ([Id])

ALTER TABLE [dbo].[LeaseRevisions] ADD [PaymentUnit] [nvarchar](max)
ALTER TABLE [dbo].[Leases] ADD [PaymentUnit] [nvarchar](max)

ALTER TABLE [dbo].[LeaseCropShares] ADD [Comment] [nvarchar](max)

ALTER TABLE [dbo].[Leases] ADD [HEL] [bit]
ALTER TABLE [dbo].[LeaseRevisions] ADD [HEL] [bit]

ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationLandAreaCode] [nvarchar](max)
ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationOwnerType] [nvarchar](max)
ALTER TABLE [dbo].[LeaseInspections] ADD [ViolationType] [nvarchar](max)

go


DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.LeaseRevisions')
AND col_name(parent_object_id, parent_column_id) = 'LeaseStart';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[LeaseRevisions] DROP CONSTRAINT [' + @var0 + ']')
ALTER TABLE [dbo].[LeaseRevisions] ALTER COLUMN [LeaseStart] [datetime] NULL
DECLARE @var1 nvarchar(128)
SELECT @var1 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Leases')
AND col_name(parent_object_id, parent_column_id) = 'LeaseStart';
IF @var1 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Leases] DROP CONSTRAINT [' + @var1 + ']')
ALTER TABLE [dbo].[Leases] ALTER COLUMN [LeaseStart] [datetime] NULL
go


DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.LeaseRevisions')
AND col_name(parent_object_id, parent_column_id) = 'LeaseStart';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[LeaseRevisions] DROP CONSTRAINT [' + @var0 + ']')
ALTER TABLE [dbo].[LeaseRevisions] ALTER COLUMN [LeaseStart] [datetime] NULL
DECLARE @var1 nvarchar(128)
SELECT @var1 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Leases')
AND col_name(parent_object_id, parent_column_id) = 'LeaseStart';
IF @var1 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Leases] DROP CONSTRAINT [' + @var1 + ']')
ALTER TABLE [dbo].[Leases] ALTER COLUMN [LeaseStart] [datetime] NULL

go

