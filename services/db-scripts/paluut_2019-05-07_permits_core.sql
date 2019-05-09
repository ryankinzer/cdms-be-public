CREATE TABLE [dbo].[Permits] (
    [Id] [int] NOT NULL IDENTITY,
    [AllotmentName] [nvarchar](max),
    [ProjectName] [nvarchar](max),
    [PermitNumber] [nvarchar](max),
    [PermitType] [int],
    [ApplicationDate] [datetime],
    [ImprovementType] [nvarchar](max),
    [IssueDate] [datetime],
    [IssuedBy] [nvarchar](max),
    [ReviewedBy] [nvarchar](max),
    [ExpireDate] [datetime],
    [CloseDate] [datetime],
    [PermitStatus] [nvarchar](max),
    [StatusDate] [datetime],
    [StatusBy] [nvarchar](max),
    [StatusNotes] [nvarchar](max),
    [PermitConditions] [nvarchar](max),
    [PermitFile] [nvarchar](max),
    [Finding] [nvarchar](max),
    [FindingDate] [datetime],
    [Fee] [decimal](18, 2),
    [FeePaymentDate] [datetime],
    [FeePaymentAmount] [decimal](18, 2),
    [FeePaymentType] [nvarchar](max),
    [FeePaymentMethod] [nvarchar](max),
    [FeePaymentReference] [nvarchar](max),
    [FeePaidBy] [nvarchar](max),
    [FeeReceivedBy] [nvarchar](max),
    [Zoning] [nvarchar](max),
    [GISUpdateRequired] [bit],
    [GISUpdateComplete] [bit],
    [Comments] [nvarchar](max),
    [SiteAddress] [nvarchar](max),
    [SquareFeet] [nvarchar](max),
    [SiteCity] [nvarchar](max),
    [SiteState] [nvarchar](max),
    [SiteZip] [nvarchar](max),
    [SiteTownship] [nvarchar](max),
    [SiteRange] [nvarchar](max),
    [SiteSection] [nvarchar](max),
    [SiteQuarter] [nvarchar](max),
    [SiteSixteenth] [nvarchar](max),
    [Valuation] [decimal](18, 2),
    [BuildingUse] [nvarchar](max),
    [LegalDescription] [nvarchar](max),
    [IsVoid] [bit],
    [IsFloodHazardOverlay] [bit],
    [OccupationalGroup] [nvarchar](max),
    [ConstructionType] [nvarchar](max),
    [BusinessName] [nvarchar](max),
    [COStatus] [nvarchar](max),
    [COIssueDate] [datetime],
    [COConditions] [nvarchar](max),
    CONSTRAINT [PK_dbo.Permits] PRIMARY KEY ([Id])
)
CREATE TABLE [dbo].[PermitEvents] (
    [Id] [int] NOT NULL IDENTITY,
    [PermitId] [int] NOT NULL,
    [ByUser] [int] NOT NULL,
    [EventDate] [datetime] NOT NULL,
    [EventType] [nvarchar](max),
    [ItemType] [nvarchar](max),
    [RequestDate] [datetime],
    [ResponseDate] [datetime],
    [Reviewer] [nvarchar](max),
    [Result] [nvarchar](max),
    [Reference] [nvarchar](max),
    [Comments] [nvarchar](max),
    [Files] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitEvents] PRIMARY KEY ([Id])
)
CREATE TABLE [dbo].[PermitPersons] (
    [Id] [int] NOT NULL IDENTITY,
    [Organization] [nvarchar](max),
    [Prefix] [nvarchar](max),
    [FirstName] [nvarchar](max),
    [LastName] [nvarchar](max),
    [Suffix] [nvarchar](max),
    [FullName] [nvarchar](max),
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
    [HomePhone] [nvarchar](max),
    [WorkPhone] [nvarchar](max),
    [CellPhone] [nvarchar](max),
    [Fax] [nvarchar](max),
    [Email] [nvarchar](max),
    [LastUpdated] [datetime],
    [UpdatedBy] [nvarchar](max),
    [Inactive] [bit] NOT NULL,
    CONSTRAINT [PK_dbo.PermitPersons] PRIMARY KEY ([Id])
)
CREATE TABLE [dbo].[PermitTypes] (
    [Id] [int] NOT NULL IDENTITY,
    [Name] [nvarchar](max),
    [Description] [nvarchar](max),
    [PermitTypeStatus] [int] NOT NULL,
    [PermitNumberPrefix] [nvarchar](max),
    [FeeRequired] [float] NOT NULL,
    [TemplateFile] [nvarchar](max),
    [StampRequired] [bit] NOT NULL,
    [InspectionsRequired] [nvarchar](max),
    [ApprovalsRequired] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitTypes] PRIMARY KEY ([Id])
)

--create the fields

DECLARE @newdsid int = 0;
DECLARE @newdatasetid int = 0;
DECLARE @newprojectid int = 0;

INSERT into Datastores (Name, Description, OwnerUserId, DefaultConfig)
values ('Permits', 'Permit fields', 1, '{}');
select @newdsid = scope_identity();


insert into Projects 
	(ProjectTypeId, OrganizationId, Name, Description, CreateDateTime) 
	values 
	(15, 1,'Permit Project','Permit Project',getdate());
