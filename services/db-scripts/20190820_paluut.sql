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

-- above ran on TEST 8/21/2019
-- NOTE: needed to update the ossible values query in the datasource fields above.

DECLARE @newdsid int = 0;
DECLARE @projid int = 0;
DECLARE @fieldid int = 0;
DECLARE @datastoreid int = 0;

set @newdsid = (select Id from Datasets where Name = 'Permit Contacts');
set @projid = (select Id from Projects where Name = 'Permit Project');
set @datastoreid = (select Id from Datastores where Name = 'Permit Contacts');

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('IsMailingDifferent','Is Mailing Different','Is Mailing Different','checkbox',@datastoreid,1,null,'string',null,null);

select @fieldid = scope_identity();

insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select
@newdatasetid, Id, FieldRoleId, getDate(), Name, DbColumnName, ControlType, null ,1
FROM Fields where Id = @fieldid;


UPDATE DatasetFields set OrderIndex = 10, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'Organization';
UPDATE DatasetFields set OrderIndex = 30, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'FirstName';
UPDATE DatasetFields set OrderIndex = 40, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'LastName';
UPDATE DatasetFields set OrderIndex = 60, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'FullName';
UPDATE DatasetFields set OrderIndex = 20, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'Prefix';
UPDATE DatasetFields set OrderIndex = 50, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'Suffix';

UPDATE DatasetFields set OrderIndex = 70, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'PhysicalAddress1';
UPDATE DatasetFields set OrderIndex = 80, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'PhysicalAddress2';
UPDATE DatasetFields set OrderIndex = 90, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'PhysicalCity';
UPDATE DatasetFields set OrderIndex = 100, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'PhysicalState';
UPDATE DatasetFields set OrderIndex = 110, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'PhysicalZip';

UPDATE DatasetFields set OrderIndex = 120, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'MailingAddress1';
UPDATE DatasetFields set OrderIndex = 130, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'MailingAddress2';
UPDATE DatasetFields set OrderIndex = 140, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'MailingCity';
UPDATE DatasetFields set OrderIndex = 150, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'MailingState';
UPDATE DatasetFields set OrderIndex = 160, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'MailingZip';

UPDATE DatasetFields set OrderIndex = 115, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'IsMailingDifferent';
UPDATE DatasetFields set OrderIndex = 170, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'HomePhone';
UPDATE DatasetFields set OrderIndex = 180, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'WorkPhone';
UPDATE DatasetFields set OrderIndex = 190, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'CellPhone';
UPDATE DatasetFields set OrderIndex = 200, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'Fax';
UPDATE DatasetFields set OrderIndex = 210, ColumnIndex = 1 WHERE DatasetId = @newdsid and DbColumnName = 'Email';

update fields set [rule] = '{"OnChange": "event.scope.toggleMailingAddress()"}' where DbColumnName = 'IsMailingDifferent' and DatastoreId = @datastoreid;

update datasetfields set orderindex = 115 where DbColumnName = 'ScopeOfWork' and datasetid = 1281;
delete from datasetfields where datasetid = 1281 and DbColumnName = 'IsVoid'

go

-- above ran on TEST 8/21/2019 to set the field orderindexes

--reorder a column
UPDATE DatasetFields set OrderIndex = 150, ColumnIndex = 1 WHERE DatasetId = 1281 and DbColumnName = 'BuildingUse';

--change plss fields to dropdowns
update fields set controltype = 'select' where datastoreid = 33 and dbcolumnname in ('SiteTownship','SiteRange','SiteSection','SiteQuarter','SiteSixteenth')
update datasetfields set controltype = 'select' where datasetid = 1281 and dbcolumnname in ('SiteTownship','SiteRange','SiteSection','SiteQuarter','SiteSixteenth')

UPDATE fields set possiblevalues = '["1N","1S","2N","2S","3N","3S","4N"]' where dbcolumnname = 'SiteTownship' and datastoreid = 33;
UPDATE fields set possiblevalues = '["32E","33E","34E","35E","36E"]' where dbcolumnname = 'SiteRange' and datastoreid = 33;
UPDATE fields set possiblevalues = '["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36"]' where dbcolumnname = 'SiteSection' and datastoreid = 33;
UPDATE fields set possiblevalues = '["NE","NW","SW","SE"]' where dbcolumnname in ('SiteQuarter','SiteSixteenth') and datastoreid = 33;

go

-- above ran on TEST 8/28/2019

update fields set controltype = 'currency' where datastoreid = 33 and dbcolumnname in( 'Valuation', 'Fee','FeePaymentAmount');
update datasetfields set controltype = 'currency' where datasetid = 1281 and dbcolumnname in ( 'Valuation', 'Fee','FeePaymentAmount');
go

--above ran on TEST 8/29

