﻿-- allow historical permit parcels
ALTER TABLE PermitParcels ALTER COLUMN ObjectId Int NULL;

-- recreate the Metrics_CBFish table with the additional columns from Mike Lambert
DROP TABLE Metrics_CBFishMetrics;

CREATE TABLE [dbo].[Metrics_CBFishMetrics] (
    [Id] [int] NOT NULL IDENTITY,
    [CBFishId] [int] NULL,
    [MetricName] VarChar(255) NULL,
    [MetricPriority] VarChar(255) NULL,
    [MetricMeasures] VarChar(255) NULL,
    CONSTRAINT [PK_dbo.Metrics_CBFishMetrics] PRIMARY KEY ([Id])
);
go

INSERT INTO Metrics_CBFishMetrics (MetricPriority, CBFishId, MetricName, MetricMeasures) VALUES 
('Primary',1379,'# of riparian miles protected','miles protected by purchase or lease, miles of stream protected in riparian areas'),
('Primary',1380,'# of riparian acres protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Secondary',1381,'# of minimum estimated HUs protected for wildlife',''),
('Secondary',1386,'# of fish transported','fish transported'),
('Primary',1387,'# of miles of stream with improved complexity','miles of stream with improved complexity'),
('Primary',1388,'# of structures installed','structures installed'),
('Primary',1400,'# of features developed','features developed'),
('Secondary',1401,'# of miles of fence installed in a riparian area','miles of fence installed'),
('Secondary',1402,'# of miles of fence installed in an upland area','miles of fence installed'),
('Primary',1403,'# of riparian acres treated','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1404,'# of upland acres treated','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1405,'# of wetland acres treated','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1406,'# of riparian miles treated','miles treated, miles of stream improved in riparian areas'),
('Primary',1438,'# of miles of primary stream reach improvement','miles of primary stream reach improved, miles of stream improved in riparian areas'),
('Primary',1439,'# of miles of total stream reach improvement','miles of total stream reach improved'),
('Primary',1440,'Amount of unprotected water flow returned to the stream by conservation in acre-feet/year','acre-feet/year of water conserved, acre-feet/year of water protected and conserved'),
('Primary',1441,'# of miles of habitat accessed to the next upstream barrier(s) or likely limit of habitable range','miles of habitat accessed'),
('Primary',1445,'# of upland acres protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Primary',1446,'# of wetland acres protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Secondary',1447,'# of students reached','people educated or contacted'),
('Secondary',1448,'# of general public reached','people educated or contacted'),
('Secondary',1449,'# of teachers reached','people educated or contacted'),
('Primary',1451,'Amount of unprotected water flow returned to the stream by conservation in cubic-feet per second (cfs)','cubic-feet per second (cfs) of water flow conserved'),
('Primary',1452,'Amount of water secured in acre-feet/year','acre-feet/year of water protected, acre-feet/year of water protected and conserved'),
('Primary',1453,'Flow of water returned to the stream as prescribed in the water acquisition in cubic-feet per second (cfs)','cubic-feet per second (cfs) of water flow protected'),
('Primary',1480,'# of screens addressed','screens addressed, screens installed or addressed'),
('Secondary',1481,'# of stream kilometers credited for resident fish','kilometers of stream credited'),
('Secondary',1482,'# of miles of road or trail created/relocated in the riparian zone','miles of road or trail relocated'),
('Primary',1488,'# of river miles treated','miles of stream fenced, miles of stream protected in riparian areas'),
('Primary',1515,'# of acres of upland non-wetland habitat treated','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1516,'# of acres of upland wetland habitat treated','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1517,'# of acres of riparian non-wetland habitat treated','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1518,'# of acres of riparian wetland habitat treated','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1519,'# of acres of freshwater non-wetland habitat treated','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1520,'# of acres of freshwater wetland habitat treated','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1521,'# of acres of estuarine wetland habitat treated','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1522,'# of acres of estuarine non-wetland habitat treated','acres treated, acres treated instream, acres improved in riparian areas'),
('Secondary',1523,'Average width of treatment','area (foot-miles) of road improved or decommissioned, area (foot-miles) of enhanced nutrients'),
('Primary',1524,'# of acres of upland non-wetland habitat protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Primary',1525,'# of acres of upland wetland habitat protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Primary',1526,'# of acres of riparian non-wetland habitat protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Primary',1527,'# of acres of riparian wetland habitat protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Primary',1528,'# of acres of freshwater non-wetland habitat protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Primary',1529,'# of acres of freshwater wetland habitat protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Primary',1530,'# of acres of estuarine wetland habitat protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Primary',1531,'# of acres of estuarine non-wetland habitat protected','acres protected by purchase or lease, acres protected in riparian areas'),
('Secondary',1546,'# of miles of fence installed in an estuarine area','miles of fence installed'),
('Secondary',1547,'# of miles of stream treated with spawning gravel','miles of stream treated with spawning gravel'),
('Secondary',1549,'# of miles of left streambank fenced in a freshwater area','miles of stream fenced, miles of stream protected in riparian areas'),
('Secondary',1550,'# of miles of left streambank fenced in an estuarine area','miles of stream fenced, miles of stream protected in riparian areas'),
('Secondary',1551,'# of miles of right streambank fenced in a freshwater area','miles of stream fenced, miles of stream protected in riparian areas'),
('Secondary',1552,'# of miles of right streambank fenced in an estuarine area','miles of stream fenced, miles of stream protected in riparian areas'),
('Primary',1555,'# of miles protected in a riparian wetland area','miles protected by purchase or lease, miles of stream protected in riparian areas'),
('Primary',1556,'# of miles protected in a riparian non-wetland area','miles protected by purchase or lease, miles of stream protected in riparian areas'),
('Secondary',1563,'# of barriers in the freshwater zone',''),
('Secondary',1564,'# of barriers in the estuarine zone',''),
('Secondary',1565,'# of miles of dike removed or modified in the freshwater area','miles of dike removed or modified'),
('Secondary',1566,'# of miles of dike removed or modified in the estuary area','miles of dike removed or modified'),
('Secondary',1567,'# of miles of dike removed or modified in the riparian area','miles of dike removed or modified'),
('Primary',1571,'# of unanchored individual log structures (not logjams) installed for only stabilization','structures installed'),
('Primary',1572,'# of anchored individual log structures (not logjams) installed for only stabilization','structures installed'),
('Primary',1573,'# of logjam structures installed for only stabilization','structures installed'),
('Primary',1574,'# of unanchored rocks/boulder structures installed for only stabilization','structures installed'),
('Primary',1575,'# of anchored rocks/boulder structures installed for only stabilization','structures installed'),
('Primary',1577,'# of rock weir structures installed for only stabilization','structures installed'),
('Primary',1579,'# of deflector/barb structures installed for only stabilization','structures installed'),
('Primary',1581,'# of rootwad structures installed for only stabilization','structures installed'),
('Primary',1582,'# of unanchored individual log structures (not logjams) installed for only complexity','structures installed'),
('Primary',1583,'# of anchored individual log structures (not logjams) installed for only complexity','structures installed'),
('Primary',1584,'# of logjam structures installed for only complexity','structures installed'),
('Primary',1585,'# of unanchored rocks/boulder structures installed for only complexity','structures installed'),
('Primary',1586,'# of anchored rocks/boulder structures installed for only complexity','structures installed'),
('Primary',1587,'# of log weir structures installed for only complexity','structures installed'),
('Primary',1588,'# of rock weir structures installed for only complexity','structures installed'),
('Primary',1592,'# of rootwad structures installed for only complexity','structures installed'),
('Primary',1593,'# of unanchored individual log structures (not logjams) installed for both stabilization and complexity','structures installed'),
('Primary',1594,'# of anchored individual log structures (not logjams) installed for both stabilization and complexity','structures installed'),
('Primary',1595,'# of logjam structures installed for both stabilization and complexity','structures installed'),
('Primary',1596,'# of unanchored rocks/boulder structures installed for both stabilization and complexity','structures installed'),
('Primary',1597,'# of anchored rocks/boulder structures installed for both stabilization and complexity','structures installed'),
('Primary',1598,'# of log weir structures installed for both stabilization and complexity','structures installed'),
('Primary',1599,'# of rock weir structures installed for both stabilization and complexity','structures installed'),
('Primary',1601,'# of deflector/barb structures installed for both stabilization and complexity','structures installed'),
('Primary',1602,'# of revetment/rip rap/other structures installed for both stabilization and complexity','structures installed'),
('Primary',1603,'# of rootwad structures installed for both stabilization and complexity','structures installed'),
('Secondary',1607,'# of miles of road or trail scarified/ripped in the riparian zone','miles of road or trail improved or decommissioned'),
('Secondary',1608,'# of miles of road or trail recontoured in the riparian zone','miles of road or trail improved or decommissioned'),
('Secondary',1624,'# of water gaps','# of Livestock Exclusion Types'),
('Secondary',1625,'# of cattle guards installed','# of Livestock Exclusion Types'),
('Secondary',1626,'# of other exclusion structures','# of Livestock Exclusion Types'),
('Secondary',1636,'# of estuarine miles treated','miles treated, miles of stream improved in riparian areas'),
('Primary',1637,'# of freshwater miles treated','miles treated, miles of stream improved in riparian areas'),
('Primary',1647,'# of small scale push-up or diversion dam partial passage barriers in the freshwater non-tidal zone','barriers removed'),
('Primary',1655,'# of small scale hydropower and diversion dam partial passage barriers in the freshwater non-tidal zone','barriers removed'),
('Primary',1667,'# of culvert partial passage barriers removed in the freshwater non-tidal zone','barriers removed'),
('Primary',1672,'# of acres of habitat treated by full dike removal in the Riparian zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1673,'# of acres of habitat treated by full dike removal in the Estuarine zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1674,'# of acres of habitat treated by full dike removal in the Freshwater Non-Tidal zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1675,'# of acres of habitat treated by dike breaching in the Riparian zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1676,'# of acres of habitat treated by dike breaching in the Estuarine zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1677,'# of acres of habitat treated by dike breaching in the Freshwater Non-Tidal zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1678,'# of acres of habitat treated by dike setbacks in the Riparian zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1679,'# of acres of habitat treated by dike setbacks in the Estuarine zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Primary',1680,'# of acres of habitat treated by dike setbacks in the Freshwater Non-Tidal zone','acres improved in various ways, acres treated instream, acres improved in riparian areas'),
('Secondary',1681,'# of miles of dike removed or modified by Full removal in the Riparian zone','miles of dike removed or modified'),
('Secondary',1682,'# of miles of dike removed or modified by Dike breaching in the Riparian zone','miles of dike removed or modified'),
('Secondary',1684,'# of miles of dike removed or modified by Full removal in the Estuarine zone','miles of dike removed or modified'),
('Secondary',1685,'# of miles of dike removed or modified by Dike breaching in the Estuarine zone','miles of dike removed or modified'),
('Primary',1690,'# of acres of riparian habitat created','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1698,'# of acres of freshwater non-tidal habitat rehabilitated/enhanced','acres treated, acres treated instream, acres improved in riparian areas'),
('Primary',1709,'# of culverts installed in the freshwater non-tidal zone','barriers improved'),
('Primary',1711,'# of bridges installed in the freshwater non-tidal zone','barriers improved'),
('Primary',1714,'# of fish ladders installed in the freshwater non-tidal zone','barriers improved'),
('Primary',1715,'# of weirs or fishway chutes or pools installed in the freshwater non-tidal zone','barriers improved'),
('Secondary',1723,'# of years treated',''),
('Secondary',1724,'# of miles of streambank protected','miles protected by purchase or lease, miles of stream protected in riparian areas'),
('Secondary',1730,'# of miles of dike removed or treated',''),
('Secondary',1731,'# of miles of streambank protected by fence maintenance',''),
('Primary',1733,'# of acres protected by fence maintenance',''),
('Secondary',1734,'# of acres maintained',''),
('Secondary',1743,'Average buffer width',''),
('Secondary',1747,'# of pools created for only stabilization','pools created'),
('Secondary',1748,'# of pools created for only complexity','pools created'),
('Secondary',1749,'# of pools created for both stabilization and complexity','pools created'),
('Primary',1752,'# of miles of side channel treated in the freshwater non-tidal zone','miles of stream with improved channel form'),
('Primary',1753,'# of miles of main channel treated in the freshwater non-tidal zone','miles of stream with improved channel form'),
('Primary',1754,'# of miles of side channel created in the freshwater non-tidal zone','miles of stream with improved channel form'),
('Primary',1755,'# of miles of main channel created in the freshwater non-tidal zone','miles of stream with improved channel form'),
('Priority',1758,'# of acres of upland non-wetland habitat protected by fencing','acres protected by fencing, acres protected in riparian areas'),
('Priority',1759,'# of acres of upland wetland habitat protected by fencing','acres protected by fencing, acres protected in riparian areas'),
('Priority',1760,'# of acres of riparian non-wetland habitat protected by fencing','acres protected by fencing, acres protected in riparian areas'),
('Priority',1761,'# of acres of riparian wetland habitat protected by fencing','acres protected by fencing, acres protected in riparian areas'),
('Secondary',1762,'# of acres of estuarine wetland habitat protected by fencing','acres protected by fencing, acres protected in riparian areas'),
('Secondary',1763,'# of acres of estuarine non-wetland habitat protected by fencing','acres protected by fencing, acres protected in riparian areas'),
('Secondary',1764,'# pounds (lbs) (to nearest 100 lbs.) of trash collected','pounds of trash collected'),
('Secondary',1765,'# of alternate water sources installed in the upland','erosion control structures or water sources installed'),
('Secondary',1766,'# of alternate water sources installed in the riparian','erosion control structures or water sources installed')

go

-- remove RVTouchstone and ReportingLevel dataset fields from all datasets
delete from datasetfields where fieldid in (select id from fields where dbcolumnname in ('RVTouchstone', 'ReportingLevel'));
go

-- RAN ON TEST 10/31 (not on PROD)