select @newprojectid = scope_identity();

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('AllotmentName','Allotment Name','','text',@newdsid,1,null,'string',null,null),                                         --'select-number',@newdsid,1,'select Id, Name as Label from locationtypes','int',null,null),
('ProjectName','Project Name','ProjectName','text',@newdsid,1,null,'string',null,null),
('PermitType','Permit Type','PermitType','select-number',@newdsid,1,'select Id, Name as Label from PermitTypes','int',null,null),
('ApplicationDate','Application Date','ApplicationDate','datetime',@newdsid,1,null,'datetime',null,null),
('ImprovementType','Improvement Type','ImprovementType','select',@newdsid,1,null,'string','["Something"]',null),
('IssueDate','Issue Date','IssueDate','datetime',@newdsid,1,null,'datetime',null,null),
('IssuedBy','Issued By','IssuedBy','text',@newdsid,1,null,'string',null,null),
('ReviewedBy','Reviewed By','ReviewedBy','text',@newdsid,1,null,'string',null,null),
('ExpireDate','Expire Date','ExpireDate','datetime',@newdsid,1,null,'datetime',null,null),
('CloseDate','Close Date','CloseDate','datetime',@newdsid,1,null,'datetime',null,null),
('PermitStatus','Permit Status','PermitStatus','text',@newdsid,1,null,'string',null,null),
('StatusDate','Status Date','StatusDate','datetime',@newdsid,1,null,'datetime',null,null),
('StatusBy','Status By','StatusBy','text',@newdsid,1,null,'string',null,null),
('StatusNotes','Status Notes','StatusNotes','textarea',@newdsid,1,null,'string',null,null),
('PermitConditions','Permit Conditions','PermitConditions','textarea',@newdsid,1,null,'string',null,null),
('PermitFile','Permit File','PermitFile','file',@newdsid,1,null,'file',null,null),
('Finding','Finding','Finding','select',@newdsid,1,null,'string',null,null),
('FindingDate','Finding Date','FindingDate','datetime',@newdsid,1,null,'datetime',null,null),
('Fee','Fee','Fee','number',@newdsid,1,null,'float',null,null),
('FeePaymentDate','Fee Payment Date','FeePaymentDate','datetime',@newdsid,1,null,'datetime',null,null),
('FeePaymentAmount','Fee Payment Amount','FeePaymentAmount','number',@newdsid,1,null,'float',null,null),
('FeePaymentType','Fee Payment Type','FeePaymentType','select',@newdsid,1,null,'string',null,null),
('FeePaymentMethod','Fee Payment Method','FeePaymentMethod','select',@newdsid,1,null,'string',null,null),
('FeePaymentReference','Fee Payment Reference','FeePaymentReference','text',@newdsid,1,null,'string',null,null),
('FeePaidBy','Fee Paid By','FeePaidBy','text',@newdsid,1,null, 'string',null,null),
('FeeReceivedBy','Fee Received By','FeeReceivedBy','text',@newdsid,1,null,'string',null,null),
('Zoning','Zoning','Zoning','text',@newdsid,1,null,'string',null,null),
('GISUpdateRequired','GIS Update Required','GISUpdateRequired','checkbox',@newdsid,1,null,'boolean',null,null),
('GISUpdateComplete','GIS Update Complete','GISUpdateComplete','checkbox',@newdsid,1,null,'boolean',null,null),
('Comments','Comments','Comments','text',@newdsid,1,null,'string',null,null),
('SiteAddress','Site Address','SiteAddress','text',@newdsid,1,null,'string',null,null),
('SquareFeet','Square Feet','SquareFeet','text',@newdsid,1,null,'string',null,null),
('SiteCity','Site City','SiteCity','text',@newdsid,1,null,'string',null,null),
('SiteState','Site State','SiteState','text',@newdsid,1,null,'string',null,null),
('SiteZip','Sit eZip','SiteZip','text',@newdsid,1,null,'string',null,null),
('SiteTownship','Site Township','SiteTownship','text',@newdsid,1,null,'string',null,null),
('SiteRange','Site Range','SiteRange','text',@newdsid,1,null,'string',null,null),
('SiteSection','Site Section','SiteSection','text',@newdsid,1,null,'string',null,null),
('SiteQuarter','Site Quarter','SiteQuarter','text',@newdsid,1,null,'string',null,null),
('SiteSixteenth','Site Sixteenth','SiteSixteenth','text',@newdsid,1,null,'string',null,null),
('Valuation','Valuation','Valuation','text',@newdsid,1,null,'string',null,null),
('BuildingUse','Building Use','BuildingUse','text',@newdsid,1,null,'string',null,null),
('LegalDescription','Legal Description','LegalDescription','text',@newdsid,1,null,'string',null,null),
('IsVoid','Is Void','IsVoid','checkbox',@newdsid,1,null,'boolean',null,null),
('IsFloodHazardOverlay','Is Flood Hazard Overlay','IsFloodHazardOverlay','checkbox',@newdsid,1,null,'boolean',null,null),
('OccupationalGroup','Occupational Group','OccupationalGroup','text',@newdsid,1,null,'string',null,null),
('ConstructionType','Construction Type','ConstructionType','select',@newdsid,1,null,'string',null,null),
('BusinessName','Business Name','BusinessName','text',@newdsid,1,null,'string',null,null),
('COStatus','CO Status','COStatus','text',@newdsid,1,null,'string',null,null),
('COIssueDate','CO Issue Date','COIssueDate','datetime',@newdsid,1,null,'datetime',null,null),
('COConditions','CO Conditions','COConditions','text',@newdsid,1,null,'string',null,null);


insert into datasets 
(ProjectId, DefaultRowQAStatusId, DefaultActivityQAStatusId, StatusId, CreateDateTime, Name, Description, DatastoreId) 
values 
(@newprojectid, 1, 5, 1,getdate(),'Permits','PermitForm',@newdsid );

select @newdatasetid = scope_identity();


insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select
@newdatasetid, Id, FieldRoleId, getDate(), Name, DbColumnName, ControlType, null ,1
FROM Fields where DatastoreId = @newdsid;

go