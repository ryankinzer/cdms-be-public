use PALUUT_DEV_GEO
go

-- Update tables
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MinWaterTemperatureC] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MaxWaterTemperatureC] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MeanWaterTemperatureC] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MinAirTemperatureC] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MaxAirTemperatureC] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MeanAirTempratureC] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MinWaterTemperatureF] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MaxWaterTemperatureF] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MeanWaterTemperatureF] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MinAirTemperatureF] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MaxAirTemperatureF] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MeanAirTempratureF] [float]
go


-- Update views
-- Up
drop view dbo.WaterTemp_Detail_VW
go
create view dbo.WaterTemp_Detail_VW
as
SELECT        d.Id, d.ReadingDateTime, d.GMTReadingDateTime, d.AirTemperature, d.AirTemperatureF, d.WaterTemperature, d.WaterTemperatureF, d.WaterLevel, d.TempAToD, d.Discharge, d.BatteryVolts, d.Conductivity, d.RowId, d.RowStatusId, d.ActivityId, d.ByUserId, d.QAStatusId, d.EffDt, d.PSI, d.AbsolutePressure, d.Depth, qa.Name AS RowQAStatus, 
			d.MinWaterTemperatureC, d.MaxWaterTemperatureC, d.MeanWaterTemperatureC, d.MinAirTemperatureC, d.MaxAirTemperatureC, d.MeanAirTempratureC, d.MinWaterTemperatureF, d.MaxWaterTemperatureF, d.MeanWaterTemperatureF, d.MinAirTemperatureF, d.MaxAirTemperatureF, d.MeanAirTempratureF
FROM            dbo.WaterTemp_Detail AS d INNER JOIN
                         dbo.QAStatus AS qa ON d.QAStatusId = qa.Id
