-- Up **********
-- Update the table
ALTER TABLE [dbo].[WaterQuality_Header] ADD [DataSource] [nvarchar](max)

-- Update the views
drop view dbo.WaterQuality_Header_VW
go
create view dbo.WaterQuality_Header_VW
as
SELECT        Id, DataType, ActivityId, ByUserId, EffDt, FieldsheetLink, HeaderComments, DataSource
FROM            dbo.WaterQuality_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.WaterQuality_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go

drop view dbo.WaterQuality_vw
go
create view dbo.WaterQuality_vw
as
SELECT        TOP (100) PERCENT loc.OtherAgencyId, d.SampleDate, CASE d .CharacteristicName WHEN 'Water Temperature' THEN 'Temperature, Water' ELSE d .CharacteristicName END AS CharacteristicName, d.Result, 
                         CASE d .ResultUnits WHEN 'FT' THEN 'ft' WHEN 'G/L' THEN 'g/L' WHEN 'INHG' THEN 'inHg' WHEN 'M' THEN 'm' WHEN 'MG/L' THEN 'mg/L' WHEN 'MG/M3' THEN 'mg/m3' WHEN 'MMHG' THEN 'mmHg' WHEN 'NG/KG' THEN 'ng/kg'
                          WHEN 'UG/KG' THEN 'ug/kg' WHEN 'UG/L' THEN 'ug/L' WHEN 'UMHO/CM' THEN 'umho/cm' WHEN 'CFU/100ML' THEN 'cfu/100mL' WHEN 'NG/L' THEN 'ng/L' WHEN 'US/CM' THEN 'uS/cm' ELSE ResultUnits END AS ResultUnits,
                          d.MdlResults, d.SampleFraction, d.MethodSpeciation, d.ContextID, d.MethodID, d.DetectionLimit, CASE WHEN (Result IS NULL) AND DataType = 'ISCO' THEN 'Ignore' WHEN (Result IS NULL) AND 
                         DataType = 'Handheld' THEN 'Not Reported' WHEN (Result IS NULL) AND MdlResults LIKE ('%>%') THEN 'Present Above Quantification Limit' WHEN (Result IS NULL) AND MdlResults LIKE ('%<%') 
                         THEN 'Present Below Quantification Limit' WHEN (Result IS NULL) AND MdlResults LIKE ('%Present%') THEN 'Present Below Quantification Limit' WHEN (Result IS NULL) 
                         THEN 'Not Detected' ELSE '' END AS ResultDetectionCondition, d.LabDuplicate, d.LabName, d.SampleID, d.Comments, h.DataType, h.DataSource, h.FieldsheetLink, h.HeaderComments, a.Id AS ActivityId, a.DatasetId, a.InstrumentId, 
                         a.ActivityDate, a.CreateDate, loc.Id AS LocationId, loc.Label AS LocationLabel, aq.QAStatusName, aq.Comments AS ActivityQAComments, d.QAStatusId AS RowQAStatusId, aq.QAStatusId AS ActivityQAStatusId, d.RowId, 
                         d.RowStatusId, CASE DataType WHEN 'ISCO' THEN 'Field Msr/Obs-Portable Data Logger' WHEN 'Handheld' THEN 'Field Msr/Obs-Portable Data Logger' WHEN 'Lab' THEN 'Sample-Routine' ELSE '' END AS ActivityType, 
                         CASE CharacteristicName WHEN 'Conductivity-TDS' THEN 'Calculated' WHEN 'Conductivity-Spec Cond' THEN 'Calculated' ELSE 'Actual' END AS ResultValueType, 
                         CASE d .ResultUnits WHEN 'FT' THEN 'ft' WHEN 'G/L' THEN 'g/L' WHEN 'INHG' THEN 'inHg' WHEN 'M' THEN 'm' WHEN 'MG/L' THEN 'mg/L' WHEN 'MG/M3' THEN 'mg/m3' WHEN 'MMHG' THEN 'mmHg' WHEN 'NG/KG' THEN 'ng/kg'
                          WHEN 'UG/KG' THEN 'ug/kg' WHEN 'UG/L' THEN 'ug/L' WHEN 'UMHO/CM' THEN 'umho/cm' WHEN 'CFU/100ML' THEN 'cfu/100mL' WHEN 'NG/L' THEN 'ng/L' WHEN 'US/CM' THEN 'uS/cm' ELSE d .ResultUnits END AS ResultDetectionUnit
FROM            dbo.Activities AS a INNER JOIN
                         dbo.WaterQuality_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.Locations AS loc ON loc.Id = a.LocationId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id LEFT OUTER JOIN
                         dbo.WaterQuality_Detail_VW AS d ON h.ActivityId = d.ActivityId
go

-- Update the data
create table #DatasetIdList (id int) -- Hold the list of ids from the datasets below

insert into #DatasetIdList
select Id from dbo.Datasets where [Name] like '%Chemistry%'

-- This will info about field records inserted below
CREATE TABLE #NewFieldInfo (id int, fieldName nvarchar(max), DbColumnName nvarchar(max), Validation nvarchar(max), ControlType nvarchar(max), [Rule] nvarchar(max), FieldRoleId int, OrderIndex int IDENTITY(1,1))  

