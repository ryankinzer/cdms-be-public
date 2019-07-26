
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


-- cadaster view and permit parcels table
-- NOTE: I created a GIS-SQL linked server on the DMZ-SQL for this and have to use this method to call the query because of:
-- http://www.sql-server-helper.com/error-messages/msg-7325.aspx


-- NOTE ::: There are two versions of this - one that runs on DEV02 and one that runs on PALUUT or PALUUT_TEST

-- NOTE::: when running on DEV02:
ALTER view PermitCadaster_VW as
select cad.ObjectId, cad.Allotment, cad.ParcelId, cad.Ownerships, cad.Taxlot, cad.Geosource, cad.Datasource, cad.Comment, cad.Address, cad.Acres_GIS, cad.Acres_cty, cad.PLSS, cad.PLSS2, cad.PLSS3, cad.PLSS_Label, cad.Last_Edited_Date, z.ZoneCode 
from sdevector.sde.Cadaster_evw cad
left outer join PermitZones z on cad.ObjectId = z.Id
go

--:: when running on PALUUT or PALUUT_TEST
ALTER view PermitCadaster_VW as
-- cadaster view and permit parcels table
-- NOTE: I created a GIS-SQL linked server on the DMZ-SQL for this and have to use this method to call the query because of:
-- http://www.sql-server-helper.com/error-messages/msg-7325.aspx

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

--- UPDATED ON TEST 7/26