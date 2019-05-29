--this is the full update script that combines all of other update scripts
-- to update CDMS1 to CDMS2


ALTER TABLE [dbo].[Datastores] ADD [LocationTypeId] [nvarchar](max)
go

DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Datastores')
AND col_name(parent_object_id, parent_column_id) = 'DatastoreDatasetId';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Datastores] DROP CONSTRAINT [' + @var0 + ']')

go
ALTER TABLE [dbo].[Datastores] DROP COLUMN [DatastoreDatasetId]
go
-- map the LocationTypeId as it should be
update Datastores set LocationTypeId = 4 WHERE TablePrefix = 'AdultWeir';
update Datastores set LocationTypeId = 113 WHERE TablePrefix = 'BSample';
update Datastores set LocationTypeId = 6 WHERE TablePrefix = 'WaterTemp';
update Datastores set LocationTypeId = 7 WHERE TablePrefix = 'SpawningGroundSurvey';
update Datastores set LocationTypeId = 109 WHERE TablePrefix = 'CreelSurvey';
update Datastores set LocationTypeId = 101 WHERE TablePrefix = 'Electrofishing';
update Datastores set LocationTypeId = 102 WHERE TablePrefix = 'SnorkelFish';
update Datastores set LocationTypeId = 103 WHERE TablePrefix = 'ScrewTrap';
update Datastores set LocationTypeId = 104 WHERE TablePrefix = 'FishScales';
update Datastores set LocationTypeId = 105 WHERE TablePrefix = 'WaterQuality';
update Datastores set LocationTypeId = 106 WHERE TablePrefix = 'StreamNet_RperS';
update Datastores set LocationTypeId = 108 WHERE TablePrefix = 'StreamNet_SAR';
update Datastores set LocationTypeId = 107 WHERE TablePrefix = 'StreamNet_NOSA';
update Datastores set LocationTypeId = 110 WHERE TablePrefix = 'ArtificialProduction';
update Datastores set LocationTypeId = 111 WHERE TablePrefix = 'CrppContracts';
update Datastores set LocationTypeId = 112 WHERE TablePrefix = 'Metrics';
update Datastores set LocationTypeId = 114 WHERE TablePrefix = 'JvRearing';
update Datastores set LocationTypeId = 115 WHERE TablePrefix = 'Genetic';
update Datastores set LocationTypeId = 116 WHERE TablePrefix = 'Benthic';
update Datastores set LocationTypeId = 117 WHERE TablePrefix = 'Drift';
update Datastores set LocationTypeId = 118 WHERE TablePrefix = 'FishTransport';
update Datastores set LocationTypeId = 8 WHERE TablePrefix = 'Appraisal';
update Datastores set LocationTypeId = 3 WHERE TablePrefix = 'CRPP';
update Datastores set LocationTypeId = 112 WHERE TablePrefix = 'Hab';

go

create view LastUpdatedDatasets_VW as 
select a.DatasetId, a.UserId, u.Fullname, d.ProjectId, d.DatastoreId, a.CreateDate, convert(varchar, a.CreateDate, 100) as LastUpdated, d.Name as DatasetName, p.Name as ProjectName
from activities a
join datasets d on d.id = a.datasetid
join projects p on p.id = d.projectid
join users u on a.userId = u.Id
where a.createdate = (select max(aa.createdate) from activities aa where aa.userid=a.userid and aa.datasetid = a.datasetid)

go

-- this is just for CTUIR CDMS - our water temp rules were broken
update fields set [Rule] = '{"OnChange":"activities.errors = undefined; removeRowErrorsBeforeRecheck(); checkForDuplicates();"}' where id = 1065;
update datasetfields set [Rule] = '{"OnChange":"activities.errors = undefined; removeRowErrorsBeforeRecheck(); checkForDuplicates();"}'
where id in (1241, 4468, 4518, 4541, 4615);
go
update datasetfields set [Rule] = null where [rule] like '%activities.errors%' and DbColumnName = 'ReadingDateTime';
update fields set [Rule] = null where [rule] like '%activities.errors%' and DbColumnName = 'ReadingDateTime';
go

-- this adds a field to our creel dataset for fisherman to work with the datasource lookup
insert into datasetfields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, SourceId, OrderIndex, ControlType,InstrumentId)
values (1230, 1507,2,getdate(),'Fisherman','FishermanId',1,5,'select',null);

-- update the datasource column of our fishermanid field - this will now provide the possibleValues list
update fields set DataSource = 'select Id, fullname as Label from Fishermen' where id = 1507;

go

