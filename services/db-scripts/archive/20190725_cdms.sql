
--note: this creates the table. the rows will need to be imported manually either from the .csv or select into from the PALUUT_DEV_KEN table.
CREATE TABLE [dbo].[PermitZones] (
    [Id] [int] NOT NULL IDENTITY,
    [ZoneCode] [nvarchar](max),
    CONSTRAINT [PK_dbo.PermitZones] PRIMARY KEY ([Id])
)

go


ALTER view PermitCadaster_VW as
select cad.ObjectId, cad.Allotment, cad.ParcelId, cad.Ownerships, cad.Taxlot, cad.Geosource, cad.Datasource, cad.Comment, cad.Address, cad.Acres_GIS, cad.Acres_cty, cad.PLSS, cad.PLSS2, cad.PLSS3, cad.PLSS_Label, cad.Last_Edited_Date, z.ZoneCode 
from OPENQUERY([GIS-SQL],'select * from sdevector.sde.Cadaster_evw') cad
left outer join PermitZones z on cad.ObjectId = z.Id;
go

-- convert result field to a group

delete from metadataproperties where name = 'ReviewResult';
go

--- ABOVE UPDATED ON TEST 7/26

--- ABOVE UPDATED ON TEST 7/29

-- ABOVE UPDATED ON TEST 8/1/19