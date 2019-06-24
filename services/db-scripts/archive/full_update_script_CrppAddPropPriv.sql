use CDMS_DEV_GEO
go

-- Update the table
ALTER TABLE [dbo].[CrppContracts_Header] ADD [OnReservation] [nvarchar](max)

-- Update the views
-- Up
drop view dbo.CrppContracts_Header_VW
go
create view dbo.CrppContracts_Header_VW
as
SELECT        Id, ProjectProponent, ByUserId, EffDt, ProjectLead, CostCenter, ProjectName, Client, AgreeNumb, DateExec, DraftDue, FinalDue, ContractEnd, ModExtDate, DocumentLink, ActivityComments, ActivityId, AwardAmount, 
                         FinalReportSubmitted, OnReservation
FROM            dbo.CrppContracts_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.CrppContracts_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


drop view dbo.CrppContracts_vw
go
create view dbo.CrppContracts_vw
as
SELECT        a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ProjectProponent, h.ByUserId, h.EffDt, h.ProjectLead, h.CostCenter, h.ProjectName, h.Client, h.AgreeNumb, 
                         h.DateExec, h.DraftDue, h.FinalDue, h.ContractEnd, h.ModExtDate, h.DocumentLink, h.ActivityComments, h.AwardAmount, h.FinalReportSubmitted, d.Id AS CrppContracts_Detail_Id, d.Testing, d.NewSites, d.MonitoredSites, 
                         d.SitesEvaluated, d.UpdatedSites, d.NewIsolates, d.Evaluation, d.Monitoring, d.Notes, d.RowId, d.RowStatusId, d.ByUserId AS CrppContracts_Detail_ByUserId, d.QAStatusId, d.EffDt AS CrppContracts_Detail_EffDt, 
                         d.SurveyAcres, d.TestSites, d.SHRENum, d.SHCSNum, d.HPRCSIT, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel, h.OnReservation
FROM            dbo.Activities AS a INNER JOIN
                         dbo.CrppContracts_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id LEFT OUTER JOIN
                         dbo.CrppContracts_Detail_VW AS d ON h.ActivityId = d.ActivityId
go


-- Add the data
insert into dbo.Fields ([Name], [Description], DataType, PossibleValues, DbColumnName, ControlType, DatastoreId, FieldRoleId)
values ('On Reservation', 'Is the contract on the reservation?', 'string', '["Yes", "No"]', 'OnReservation', 'select', (select Id from dbo.Datastores where [Name] = 'CrppContracts'), 1)

insert into dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, SourceId, InstrumentId, OrderIndex, ControlType)
values(
(select Id from dbo.Datasets where [Name] = 'CRPP Contracts'),
(select Id from dbo.Fields where DbColumnName = 'OnReservation'),
1,
(convert(varchar, getdate(), 121)),
'On Reservation',
'OnReservation',
1,
null,
95,
'select'
)


-- Down
/*
drop view dbo.CrppContracts_Header_VW
go
create view dbo.CrppContracts_Header_VW
as
SELECT        Id, ProjectProponent, ByUserId, EffDt, ProjectLead, CostCenter, ProjectName, Client, AgreeNumb, DateExec, DraftDue, FinalDue, ContractEnd, ModExtDate, DocumentLink, ActivityComments, ActivityId, AwardAmount, 
                         FinalReportSubmitted
FROM            dbo.CrppContracts_Header AS h
WHERE        (EffDt =
                             (SELECT        MAX(EffDt) AS MaxEffDt
                               FROM            dbo.CrppContracts_Header AS hh
                               WHERE        (ActivityId = h.ActivityId)))
go


drop view dbo.CrppContracts_vw
go
create view dbo.CrppContracts_vw
as
SELECT        a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.ProjectProponent, h.ByUserId, h.EffDt, h.ProjectLead, h.CostCenter, h.ProjectName, h.Client, h.AgreeNumb, 
                         h.DateExec, h.DraftDue, h.FinalDue, h.ContractEnd, h.ModExtDate, h.DocumentLink, h.ActivityComments, h.AwardAmount, h.FinalReportSubmitted, d.Id AS CrppContracts_Detail_Id, d.Testing, d.NewSites, d.MonitoredSites, 
                         d.SitesEvaluated, d.UpdatedSites, d.NewIsolates, d.Evaluation, d.Monitoring, d.Notes, d.RowId, d.RowStatusId, d.ByUserId AS CrppContracts_Detail_ByUserId, d.QAStatusId, d.EffDt AS CrppContracts_Detail_EffDt, 
                         d.SurveyAcres, d.TestSites, d.SHRENum, d.SHCSNum, d.HPRCSIT, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM            dbo.Activities AS a INNER JOIN
                         dbo.CrppContracts_Header_VW AS h ON a.Id = h.ActivityId INNER JOIN
                         dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId INNER JOIN
                         dbo.Locations AS l ON a.LocationId = l.Id LEFT OUTER JOIN
                         dbo.CrppContracts_Detail_VW AS d ON h.ActivityId = d.ActivityId
go
*/