ALTER VIEW dbo.WaterTemp_VW
    AS
    SELECT        h.Id AS WaterTemp_Header_Id, h.Technicians, h.Comments, h.CollectionType, h.FieldActivityType, h.StaticWaterLevel, h.WeatherConditions, h.SamplePeriod, h.SampleTempUnit, h.DeployTime, h.ByUserId, h.EffDt, 
                                d.Id AS WaterTemp_Detail_Id, d.ReadingDateTime, d.GMTReadingDateTime, d.WaterTemperature, d.WaterTemperatureF, d.AirTemperature, d.AirTemperatureF, d.WaterLevel, d.TempAToD, d.Discharge, d.BatteryVolts, d.Conductivity, 
                                d.RowId, d.RowStatusId, d.ByUserId AS WaterTemp_Detail_ByUserId, d.QAStatusId AS RowQAStatusId, d.EffDt AS WaterTemp_Detail_EffDt, d.PSI, d.AbsolutePressure, d.Depth, aq.QAStatusId AS ActivityQAStatusId, 
                                aq.UserId AS ActivityQAUserId, aq.Comments AS ActivityQAComments, a.Description, a.DatasetId, a.SourceId, a.LocationId, a.UserId AS Activity_UserId, a.ActivityTypeId, a.CreateDate, a.Id AS ActivityId, 
                                aq.QAStatusName AS ActivityQAStatusName, a.InstrumentId, a.ActivityDate, L.Label, w.Name, L.WaterBodyId, L.LocationTypeId, CASE WHEN d .QAStatusId > 1 THEN '' ELSE d .WaterTemperature END AS CorrectTemp, 
                                L.OtherAgencyId, qas.Name AS RowQAStatusName
    FROM            dbo.QAStatus AS qas INNER JOIN
                                dbo.WaterTemp_Detail_VW AS d ON qas.Id = d.QAStatusId RIGHT OUTER JOIN
                                dbo.Activities AS a INNER JOIN
                                dbo.WaterTemp_Header_VW AS h ON h.ActivityId = a.Id INNER JOIN
                                dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                                dbo.Locations AS L ON a.LocationId = L.Id INNER JOIN
                                dbo.WaterBodies AS w ON L.WaterBodyId = w.Id ON d.ActivityId = h.ActivityId

go

ALTER VIEW dbo.Metrics_vw
AS
SELECT        h.Id, h.YearReported, h.ByUserId, h.EffDt, a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, d.Id AS Metrics_Detail_Id, d.WorkElementName, d.Measure, 
                         d.PlannedValue, d.ActualValue, d.Comments, d.RowId, d.RowStatusId, d.ByUserId AS Metrics_Detail_ByUserId, d.QAStatusId, d.EffDt AS Metrics_Detail_EffDt, l.Label AS LocationLabel, aq.QAStatusName, aq.Comments AS ActivityQAComments, aq.QAStatusId AS ActivityQAStatusId
FROM            dbo.Activities AS a INNER JOIN
                         dbo.Metrics_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id LEFT OUTER JOIN
                         dbo.Metrics_Detail_VW AS d ON h.ActivityId = d.ActivityId

go

--add some columns that are long overdue!
ALTER TABLE [dbo].[Datastores] ADD [DefaultConfig] [nvarchar](max)
ALTER TABLE [dbo].[Fields] ADD [DatastoreId] [int] NOT NULL DEFAULT 0
ALTER TABLE [dbo].[Fields] ADD [FieldRoleId] [int] NOT NULL DEFAULT 0
go

-- add a new field category to fix the doubling up of FishTransport and WaterTemp and then set the new DatastoreId field
DECLARE @fishtransportfcid int = 0;
insert into FieldCategories (Name, Description) values ('Fish Transport','Fish Transport');
select @fishtransportfcid = scope_identity();
update fields set FieldCategoryId = @fishtransportfcid where id in (26,32,35,1038,1039,1040,1046,1052);
update datastores set FieldCategoryId = @fishtransportfcid where TablePrefix = 'FishTransport';
update fields set DatastoreId = (select d.Id from Datastores d where d.FieldCategoryId = fields.FieldCategoryId);
go


-- now we can remove the fieldcategory altogether
IF object_id(N'[dbo].[FK_dbo.Fields_dbo.FieldCategories_FieldCategoryId]', N'F') IS NOT NULL
    ALTER TABLE [dbo].[Fields] DROP CONSTRAINT [FK_dbo.Fields_dbo.FieldCategories_FieldCategoryId]
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_FieldCategoryId' AND object_id = object_id(N'[dbo].[Fields]', N'U'))
    DROP INDEX [IX_FieldCategoryId] ON [dbo].[Fields]
DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Datastores')
AND col_name(parent_object_id, parent_column_id) = 'FieldCategoryId';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Datastores] DROP CONSTRAINT [' + @var0 + ']')
ALTER TABLE [dbo].[Datastores] DROP COLUMN [FieldCategoryId]
DECLARE @var1 nvarchar(128)
SELECT @var1 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.Fields')
AND col_name(parent_object_id, parent_column_id) = 'FieldCategoryId';
IF @var1 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[Fields] DROP CONSTRAINT [' + @var1 + ']')
ALTER TABLE [dbo].[Fields] DROP COLUMN [FieldCategoryId]
DROP TABLE [dbo].[FieldCategories]
go

