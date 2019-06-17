use PALUUT_DEV_GEO
GO

-- Add the tables
CREATE TABLE [dbo].[CreelPhone_Detail] (
    [Id] [int] NOT NULL IDENTITY,
    [StreamName] [int],
    [Trips] [int],
    [HoursFished] [decimal](18, 2),
    [CreelInterviews] [int],
    [Species] [nvarchar](max),
    [NumberCaught] [int],
    [Disposition] [nvarchar](max),
    [LifeStage] [nvarchar](max),
    [Sex] [nvarchar](max),
    [Origin] [nvarchar](max),
    [MethodCaught] [nvarchar](max),
    [FishComments] [nvarchar](max),
    [RowId] [int] NOT NULL,
    [RowStatusId] [int] NOT NULL,
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [QAStatusId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.CreelPhone_Detail] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[CreelPhone_Detail]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[CreelPhone_Detail]([ByUserId])
CREATE INDEX [IX_QAStatusId] ON [dbo].[CreelPhone_Detail]([QAStatusId])
CREATE TABLE [dbo].[CreelPhone_Header] (
    [Id] [int] NOT NULL IDENTITY,
    [FishermanId] [int] NOT NULL,
    [Fished] [nvarchar](max),
    [InterviewComments] [nvarchar](max),
    [ActivityId] [int] NOT NULL,
    [ByUserId] [int] NOT NULL,
    [EffDt] [datetime] NOT NULL,
    CONSTRAINT [PK_dbo.CreelPhone_Header] PRIMARY KEY ([Id])
)
CREATE INDEX [IX_ActivityId] ON [dbo].[CreelPhone_Header]([ActivityId])
CREATE INDEX [IX_ByUserId] ON [dbo].[CreelPhone_Header]([ByUserId])
ALTER TABLE [dbo].[CreelPhone_Detail] ADD CONSTRAINT [FK_dbo.CreelPhone_Detail_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[CreelPhone_Detail] ADD CONSTRAINT [FK_dbo.CreelPhone_Detail_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
ALTER TABLE [dbo].[CreelPhone_Detail] ADD CONSTRAINT [FK_dbo.CreelPhone_Detail_dbo.QAStatus_QAStatusId] FOREIGN KEY ([QAStatusId]) REFERENCES [dbo].[QAStatus] ([Id])
ALTER TABLE [dbo].[CreelPhone_Header] ADD CONSTRAINT [FK_dbo.CreelPhone_Header_dbo.Activities_ActivityId] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activities] ([Id])
ALTER TABLE [dbo].[CreelPhone_Header] ADD CONSTRAINT [FK_dbo.CreelPhone_Header_dbo.Users_ByUserId] FOREIGN KEY ([ByUserId]) REFERENCES [dbo].[Users] ([Id])
GO


--Add the views
--DROP VIEW CreelPhone_Header_VW
--GO
CREATE VIEW CreelPhone_Header_VW
AS
SELECT Id, FishermanId, Fished, InterviewComments, ActivityId, ByUserId, EffDt
FROM dbo.CreelPhone_Header AS h
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.CreelPhone_Header AS hh
	WHERE        (ActivityId = h.ActivityId)))
GO

--DROP VIEW CreelPhone_Detail_VW
--GO
CREATE VIEW CreelPhone_Detail_VW
AS
SELECT Id, StreamName, Trips, HoursFished, CreelInterviews, Species, NumberCaught, Disposition, LifeStage, Sex, Origin, MethodCaught, FishComments, RowId, RowStatusId, ActivityId, ByUserId, QAStatusId, EffDt
FROM dbo.CreelPhone_Detail AS d
WHERE (EffDt = 
	(SELECT MAX(EffDt) AS MaxEffDt
	FROM            dbo.CreelPhone_Detail AS dd
	WHERE        (ActivityId = d.ActivityId) AND (RowId = d.RowId))) AND (RowStatusId = 0)
GO

--DROP VIEW CreelPhone_vw
--GO
CREATE VIEW CreelPhone_vw
AS
SELECT a.Id AS ActivityId, a.DatasetId, a.SourceId, a.LocationId, a.UserId, a.ActivityTypeId, a.CreateDate, a.ActivityDate, h.Id, h.FishermanId, h.Fished, h.InterviewComments, h.ByUserId, h.EffDt, d.Id AS CreelPhone_Detail_Id, d.StreamName, d.Trips, d.HoursFished, d.CreelInterviews, d.Species, d.NumberCaught, d.Disposition, d.LifeStage, d.Sex, d.Origin, d.MethodCaught, d.FishComments, d.RowId, d.ByUserId AS CreelPhone_Detail_ByUserId, d.QAStatusId, d.EffDt AS CreelPhone_Detail_EffDt, aq.QAStatusId AS ActivityQAStatusId, aq.UserId AS ActivityQAUserId, aq.Comments, aq.QAStatusName, l.Label AS LocationLabel
FROM dbo.Activities AS a 
INNER JOIN dbo.CreelPhone_Header_VW AS h ON a.Id = h.ActivityId 
LEFT OUTER JOIN dbo.CreelPhone_Detail_VW AS d ON h.ActivityId = d.ActivityId 
INNER JOIN dbo.ActivityQAs_VW AS aq ON a.Id = aq.ActivityId 
INNER JOIN dbo.Locations AS l ON a.LocationId = l.Id 
GO

ALTER TABLE [dbo].[CreelPhone_Header] ADD [Season] [int] NOT NULL DEFAULT 0


