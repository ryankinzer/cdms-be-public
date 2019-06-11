-- PALUUT: updates for permit module + columnindex for datasetfields (kb)

-- add columnindex field to datasetfields for grouping fields in the UI
ALTER TABLE [dbo].[DatasetFields] ADD [ColumnIndex] [int]
go

-- add itemid to file for cross-referencing permitnumber and in the future, correspondenceitems, etc.
ALTER TABLE [dbo].[Files] ADD [ItemId] [int]
go

-- add the permitnumber that we somehow missed!
DECLARE @newfieldid int = 0;

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('PermitNumber','Permit Number','Permit Number','text',33,1,null,'string',null,null);

select @newfieldid = scope_identity();

insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) values 
(1281, @newfieldid, 1, getdate(), 'Permit Number','PermitNumber','text',null,1);

go

-- set all 'datetimes' to 'date' control type
update datasetfields set controltype = 'date' where controltype = 'datetime' and datasetid = 1281

-- update the PermitStatus field
update fields 
set 
controltype = 'select',
possiblevalues = '["Under Review", "Approved", "Conditionally Approved", "Denied","Incomplete","Cancelled", "Archived"]'
where datastoreid = 33 and dbcolumnname = 'PermitStatus'

update datasetfields 
set
controltype = 'select'
where datasetid = 1281 and dbcolumnname = 'PermitStatus'

go


-- update the FeePaymentMethod field
update fields 
set 
controltype = 'select',
possiblevalues = '["Cash","Check","Credit","PO"]'
where datastoreid = 33 and dbcolumnname = 'FeePaymentMethod'

update datasetfields 
set
controltype = 'select'
where datasetid = 1281 and dbcolumnname = 'FeePaymentMethod'

go



-- update the FeePaymentType field
update fields 
set 
controltype = 'select',
possiblevalues = '["Finance Office","Permit Office"]'
where datastoreid = 33 and dbcolumnname = 'FeePaymentType'

update datasetfields 
set
controltype = 'select'
where datasetid = 1281 and dbcolumnname = 'FeePaymentType'

go


-- update the Finding field
update fields 
set 
controltype = 'select',
possiblevalues = '["Under Review", "Approved", "Conditionally Approved", "Denied","Incomplete","Cancelled"]'
where datastoreid = 33 and dbcolumnname = 'Finding'

update datasetfields 
set
controltype = 'select'
where datasetid = 1281 and dbcolumnname = 'Finding'

go


-- update the ConstructionType field
update fields 
set 
controltype = 'select',
possiblevalues = '["VA",
"IIA",
"II",
"1-B",
"VB",
"IB",
"IIB",
"V-N",
"V"]'
where datastoreid = 33 and dbcolumnname = 'ConstructionType'

update datasetfields 
set
controltype = 'select'
where datasetid = 1281 and dbcolumnname = 'ConstructionType'

go


-- update the ImprovementType field

update fields 
set 
controltype = 'select',
possiblevalues = '["(RETIRED) Mobile Home – Placement",
"(RETIRED) Mobile Home – Replacement",
"Access. Building",
"Addition",
"AG Exempt",
"Communication Tower – New",
"Communication Tower–Improvement",
"Electrical",
"Forest Practice",
"Home - New",
"Home Occupation",
"Land Division",
"Manufactured Commercial–Placement",
"Manufactured Home–Placement",
"Manufactured Home–Replacement",
"Mechanical",
"New Commercial Construction",
"Other",
"Plumbing",
"Remodel",
"SDP Construction",
"SDP Major Repair",
"SDP Minor Repair",
"SDP Site Assessment",
"Sign",
"Utility Pole/line",
"Zone Change - Code",
"Zone Change–Map"]'
where datastoreid = 33 and dbcolumnname = 'ImprovementType'

go


-- update the Comments field to a textarea
update fields 
set 
controltype = 'textarea'
where datastoreid = 33 and dbcolumnname = 'Comments'

update datasetfields 
set
controltype = 'textarea'
where datasetid = 1281 and dbcolumnname = 'Comments'

go