-- update the new fieldroleid in the fields table from a row in datasetfields (if exists)
--   note: after this runs, there are still 35 rows that aren't set and need to be address by colette: e.g.: select * from fields where fieldroleid = 0
update fields set fieldroleid = (select top 1 fieldroleid from datasetfields df where df.fieldid = fields.Id) 
where fields.Id in (select distinct fieldid from datasetfields)
go

-- finally update our datastore default config with a config from one of the datasets that have a config for that datastore
update Datastores set DefaultConfig = (select top 1 Config from datasets where Config is not null and Datastores.Id = datasets.datastoreId) 
where Datastores.Id in (select distinct dc.DatastoreId from Datasets dc where dc.Config is not null and dc.DatastoreId is not null)
go

-- create a our activity system fields datastore!

DECLARE @activitydsid int = 0;

insert into Datastores (Name, TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig) values ('ActivitySystemFields',null,1,null,
'{
  "DataEntryPage": {
    "HeaderFields": [
      "Location",
      "ActivityDate",
      "SampleDate",
      "Timezone",
      "Instrument",
      "AccuracyCheck",
      "PostAccuracyCheck"
    ],
    "QAFields": [
      "QAStatus",
      "QAComments"
    ],
    "DetailFields": [
      "RowQAStatus"
    ],
    "HiddenFields": [
      "Instrument",
      "AccuracyCheck",
      "PostAccuracyCheck",
      "Timezone",
      "SampleDate",
      "RowQAStatus"
    ],
    "sort": {
      "field": "ActivityDate",
      "direction": "desc"
    }
  }
}');

select @activitydsid = scope_identity();

insert into Fields (Name, Description, DbColumnName, ControlType, DatastoreId, FieldRoleId)
values 
('Activity Date','Activity date field','ActivityDate','activity-date', @activitydsid, 1),
('QA Status','Activity QA Status','QAStatus','qa-status-select',@activitydsid,1),
('QA Comments','Activity QA Comments','QAComments','qa-status-comment',@activitydsid,1),
('Location','Activity location','LocationId','location-select',@activitydsid,1),
('Instrument','Activity instrument','InstrumentId','instrument-select',@activitydsid,1),
('Accuracy Check','Activity instrument accuracy check','AccuracyCheckId','accuracy-check-select',@activitydsid,1),
('Post Accuracy Check','Activity instrument post-accuracy check','PostAccuracyCheckId','post-accuracy-check-select',@activitydsid,1),
('Reading Timezone','Activity reading timezone','Timezone','timezone-select',@activitydsid,1),
('Row QA Status','Activity row QA status','QAStatusId','select',@activitydsid,1),
('Activity Description','Activity description field','Description','activity-text', @activitydsid, 1);

go

----------------- run this together

DECLARE @sysdsid int = 0;
select @sysdsid=id from DataStores where Name = 'ActivitySystemFields';

-- add activity date to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'ActivityDate'), 1, 'Activity Date','ActivityDate',1,1,'activity-date',null
from datasets where datastoreid in (1,2,4,5,7,8,9,10,11,12,13,14,15,18,19,20);

-- add activity date as "sample date" for Benthic and Drift
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'ActivityDate'), 1, 'Sample Date','ActivityDate',1,1,'activity-date',null
from datasets where datastoreid in (21,22);

-- add location to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'LocationId'), 1, 'Location','LocationId',1,2,'location-select',null
from datasets where datastoreid in (1,2,3,4,5,6,7,8,9,11,12,13,14,15,17,18,19,20,21,22);

-- add qa status to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND Name = 'QA Status'), 1, 'QA Status','QAStatusId',1,97,'qa-status-select',null
from datasets where datastoreid in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,22);

-- add qa comments to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'QAComments'), 1, 'QA Comments','QAComments',1,98,'qa-status-comment',null
from datasets where datastoreid in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21,22);

-- for crpp contracts

insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'ActivityDate'), 1, 'Date Received','ActivityDate',1,1,'activity-date',null
from datasets where datastoreid in (16);

insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'LocationId'), 1, 'Location','LocationId',1,2,'hidden',null
from datasets where datastoreid in (16);

insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND Name = 'QA Status'), 1, 'QA Status','QAStatusId',1,97,'hidden',null
from datasets where datastoreid in (16);

insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'QAComments'), 1, 'QA Comments','QAComments',1,98,'hidden',null
from datasets where datastoreid in (16);


-- add instruments to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'InstrumentId'), 1, 'Instrument','InstrumentId',1,4,'instrument-select',null
from datasets where datastoreid in (3,6);

-- add accuracy check to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'AccuracyCheckId'), 1, 'Accuracy Check','AccuracyCheckId',1,5,'accuracy-check-select',null
from datasets where datastoreid in (3,6);

-- add post accuracy check to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'PostAccuracyCheckId'), 1, 'Post-accuracy Check','PostAccuracyCheckId',1,6,'post-accuracy-check-select',null
from datasets where datastoreid in (3,6);

-- add timezone to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'Timezone'), 1, 'Timezone','Timezone',1,7,'timezone-select',null
from datasets where datastoreid in (3,6);

