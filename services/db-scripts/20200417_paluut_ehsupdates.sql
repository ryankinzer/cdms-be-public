-- this drops and rebuilds the EHSViolationEvents to the new structure

drop table EHSViolationEvents;
CREATE TABLE [dbo].[EHSViolationEvents] (
    [Id] [int] NOT NULL IDENTITY,
    [EHSViolationId] [int] NOT NULL,
    [ByUser] [int] NOT NULL,
    [CreateDate] [datetime] NOT NULL,
    [EventDate] [datetime] NOT NULL,
    [EventType] [nvarchar](max),
    [EventTypeOther] [nvarchar](max),
    [PropertyStreet] [nvarchar](max),
    [CompletedDate] [datetime],
    [ComplianceDate] [datetime],
    [Comments] [nvarchar](max),
    [Notifications] [nvarchar](max),
    [ViolationType] [nvarchar](max),
	[ViolationTypeOther] [nvarchar](max),
    [Responder] [nvarchar](max),
    [Respondents] [nvarchar](max),
    [OthersPresent] [nvarchar](max),
    [GISImportId] [nvarchar](max),
    [Files] [nvarchar](max),
    CONSTRAINT [PK_dbo.EHSViolationEvents] PRIMARY KEY ([Id])
)	
go

DECLARE @datastoreid int = 0;
DECLARE @datasetid int = 0;

set @datastoreid = (SELECT Id from Datastores WHERE name = 'EHS Violation Events');
set @datasetid = (SELECT Id from Datasets where name = 'EHS Violation Events');

delete from datasetfields where datasetid = @datasetid;
delete from fields where datastoreid = @datastoreid;

-- Create the Field+DatasetFields

CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1) )    

INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, [Rule], FieldRoleId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType , INSERTED.[Rule], INSERTED.FieldRoleId INTO #NewFieldInfo

SELECT
        Name = 'Activity Date',
        Description = 'Date of activity',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'EventDate',
        ControlType = 'date',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Activity Type',
        Description = 'Type of event',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Site Visit","Interview","Email","Phone Call","Document","Court Hearing","Abatement Plan","Other"]',
        DbColumnName = 'EventType',
        ControlType = 'select-group',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Event Type (other)',
        Description = 'Type of event if other (note)',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'EventTypeOther',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT   
        Name = 'Compliance Date',
        Description = 'Date compliance is required/due',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'ComplianceDate',
        ControlType = 'date',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT   
        Name = 'Completed Date',
        Description = 'Date activity was completed',
        Units = NULL,
        Validation = NULL,
        DataType = 'datetime',
        PossibleValues = null,
        DbColumnName = 'CompletedDate',
        ControlType = 'date',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Responder',
        Description = 'Person responsible for this event',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = '["Replace Me"]',
        DbColumnName = 'Responder',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1


UNION ALL SELECT
        Name = 'Respondents',
        Description = 'Person(s) receiving communication or action',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'Respondents',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Others Present',
        Description = 'Other people present',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'OthersPresent',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Violation Type',
        Description = 'Type of violation (note)',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ViolationType',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Violation Type (other)',
        Description = 'Type of violation if other (note)',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'ViolationTypeOther',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Property Street',
        Description = 'Property Street (note)',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'PropertyStreet',
        ControlType = 'text',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Notifications',
        Description = 'Notifications to send (note)',
        Units = NULL,
        Validation = NULL,
        DataType = 'string',
        PossibleValues = null,
        DbColumnName = 'Notifications',
        ControlType = 'text',
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


update fields set DataSource = 'select possiblevalues from metadataproperties where id = 53' where datastoreid = @datastoreid and DbColumnName in ('StatusUpdatedBy');

update fields set possiblevalues = '[{"Id":"Document Served","Label":"Document Served","Group":"Document"},{"Id":"Abatement Plan","Label":"Abatement Plan","Group":"Document"},{"Id":"Citation","Label":"Citation","Group":"Document"},
{"Id":"Notice","Label":"Notice","Group":"Correspondence"},{"Id":"Email","Label":"Email","Group":"Correspondence"},{"Id":"Letter","Label":"Letter","Group":"Correspondence"},{"Id":"Phone Call","Label":"Phone Call","Group":"Correspondence"},
{"Id":"Mail","Label":"Mail","Group":"Correspondence"},{"Id":"Site Visit","Label":"Site Visit","Group":"In Person"},{"Id":"Interview","Label":"Interview","Group":"In Person"},{"Id":"Inspection","Label":"Inspection","Group":"In Person"},
{"Id":"BIA Information","Label":"BIA Information","Group":"Other"},{"Id":"Court Hearing","Label":"Court Hearing","Group":"Other"},{"Id":"Review","Label":"Review","Group":"Other"}]', 
controltype = 'select-group' where datastoreid = @datastoreid and DbColumnName = 'EventType';

update datasetfields set controltype = 'select-group' where datasetid = @datasetid and DbColumnName = 'EventType';