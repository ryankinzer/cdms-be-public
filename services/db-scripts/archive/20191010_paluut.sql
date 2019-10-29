-- Run on PALUUT_TEST as of 10/15/19

-- set default for inactive column
alter table permitpersons add constraint df_inactive default 0 for inactive




-- create metric field for cb fish metrics dropdown --------------------------------------- BEGIN

-- create a table that stores the dropdown values
CREATE TABLE [dbo].[Metrics_CBFishMetrics] (
    [Id] [int] NOT NULL IDENTITY,
    [CBFishId] [int] NULL,
    [MetricName] VarChar(255) NULL,
    CONSTRAINT [PK_dbo.Metrics_CBFishMetrics] PRIMARY KEY ([Id])
);
go

-- create the cdms datastore for it (so we can use the new table editor in the future)
DECLARE @newdsid int = 0;

INSERT into Datastores (Name, Description, TablePrefix, OwnerUserId, DefaultConfig)
values ('Metrics_CBFishMetrics', 'Habitat CB Fish metrics for dropdown','Metrics_CBFishMetrics', 1, '{"ActivitiesPage":{"Route":"table"}}');
select @newdsid = scope_identity();

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('CBFishId','CBFishId','CB Fish Metrics Id','number',@newdsid,1,null,'int',null,null),
('MetricName','MetricName','MetricName','text',@newdsid,1,null,'string',null,null);

go

ALTER TABLE [dbo].[Metrics_Detail] ADD ReportingMetric nvarchar(max);
go


-- now add the ReportingMetric field to the metrics datastore and all existing metrics datasets
DECLARE @metricsdatastoreid int = 0;
DECLARE @fieldid int = 0;

set @metricsdatastoreid = (select Id from Datastores where Name = 'Metrics');

insert into Fields (DbColumnName, Name, Description, ControlType, DatastoreId, FieldRoleId, DataSource, DataType,PossibleValues,Validation) 	
values 
('ReportingMetric','Reporting Metric','Reporting Metric','select',@metricsdatastoreid,2,'select MetricName as Id, MetricName as Label from Metrics_CBFishMetrics','string',null,null);

select @fieldid = scope_identity();

-- add the field to each dataset in Metrics
insert into DatasetFields 
(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, ControlType,InstrumentId,SourceId) 
select d.Id as DatasetId, f.Id as FieldId, f.FieldRoleId, getDate(), f.Name, f.DbColumnName, f.ControlType,  null, 1
from datasets d join fields f on f.Id = @fieldid
where d.datastoreid = @metricsdatastoreid

go