-- add rowqa to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND Name = 'Row QA Status'), 2, 'QA','QAStatusId',1,99,'select',null
from datasets where datastoreid in (3);

-- add description to all datasets that need it
insert into DatasetFields (CreateDateTime, DatasetId, FieldId, FieldRoleId, Label, DbColumnName, SourceId, OrderIndex, ControlType, InstrumentId)
select getdate(), id, (select id from Fields where DatastoreId = @sysdsid AND DbColumnName = 'Description'), 1, 'Description','Description',1,8,'activity-text',null
from datasets where datastoreid in (3);


go

DECLARE @newdsid int = 0;
DECLARE @newprojectypeid int = 0;
DECLARE @newprojectid int = 0;
DECLARE @newdatasetid int = 0;

insert into ProjectTypes (Name, Description) values ('System','CDMS System')
select @newprojectypeid = scope_identity();

insert into Projects 
	(ProjectTypeId, OrganizationId, Name, Description, CreateDateTime) 
	values 
	(@newprojectypeid, 1,'System','CDMS System',getdate());
select @newprojectid = scope_identity();

insert into Datastores (Name, TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig) values ('LocationSystemFields',null,1,null,'{}');
select @newdsid = scope_identity();

insert into Fields (Name, Description, DbColumnName, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('Location Type','LocationTypeId','LocationTypeId','select-number',@newdsid,1,'select Id, Name as Label from locationtypes','int',null,null),
('Label','Label','Label','text',@newdsid,1,null,'string',null,null),
('Description','Description','Description','textarea',@newdsid,1,null,'string',null,null),
('Other Agency Id','OtherAgencyId','OtherAgencyId','text',@newdsid,1,null,'string',null,null),
('Elevation','Elevation','Elevation','number',@newdsid,1,null,'int',null,null),
('GPS Easting','GPSEasting','GPSEasting','easting',@newdsid,1,null,'double',null,'required;[100000,999999]'),
('GPS Northing','GPSNorthing','GPSNorthing','northing',@newdsid,1,null,'double',null,'required;[1000000,9999999]'),
('UTM Zone','UTMZone','UTMZone','text',@newdsid,1,null,'string',null,null),
('Projection','Projection','Projection','text',@newdsid,1,null,'string',null,null),
('Latitude','Latitude','Latitude','number',@newdsid,1,null,'int',null,null),
('Longitude','Longitude','Longitude','number',@newdsid,1,null,'int',null,null),
('Status','Status','Status','select-number',@newdsid,1,null,'int','{"0":"Active","1":"Inactive"}',null),
('Name','Name','Name','text',@newdsid,1,null,'string',null,null),
('River Mile','RiverMile','RiverMile','number',@newdsid,1,null,'int',null,null),
('Study Design','StudyDesign','StudyDesign','text',@newdsid,1,null,'string',null,null),
('Wetted Depth','WettedDepth','WettedDepth','number',@newdsid,1,null,'int',null,null),
('Wetted Width','WettedWidth','WettedWidth','number',@newdsid,1,null,'int',null,null),
('Waterbody','WaterBodyId','WaterBodyId','select-number',@newdsid,1,'SELECT Id, Name as Label from Waterbodies','int',null,null),
('Create DateTime','CreateDateTime','CreateDateTime','datetime',@newdsid,1,null, 'datetime',null,null),
('Image Link','ImageLink','ImageLink','text',@newdsid,1,null,'string',null,null),
('Subproject Id','SubprojectId','SubprojectId','number',@newdsid,1,null,'int',null,null),
('SdeObject Id','SdeObjectId','SdeObjectId','number',@newdsid,1,null,'int',null,null);


insert into datasets 
(ProjectId, DefaultRowQAStatusId, DefaultActivityQAStatusId, StatusId, CreateDateTime, Name, Description, DatastoreId) 
values 
(@newprojectid, 1, 5, 1,getdate(),'Location','CDMS Location Form',@newdsid );

select @newdatasetid = scope_identity();


insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select
@newdatasetid, Id, FieldRoleId, getDate(), Name, DbColumnName, ControlType, null ,1
FROM Fields where DatastoreId = @newdsid;

go

-- Create a new datastore + dataset for the CRPP Correspondence dataset (no longer a tab but a bona-fide dataset)

DECLARE @crppprojectid int = 2247;
DECLARE @newdsid int = 0;
DECLARE @newdatasetid int = 0;

insert into Datastores (Name, TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig) values ('CRPPCorrespondence',null,1,null,'{"ActivitiesPage":{"Route":"crppcorrespondence"}}');
select @newdsid = scope_identity();

insert into datasets 
(ProjectId, DefaultRowQAStatusId, DefaultActivityQAStatusId, StatusId, CreateDateTime, Name, Description, DatastoreId, Config) 
values 
(@crppprojectid, 1, 5, 1,getdate(),'CRPP Correspondence','CRPP Correspondence',@newdsid, '{"ActivitiesPage":{"Route":"crppcorrespondence"}}' );

select @newdatasetid = scope_identity();

go


-- now do the same for Habitat Sites.
DECLARE @newhabdsid int = 0;

insert into Datastores (Name, TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig) values ('Habitat Sites',null,1,null,'{"ActivitiesPage":{"Route":"habitatsites"}}');
select @newhabdsid = scope_identity();

--add a dataset for each habitat project that should have one
insert into datasets 
(ProjectId, DefaultRowQAStatusId, DefaultActivityQAStatusId, StatusId, CreateDateTime, Name, Description, DatastoreId, Config) 
select Id,1, 5, 1,getdate(),'Habitat Sites','Habitat Sites',@newhabdsid, '{"ActivitiesPage":{"Route":"habitatsites"}}' 
from projects where Id in (select distinct RelationId from metadatavalues_vw where metadatapropertyid = 24 and [values] = 'Habitat');

go

update metadataproperties set controltype = 'hidden' where id in (11,13,25,26);
update metadataproperties set controltype = 'text' where id in (22);
update metadataproperties set controltype = 'textarea' where id in (1,3,4,5,9,14,15,20);

DECLARE @entityid int = 0;
insert into metadataentities (name, description) values ('Correspondence','CRPP Correspondence lookup fields');
select @entityid = scope_identity();

insert into metadataproperties (MetadataEntityId, Name, Description, DataType, PossibleValues, ControlType) values 
(@entityid, 'Agency','Agency','string','[]','select'),
(@entityid, 'County','County','string','[]','select'),
(@entityid, 'CorrespondenceType','Correspondence Type','string','[]','select'),
(@entityid, 'ResponseType','Response Type','string','[]','select'),
(@entityid, 'NumberOfDays','Number Of Days','number','[]','select'),
(@entityid, 'StaffMember','Staff Member - These names must match the user''s name in Outlook, and the full name in table Users.','string','[]','select'),
(@entityid, 'ProjectLead','Project Lead - These names must match the user''s name in Outlook, and the full name in table Users.','string','[]','select');

update metadataproperties set PossibleValues = 
'[
"ACHP",
"Anderson Perry",
"Army",
"Baker County",
"Benton County",
"BIA",
"BLM",
"Blue Mountain Ranger District",
"BNSF",
"BOR",
"BPA",
"Camas",
"CenturyLink",
"Clark County",
"College Place",
"Columbia County",
"Corps Portland District",
"Corps Regulatory",
"Corps Walla Walla District",
"CRGNSA",
"CTUIR",
"DAHP",
"DECD",
"Department of Ecology",
"DEQ",
"DOE",
"DOGAMI",
"DSL",
"EPA",
"FAA",
"FCC",
"Federal Transit Authority",
"FEMA",
"FERC",
"FHWA",
"Fisheries",
"Fort Vancouver (NPS)",
"Franklin County",
"FSA",
"Hells Canyon NRA",
"Heppner Ranger District",
"Hermiston",
"Hood River County",
"HUD",
"Idaho Power",
"Irrigon",
"John Day Fossil Beds (NPS)",
"Kennewick",
"Klickitat County",
"La Grande Ranger District",
"Landowner",
"Malheur National Forest",
"Morrow County",
"Navy",
"Nez Perce National Historical Park (NPS)",
"North Fork John Day Ranger District",
"Northwest Pipeline",
"NPS",
"NRCS",
"ODEQ",
"ODOE",
"ODOT",
"OPRD",
"Oregon City",
"Oregon Military Department/Oregon Army National Guard",
"Other",
"OWRD",
"PacifiCorp",
"Pasco",
"PGE",
"Planning Dept",
"Pomeroy Ranger District",
"Port of Benton",
"Port of Clarkston",
"Port of Columbia",
"Port of Kennewick",
"Port of Morrow",
"Port of Umatilla",
"Port of Walla Walla",
"Public Works",
"RAF",
"Recreation and Conservation Office",
"Richland",
"Rural Development",
"RUS",
"SHPO Oregon",
"Skamania County",
"Skamania County PUD",
"Umatilla County",
"Umatilla National Forest",
"UPRR",
"USACE",
"USFWS",
"VA",
"Vancouver",
"Walla Walla City",
"Walla Walla County",
"Walla Walla Ranger District",
"Wallowa County",
"Wallowa Valley Ranger District",
"Wallowa-Whitman National Forest",
"Wasco County",
"Washington Department of Commerce",
"Washington Department of Health",
"Washington Department of Natural Resources",
"Washington State Parks",
"Water Resources",
"WDFW",
"Western Federal Lands Highway Division",
"Whitman Mission (NPS)",
"Whitman Unit",
"Wildhorse Resort and Casino (WRC)",
"Wildlife",
"WSDOT",
"Yellowstone National Park"
]' where name = 'Agency';

