-- PALUUT: updates for permit module + columnindex for datasetfields (kb)

-- add columnindex field to datasetfields for grouping fields in the UI
ALTER TABLE [dbo].[DatasetFields] ADD [ColumnIndex] [int]

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
    [ParcelNumber] [nvarchar](max),
    [AllotmentNumber] [nvarchar](max),
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
select * from datastores