-- add in the data for the ReportingMetrics dropdown
INSERT INTO Metrics_CBFishMetrics (CBFishId, MetricName) VALUES
('1438','# of miles of primary stream reach improvement'),
('1439','# of miles of total stream reach improvement'),
('1440','Amount of unprotected water flow returned to the stream by conservation in acre-feet/year'),
('1451','Amount of unprotected water flow returned to the stream by conservation in cubic-feet per second (cfs)'),
('1387','# of miles of stream with improved complexity'),
('1388','# of structures installed'),
('1401','# of miles of fence installed in a riparian area'),
('1402','# of miles of fence installed in an upland area'),
('1403','# of riparian acres treated'),
('1404','# of upland acres treated'),
('1405','# of wetland acres treated'),
('1406','# of riparian miles treated'),
('1447','# of students reached'),
('1448','# of general public reached'),
('1449','# of teachers reached'),
('1441','# of miles of habitat accessed to the next upstream barrier(s) or likely limit of habitable range'),
('1488','# of river miles treated'),
('1517','# of acres of riparian non-wetland habitat treated'),
('1518','# of acres of riparian wetland habitat treated'),
('1519','# of acres of freshwater non-wetland habitat treated'),
('1520','# of acres of freshwater wetland habitat treated'),
('1521','# of acres of estuarine wetland habitat treated'),
('1522','# of acres of estuarine non-wetland habitat treated'),
('1563','# of barriers in the freshwater zone'),
('1564','# of barriers in the estuarine zone'),
('1565','# of miles of dike removed or modified in the freshwater area'),
('1566','# of miles of dike removed or modified in the estuary area'),
('1567','# of miles of dike removed or modified in the riparian area'),
('1546','# of miles of fence installed in an estuarine area'),
('1549','# of miles of left streambank fenced in a freshwater area'),
('1550','# of miles of left streambank fenced in an estuarine area'),
('1551','# of miles of right streambank fenced in a freshwater area'),
('1552','# of miles of right streambank fenced in an estuarine area'),
('1758','# of acres of upland non-wetland habitat protected by fencing'),
('1759','# of acres of upland wetland habitat protected by fencing'),
('1760','# of acres of riparian non-wetland habitat protected by fencing'),
('1761','# of acres of riparian wetland habitat protected by fencing'),
('1762','# of acres of estuarine wetland habitat protected by fencing'),
('1763','# of acres of estuarine non-wetland habitat protected by fencing'),
('1515','# of acres of upland non-wetland habitat treated'),
('1516','# of acres of upland wetland habitat treated'),
('1480','# of screens addressed'),
('1734','# of acres maintained'),
('1723','# of years treated'),
('1731','# of miles of streambank protected by fence maintenance'),
('1733','# of acres protected by fence maintenance'),
('1547','# of miles of stream treated with spawning gravel'),
('1594','# of anchored individual log structures (not logjams) installed for both stabilization and complexity'),
('1595','# of logjam structures installed for both stabilization and complexity'),
('1596','# of unanchored rocks/boulder structures installed for both stabilization and complexity'),
('1598','# of log weir structures installed for both stabilization and complexity'),
('1602','# of revetment/rip rap/other structures installed for both stabilization and complexity'),
('1730','# of miles of dike removed or treated'),
('1626','# of other exclusion structures'),
('1743','Average buffer width'),
('1647','# of small scale push-up or diversion dam partial passage barriers in the freshwater non-tidal zone'),
('1636','# of estuarine miles treated'),
('1637','# of freshwater miles treated'),
('1571','# of unanchored individual log structures (not logjams) installed for only stabilization'),
('1573','# of logjam structures installed for only stabilization'),
('1582','# of unanchored individual log structures (not logjams) installed for only complexity'),
('1584','# of logjam structures installed for only complexity'),
('1593','# of unanchored individual log structures (not logjams) installed for both stabilization and complexity'),
('1748','# of pools created for only complexity'),
('1752','# of miles of side channel treated in the freshwater non-tidal zone'),
('1754','# of miles of side channel created in the freshwater non-tidal zone'),
('1673','# of acres of habitat treated by full dike removal in the Estuarine zone'),
('1676','# of acres of habitat treated by dike breaching in the Estuarine zone'),
('1679','# of acres of habitat treated by dike setbacks in the Estuarine zone'),
('1684','# of miles of dike removed or modified by Full removal in the Estuarine zone'),
('1685','# of miles of dike removed or modified by Dike breaching in the Estuarine zone'),
('1672','# of acres of habitat treated by full dike removal in the Riparian zone'),
('1674','# of acres of habitat treated by full dike removal in the Freshwater Non-Tidal zone'),
('1675','# of acres of habitat treated by dike breaching in the Riparian zone'),
('1677','# of acres of habitat treated by dike breaching in the Freshwater Non-Tidal zone'),
('1678','# of acres of habitat treated by dike setbacks in the Riparian zone'),
('1680','# of acres of habitat treated by dike setbacks in the Freshwater Non-Tidal zone'),
('1681','# of miles of dike removed or modified by Full removal in the Riparian zone'),
('1711','# of bridges installed in the freshwater non-tidal zone'),
('1714','# of fish ladders installed in the freshwater non-tidal zone'),
('1753','# of miles of main channel treated in the freshwater non-tidal zone'),
('1755','# of miles of main channel created in the freshwater non-tidal zone'),
('1452','Amount of water secured in acre-feet/year'),
('1453','Flow of water returned to the stream as prescribed in the water acquisition in cubic-feet per second (cfs)'),
('1526','# of acres of riparian non-wetland habitat protected'),
('1724','# of miles of streambank protected'),
('1587','# of log weir structures installed for only complexity'),
('1585','# of unanchored rocks/boulder structures installed for only complexity'),
('1379','# of riparian miles protected'),
('1380','# of riparian acres protected'),
('1445','# of upland acres protected'),
('1446','# of wetland acres protected'),
('1599','# of rock weir structures installed for both stabilization and complexity'),
('1667','# of culvert partial passage barriers removed in the freshwater non-tidal zone'),
('1766','# of alternate water sources installed in the riparian'),
('1574','# of unanchored rocks/boulder structures installed for only stabilization'),
('1577','# of rock weir structures installed for only stabilization'),
('1588','# of rock weir structures installed for only complexity'),
('1747','# of pools created for only stabilization'),
('1709','# of culverts installed in the freshwater non-tidal zone'),
('1625','# of cattle guards installed'),
('1624','# of water gaps'),
('1765','# of alternate water sources installed in the upland'),
('1400','# of features developed'),
('1572','# of anchored individual log structures (not logjams) installed for only stabilization'),
('1583','# of anchored individual log structures (not logjams) installed for only complexity'),
('1579','# of deflector/barb structures installed for only stabilization'),
('1581','# of rootwad structures installed for only stabilization'),
('1592','# of rootwad structures installed for only complexity'),
('1690','# of acres of riparian habitat created'),
('1527','# of acres of riparian wetland habitat protected'),
('1482','# of miles of road or trail created/relocated in the riparian zone'),
('1523','Average width of treatment'),
('1607','# of miles of road or trail scarified/ripped in the riparian zone'),
('1608','# of miles of road or trail recontoured in the riparian zone'),
('1601','# of deflector/barb structures installed for both stabilization and complexity'),
('1698','# of acres of freshwater non-tidal habitat rehabilitated/enhanced'),
('1749','# of pools created for both stabilization and complexity'),
('1603','# of rootwad structures installed for both stabilization and complexity'),
('1386','# of fish transported'),
('1524','# of acres of upland non-wetland habitat protected'),
('1525','# of acres of upland wetland habitat protected'),
('1528','# of acres of freshwater non-wetland habitat protected'),
('1529','# of acres of freshwater wetland habitat protected'),
('1530','# of acres of estuarine wetland habitat protected'),
('1531','# of acres of estuarine non-wetland habitat protected'),
('1555','# of miles protected in a riparian wetland area'),
('1556','# of miles protected in a riparian non-wetland area'),
('1764','# pounds (lbs) (to nearest 100 lbs.) of trash collected'),
('1381','# of minimum estimated HUs protected for wildlife'),
('1481','# of stream kilometers credited for resident fish'),
('1655','# of small scale hydropower and diversion dam partial passage barriers in the freshwater non-tidal zone'),
('1597','# of anchored rocks/boulder structures installed for both stabilization and complexity'),
('1575','# of anchored rocks/boulder structures installed for only stabilization'),
('1586','# of anchored rocks/boulder structures installed for only complexity'),
('1682','# of miles of dike removed or modified by Dike breaching in the Riparian zone'),
('1715','# of weirs or fishway chutes or pools installed in the freshwater non-tidal zone');
go

