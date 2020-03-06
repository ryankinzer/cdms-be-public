
begin TRAN T1;

--set these to what you want
DECLARE @datasetname nvarchar(max) = 'ESPViolations'; -- no spaces!
DECLARE @datasetdesc nvarchar(max) = 'Environmental Health & Safety Violations';
DECLARE @owneruserid int = 1; 
DECLARE @projectid int = 11044; 
DECLARE @locationtypeid int = 0;

DECLARE @defaultrowqa int = 1;
DECLARE @defaultactivityqa int = 6;
DECLARE @defaultdatasetstatus int = 1;

DECLARE @datastoreid int = 0;
DECLARE @datasetid int = 0;

-- Create the Location type
INSERT into LocationTypes (Name, Description)
  values (
	@datasetname,
	concat(@datasetname,' Location Type')
 );

select @locationtypeid = scope_identity();

-- Create the Datastore --excluding tableprefix b/c not relevant for EHS
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
        Name = 'Name',
        Description = 'Project name for the complaint/violation',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'Name',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'File Number',
        Description = 'File number associated with complaint/violation',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'FileNumber',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'File Type',
        Description = 'Type of file',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Complaint","Violation"]',
        DbColumnName = 'FileType',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT   
        Name = 'Create Date',
        Description = 'Date complaint/violation record created',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'CreateDate',
        ControlType = 'date',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT   
        Name = 'Violation Start Date',
        Description = 'Date violation started',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'ViolationStartDate',
        ControlType = 'date',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT   
        Name = 'Violation Resolved Date',
        Description = 'Date violation was resolved',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'ViolationResolvedDate',
        ControlType = 'date',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT   
        Name = 'Status Update Date',
        Description = 'Date status was last updated',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'StatusUpdateDate',
        ControlType = 'date',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Reviewer',
        Description = 'Person assigned to this record',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Replace Me"]',
        DbColumnName = 'Reviewer',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1


UNION ALL SELECT
        Name = 'Violation Offenses',
        Description = 'List of violation offenses',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Junked items","Manure spill","Open dumping","Lead paint","Sewage issue","Other"]',
        DbColumnName = 'ViolationOffenses',
        ControlType = 'multiselect-checkbox',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Violation Description',
        Description = 'Description of violation',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ViolationDescription',
        ControlType = 'textarea',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Violation Status',
        Description = 'Status of violation',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Under investigation","Founded","Unfounded"]',
        DbColumnName = 'ViolationStatus',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Status Updated By',
        Description = 'Last person to update the status',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Replace Me"]',
        DbColumnName = 'StatusUpdatedBy',
        ControlType = 'select',
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
        Name = 'Complainant Name',
        Description = 'Name of complainant',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ComplainantName',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Complainant Address',
        Description = 'Address of complainant',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ComplainantAddress',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Complainant Type',
        Description = 'Type that describes this complainant',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Reservation Resident","CTUIR Employee","Other"]',
        DbColumnName = 'ComplainantType',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Complainant City',
        Description = 'City of complainant',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Pendleton"]',
        DbColumnName = 'ComplainantCity',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Complainant State',
        Description = 'State of complainant',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["OR"]',
        DbColumnName = 'ComplainantState',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Complainant Zip',
        Description = 'Zip of this complainant',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["97801"]',
        DbColumnName = 'ComplainantZip',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Complainant Phone',
        Description = 'Phone number of complainant',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ComplainantPhone',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Complainant Email',
        Description = 'Email of complainant',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ComplainantEmail',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT   
        Name = 'Complaint Date',
        Description = 'Date complaint was received',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'ComplaintDate',
        ControlType = 'date',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1


UNION ALL SELECT
        Name = 'Complaint Description',
        Description = 'Description of complaint',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ComplaintDescription',
        ControlType = 'textarea',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Complaint Received By',
        Description = 'Person who received the complaint',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ComplaintReceivedBy',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1


UNION ALL SELECT
        Name = 'Site Name',
        Description = 'Name of business or site',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'SiteName',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Site Address',
        Description = 'Address of site',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'SiteAddress',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Site City',
        Description = 'City of site',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Pendleton"]',
        DbColumnName = 'SiteCity',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Site State',
        Description = 'State of site',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["OR"]',
        DbColumnName = 'SiteState',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Site Zip',
        Description = 'Zip of this site',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["97801"]',
        DbColumnName = 'SiteZip',
        ControlType = 'select',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Notifications',
        Description = 'Send notifications to parties',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["CRPP","BIA","CRPP","DCFS","Planning","Public Safety","Yellowhawk","Water Resources"]',
        DbColumnName = 'NotifyRoutes',
        ControlType = 'multiselect-checkbox',
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

-- set project's program and sub-program
INSERT INTO MetadataValues (MetadataPropertyId, RelationId, EffDt, [Values], UserId) values (24,@projectid,getdate(), '(None)' ,1);
INSERT INTO MetadataValues (MetadataPropertyId, RelationId, EffDt, [Values], UserId) values (23,@projectid,getdate(), 'Admin' ,1);

COMMIT TRAN T1;