update metadataproperties set PossibleValues = 
'[
"Asotin",
"Baker",
"Benton",
"Clark",
"Columbia",
"Franklin",
"Garfield",
"Gilliam",
"Grant, WA",
"Grant, OR",
"Hood River",
"Klickitat",
"Malheur",
"Morrow",
"Multnomah",
"Other",
"Sherman",
"Skamania",
"Umatilla",
"Union",
"Walla Walla",
"Wallowa",
"Wasco",
"Wheeler",
"Whitman"]' where name = 'County';

update metadataproperties set PossibleValues = 
'["Project Notification",
"Notice of Application",
"Seeking Concurrence",
"Document Review",
"Permit Review",
"Sending materials for our records",
"Other"]' where name = 'CorrespondenceType';

update metadataproperties set PossibleValues = 
'["APE letter",
"Asked to be consulting party",
"Defer to other tribe(s)",
"Determination of Eligibility",
"Did not review",
"Emailed Comments",
"Finding of Effect",
"Issued survey/excavation permit",
"Let it go",
"Missed opportunity to review",
"NAGPRA FR Notice",
"NAGPRA inventory/summary",
"none--ok",
"Notice of Application",
"Other",
"Out of area",
"Permit Application",
"Report for Review",
"Requested a monitor",
"Requested a survey",
"Requested additional information",
"Requested report",
"Requested testing",
"Response to comments",
"Reviewed report",
"Same as previously reviewed project",
"Sent letter",
"Signed off on",
"Simple Notification"]' where name = 'ResponseType';

