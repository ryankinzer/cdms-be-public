use paluut_test
go

-- Update tables
ALTER TABLE [dbo].[SnorkelFish_Header] ADD [FieldSheetFile] [nvarchar](max)
go

--Update views
--Up
drop view dbo.SnorkelFish_Header_VW
go
create view dbo.SnorkelFish_Header_VW
as
SELECT        Id, Team, StartWaterTemp, Visibility, VisitId, Comments, CollectionType, ActivityId, ByUserId, EffDt, NoteTaker, StartTime, EndTime, WeatherConditions, DominantSpecies, CommonSpecies, RareSpecies, IsAEM, HabitatVisitId, 
                         EndWaterTemp, Protocol, FieldSheetFile
FROM            dbo.SnorkelFish_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.SnorkelFish_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go

drop view dbo.SnorkelFish_vw
go
create view dbo.SnorkelFish_vw
as
SELECT        h.Team, h.NoteTaker, h.StartTime, h.EndTime, h.StartWaterTemp, h.Visibility, h.WeatherConditions, h.VisitId, h.Comments, h.CollectionType, h.DominantSpecies, h.CommonSpecies, h.RareSpecies, iif(h.IsAEM = 'YES', 
                         AEMHabitatType, ChannelUnitType) AS UnitType, h.IsAEM, h.HabitatVisitId, h.EndWaterTemp, h.Protocol, h.FieldSheetFile,d .NoSnorklers, d .FishID, d .ChannelUnitNumber, d .Lane, d .Type, d .ChannelAverageDepth, d .ChannelLength, 
                         d .ChannelWidth, d .ChannelMaxDepth, d .Unit, d .ChannelLength * d .ChannelWidth AS ChannelArea, d .FishCount, d .Species, d .SizeClass, d .UnidentifiedSalmonID, d .OtherSpeciesPres, d .NaturalWoodUsed, 
                         d .PlacedWoodUsed, d .NaturalBoulderUsed, d .PlacedBoulderUsed, d .NaturalOffChannelUsed, d .CreatedOffChannelUsed, d .NewSideChannelUsed, d .NoStructureUsed, d .AmbientTemp, d .MinimumTemp, d .FieldNotes, 
                         d .ChannelUnitType, d .AEMHabitatType, d .AEMLength, d .RowId, d .RowStatusId, d .QAStatusId, d .GPSEasting, d .GPSNorthing, d .WaypointNumber, a.id AS ActivityId, a.DatasetId, a.InstrumentId, a.LaboratoryId, a.ActivityDate, 
                         a.CreateDate, w.id AS WaterbodyId, w.name AS WaterbodyName, l.id AS LocationId, l.Label AS LocationLabel, aq.QAStatusName AS QAStatusName, aq.Comments AS ActivityQAComments, 
                         aq.QAStatusId AS ActivityQAStatusId
FROM            dbo.Activities AS a INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                         dbo.SnorkelFish_Header_VW AS h ON h.ActivityId = a.Id INNER JOIN
                         dbo.Datasets AS ds ON ds.Id = a.DatasetId INNER JOIN
                         dbo.Locations AS l ON l.Id = a.LocationId INNER JOIN
                         dbo.WaterBodies AS w ON w.Id = l.WaterBodyId RIGHT OUTER JOIN
                         dbo.SnorkelFish_Detail_VW AS d ON d .ActivityId = a.Id
go


--Update data
insert into dbo.Fields([Name], [Description], DataType, DbColumnName, ControlType, DatastoreId, FieldRoleId)
values('FieldSheet File', 'Copy of the field sheet', 'string', 'FieldSheetFile', 'file', 7, 1)
go