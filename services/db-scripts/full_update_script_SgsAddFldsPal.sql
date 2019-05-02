-- Add New Header Properties to SGS
-- Update the table
ALTER TABLE [dbo].[SpawningGroundSurvey_Header] ADD [StrandingIssues] [nvarchar](max)
ALTER TABLE [dbo].[SpawningGroundSurvey_Header] ADD [StrandingComments] [nvarchar](max)
go

-- Update the views
drop view SpawningGroundSurvey_Header_VW
go
create view SpawningGroundSurvey_Header_VW
AS
SELECT        Id, Technicians, StartTime, EndTime, StartTemperature, EndTemperature, StartEasting, StartNorthing, EndEasting, EndNorthing, Flow, WaterVisibility, Weather, FlaggedRedds, NewRedds, HeaderComments, FieldsheetLink, 
                         ActivityId, ByUserId, EffDt, TargetSpecies, StrandingIssues, StrandingComments
FROM            dbo.SpawningGroundSurvey_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.SpawningGroundSurvey_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


drop view SpawningGroundSurvey_vw
go
create view SpawningGroundSurvey_vw
AS
SELECT        h.Id AS HeaderID, h.Technicians, h.StartTime, h.EndTime, h.StartTemperature, h.EndTemperature, h.StartEasting, h.StartNorthing, h.EndEasting, h.EndNorthing, h.Flow, h.WaterVisibility, h.Weather, h.FlaggedRedds, 
                         h.NewRedds, h.HeaderComments, h.FieldsheetLink, h.ByUserId AS HeaderUserId, h.EffDt AS HeaderEffDt, h.TargetSpecies, h.StrandingIssues,
						 h.StrandingComments,
						 d.Id AS DetailID, d.FeatureID, d.FeatureType, d.Species, d.Time, d.Temp, d.Channel, d.ReddLocation, 
                         d.ReddHabitat, d.Origin, d.WaypointNumber, d.FishCount, d.FishLocation, d.Sex, d.FinClips, d.Marks, d.SpawningStatus, d.ForkLength, d.MeHPLength, d.SnoutID, d.ScaleID, d.Tag, d.TagID, d.Comments, d.Ident, d.EastingUTM, 
                         d.NorthingUTM, d.DateTime, d.RowId, d.RowStatusId, d.ByUserId AS DetailUserId, d.QAStatusId, d.EffDt AS DetailEffDt, d.GeneticID, d.KidneyID, d.EstimatedLocation, d.PercentRetained, d.NumberEggsRetained, d.MortalityType, 
                         d.ReddMeasurements, a.Id AS ActivityId, a.DatasetId, a.InstrumentId, a.LaboratoryId, a.ActivityDate, a.CreateDate, w.Id AS WaterbodyId, w.Name AS WaterbodyName, l.Id AS LocationId, l.Label AS LocationLabel, 
                         (CASE species WHEN 'STS' THEN year(dateadd(month, 3, activitydate)) ELSE year(activitydate) END) AS runyear, aq.QAStatusName, aq.Comments AS ActivityQAComments, aq.QAStatusId AS ActivityQAStatusId, 
                         w.Description AS Basin, l.SdeObjectId
FROM            dbo.Activities AS a INNER JOIN
                         dbo.SpawningGroundSurvey_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.Locations AS l ON l.Id = a.LocationId INNER JOIN
                         dbo.WaterBodies AS w ON w.Id = l.WaterBodyId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id LEFT OUTER JOIN
                         dbo.SpawningGroundSurvey_Detail_VW AS d ON h.ActivityId = d.ActivityId
go

-- Add the data
insert into dbo.Fields ([Name], [Description], Units, [Validation], Datatype, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId, FieldRoleId)
values 
('Stranding Issues', 'Need Definition', null, null, 'string', '["No Issues", "Warm Water", "Fish Passage", "Low Flow"]', null, 'StrandingIssues', 'multiselect', 5, 1),
('Stranding Comments', 'Comments for the Stranding', null, null, 'string', null, null, 'StrandingComments', 'textarea', 5, 1)