update metadataproperties set PossibleValues = 
'["Bambi Rodriguez",
"Shawn Steinmetz",
"Catherine Dickson",
"Carey Miller",
"Jennifer Karson Engum",
"Shari Sheoships",
"Arthur Van Pelt",
"Teara Farrow Ferman",
"Dara Williams-Worden",
"Julius Patrick",
"Nathan May",
"Kristen Tiede"]' where name = 'StaffMember';

update metadataproperties set PossibleValues = 
'["Bambi Rodriguez",
"Carey Miller",
"Catherine Dickson",
"Kristen Tiede",
"Shawn Steinmetz",
"Arthur Van Pelt",
"Dara Williams-Worden",
"Jennifer Karson Engum",
"Julius Patrick",
"Shari Sheoships",
"Nathan May",
"Teara Farrow Ferman"]' where name = 'ProjectLead';

go

--creates lookuptables entities

CREATE TABLE [dbo].[LookupTables] (
    [Id] [int] NOT NULL IDENTITY,
    [Name] [nvarchar](max),
    [Label] [nvarchar](max),
    [Description] [nvarchar](max),
    [DatasetId] [int],
    CONSTRAINT [PK_dbo.LookupTables] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_DatasetId] ON [dbo].[LookupTables]([DatasetId])
ALTER TABLE [dbo].[LookupTables] ADD CONSTRAINT [FK_dbo.LookupTables_dbo.Datasets_DatasetId] FOREIGN KEY ([DatasetId]) REFERENCES [dbo].[Datasets] ([Id])

ALTER TABLE [dbo].[Projects] ADD [Config] [nvarchar](max)

go

-- setup our location table fields: fishermen
DECLARE @newdsid int = 0;
DECLARE @newdatasetid int = 0;
DECLARE @cdmssystemprojectid int = 0;

set @cdmssystemprojectid =(select Id from projects where [name] = 'System');

insert into Datastores (Name, TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig) values ('Fisherman Lookup Fields','Fishermen',1,null,'{}');
select @newdsid = scope_identity();