-- contacts table
CREATE TABLE [dbo].[PermitContacts] (
    [PermitId] [int] NOT NULL,
    [PermitPersonId] [int] NOT NULL,
    [IsPrimary] [bit] NOT NULL,
    [ContactType] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitContacts] PRIMARY KEY ([PermitId], [PermitPersonId])
)
CREATE INDEX [IX_PermitId] ON [dbo].[PermitContacts]([PermitId])
CREATE INDEX [IX_PermitPersonId] ON [dbo].[PermitContacts]([PermitPersonId])
ALTER TABLE [dbo].[PermitContacts] ADD CONSTRAINT [FK_dbo.PermitContacts_dbo.Permits_PermitId] FOREIGN KEY ([PermitId]) REFERENCES [dbo].[Permits] ([Id])
ALTER TABLE [dbo].[PermitContacts] ADD CONSTRAINT [FK_dbo.PermitContacts_dbo.PermitPersons_PermitPersonId] FOREIGN KEY ([PermitPersonId]) REFERENCES [dbo].[PermitPersons] ([Id])

go

-- cadaster view and permit parcels table
create view PermitCadaster_VW as
select * from sdevector.sde.Cadaster_evw

go

CREATE TABLE [dbo].[PermitParcels] (
    [Id] [int] NOT NULL IDENTITY,
    [PermitId] [int] NOT NULL,
    [ObjectId] [int] NOT NULL,
    [ParcelId] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitParcels] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_PermitId] ON [dbo].[PermitParcels]([PermitId])
CREATE INDEX [IX_ObjectId] ON [dbo].[PermitParcels]([ObjectId])
ALTER TABLE [dbo].[PermitParcels] ADD CONSTRAINT [FK_dbo.PermitParcels_dbo.Permits_PermitId] FOREIGN KEY ([PermitId]) REFERENCES [dbo].[Permits] ([Id])

go

-- now for the permit events dataset and fields

DECLARE @newdsid int = 0;
DECLARE @newprojectid int = 0;
DECLARE @newdatasetid int = 0;

set @newprojectid = (select id from projects where name = 'Permit Project');


INSERT into Datastores (Name, Description, OwnerUserId, DefaultConfig)
values ('Permit Events', 'Permit event fields', 1, '{}');
select @newdsid = scope_identity();

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('EventDate','Created','Date event created','datetime',@newdsid,1,null,'datetime',null,null),
('EventType','Event Type','Event Type','select',@newdsid,1,null,'string','["Approval","Document","Correspondence","Inspection","Record"]',null),
('ItemType','Item Type','Item Type','select',@newdsid,1,null,'string','["CRPP","WRP","County","Blueprint","Site Plan","Phone Call","Email","TPO","Finance","Structural","Electrical","Final"]',null),
('RequestDate','Request Date','Request Date','datetime',@newdsid,1,null,'datetime',null,null),
('ResponseDate','Response Date','Response Date','datetime',@newdsid,1,null,'datetime',null,null),
('Reviewer','Reviewer','Reviewer','text',@newdsid,1,null,'string',null,null),
('Result','Result','Result','text',@newdsid,1,null,'string',null,null),
('Reference','Reference','Reference','text',@newdsid,1,null,'string',null,null),
('Comments','Comments','Comments','text',@newdsid,1,null,'string',null,null),
('Files','Attachments','Files','file',@newdsid,1,null,'file',null,null);


insert into datasets 
(ProjectId, DefaultRowQAStatusId, DefaultActivityQAStatusId, StatusId, CreateDateTime, Name, Description, DatastoreId) 
values 
(@newprojectid, 1, 5, 1,getdate(),'Permit Events','Permit Events Form',@newdsid );

select @newdatasetid = scope_identity();


insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select
@newdatasetid, Id, FieldRoleId, getDate(), Name, DbColumnName, ControlType, null ,1
FROM Fields where DatastoreId = @newdsid;

go


ALTER TABLE [dbo].[Permits] DROP COLUMN [OccupationalGroup];
go
ALTER TABLE [dbo].[Permits] ADD [OccupancyGroup] [nvarchar](max)
go

update fields 
set 
Name = 'Occupancy Group',
Description = 'Occupancy Group',
DbColumnName = 'OccupancyGroup'
where 
dbcolumnname = 'OccupationalGroup';

update datasetfields 
set 
Label = 'Occupancy Group',
DbColumnName = 'OccupancyGroup'
where 
dbcolumnname = 'OccupationalGroup';
go

