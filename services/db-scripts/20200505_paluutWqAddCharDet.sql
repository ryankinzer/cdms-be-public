use paluut_dev_geo
go

-- Up
-- Update table
ALTER TABLE [dbo].[WaterQuality_Detail] ADD [CharactDetected] [nvarchar](max)
go

-- Update views
Drop view dbo.WaterQuality_Detail_VW
go
Create view dbo.WaterQuality_Detail_VW
as
SELECT        Id, CharacteristicName, Result, ResultUnits, LabDuplicate, Comments, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt, MdlResults, SampleDate, SampleID, SampleFraction, MethodSpeciation, DetectionLimit, ContextID, MethodID, LabName, CharactDetected
FROM            dbo.WaterQuality_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.WaterQuality_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
go

Drop view dbo.WaterQuality_vw
go
Create view dbo.WaterQuality_vw
as
SELECT        TOP (100) PERCENT loc.OtherAgencyId, d.SampleDate, CASE d .CharacteristicName WHEN 'Water Temperature' THEN 'Temperature, Water' ELSE d .CharacteristicName END AS CharacteristicName, d.Result, 
                         CASE d .ResultUnits WHEN 'FT' THEN 'ft' WHEN 'G/L' THEN 'g/L' WHEN 'INHG' THEN 'inHg' WHEN 'M' THEN 'm' WHEN 'MG/L' THEN 'mg/L' WHEN 'MG/M3' THEN 'mg/m3' WHEN 'MMHG' THEN 'mmHg' WHEN 'NG/KG' THEN 'ng/kg'
                          WHEN 'UG/KG' THEN 'ug/kg' WHEN 'UG/L' THEN 'ug/L' WHEN 'UMHO/CM' THEN 'umho/cm' WHEN 'CFU/100ML' THEN 'cfu/100mL' WHEN 'NG/L' THEN 'ng/L' WHEN 'US/CM' THEN 'uS/cm' ELSE ResultUnits END AS ResultUnits,
                          d.MdlResults, d.SampleFraction, d.MethodSpeciation, d.ContextID, d.MethodID, d.DetectionLimit, CASE WHEN (Result IS NULL) AND DataType = 'ISCO' THEN 'Ignore' WHEN (Result IS NULL) AND 
                         DataType = 'Handheld' THEN 'Not Reported' WHEN (Result IS NULL) AND MdlResults LIKE ('%>%') THEN 'Present Above Quantification Limit' WHEN (Result IS NULL) AND MdlResults LIKE ('%<%') 
                         THEN 'Present Below Quantification Limit' WHEN (Result IS NULL) AND MdlResults LIKE ('%Present%') THEN 'Present Below Quantification Limit' WHEN (Result IS NULL) 
                         THEN 'Not Detected' ELSE '' END AS ResultDetectionCondition, d.LabDuplicate, d.LabName, d.SampleID, d.Comments, h.DataType, h.DataSource, h.FieldsheetLink, h.HeaderComments, a.Id AS ActivityId, a.DatasetId, 
                         a.InstrumentId, a.ActivityDate, a.CreateDate, loc.Id AS LocationId, loc.Label AS LocationLabel, aq.QAStatusName, aq.Comments AS ActivityQAComments, d.QAStatusId AS RowQAStatusId, aq.QAStatusId AS ActivityQAStatusId, 
                         d.RowId, d.RowStatusId, CASE DataType WHEN 'ISCO' THEN 'Field Msr/Obs-Portable Data Logger' WHEN 'Handheld' THEN 'Field Msr/Obs-Portable Data Logger' WHEN 'Lab' THEN 'Sample-Routine' ELSE '' END AS ActivityType,
                          CASE CharacteristicName WHEN 'Conductivity-TDS' THEN 'Calculated' WHEN 'Conductivity-Spec Cond' THEN 'Calculated' ELSE 'Actual' END AS ResultValueType, 
                         CASE d .ResultUnits WHEN 'FT' THEN 'ft' WHEN 'G/L' THEN 'g/L' WHEN 'INHG' THEN 'inHg' WHEN 'M' THEN 'm' WHEN 'MG/L' THEN 'mg/L' WHEN 'MG/M3' THEN 'mg/m3' WHEN 'MMHG' THEN 'mmHg' WHEN 'NG/KG' THEN 'ng/kg'
                          WHEN 'UG/KG' THEN 'ug/kg' WHEN 'UG/L' THEN 'ug/L' WHEN 'UMHO/CM' THEN 'umho/cm' WHEN 'CFU/100ML' THEN 'cfu/100mL' WHEN 'NG/L' THEN 'ng/L' WHEN 'US/CM' THEN 'uS/cm' ELSE d .ResultUnits END AS ResultDetectionUnit,
                          d.CharactDetected
FROM            dbo.Activities AS a INNER JOIN
                         dbo.WaterQuality_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.Locations AS loc ON loc.Id = a.LocationId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id LEFT OUTER JOIN
                         dbo.WaterQuality_Detail_VW AS d ON h.ActivityId = d.ActivityId
go


-- Update data
insert into dbo.Fields ([TechnicalName], [Name], [Description], Units, [Validation], DataType, PossibleValues, [Rule], DbColumnName, ControlType, DataSource, DatastoreId, FieldRoleId)
values (null, 'CharactDetected', 'Characteristic Detected', null, null, 'string', '["Absent","Present"]', null, 'CharactDetected', 'text', null, (select Id from dbo.Datastores where TablePrefix = 'WaterQuality'), 2)
go

insert into dbo.DatasetFields (DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType, [Rule], ColumnIndex)
values (
(select Id from dbo.Datasets where DatastoreId = 6 and [Name] like 'TPO-%'),
(select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'WaterQuality')and DbColumnName = 'CharactDetected'),
2,
(select convert(varchar, getdate(), 121)),
'Characteristic Detected',
'CharactDetected',
null, 1, null, 117,
'select', null, null
)
go


-- Down
/*alter table dbo.WaterQuality_Detail drop column CharactDetected
go

Drop view dbo.WaterQuality_Detail_VW
go
Create view dbo.WaterQuality_Detail_VW
as
SELECT        Id, CharacteristicName, Result, ResultUnits, LabDuplicate, Comments, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt, MdlResults, SampleDate, SampleID, SampleFraction, MethodSpeciation, DetectionLimit, 
                         ContextID, MethodID, LabName
FROM            dbo.WaterQuality_Detail AS d
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.WaterQuality_Detail AS dd
                               WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
go
*/