insert into Fields (Name, Description, DbColumnName, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('First Name','FirstName','FirstName','text',@newdsid,1,null,'string',null,null),
('Aka','Aka','Aka','text',@newdsid,1,null,'string',null,null),
('Last Name','LastName','LastName','text',@newdsid,1,null,'string',null,null),
('Phone Number','PhoneNumber','PhoneNumber','text',@newdsid,1,null,'string',null,null),
('Date Added','DateAdded','DateAdded','date',@newdsid,1,null,'datetime',null,null),
('Date Inactive','DateInactive','DateInactive','date',@newdsid,1,null,'datetime',null,null),
('Fullname','FullName','FullName','text',@newdsid,1,null,'string',null,null),
('Comments','FishermanComments','FishermanComments','text',@newdsid,1,null,'string',null,null),
('Status','StatusId','StatusId','select-number',@newdsid,1,null,'int','{"0":"Active","1":"Inactive"}',null),
('Ok To Call','OkToCallId','OkToCallId','select-number',@newdsid,1,null,'int','{"0":"Yes","1":"No"}',null);


insert into datasets 
(ProjectId, DefaultRowQAStatusId, DefaultActivityQAStatusId, StatusId, CreateDateTime, Name, Description, DatastoreId) 
values 
(@cdmssystemprojectid, 1, 5, 1,getdate(),'Fishermen','CDMS Fishermen Lookup Table',@newdsid );

select @newdatasetid = scope_identity();

insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select
@newdatasetid, Id, FieldRoleId, getDate(), Name, DbColumnName, ControlType, null ,1
FROM Fields where DatastoreId = @newdsid;

insert into LookupTables
(Name, Label, Description, DatasetId)
values
('Fishermen','Fishermen','Fishermen Lookup Table',@newdatasetid)

go

-- setup our location table fields: seasons
DECLARE @newdsid int = 0;
DECLARE @newdatasetid int = 0;
DECLARE @cdmssystemprojectid int = 0;

set @cdmssystemprojectid =(select Id from projects where [name] = 'System');

insert into Datastores (Name, TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig) values ('Seasons Lookup Fields','Seasons',1,null,'{}');
select @newdsid = scope_identity();

insert into Fields (Name, Description, DbColumnName, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('Species','Species','Species','text',@newdsid,1,null,'string',null,null),
('Season','Season','Season','number',@newdsid,1,null,'int',null,null),
('Total Days','TotalDays','TotalDays','number',@newdsid,1,null,'int',null,null),
('Open Date','OpenDate','OpenDate','date',@newdsid,1,null,'datetime',null,null),
('Close Date','CloseDate','CloseDate','date',@newdsid,1,null,'datetime',null,null),
('Dataset','DatasetId','DatasetId','number',@newdsid,1,null,'int',null,null);


insert into datasets 
(ProjectId, DefaultRowQAStatusId, DefaultActivityQAStatusId, StatusId, CreateDateTime, Name, Description, DatastoreId) 
values 
(@cdmssystemprojectid, 1, 5, 1,getdate(),'Seasons','CDMS Seasons Lookup Table',@newdsid );

select @newdatasetid = scope_identity();

insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select
@newdatasetid, Id, FieldRoleId, getDate(), Name, DbColumnName, ControlType, null ,1
FROM Fields where DatastoreId = @newdsid;

insert into LookupTables
(Name, Label, Description, DatasetId)
values
('Seasons','Seasons','Seasons Lookup Table',@newdatasetid)

go

insert into LookupTables
(Name, Label, Description, DatasetId)
values
('Instruments','Instruments','Instruments Lookup Table',null)

go

--creates a new location type for "Habitat Sites" and modifies existing locations that are habitat sites to use it.

DECLARE @newloctypeid int = 0;

INSERT INTO LocationTypes (Name, Description) values ('Habitat Sites','Habitat Site Locations');

select @newloctypeid = scope_identity();

UPDATE Locations set LocationTypeId = @newloctypeid where subprojectid is not null and LocationTypeId = 112;

UPDATE Datastores set LocationTypeId = @newloctypeid where [Name] = 'Habitat Sites';

go

DECLARE @entityid int = 0;
insert into metadataentities (name, description) values ('Habitat Sites','Habitat Sites lookup fields');
select @entityid = scope_identity();

insert into metadataproperties (MetadataEntityId, Name, Description, DataType, PossibleValues, ControlType) values 
(@entityid, 'Collaborator','Collaborator','string','[]','select'),
(@entityid, 'Funder','Funder','string','[]','select');

update metadataproperties set PossibleValues = 
'[
"Blue Mountain Habitat Restoration Council",
"Bureau of Reclamation",
"Bonneville Power Authority",
"Columbia Conservation District",
"CTUIR",
"Eco Trust",
"Grande Ronde Model Watershed",
"Landowners",
"Nez Perce Tribe",
"NF John Day Watershed Council",
"Natural Resource Conservation Service",
"Oregon Department of Fish and Wildlife",
"Oregon Department of Transportation",
"Oregon Watershed Enhancement Board",
"Other",
"Pacific Coastal Salmon Recovery Fund",
"Pomeroy Conservation District",
"Salmon Recovery Funding Board",
"Snake River Salmon Recovery Board",
"Umatilla County Soil and Water Conservation District",
"Umatilla National Forest",
"US Forest Service",
"Wallowa Whitman National Forest",
"Washington Department of Fish and Wildlife"
]' where name = 'Collaborator';

update metadataproperties set PossibleValues = 
'[
"Blue Mountain Habitat Restoration Council",
"Bonneville Power Authority",
"Bureau of Reclamation",
"CTUIR",
"Eco Trust",
"Grande Ronde Model Watershed",
"NF John Day Watershed Council",
"Oregon Department of Fish and Wildlife",
"Oregon Watershed Enhancement Board",
"Other",
"Pacific Coastal Salmon Recovery Fund",
"Snake River Salmon Recovery Board",
"Umatilla County Soil and Water Conservation District",
"Umatilla National Forest",
"US Forest Service",
"Wallowa Whitman National Forest",
"Washington Department of Fish and Wildlife"
]' where name = 'Funder';

go

create table __Analytics (
	Id INT NOT NULL IDENTITY(1,1),
	RequestTimestamp datetime default CURRENT_TIMESTAMP,
	Username varchar(255) NOT NULL,
	Route varchar(255) NOT NULL,
	Action varchar(255) NOT NULL,
	Target INT,
	PRIMARY KEY (Id)
)
go


--- tweaks and fixes for CTUIR