declare @DatasetId as int;
declare @FieldId as int;

set @DatasetId = (select Id from dbo.Datasets where [Name] like 'WWME-Spawning%');

set @FieldId = (select Id from dbo.Fields where DbColumnName = 'StrandingIssues');
insert into dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, SourceId, InstrumentId, OrderIndex, ControlType)
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Stranding Issues', 'StrandingIssues', 1, NULL, 92, 'multiselect')


set @FieldId = (select Id from dbo.Fields where DbColumnName = 'StrandingComments');
insert into dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, SourceId, InstrumentId, OrderIndex, ControlType)
values (@DatasetId, @FieldId, 1, CONVERT(VARCHAR(23), GETDATE(), 121), 'Stranding Comments', 'StrandingComments', 1, NULL, 94, 'textarea')

--Down
/*
-- Update the table
ALTER TABLE dbo.[SpawningGroundSurvey_Header] DROP Column StrandingIssues
ALTER TABLE [dbo].[SpawningGroundSurvey_Header] DROP Column StrandingComments
go

-- Update the views
drop view SpawningGroundSurvey_Header_VW
go
create view SpawningGroundSurvey_Header_VW
AS
SELECT        Id, Technicians, StartTime, EndTime, StartTemperature, EndTemperature, StartEasting, StartNorthing, EndEasting, EndNorthing, Flow, WaterVisibility, Weather, FlaggedRedds, NewRedds, HeaderComments, FieldsheetLink, 
                         ActivityId, ByUserId, EffDt, TargetSpecies
FROM            dbo.SpawningGroundSurvey_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.SpawningGroundSurvey_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


drop view SpawningGroundSurvey_vw
go
create view SpawningGroundSurvey_vw
AS
SELECT        h.Id AS HeaderID, h.Technicians, h.StartTime, h.EndTime, h.StartTemperature, h.EndTemperature, h.StartEasting, h.StartNorthing, h.EndEasting, h.EndNorthing, h.Flow, h.WaterVisibility, h.Weather, h.FlaggedRedds, 
                         h.NewRedds, h.HeaderComments, h.FieldsheetLink, h.ByUserId AS HeaderUserId, h.EffDt AS HeaderEffDt, h.TargetSpecies,
						 d.Id AS DetailID, d.FeatureID, d.FeatureType, d.Species, d.Time, d.Temp, d.Channel, d.ReddLocation, 
                         d.ReddHabitat, d.Origin, d.WaypointNumber, d.FishCount, d.FishLocation, d.Sex, d.FinClips, d.Marks, d.SpawningStatus, d.ForkLength, d.MeHPLength, d.SnoutID, d.ScaleID, d.Tag, d.TagID, d.Comments, d.Ident, d.EastingUTM, 
                         d.NorthingUTM, d.DateTime, d.RowId, d.RowStatusId, d.ByUserId AS DetailUserId, d.QAStatusId, d.EffDt AS DetailEffDt, d.GeneticID, d.KidneyID, d.EstimatedLocation, d.PercentRetained, d.NumberEggsRetained, d.MortalityType, 
                         d.ReddMeasurements, a.Id AS ActivityId, a.DatasetId, a.InstrumentId, a.LaboratoryId, a.ActivityDate, a.CreateDate, w.Id AS WaterbodyId, w.Name AS WaterbodyName, l.Id AS LocationId, l.Label AS LocationLabel, 
                         (CASE species WHEN 'STS' THEN year(dateadd(month, 3, activitydate)) ELSE year(activitydate) END) AS runyear, aq.QAStatusName, aq.Comments AS ActivityQAComments, aq.QAStatusId AS ActivityQAStatusId, 
                         w.Description AS Basin, l.SdeObjectId
FROM            dbo.Activities AS a INNER JOIN
                         dbo.SpawningGroundSurvey_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.Locations AS l ON l.Id = a.LocationId INNER JOIN
                         dbo.WaterBodies AS w ON w.Id = l.WaterBodyId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id LEFT OUTER JOIN
                         dbo.SpawningGroundSurvey_Detail_VW AS d ON h.ActivityId = d.ActivityId
go
*/