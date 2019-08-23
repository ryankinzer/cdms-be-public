update dbo.Datasets
set Config = '{"DataEntryPage":{"HiddenFields":["ActivityDate"]},"ActivitiesPage":{"ShowFields":["Description","Location.Label","headerdata.DataType","User.Fullname"]},"AllowSaveWithErrors":true,"EnableDuplicateChecking":true,"DuplicateCheckFields":["DataType","Description","LocationId"],"SpecifyActivityListFields":true,"ActivityListFields":["DataType","Description","LocationId","QAStatusId"]}'
where [Name] = 'WRP-Water Chemistry'

update dbo.Datasets
set Config = '{"DataEntryPage":{"HiddenFields":["ActivityDate"]},"ActivitiesPage":{"ShowFields":["Description","Location.Label","headerdata.DataType","User.Fullname"]},"AllowSaveWithErrors":true,"EnableDuplicateChecking":true,"DuplicateCheckFields":["DataType","LocationId"],"SpecifyActivityListFields":true,"ActivityListFields":["DataType","LocationId","QAStatusId"]}'
where [Name] = 'EESP-Water Chemistry'