-- create metric field for cb fish metrics dropdown --------------------------------------- END


-- update possible values for Permit Events ItemType 
update fields set possiblevalues = '[{"Id":"CRPP","Label":"CRPP","Group":"Review"},{"Id":"WRP","Label":"WRP","Group":"Review"},{"Id":"BldgCode","Label":"Bldg Code","Group":"Review"},{"Id":"Env","Label":"Env. Health","Group":"Review"},{"Id":"PubWrks","Label":"Pub. Works","Group":"Review"},{"Id":"TERO","Label":"TERO","Group":"Review"},{"Id":"Roads","Label":"County","Group":"Review"},{"Id":"Fire","Label":"Fire Dept.","Group":"Review"},{"Id":"SitePlan","Label":"Site Plan","Group":"Document"},{"Id":"OwnerAuth","Label":"Owner Auth","Group":"Document"},{"Id":"Survey","Label":"Survey","Group":"Document"},{"Id":"PhoneCall","Label":"Phone Call","Group":"Correspondence"},{"Id":"Email","Label":"Email","Group":"Correspondence"},{"Id":"InPerson","Label":"In Person","Group":"Correspondence"},{"Id":"Finance","Label":"Finance","Group":"Finance"},{"Id":"Structural","Label":"Structural","Group":"Inspection"},{"Id":"Electrical","Label":"Electrical","Group":"Inspection"},{"Id":"Plumbing","Label":"Plumbing","Group":"Inspection"},{"Id":"Mechanical","Label":"Mechanical","Group":"Inspection"},{"Id":"Final","Label":"Final","Group":"Inspection"},{"Id":"Other","Label":"Other","Group":"Other"}]' where datastoreid =34 and dbcolumnname = 'ItemType';

-- change FeeReceivedBy to a dropdown from metadata
DECLARE @entityid int = 0;
DECLARE @propertyid int = 0;

set @entityid = (select Id from metadataentities where [Name] = 'Permit Fields');

insert into metadataproperties (metadataentityid, [Name], description, Datatype, possiblevalues) VALUES
(@entityid, 'FeeReceivedBy', 'Fee Received By', 'string','["Leslie Cain","Dani Schulte"]');

set @propertyid = scope_identity();

update fields set controltype = 'select', datasource = concat('select possiblevalues from metadataproperties where id = ',@propertyid) where dbcolumnname = 'FeeReceivedBy' and DatastoreId = 33;
update datasetfields set controltype = 'select' where dbcolumnname = 'FeeReceivedBy' and datasetid = 1281
go

--fix an error in some possible values I noticed: 
update fields set possiblevalues = '["Yes", "No"]' where possiblevalues = '["Yes", "No]';

-- create rule for address length
update fields set [rule] = '{"OnValidate":"if (value.length>32) row_errors.push(''[SiteAddress] Address must be less than 32 characters'')"}' where datastoreid = 33 and DbColumnName = 'SiteAddress';
go

--remove Legal Description field
delete from datasetfields where dbcolumnname = 'LegalDescription' and datasetid = 1281;
go