-- Header Fields
INSERT INTO dbo.Fields (Name, [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DatastoreId)
OUTPUT INSERTED.id, INSERTED.Name, INSERTED.DbColumnName, INSERTED.Validation, INSERTED.ControlType, INSERTED.[Rule], NULL INTO #NewFieldInfo
SELECT
		Name = 'Data Source',
		Description = 'Data Source',
		Units = NULL,
		Validation = NULL,
		DataType = 'string',
		PossibleValues = '["Goes Satellite", "Manual Upload", "Verizon"]',
		[Rule] = NULL,
		DbColumnName = 'DataSource',
		ControlType = 'select',
		DatastoreId = (select Id from dbo.Datastores where TablePrefix = 'WaterQuality')

update #NewFieldInfo set FieldRoleId = 1 where FieldRoleId is NULL --1 == header

INSERT INTO dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, Validation, SourceId, InstrumentId, OrderIndex, ControlType, [Rule])
SELECT
    DatasetId      = d.id,
    FieldId        = f.id,
    FieldRoleId    = f.FieldRoleId,
    CreateDateTime = CONVERT(VARCHAR(23), GETDATE(), 121),
    Label          = f.fieldName,
    DbColumnName   = f.DbColumnName,
    Validation     = f.Validation,
    SourceId       = 1,
    InstrumentId   = NULL,
    OrderIndex     = 12,     -- x10 to make it easier to insert intermediate orders
    ControlType    = f.ControlType,
    [Rule]         = f.[Rule]
FROM #DatasetIdList as d, #NewFieldInfo as f


-- Down **********
/*
-- Update the views
drop view dbo.WaterQuality_Header_VW
go
create view dbo.WaterQuality_Header_VW
as
SELECT        Id, DataType, ActivityId, ByUserId, EffDt, FieldsheetLink, HeaderComments
FROM            dbo.WaterQuality_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.WaterQuality_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


drop view dbo.WaterQuality_vw
go
create view dbo.WaterQuality_vw
as
SELECT        TOP (100) PERCENT loc.OtherAgencyId, d.SampleDate, CASE d .CharacteristicName WHEN 'Water Temperature' THEN 'Temperature, Water' ELSE d .CharacteristicName END AS CharacteristicName, d.Result, 
                         CASE d .ResultUnits WHEN 'FT' THEN 'ft' WHEN 'G/L' THEN 'g/L' WHEN 'INHG' THEN 'inHg' WHEN 'M' THEN 'm' WHEN 'MG/L' THEN 'mg/L' WHEN 'MG/M3' THEN 'mg/m3' WHEN 'MMHG' THEN 'mmHg' WHEN 'NG/KG' THEN 'ng/kg'
                          WHEN 'UG/KG' THEN 'ug/kg' WHEN 'UG/L' THEN 'ug/L' WHEN 'UMHO/CM' THEN 'umho/cm' WHEN 'CFU/100ML' THEN 'cfu/100mL' WHEN 'NG/L' THEN 'ng/L' WHEN 'US/CM' THEN 'uS/cm' ELSE ResultUnits END AS ResultUnits,
                          d.MdlResults, d.SampleFraction, d.MethodSpeciation, d.ContextID, d.MethodID, d.DetectionLimit, CASE WHEN (Result IS NULL) AND DataType = 'ISCO' THEN 'Ignore' WHEN (Result IS NULL) AND 
                         DataType = 'Handheld' THEN 'Not Reported' WHEN (Result IS NULL) AND MdlResults LIKE ('%>%') THEN 'Present Above Quantification Limit' WHEN (Result IS NULL) AND MdlResults LIKE ('%<%') 
                         THEN 'Present Below Quantification Limit' WHEN (Result IS NULL) AND MdlResults LIKE ('%Present%') THEN 'Present Below Quantification Limit' WHEN (Result IS NULL) 
                         THEN 'Not Detected' ELSE '' END AS ResultDetectionCondition, d.LabDuplicate, d.LabName, d.SampleID, d.Comments, h.DataType, h.FieldsheetLink, h.HeaderComments, a.Id AS ActivityId, a.DatasetId, a.InstrumentId, 
                         a.ActivityDate, a.CreateDate, loc.Id AS LocationId, loc.Label AS LocationLabel, aq.QAStatusName, aq.Comments AS ActivityQAComments, d.QAStatusId AS RowQAStatusId, aq.QAStatusId AS ActivityQAStatusId, d.RowId, 
                         d.RowStatusId, CASE DataType WHEN 'ISCO' THEN 'Field Msr/Obs-Portable Data Logger' WHEN 'Handheld' THEN 'Field Msr/Obs-Portable Data Logger' WHEN 'Lab' THEN 'Sample-Routine' ELSE '' END AS ActivityType, 
                         CASE CharacteristicName WHEN 'Conductivity-TDS' THEN 'Calculated' WHEN 'Conductivity-Spec Cond' THEN 'Calculated' ELSE 'Actual' END AS ResultValueType, 
                         CASE d .ResultUnits WHEN 'FT' THEN 'ft' WHEN 'G/L' THEN 'g/L' WHEN 'INHG' THEN 'inHg' WHEN 'M' THEN 'm' WHEN 'MG/L' THEN 'mg/L' WHEN 'MG/M3' THEN 'mg/m3' WHEN 'MMHG' THEN 'mmHg' WHEN 'NG/KG' THEN 'ng/kg'
                          WHEN 'UG/KG' THEN 'ug/kg' WHEN 'UG/L' THEN 'ug/L' WHEN 'UMHO/CM' THEN 'umho/cm' WHEN 'CFU/100ML' THEN 'cfu/100mL' WHEN 'NG/L' THEN 'ng/L' WHEN 'US/CM' THEN 'uS/cm' ELSE d .ResultUnits END AS ResultDetectionUnit
FROM            dbo.Activities AS a INNER JOIN
                         dbo.WaterQuality_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.Locations AS loc ON loc.Id = a.LocationId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON aq.ActivityId = a.Id LEFT OUTER JOIN
                         dbo.WaterQuality_Detail_VW AS d ON h.ActivityId = d.ActivityId
go

-- Delete the property
alter table [dbo].[WaterQuality_Header] drop column [DataSource]
*/
