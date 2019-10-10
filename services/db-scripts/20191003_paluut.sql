-- THIS FILE IS ALREADY RUN ON PALUUT_TEST but not on PALUUT_PROD
-- archive once it is run on test and commit/merge :)


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

-- add rules for fullname concatenation function
DECLARE @datastoreid int = 0;
set @datastoreid = (select Id from Datastores where Name = 'Permit Contacts');

update fields set [Rule] = '{"OnChange": "event.scope.updateFullname();"}' 
where datastoreid = @datastoreid and Name in ('FirstName', 'LastName','Prefix','Suffix')

go
-- update parcel number field label
update fields set Name = 'Parcel Number(s)', Description = 'The parcel number(s) related to this permit.' where datastoreid = 33 and Name = 'Legal Description';
update datasetfields set Label = 'Parcel Number(s)' where datasetid = 1281 and Label = 'Legal Description'

--above ran on test 9/23

-- changes per dani
update datasetfields set orderindex = 27 where datasetid = 1281 and DbColumnName = 'SiteAddress';
update datasetfields set orderindex = 28 where datasetid = 1281 and DbColumnName = 'LegalDescription';
delete from datasetfields where datasetid = 1281 and DbColumnName in ('SiteTownship','SiteRange','SiteSection','SiteQuarter','SiteSixteenth')

go

-- above ran on test 9/26


-- add ReportingLevel to Metrics_Detail (and all Metrics datasets)

ALTER TABLE [dbo].[Metrics_Detail] ADD ReportingLevel nvarchar(max);
go


-- add the field + dataset field to all existing Metrics datasets
DECLARE @metricsdatastoreid int = 0;
DECLARE @fieldid int = 0;

set @metricsdatastoreid = (select Id from Datastores where Name = 'Metrics');

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('ReportingLevel','Reporting Level','Reporting Level for this Metric','select',@metricsdatastoreid,2,null,'string','["Primary","Secondary"]',null);

select @fieldid = scope_identity();

-- add the field to each dataset in Metrics
insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select d.Id as DatasetId, f.Id as FieldId, f.FieldRoleId, getDate(), f.Name, f.DbColumnName, f.ControlType,  null, 1
from datasets d join fields f on f.Id = @fieldid
where d.datastoreid = @metricsdatastoreid

go

-- ABOVE ran on 10/3 on PALUUT_TEST