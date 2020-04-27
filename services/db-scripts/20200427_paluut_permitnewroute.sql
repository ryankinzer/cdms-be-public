-- add Fire as a route

update fields set possiblevalues = '["CRPP","WRP","BldgCode","Env","PubWrks","TERO","Roads", "Fire"]' where dbcolumnname = 'ReviewsRequired' and datastoreid = 33;
alter table Permits add Route_Fire nvarchar(max);
