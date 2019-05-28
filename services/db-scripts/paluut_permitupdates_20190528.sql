-- add columnindex field to datasetfields for grouping fields in the UI
ALTER TABLE [dbo].[DatasetFields] ADD [ColumnIndex] [int]

-- add the permitnumber that we somehow missed!
DECLARE @newfieldid int = 0;

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('PermitNumber','Permit Number','Permit Number','text',33,1,null,'string',null,null);

select @newfieldid = scope_identity();

insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) values 
(1281, @newfieldid, 1, getdate(), 'Permit Number','PermitNumber','text',null,1);