WHERE        (d.EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.WaterTemp_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (d.RowStatusId = 0)
go


drop view dbo.WaterTemp_VW
go
create view dbo.WaterTemp_VW
as
SELECT        h.Id AS WaterTemp_Header_Id, h.Technicians, h.Comments, h.CollectionType, h.FieldActivityType, h.StaticWaterLevel, h.WeatherConditions, h.SamplePeriod, h.SampleTempUnit, h.DeployTime, h.ByUserId, h.EffDt, 
                         d.Id AS WaterTemp_Detail_Id, d.ReadingDateTime, d.GMTReadingDateTime, d.WaterTemperature, d.WaterTemperatureF, d.AirTemperature, d.AirTemperatureF, d.WaterLevel, d.TempAToD, d.Discharge, d.BatteryVolts, 
                         d.Conductivity, d.RowId, d.RowStatusId, d.ByUserId AS WaterTemp_Detail_ByUserId, d.QAStatusId AS RowQAStatusId, d.EffDt AS WaterTemp_Detail_EffDt, d.PSI, d.AbsolutePressure, d.Depth, 
						 d.MinWaterTemperatureC, d.MaxWaterTemperatureC, d.MeanWaterTemperatureC, d.MinAirTemperatureC, d.MaxAirTemperatureC, d.MeanAirTempratureC,
						 d.MinWaterTemperatureF, d.MaxWaterTemperatureF, d.MeanWaterTemperatureF, d.MinAirTemperatureF, d.MaxAirTemperatureF, d.MeanAirTempratureF,
                         aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments AS ActivityQAComments, a.Description, a.DatasetId, a.SourceId, a.LocationId, a.UserId AS Activity_UserId, a.ActivityTypeId, a.CreateDate, 
                         a.Id AS ActivityId, aq.QAStatusName AS ActivityQAStatusName, a.InstrumentId, a.ActivityDate, L.Label, w.Name, L.WaterBodyId, L.LocationTypeId, 
                         CASE WHEN d .QAStatusId > 1 THEN '' ELSE d .WaterTemperature END AS CorrectTemp, L.OtherAgencyId, qas.Name AS RowQAStatusName, a.AccuracyCheckId, a.PostAccuracyCheckId, a.Timezone
FROM            dbo.QAStatus AS qas INNER JOIN
                         dbo.WaterTemp_Detail_VW AS d ON qas.Id = d.QAStatusId RIGHT OUTER JOIN
                         dbo.Activities AS a INNER JOIN
                         dbo.WaterTemp_Header_VW AS h ON h.ActivityId = a.Id INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                         dbo.Locations AS L ON a.LocationId = L.Id INNER JOIN
                         dbo.WaterBodies AS w ON L.WaterBodyId = w.Id ON d.ActivityId = h.ActivityId
go


-- Update data
insert into dbo.Fields ([Name], [Description], Units, [Validation], DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId, FieldRoleId)
values 
('Min Water Temperature', 'Minimum daily water temperature in degree C', 'C', '[-25,49]', 'float', null, null, 'MinWaterTemperatureC', 'number', 3, 2),
('Max Water Temperature', 'Maximum daily water temperature in degree C', 'C', '[-25,49]', 'float', null, null, 'MaxWaterTemperatureC', 'number', 3, 2),
('Mean Water Temperature', 'Mean daily water tempertaure in degree C', 'C', '[-25,49]', 'float', null, null, 'MeanWaterTemperatureC', 'number', 3, 2),
('Min Air Temperature', 'Minimum daily air temperature in degree C', 'C', '[-25,49]', 'float', null, null, 'MinAirTemperatureC', 'number', 3, 2),
('Max Air Temperature', 'Maximum daily air temperature in degree C', 'C', '[-25,49]', 'float', null, null, 'MaxAirTemperatureC', 'number', 3, 2),
('Mean Air Temprature', 'Mean daily air tempertaure in degree C', 'C', '[-25,49]', 'float', null, null, 'MeanAirTempratureC', 'number', 3, 2),
('Min Water Temperature', 'Minimum daily water temperature in degree F', 'F', '[-40,120]', 'float', null, null, 'MinWaterTemperatureF', 'number', 3, 2),
('Max Water Temperature', 'Maximum daily water temperature in degree F', 'F', '[-40,120]', 'float', null, null, 'MaxWaterTemperatureF', 'number', 3, 2),
('Mean Water Temperature', 'Mean daily water tempertaure in degree F', 'F', '[-40,120]', 'float', null, null, 'MeanWaterTemperatureF', 'number', 3, 2),
('Min Air Temperature', 'Minimum daily air temperature in degree F', 'F', '[-40,120]', 'float', null, null, 'MinAirTemperatureF', 'number', 3, 2),
('Max Air Temperature', 'Maximum daily air temperature in degree F', 'F', '[-40,120]', 'float', null, null, 'MaxAirTemperatureF', 'number', 3, 2),
('Mean Air Temprature', 'Mean daily air tempertaure in degree F', 'F', '[-40,120]', 'float', null, null, 'MeanAirTempratureF', 'number', 3, 2)
go


-- Update views
-- Down
drop view dbo.WaterTemp_Detail_VW
go
create view dbo.WaterTemp_Detail_VW
as
SELECT        d.Id, d.ReadingDateTime, d.GMTReadingDateTime, d.AirTemperature, d.AirTemperatureF, d.WaterTemperature, d.WaterTemperatureF, d.WaterLevel, d.TempAToD, d.Discharge, d.BatteryVolts, d.Conductivity, d.RowId, 
                         d.RowStatusId, d.ActivityId, d.ByUserId, d.QAStatusId, d.EffDt, d.PSI, d.AbsolutePressure, d.Depth, qa.Name AS RowQAStatus
FROM            dbo.WaterTemp_Detail AS d INNER JOIN
                         dbo.QAStatus AS qa ON d.QAStatusId = qa.Id
WHERE        (d.EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.WaterTemp_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (d.RowStatusId = 0)
go

drop view dbo.WaterTemp_VW
go
create view dbo.WaterTemp_VW
as
SELECT        h.Id AS WaterTemp_Header_Id, h.Technicians, h.Comments, h.CollectionType, h.FieldActivityType, h.StaticWaterLevel, h.WeatherConditions, h.SamplePeriod, h.SampleTempUnit, h.DeployTime, h.ByUserId, h.EffDt, 
                         d.Id AS WaterTemp_Detail_Id, d.ReadingDateTime, d.GMTReadingDateTime, d.WaterTemperature, d.WaterTemperatureF, d.AirTemperature, d.AirTemperatureF, d.WaterLevel, d.TempAToD, d.Discharge, d.BatteryVolts, 
                         d.Conductivity, d.RowId, d.RowStatusId, d.ByUserId AS WaterTemp_Detail_ByUserId, d.QAStatusId AS RowQAStatusId, d.EffDt AS WaterTemp_Detail_EffDt, d.PSI, d.AbsolutePressure, d.Depth, 
                         aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments AS ActivityQAComments, a.Description, a.DatasetId, a.SourceId, a.LocationId, a.UserId AS Activity_UserId, a.ActivityTypeId, a.CreateDate, 
                         a.Id AS ActivityId, aq.QAStatusName AS ActivityQAStatusName, a.InstrumentId, a.ActivityDate, L.Label, w.Name, L.WaterBodyId, L.LocationTypeId, 
                         CASE WHEN d .QAStatusId > 1 THEN '' ELSE d .WaterTemperature END AS CorrectTemp, L.OtherAgencyId, qas.Name AS RowQAStatusName, a.AccuracyCheckId, a.PostAccuracyCheckId, a.Timezone
FROM            dbo.QAStatus AS qas INNER JOIN
                         dbo.WaterTemp_Detail_VW AS d ON qas.Id = d.QAStatusId RIGHT OUTER JOIN
                         dbo.Activities AS a INNER JOIN
                         dbo.WaterTemp_Header_VW AS h ON h.ActivityId = a.Id INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                         dbo.Locations AS L ON a.LocationId = L.Id INNER JOIN
                         dbo.WaterBodies AS w ON L.WaterBodyId = w.Id ON d.ActivityId = h.ActivityId
go