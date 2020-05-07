-- Add fire dept route to EHS Inspection Violations

update fields set possiblevalues = '["CRPP","BIA","CRPP","DCFS","Planning","Public Safety","Yellowhawk","Water Resources","Fire Dept"]' where datastoreid = 39 and dbcolumnname = 'NotifyRoutes'

insert into PermitRoutes (EventType, ItemType, Rank, Email) values ('EHSInspectionViolation','Fire Dept',0,'RobBurnside@ctuir.org');

