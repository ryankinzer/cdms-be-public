-- create MetStation dataset
-- RAN on test 10/22

CREATE TABLE [dbo].[MetStation_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [CharacteristicName] [nvarchar](max),
    [Result] [decimal](9, 3),
    [ResultUnits] [nvarchar](max),
    [Comments] [nvarchar](max),
    [SampleDate] [datetime],
    [RowId] [int] NOT NULL,
    [RowStatusId] [int] NOT NULL,
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [QAStatusId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.MetStation_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[MetStation_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[MetStation_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[MetStation_Detail]([QAStatusId])
CREATE TABLE [dbo].[MetStation_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [DataType] [nvarchar](max),
    [FieldsheetLink] [nvarchar](max),
    [HeaderComments] [nvarchar](max),
    [DataSource] [nvarchar](max),
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.MetStation_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[MetStation_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[MetStation_Header]([ByUserId])
ALTER TABLE [dbo].[MetStation_Detail] ADD CONSTRAINT [FK_dbo.MetStation_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[MetStation_Detail] ADD CONSTRAINT [FK_dbo.MetStation_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[MetStation_Detail] ADD CONSTRAINT [FK_dbo.MetStation_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[MetStation_Header] ADD CONSTRAINT [FK_dbo.MetStation_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[MetStation_Header] ADD CONSTRAINT [FK_dbo.MetStation_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])

go

begin TRAN T1;

--set these to what you want
DECLARE @datasetname nvarchar(max) = 'MetStation';
DECLARE @datasetdesc nvarchar(max) = 'Meteorological Station Dataset';
DECLARE @owneruserid int = 1; -- TODO: update to amanda
DECLARE @projectid int = 0; 
DECLARE @locationtypeid int = 0;

DECLARE @defaultrowqa int = 1;
DECLARE @defaultactivityqa int = 6;
DECLARE @defaultdatasetstatus int = 1;

DECLARE @datastoreid int = 0;
DECLARE @datasetid int = 0;

INSERT into Projects (Name, Description, ProjectTypeId, OwnerId, OrganizationId, CreateDateTime) 
values (
    'Huckleberry Phenology Project',
    'RAF Huckleberry Phenology Project',
	15,
	@owneruserid,
	1,
	getdate()
);

select @projectid = scope_identity();

INSERT into LocationTypes (Name, Description)
  values (
	@datasetname,
	concat(@datasetname,' Location Type')
 );

select @locationtypeid = scope_identity();

-- Create the Datastore 
INSERT into Datastores (
		Name, 
		[Description], 
		TablePrefix,
		OwnerUserId,
        LocationTypeId,
        DefaultConfig
	) VALUES (
		@datasetname,
		@datasetdesc,
		@datasetname,
		@owneruserid,
        @locationtypeid,
        '{}'
	);

select @datastoreid = scope_identity(); --the id just created

--Create the Dataset
INSERT into Datasets (
	ProjectId,
	DefaultRowQAStatusId,
	StatusId,
	CreateDateTime,
	Name,
	[Description],
	DefaultActivityQAStatusId,
	DatastoreId,
	Config
) VALUES (
	@projectid,
	@defaultrowqa,
	@defaultdatasetstatus,
	GETDATE(),
	@datasetname,
	@datasetdesc,
	@defaultactivityqa,
	@datastoreid,
	'{"SpecifyActivityListFields":true,"ActivityListFields":["DataSource"]}'
);

select @datasetid = scope_identity(); --the id just created

-- add datasetrowqa and datasetactivityqa options
INSERT into DatasetQAStatus1 (
	Dataset_Id,
	QAStatus_Id
) VALUES (
	@datasetid,
	1 --ok
);

INSERT into DatasetQAStatus (
	Dataset_Id,
	QAStatus_Id
) VALUES (
	@datasetid,
	5 --approved
);

INSERT into DatasetQAStatus (
	Dataset_Id,
	QAStatus_Id
) VALUES (
	@datasetid,
	6 --readyforqa
);

-- Create the Field+DatasetFields

CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1) )    

INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, [Rule], FieldRoleId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType , INSERTED.[Rule], INSERTED.FieldRoleId INTO #NewFieldInfo



SELECT   
        Name = 'Data Type',
        Description = 'Type of data',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Satellite Feed","Manual Upload"]',
        DbColumnName = 'DataType',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Data Source',
        Description = 'Source of data',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Station 1","Station 2","Station 3"]',
        DbColumnName = 'DataSource',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Fieldsheet',
        Description = 'Link to fieldsheet',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'FieldsheetLink',
        ControlType = 'file',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Comments',
        Description = 'Comments',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'HeaderComments',
        ControlType = 'textarea',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Characteristic',
        Description = 'Name of Characteristic',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'CharacteristicName',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'Sample Date',
        Description = 'Date and time the sample was collected',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'SampleDate',
        ControlType = 'datetime',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'Result',
        Description = 'Result Value',
        Units = NULL,
        Validation = NULL,
        DataType = 'number',
        PossibleValues = null,
        DbColumnName = 'Result',
        ControlType = 'number',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'Result Units',
        Description = 'Result Value Units',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ResultUnits',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

UNION ALL SELECT
        Name = 'Comments',
        Description = 'Comments',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'Comments',
        ControlType = 'textarea',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 2

-- Add in the activity system fields
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT
    DatasetId       = @datasetid,
    FieldId        = f.Id,
    FieldRoleId    = f.FieldRoleId,
    CreateDateTime = GETDATE(),
    Label          = f.Name,
    DbColumnName   = f.DbColumnName,
    Validation     = f.Validation,
    SourceId       = 1,
    InstrumentId   = NULL,
    OrderIndex     = 1, 
    ControlType    = f.ControlType,
    [Rule]         = f.[Rule]
FROM Fields as f WHERE DatastoreId = 23 AND DbColumnName in ('QAStatus','QAComments','LocationId','QAStatusId');

UPDATE DatasetFields set OrderIndex = 500 WHERE DatasetId = @datasetid AND DbColumnName = 'QAStatus';
UPDATE DatasetFields set OrderIndex = 510 WHERE DatasetId = @datasetid AND DbColumnName = 'QAComments';

-- Finally, Bulk add the new fields to the dataset -- this will insert a new row for each combination of datasetId and fieldId for the records inserted above
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT
    DatasetId      = @datasetid,
    FieldId        = f.id,
    FieldRoleId    = f.FieldRoleId,
    CreateDateTime = GETDATE(),
    Label          = f.fieldName,
    DbColumnName   = f.DbColumnName,
    Validation     = f.Validation,
    SourceId       = 1,
    InstrumentId   = NULL,
    OrderIndex     = f.OrderIndex * 10,     -- x10 to make it easier to insert intermediate orders
    ControlType    = f.ControlType,
    [Rule]         = f.[Rule]
FROM #NewFieldInfo as f

drop table #NewFieldInfo

-- set project's program and sub-program
INSERT INTO MetadataValues (MetadataPropertyId, RelationId, EffDt, [Values], UserId) values (24,@projectid,getdate(), '(None)' ,1);
INSERT INTO MetadataValues (MetadataPropertyId, RelationId, EffDt, [Values], UserId) values (23,@projectid,getdate(), 'RAF' ,1);

COMMIT TRAN T1;