-- now for ehsViolationCodes
BEGIN TRAN T1;

--set these to what you want
DECLARE @datasetname nvarchar(max) = 'EHS Violation Codes'; 
DECLARE @datasetdesc nvarchar(max) = 'Environmental Health & Safety Violation Codes';
DECLARE @owneruserid int = 1; 
DECLARE @projectid int = 0; 

DECLARE @defaultrowqa int = 1;
DECLARE @defaultactivityqa int = 6;
DECLARE @defaultdatasetstatus int = 1;

DECLARE @datastoreid int = 0;
DECLARE @datasetid int = 0;

-- we'll attach it to an existing project.
set @projectid = (select Id from Projects where Name = 'Environmental Health and Safety');



-- Create the Datastore --excluding tableprefix and locationtypeid b/c not relevant for EHS
INSERT into Datastores (
		Name, 
		[Description], 
		OwnerUserId,
        LocationTypeId,
        DefaultConfig
	) VALUES (
		@datasetname,
		@datasetdesc,
		@owneruserid,
        null,
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
	'{}'
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
        Name = 'Code Section',
        Description = 'Code Section',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = NULL,
        DbColumnName = 'CodeSection',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Code Paragraph',
        Description = 'Code Paragraph',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = NULL,
        DbColumnName = 'CodeParagraph',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Code SubParagraph',
        Description = 'Code SubParagraph',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = NULL,
        DbColumnName = 'CodeSubParagraph',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1


UNION ALL SELECT
        Name = 'Description',
        Description = 'Description',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'Description',
        ControlType = 'textarea',
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
        DbColumnName = 'Comments',
        ControlType = 'textarea',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Attachments',
        Description = 'Files attached to this event',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'Files',
        ControlType = 'file',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1



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


COMMIT TRAN T1;