--set creel time fields to be time types
update fields set ControlType = 'time' where id in (select id from fields where dbcolumnname in ('TimeStart', 'TimeEnd', 'InterviewTime') and DatastoreId = 14);
update datasetfields set ControlType = 'time' where id in (select id from datasetfields where dbcolumnname in ('TimeStart', 'TimeEnd', 'InterviewTime') and datasetid = 1230);
go

--set creel dropdown
update fields set possiblevalues = '{ "0": "00:00",
  "15": "00:15",
  "30": "00:30",
  "45": "00:45",
  "60": "01:00",
  "75": "01:15",
  "90": "01:30",
  "105": "01:45",
  "120": "02:00",
  "135": "02:15",
  "150": "02:30",
  "165": "02:45",
  "180": "03:00",
  "195": "03:15",
  "210": "03:30",
  "225": "03:45",
  "240": "04:00",
  "255": "04:15",
  "270": "04:30",
  "285": "04:45",
  "300": "05:00",
  "315": "05:15",
  "330": "05:30",
  "345": "05:45",
  "360": "06:00",
  "375": "06:15",
  "390": "06:30",
  "405": "06:45",
  "420": "07:00",
  "435": "07:15",
  "450": "07:30",
  "465": "07:45",
  "480": "08:00",
  "495": "08:15",
  "510": "08:30",
  "525": "08:45",
  "540": "09:00",
  "555": "09:15",
  "570": "09:30",
  "585": "09:45",
  "600": "10:00",
  "615": "10:15",
  "630": "10:30",
  "645": "10:45",
  "660": "11:00",
  "675": "11:15",
  "690": "11:30",
  "705": "11:45",
  "720": "12:00",
  "735": "12:15",
  "750": "12:30",
  "765": "12:45",
  "780": "13:00",
  "795": "13:15",
  "810": "13:30",
  "825": "13:45",
  "840": "14:00",
  "855": "14:15",
  "870": "14:30",
  "885": "14:45",
  "900": "15:00",
  "915": "15:15",
  "930": "15:30",
  "945": "15:45",
  "960": "16:00",
  "975": "16:15",
  "990": "16:30",
  "1005": "16:45",
  "1020": "17:00",
  "1035": "17:15",
  "1050": "17:30",
  "1065": "17:45",
  "1080": "18:00" }'
  where id = (select id from fields where name = 'Total Time Fished');
go

--set appraisal route and activity list fields
update datasets set Config = '{"RestrictRoles":["DECD"],"ActivitiesPage":{"ShowFields":["Allotment","AllotmentStatus"]},"DataEntryPage":{"HiddenFields":["Location","ActivityDate","Instrument","QA","BulkQaChange"]},"SpecifyActivityListFields":true,"ActivityListFields":["ActivityDate","AllotmentStatus","LeaseTypes","LocationId","Allotment","CobellAppraisalWave"]}' 
where id = 1193;
go


--add project configs for lookups
update projects set config = '{"Lookups":[{"Id":"3","Label":"Instruments"}]}' where id = 1199;
update projects set config = '{"Lookups":[{"Id":"1","Label":"Fishermen","DatasetId":1273},{"Id":"2","Label":"Seasons","DatasetId":1274}]}' where id = 1217;
update projects set config = '{"Lookups":[{"Id":"7","Label":"Correspondence","Type":"Metafields"}]}' where id = 2247;
update projects set config = '{
  "Lookups": [
    {
      "Id": "8",
      "Label": "Habitat",
      "Type": "Metafields"
    }
  ],
  "ShowHabitatSitesForDatasets": [
    "Biom-Benthic",
    "Biom-Drift",
    "BioM-Electrofishing",
    "BioM-Snorkel"
  ]
}' where id = 2249;

go

--appraisal locations linked to project
delete from locationprojects where Project_Id = 2246;
insert into locationprojects (Location_Id, Project_Id) 
select id, 2246 from locations where locationtypeid=8;
go

-- add SharingLevel to files table, set default to 1 (private), update all existing rows
ALTER TABLE Files
ADD SharingLevel int NOT NULL
CONSTRAINT DefaultSharingLevelPrivate DEFAULT (1)
WITH VALUES;
go

ALTER TABLE HabitatItems
ADD SharingLevel int NOT NULL
CONSTRAINT DefaultHabItemSharingLevelPrivate DEFAULT (1)
WITH VALUES;
go

--delete these unused records
delete from fields where FieldRoleId = 0;

-- set for crppcontracts ProjectLead field
update fields set DataSource = 'select PossibleValues from metadataproperties where name = ''ProjectLead''' where Name = 'Project Lead' and DatastoreId = 16;

--update water quality to 9,3 decimalprecision
DECLARE @var0 nvarchar(128)
SELECT @var0 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id(N'dbo.WaterQuality_Detail')
AND col_name(parent_object_id, parent_column_id) = 'Result';
IF @var0 IS NOT NULL
    EXECUTE('ALTER TABLE [dbo].[WaterQuality_Detail] DROP CONSTRAINT [' + @var0 + ']')
ALTER TABLE [dbo].[WaterQuality_Detail] ALTER COLUMN [Result] [decimal](9, 3) NULL

