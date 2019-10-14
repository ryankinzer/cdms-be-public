-- THIS FILE IS ALREADY RUN ON PRODUCTION

-- Create bona fide "Contacts" dataset for Permits

DECLARE @newdsid int = 0;
DECLARE @newprojectid int = 0;
DECLARE @newdatasetid int = 0;

set @newprojectid = (select id from projects where name = 'Permit Project');


INSERT into Datastores (Name, Description, OwnerUserId, DefaultConfig)
values ('Permit Contacts', 'Permit contact fields', 1, '{}');
select @newdsid = scope_identity();

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('Organization','Organization','Organization','text',@newdsid,1,null,'string',null,null),
('FirstName','First Name','First Name','text',@newdsid,1,null,'string',null,null),
('LastName','Last Name','Last Name','text',@newdsid,1,null,'string',null,null),
('FullName','Full Name','Full Name','text',@newdsid,1,null,'string',null,null),
('Prefix','Prefix','Prefix','text',@newdsid,1,null,'string',null,null),
('Suffix','Suffix','Suffix','text',@newdsid,1,null,'string',null,null),
('MailingAddress1','Mailing Address1','Mailing Address1','text',@newdsid,1,null,'string',null,null),
('MailingAddress2','Mailing Address2','Mailing Address2','text',@newdsid,1,null,'string',null,null),
('MailingCity','Mailing City','Mailing City','select',@newdsid,1,'select possiblevalues from metadataproperties where id = 80','string',null,null),
('MailingState','Mailing State','Mailing State','select',@newdsid,1,'select possiblevalues from metadataproperties where id = 81','string',null,null),
('MailingZip','Mailing Zip','MailingZip','select',@newdsid,1,'select possiblevalues from metadataproperties where id = 82','string',null,null),
('PhysicalAddress1','Physical Address1','Physical Address1','text',@newdsid,1,null,'string',null,null),
('PhysicalAddress2','Physical Address2','Physical Address2','text',@newdsid,1,null,'string',null,null),
('PhysicalCity','Physical City','Physical City','select',@newdsid,1,'select possiblevalues from metadataproperties where id = 80','string',null,null),
('PhysicalState','Physical State','Physical State','select',@newdsid,1,'select possiblevalues from metadataproperties where id = 81','string',null,null),
('PhysicalZip','Physical Zip','Physical Zip','select',@newdsid,1,'select possiblevalues from metadataproperties where id = 82','string',null,null),
('HomePhone','Home Phone','Home Phone','text',@newdsid,1,null,'string',null,null),
('CellPhone','Cell Phone','Cell Phone','text',@newdsid,1,null,'string',null,null),
('WorkPhone','Work Phone','Work Phone','text',@newdsid,1,null,'string',null,null),
('Fax','Fax','Fax','text',@newdsid,1,null,'string',null,null),
('Email','Email','Email','text',@newdsid,1,null,'string',null,null);


insert into datasets 
(ProjectId, DefaultRowQAStatusId, DefaultActivityQAStatusId, StatusId, CreateDateTime, Name, Description, DatastoreId) 
values 
(@newprojectid, 1, 5, 1,getdate(),'Permit Contacts','Permit Contacts Form',@newdsid );

select @newdatasetid = scope_identity();


insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select
@newdatasetid, Id, FieldRoleId, getDate(), Name, DbColumnName, ControlType, null ,1
FROM Fields where DatastoreId = @newdsid;

go

