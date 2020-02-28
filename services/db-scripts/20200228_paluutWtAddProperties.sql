use PALUUT_DEV_GEO
go

-- Update tables
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MinWaterTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MaxWaterTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MeanWaterTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MinAirTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MaxAirTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MeanAirTemprature] [float]
go


-- Update views
-- Up
drop view dbo.WaterTemp_Detail_VW
go
create view dbo.WaterTemp_Detail_VW
as
SELECT        d.Id, d.ReadingDateTime, d.GMTReadingDateTime, d.AirTemperature, d.AirTemperatureF, d.WaterTemperature, d.WaterTemperatureF, d.WaterLevel, d.TempAToD, d.Discharge, d.BatteryVolts, d.Conductivity, d.RowId, d.RowStatusId, d.ActivityId, d.ByUserId, d.QAStatusId, d.EffDt, d.PSI, d.AbsolutePressure, d.Depth, qa.Name AS RowQAStatus, d.MinWaterTemperature, d.MaxWaterTemperature, d.MeanWaterTemperature, d.MinAirTemperature, d.MaxAirTemperature, d.MeanAirTemprature
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
                         d.Conductivity, d.RowId, d.RowStatusId, d.ByUserId AS WaterTemp_Detail_ByUserId, d.QAStatusId AS RowQAStatusId, d.EffDt AS WaterTemp_Detail_EffDt, d.PSI, d.AbsolutePressure, d.Depth, d.MinWaterTemperature, d.MaxWaterTemperature, d.MeanWaterTemperature, d.MinAirTemperature, d.MaxAirTemperature, d.MeanAirTemprature,
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
('MinWaterTemperature', 'Minimum daily water temperature in degree C', 'C', '[-25,49]', 'float', null, null, 'MinWaterTemperature', 'number', 3, 2),
('MaxWaterTemperature', 'Maximum daily water temperature in degree C', 'C', '[-25,49]', 'float', null, null, 'MaxWaterTemperature', 'number', 3, 2),
('MeanWaterTemperature', 'Mean daily water tempertaure in degree C', 'C', '[-25,49]', 'float', null, null, 'MeanWaterTemperature', 'number', 3, 2),
('MinAirTemperature', 'Minimum daily air temperature in degree C', 'C', '[-25,49]', 'float', null, null, 'MinAirTemperature', 'number', 3, 2),
('MaxAirTemperature', 'Maximum daily air temperature in degree C', 'C', '[-25,49]', 'float', null, null, 'MaxAirTemperature', 'number', 3, 2),
('MeanAirTemprature', 'Mean daily air tempertaure in degree C', 'C', '[-25,49]', 'float', null, null, 'MeanAirTemprature', 'number', 3, 2)
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