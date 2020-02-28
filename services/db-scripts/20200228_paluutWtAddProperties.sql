use PALUUT_DEV_GEO
go

ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MinWaterTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MaxWaterTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MeanWaterTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MinAirTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MaxAirTemperature] [float]
ALTER TABLE [dbo].[WaterTemp_Detail] ADD [MeanAirTemprature] [float]