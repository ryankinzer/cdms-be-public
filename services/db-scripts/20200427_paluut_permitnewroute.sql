-- add Fire as a route

update fields set possiblevalues = '["CRPP","WRP","BldgCode","Env","PubWrks","TERO","Roads", "Fire"]' where dbcolumnname = 'ReviewsRequired' and datastoreid = 33;
alter table Permits add Route_Fire nvarchar(max);

-- add new fields
alter table Permits 
	add MinimumSetbacksMet bit;
alter table Permits 	
	add LegalLotOfRecord bit;
alter table Permits 	
	add UnresolvedViolations bit;


DECLARE @datastoreid int = 33;
DECLARE @datasetid int = 1281;

CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1) )    

INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, [Rule], FieldRoleId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType , INSERTED.[Rule], INSERTED.FieldRoleId INTO #NewFieldInfo

SELECT
        Name = 'Minimum Setbacks Met',
        Description = 'Have the minimum setbacks been met?',
        Units = NULL,
        Validation = NULL,
        DataType = 'boolean',
        PossibleValues = null,
        DbColumnName = 'MinimumSetbacksMet',
        ControlType = 'checkbox',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Legal Lot of Record',
        Description = 'Is this the legal lot of record?',
        Units = NULL,
        Validation = NULL,
        DataType = 'boolean',
        PossibleValues = null,
        DbColumnName = 'LegalLotOfRecord',
        ControlType = 'checkbox',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1

UNION ALL SELECT
        Name = 'Unresolved Violations',
        Description = 'Are there unresolved violations?',
        Units = NULL,
        Validation = NULL,
        DataType = 'boolean',
        PossibleValues = null,
        DbColumnName = 'UnresolvedViolations',
        ControlType = 'checkbox',
        DatastoreId = @datastoreid,
        [Rule] = NULL,
        FieldRoleId = 1


-- Finally, Bulk add the new fields to the dataset -- this will insert a new row for each combination of datasetId and fieldId for the records inserted above
INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule], ColumnIndex)
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
    [Rule]         = f.[Rule],
    ColumnIndex    = 3
FROM #NewFieldInfo as f

drop table #NewFieldInfo

-- set the orderindex
update datasetfields set orderindex = 430 where datasetid = 1281 and DbColumnName = 'UnresolvedViolations';
update datasetfields set orderindex = 440 where datasetid = 1281 and DbColumnName = 'LegalLotOfRecord';
update datasetfields set orderindex = 450 where datasetid = 1281 and DbColumnName = 'MinimumSetbacksMet';
