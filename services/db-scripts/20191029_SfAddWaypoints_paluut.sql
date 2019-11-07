use paluut_dev_geo
go

--Up
--Update tables
ALTER TABLE [dbo].[SnorkelFish_Detail] ADD [WaypointNumber] [int]

--Update views
drop view dbo.SnorkelFish_Detail_VW
go
create view dbo.SnorkelFish_Detail_VW
as
SELECT        Id, FishID, ChannelUnitNumber, Lane, FishCount, Species, SizeClass, NaturalWoodUsed, PlacedWoodUsed, NaturalBoulderUsed, PlacedBoulderUsed, NaturalOffChannelUsed, CreatedOffChannelUsed, NewSideChannelUsed, 
                         NoStructureUsed, FieldNotes, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt, NoSnorklers, Type, ChannelAverageDepth, ChannelLength, ChannelWidth, ChannelMaxDepth, UnidentifiedSalmonID, OtherSpeciesPres, 
                         AmbientTemp, MinimumTemp, ChannelUnitType, AEMHabitatType, AEMLength, Unit, GPSEasting, GPSNorthing, WaypointNumber
FROM            dbo.SnorkelFish_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.SnorkelFish_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
go


drop view dbo.SnorkelFish_vw
go
create view dbo.SnorkelFish_vw
as
SELECT        h.Team, h.NoteTaker, h.StartTime, h.EndTime, h.StartWaterTemp, h.Visibility, h.WeatherConditions, h.VisitId, h.Comments, h.CollectionType, h.DominantSpecies, h.CommonSpecies, h.RareSpecies, iif(h.IsAEM = 'YES', 
                         AEMHabitatType, ChannelUnitType) AS UnitType, h.IsAEM, h.HabitatVisitId, h.EndWaterTemp, h.Protocol, d.NoSnorklers, d.FishID, d.ChannelUnitNumber, d.Lane, d.Type, d.ChannelAverageDepth, d.ChannelLength, 
                         d.ChannelWidth, d.ChannelMaxDepth, d.Unit, d.ChannelLength * d.ChannelWidth AS ChannelArea, d.FishCount, d.Species, d.SizeClass, d.UnidentifiedSalmonID, d.OtherSpeciesPres, d.NaturalWoodUsed, 
                         d.PlacedWoodUsed, d.NaturalBoulderUsed, d.PlacedBoulderUsed, d.NaturalOffChannelUsed, d.CreatedOffChannelUsed, d.NewSideChannelUsed, d.NoStructureUsed, d.AmbientTemp, d.MinimumTemp, d.FieldNotes, 
                         d.ChannelUnitType, d.AEMHabitatType, d.AEMLength, d.RowId, d.RowStatusId, d.QAStatusId, d.GPSEasting, d.GPSNorthing, d.WaypointNumber, a.id AS ActivityId, a.DatasetId, a.InstrumentId, a.LaboratoryId, a.ActivityDate, a.CreateDate, 
                         w.id AS WaterbodyId, w.name AS WaterbodyName, l.id AS LocationId, l.Label AS LocationLabel, aq.QAStatusName AS QAStatusName, aq.Comments AS ActivityQAComments, aq.QAStatusId AS ActivityQAStatusId
FROM            dbo.Activities AS a INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                         dbo.SnorkelFish_Header_VW AS h ON h.ActivityId = a.Id INNER JOIN
                         dbo.Datasets AS ds ON ds.Id = a.DatasetId INNER JOIN
                         dbo.Locations AS l ON l.Id = a.LocationId INNER JOIN
                         dbo.WaterBodies AS w ON w.Id = l.WaterBodyId RIGHT OUTER JOIN
                         dbo.SnorkelFish_Detail_VW AS d ON d.ActivityId = a.Id
go


--Add the data
insert into dbo.Fields([Name], [Description], Units, [Validation], DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId, FieldRoleId)
values
(
	'Waypoint Number', 
	'Waypoint Number as assigned by the GPS device',
	null, 
	null,
	'int', 
	null, 
	'{"OnChange": "if(scope.waypoints){var w=scope.waypoints[value]; if(w){row[''NorthingUTM'']=w.y;row[''EastingUTM'']=w.x;}}"}',
	'WaypointNumber',
	'number',
	(select Id from dbo.Datastores where TablePrefix = 'SnorkelFish'),
	2
),
(
	'Waypoints File',
	'Upload a copy of your waypoints file',
	null,
	null,
	null,
	null,
	null,
	null,
	'temp-waypoint-file',
	(select Id from dbo.Datastores where TablePrefix = 'SnorkelFish'),
	1
)

INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
values
(
	(select Id from dbo.Datasets where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'SnorkelFish') and [Name] = 'GRME-Snorkel'),
	(select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'SnorkelFish') and DbColumnName = 'WaypointNumber'),
	2,
	GetDate(),
	'Waypoint Number',
	'WaypointNumber',
	null,
	1,
	null,
	1703,
	'number',
	'{"OnChange": "if(scope.waypoints){var w=scope.waypoints[value]; if(w){row[''NorthingUTM'']=w.y;row[''EastingUTM'']=w.x;}}"}'
),
(
	(select Id from dbo.Datasets where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'SnorkelFish') and [Name] = 'GRME-Snorkel'),
	(select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'SnorkelFish') and [Name] = 'Waypoints File'),
	1,
	GetDate(),
	'Waypoints',
	null,
	1,
	null,
	60,
	'temp-waypoint-file',
	null
)


--We are only adding the Waypoint to GRME-Snorkel right now.  Leaving this in, 
/*(
	(select Id from dbo.Datasets where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'SnorkelFish') and [Name] = 'BioM-Snorkel'),
	(select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'SnorkelFish') and DbColumnName = 'WaypointNumber'),
	2,
	GetDate(),
	'Waypoint Number',
	'WaypointNumber',
	null,
	1,
	null,
	230,
	'number',
	'{"OnChange": "if(scope.waypoints){var w=scope.waypoints[value]; if(w){row[''NorthingUTM'']=w.y;row[''EastingUTM'']=w.x;}}"}'
)
*/



--Down
/*
--Remove the data
Delete from dbo.DatasetFields where DatasetId in (select Id from dbo.Datasets where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'SnorkelFish'))
and DbColumnName = 'WaypointNumber'

--Update views
drop view dbo.SnorkelFish_Detail_VW
go
create view dbo.SnorkelFish_Detail_VW
as
SELECT        Id, FishID, ChannelUnitNumber, Lane, FishCount, Species, SizeClass, NaturalWoodUsed, PlacedWoodUsed, NaturalBoulderUsed, PlacedBoulderUsed, NaturalOffChannelUsed, CreatedOffChannelUsed, NewSideChannelUsed, 
                         NoStructureUsed, FieldNotes, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt, NoSnorklers, Type, ChannelAverageDepth, ChannelLength, ChannelWidth, ChannelMaxDepth, UnidentifiedSalmonID, OtherSpeciesPres, 
                         AmbientTemp, MinimumTemp, ChannelUnitType, AEMHabitatType, AEMLength, Unit, GPSEasting, GPSNorthing
FROM            dbo.SnorkelFish_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.SnorkelFish_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
go


drop view dbo.SnorkelFish_vw
go
create view dbo.SnorkelFish_vw
as
SELECT        h.Team, h.NoteTaker, h.StartTime, h.EndTime, h.StartWaterTemp, h.Visibility, h.WeatherConditions, h.VisitId, h.Comments, h.CollectionType, h.DominantSpecies, h.CommonSpecies, h.RareSpecies, iif(h.IsAEM = 'YES', 
                         AEMHabitatType, ChannelUnitType) AS UnitType, h.IsAEM, h.HabitatVisitId, h.EndWaterTemp, h.Protocol, d .NoSnorklers, d .FishID, d .ChannelUnitNumber, d .Lane, d .Type, d .ChannelAverageDepth, d .ChannelLength, 
                         d .ChannelWidth, d .ChannelMaxDepth, d .Unit, d .ChannelLength * d .ChannelWidth AS ChannelArea, d .FishCount, d .Species, d .SizeClass, d .UnidentifiedSalmonID, d .OtherSpeciesPres, d .NaturalWoodUsed, 
                         d .PlacedWoodUsed, d .NaturalBoulderUsed, d .PlacedBoulderUsed, d .NaturalOffChannelUsed, d .CreatedOffChannelUsed, d .NewSideChannelUsed, d .NoStructureUsed, d .AmbientTemp, d .MinimumTemp, d .FieldNotes, 
                         d .ChannelUnitType, d .AEMHabitatType, d .AEMLength, d .RowId, d .RowStatusId, d .QAStatusId, d .GPSEasting, d .GPSNorthing, a.id AS ActivityId, a.DatasetId, a.InstrumentId, a.LaboratoryId, a.ActivityDate, a.CreateDate, 
                         w.id AS WaterbodyId, w.name AS WaterbodyName, l.id AS LocationId, l.Label AS LocationLabel, aq.QAStatusName AS QAStatusName, aq.Comments AS ActivityQAComments, aq.QAStatusId AS ActivityQAStatusId
FROM            dbo.Activities AS a INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                         dbo.SnorkelFish_Header_VW AS h ON h.ActivityId = a.Id INNER JOIN
                         dbo.Datasets AS ds ON ds.Id = a.DatasetId INNER JOIN
                         dbo.Locations AS l ON l.Id = a.LocationId INNER JOIN
                         dbo.WaterBodies AS w ON w.Id = l.WaterBodyId RIGHT OUTER JOIN
                         dbo.SnorkelFish_Detail_VW AS d ON d .ActivityId = a.Id

--Update tables
ALTER TABLE [dbo].[SnorkelFish_Detail] Drop Column [WaypointNumber]
*/