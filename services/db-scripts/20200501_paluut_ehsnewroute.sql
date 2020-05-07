-- Add fire dept route to EHS Inspection Violations

update fields set possiblevalues = '["CRPP","BIA","DCFS","Planning","Public Safety","Yellowhawk","Water Resources","Fire Dept"]' where datastoreid = 39 and dbcolumnname = 'NotifyRoutes'

insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','Fire Dept',0,'RobBurnside@ctuir.org');
insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','CRPP',0,'CareyMiller@ctuir.org');
insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','BIA',0,'Michael.Jackson@bia.gov');
insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','DCFS',0,'TonyBarnett@ctuir.org');
insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','Planning',0,'LoraElliott@ctuir.org');
insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','Public Safety',0,'utpd@ctuir.org');
--insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','Yellowhawk',0,'Colee@ctuir.org');
insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','Water Resources',0,'CraigKvern@ctuir.org');
insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','Water Resources',1,'RobinHarris@ctuir.org');