ALTER TABLE [dbo].[Permits] DROP COLUMN [FindingDate];
ALTER TABLE [dbo].[Permits] DROP COLUMN [Finding];
go
ALTER TABLE [dbo].[Permits] ADD [FileStatus] [nvarchar](max)
go

update fields 
set 
Name = 'File Status',
Description = 'File Status',
DbColumnName = 'FileStatus'
where 
dbcolumnname = 'Finding';

update datasetfields 
set 
Label = 'File Status',
DbColumnName = 'FileStatus'
where 
dbcolumnname = 'Finding';
go

-- now for metadata fields for permit
DECLARE @newentityid int = 0;
insert into MetadataEntities (Name, Description) values ('Permit Fields','Permit lookup fields');
select @newentityid = scope_identity();

insert into MetadataProperties (metadataentityid, name, description, datatype, controltype, possiblevalues)
values
(@newentityid,'ImprovementType','Improvement Type','string','select','["(RETIRED) Mobile Home – Placement",
"(RETIRED) Mobile Home – Replacement",
"Access. Building",
"Addition",
"AG Exempt",
"Communication Tower – New",
"Communication Tower–Improvement",
"Electrical",
"Forest Practice",
"Home - New",
"Home Occupation",
"Land Division",
"Manufactured Commercial–Placement",
"Manufactured Home–Placement",
"Manufactured Home–Replacement",
"Mechanical",
"New Commercial Construction",
"Other",
"Plumbing",
"Remodel",
"SDP Construction",
"SDP Major Repair",
"SDP Minor Repair",
"SDP Site Assessment",
"Sign",
"Utility Pole/line",
"Zone Change - Code",
"Zone Change–Map"]'),
(@newentityid,'IssuedBy','Issued By','string','select','["Dani Schulte","Holly Anderson"]'),
(@newentityid,'ReviewedBy','Reviewed By','string','select','["Dani Schulte","Holly Anderson"]'),
(@newentityid,'PermitStatus','Permit Status','string','select','["Under Review", "Approved", "Conditionally Approved", "Denied","Incomplete","Cancelled", "Archived"]'),
(@newentityid,'FileStatus','File Status','string','select','["Active", "Inactive", "Archived"]'),
(@newentityid,'FeePaymentType','Fee Payment Type','string','select','["Finance Office","Permit Office"]'),
(@newentityid,'FeePaymentMethod','Fee Payment Method','string','select','["Cash","Check","Credit","PO"]'),
(@newentityid,'BuildingUse','Building Use','string','select','["Residential","Commercial","Industrial"]'),
(@newentityid,'OccupancyGroup','Occupancy Group','string','select','["A-1","A-2","A-3","A-4","A-5","B","E","F-1","F-2","H-1","H-2","H-3","H-4","H-5","I-1","I-2","I-3","I-4","M","R-1","R-2","R-3","R-4","S-1","S-2","U"]'),
(@newentityid,'ConstructionType','Construction Type','string','select','["VA",
"IIA",
"II",
"1-B",
"VB",
"IB",
"IIB",
"V-N",
"V"]'),
(@newentityid,'COStatus','CO Status','string','select','["Yes","No","N/A"]');

go

update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 52' where datastoreid = 33 and dbColumnname = 'ImprovementType';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 62' where datastoreid = 33 and dbColumnname = 'COStatus';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 61' where datastoreid = 33 and dbColumnname = 'ConstructionType';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 60' where datastoreid = 33 and dbColumnname = 'OccupancyGroup';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 59' where datastoreid = 33 and dbColumnname = 'BuildingUse';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 58' where datastoreid = 33 and dbColumnname = 'FeePaymentMethod';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 57' where datastoreid = 33 and dbColumnname = 'FeePaymentType';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 56' where datastoreid = 33 and dbColumnname = 'FileStatus';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 55' where datastoreid = 33 and dbColumnname = 'PermitStatus';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 54' where datastoreid = 33 and dbColumnname = 'ReviewedBy';
update fields set possiblevalues = null, datasource='select possiblevalues from metadataproperties where id = 53' where datastoreid = 33 and dbColumnname = 'IssuedBy';
go
