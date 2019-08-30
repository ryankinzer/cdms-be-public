--up
drop view dbo.WaterTemp_VW
go
create view dbo.WaterTemp_VW
as
SELECT        h.Id AS WaterTemp_Header_Id, h.Technicians, h.Comments, h.CollectionType, h.FieldActivityType, h.StaticWaterLevel, h.WeatherConditions, h.SamplePeriod, h.SampleTempUnit, h.DeployTime, h.ByUserId, h.EffDt, 
                         d.Id AS WaterTemp_Detail_Id, d.ReadingDateTime, d.GMTReadingDateTime, d.WaterTemperature, d.WaterTemperatureF, d.AirTemperature, d.AirTemperatureF, d.WaterLevel, d.TempAToD, d.Discharge, d.BatteryVolts, 
                         d.Conductivity, d.RowId, d.RowStatusId, d.ByUserId AS WaterTemp_Detail_ByUserId, d.QAStatusId AS RowQAStatusId, d.EffDt AS WaterTemp_Detail_EffDt, d.PSI, d.AbsolutePressure, d.Depth, 
                         aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments AS ActivityQAComments, a.Description, a.DatasetId, a.SourceId, a.LocationId, a.UserId AS Activity_UserId, a.ActivityTypeId, a.CreateDate, 
                         a.Id AS ActivityId, aq.QAStatusName AS ActivityQAStatusName, a.InstrumentId, a.ActivityDate, L.Label, w.Name, L.WaterBodyId, L.LocationTypeId, 
                         CASE WHEN d .QAStatusId > 1 THEN '' ELSE d .WaterTemperature END AS CorrectTemp, L.OtherAgencyId, qas.Name AS RowQAStatusName, a.AccuracyCheckId, a.PostAccuracyCheckId
FROM            dbo.QAStatus AS qas INNER JOIN
                         dbo.WaterTemp_Detail_VW AS d ON qas.Id = d.QAStatusId RIGHT OUTER JOIN
                         dbo.Activities AS a INNER JOIN
                         dbo.WaterTemp_Header_VW AS h ON h.ActivityId = a.Id INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                         dbo.Locations AS L ON a.LocationId = L.Id INNER JOIN
                         dbo.WaterBodies AS w ON L.WaterBodyId = w.Id ON d.ActivityId = h.ActivityId

--down
/*drop view dbo.WaterTemp_VW
go
create view dbo.WaterTemp_VW
as
SELECT        h.Id AS WaterTemp_Header_Id, h.Technicians, h.Comments, h.CollectionType, h.FieldActivityType, h.StaticWaterLevel, h.WeatherConditions, h.SamplePeriod, h.SampleTempUnit, h.DeployTime, h.ByUserId, h.EffDt, 
                         d.Id AS WaterTemp_Detail_Id, d.ReadingDateTime, d.GMTReadingDateTime, d.WaterTemperature, d.WaterTemperatureF, d.AirTemperature, d.AirTemperatureF, d.WaterLevel, d.TempAToD, d.Discharge, d.BatteryVolts, 
                         d.Conductivity, d.RowId, d.RowStatusId, d.ByUserId AS WaterTemp_Detail_ByUserId, d.QAStatusId AS RowQAStatusId, d.EffDt AS WaterTemp_Detail_EffDt, d.PSI, d.AbsolutePressure, d.Depth, 
                         aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments AS ActivityQAComments, a.Description, a.DatasetId, a.SourceId, a.LocationId, a.UserId AS Activity_UserId, a.ActivityTypeId, a.CreateDate, 
                         a.Id AS ActivityId, aq.QAStatusName AS ActivityQAStatusName, a.InstrumentId, a.ActivityDate, L.Label, w.Name, L.WaterBodyId, L.LocationTypeId, 
                         CASE WHEN d .QAStatusId > 1 THEN '' ELSE d .WaterTemperature END AS CorrectTemp, L.OtherAgencyId, qas.Name AS RowQAStatusName
FROM            dbo.QAStatus AS qas INNER JOIN
                         dbo.WaterTemp_Detail_VW AS d ON qas.Id = d.QAStatusId RIGHT OUTER JOIN
                         dbo.Activities AS a INNER JOIN
                         dbo.WaterTemp_Header_VW AS h ON h.ActivityId = a.Id INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id INNER JOIN
                         dbo.Locations AS L ON a.LocationId = L.Id INNER JOIN
                         dbo.WaterBodies AS w ON L.WaterBodyId = w.Id ON d.ActivityId = h.ActivityId
*/