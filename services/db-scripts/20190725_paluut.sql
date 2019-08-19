
--note: this creates the table. the rows will need to be imported manually either from the .csv or select into from the PALUUT_DEV_KEN table.
CREATE TABLE [dbo].[PermitZones] (
    [Id] [int] NOT NULL IDENTITY,
    [ZoneCode] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitZones] PRIMARY KEY ([Id])
)

go

-- import from PALUUT_DEV_KEN table
SET IDENTITY_INSERT PermitZones ON
insert into PermitZones (Id, ZoneCode)
select Id, ZoneCode from [GIS-SQL].PALUUT_DEV_KEN.dbo.PermitZones
SET IDENTITY_INSERT PermitZones OFF
go



ALTER view PermitCadaster_VW as
select cad.ObjectId, cad.Allotment, cad.ParcelId, cad.Ownerships, cad.Taxlot, cad.Geosource, cad.Datasource, cad.Comment, cad.Address, cad.Acres_GIS, cad.Acres_cty, cad.PLSS, cad.PLSS2, cad.PLSS3, cad.PLSS_Label, cad.Last_Edited_Date, z.ZoneCode 
from OPENQUERY([GIS-SQL],'select * from sdevector.sde.Cadaster_evw') cad
left outer join PermitZones z on cad.ObjectId = z.Id;
go

-- convert result field to a group

DECLARE @eventsdsid int = 0;
select @eventsdsid = id from Datastores where Name = 'Permit Events';

DECLARE @eventsdataset int = 0;
select @eventsdataset = id from Datasets where DatastoreId = @eventsdsid;

update Fields set possiblevalues = '[{"Id":"Passed","Label":"Passed","Group":"Inspection"},{"Id":"Signature Required","Label":"Signature Required","Group":"Inspection"},{"Id":"Photos Required","Label":"Photos Required","Group":"Inspection"},{"Id":"Reinspection Required","Label":"Reinspection Required","Group":"Inspection"},{"Id":"Additional Information Needed","Label":"Additional Information Needed","Group":"Review"},{"Id":"Approved","Label":"Approved","Group":"Review"},{"Id":"Approved with Conditions","Label":"Approved with Conditions","Group":"Review"},{"Id":"Denied","Label":"Denied","Group":"Review"}]', controltype = 'select-group', datasource = null where DatastoreId =  @eventsdsid and dbcolumnname = 'Result';
update DatasetFields set controltype = 'select-group' where dbcolumnname = 'Result' and datasetid = @eventsdataset;

delete from metadataproperties where name = 'ReviewResult';
go

--- ABOVE UPDATED ON TEST 7/26

DECLARE @eventsdsid int = 0;
select @eventsdsid = id from Datastores where Name = 'Permit Events';

DECLARE @eventsdataset int = 0;
select @eventsdataset = id from Datasets where DatastoreId = @eventsdsid;

update datasetfields set controltype = 'textarea' where dbcolumnname = 'Comments' and datasetid = @eventsdataset;
go

update metadataproperties set possiblevalues = '["New Application","Under Review", "Approved", "Conditionally Approved", "Denied","Incomplete","Cancelled", "Archived"]'
where name = 'PermitStatus' and MetadataEntityId = 9;

go

--- ABOVE UPDATED ON TEST 7/29

ALTER TABLE [dbo].[PermitTypes] ADD [CurrentPermitNumber] [int];
go

update datasetfields set controltype = 'date' where datasetid = 1281 and controltype = 'datetime';
delete from datasetfields where id in (5473, 5474, 5475, 5476, 5477);
update metadataproperties set possiblevalues = '["Active","Inactive","Ready to Archive","Archived","Deleted"]' where metadataentityid = 9 and name = 'FileStatus';

go


insert into metadataproperties (metadataentityid, Name, Description, DataType, PossibleValues, controltype) 
values
(9, 'FileTypes','Description of the File Type', 'string','["Site Plan","Inspection Report","Email Message","Other Document"]', 'select');
go



-- update the city/state/zip dropdowns
DECLARE @filetypesmd int = 0;

insert into metadataproperties (metadataentityid, Name, Description, DataType, PossibleValues, controltype) 
values
(9, 'SiteCities','Possible cities in site location', 'string','["Adams","Athena","Cayuse","La Grande","Meacham","Pendleton","Pilot Rock","Weston","Unknown"]', 'select');
select @filetypesmd = scope_identity();

update Fields set datasource = concat('select possiblevalues from metadataproperties where id = ', @filetypesmd) where DatastoreId =  33 and dbcolumnname = 'SiteCity';
update DatasetFields set controltype = 'select' where dbcolumnname = 'SiteCity' and datasetid = 1281;


insert into metadataproperties (metadataentityid, Name, Description, DataType, PossibleValues, controltype) 
values
(9, 'SiteStates','Possible states in site location', 'string','["OR"]', 'select');
select @filetypesmd = scope_identity();

update Fields set datasource = concat('select possiblevalues from metadataproperties where id = ', @filetypesmd), controltype = 'select' where DatastoreId =  33 and dbcolumnname = 'SiteState';
update DatasetFields set controltype = 'select' where dbcolumnname = 'SiteState' and datasetid = 1281;


insert into metadataproperties (metadataentityid, Name, Description, DataType, PossibleValues, controltype) 
values
(9, 'SiteZips','Possible zips in site location', 'string','["97801","97810","97813","97821","97850","97856","97868","97886","Unknown"]', 'select');
select @filetypesmd = scope_identity();

update Fields set datasource = concat('select possiblevalues from metadataproperties where id = ', @filetypesmd) where DatastoreId =  33 and dbcolumnname = 'SiteZip';
update DatasetFields set controltype = 'select' where dbcolumnname = 'SiteZip' and datasetid = 1281;

go

-- ABOVE UPDATED ON TEST 8/1/19