use PALUUT_DEV_GEO
go

ALTER TABLE [dbo].[Subproject_Hab] ADD [ProjectLead] [nvarchar](max)

insert into dbo.MetadataProperties (MetadataEntityId, [Name], [Description], DataType, PossibleValues, ControlType)
values (8, 'ProjectLead', 'Project Lead', 'string', '["CTUIR","Nez Perce Tribe","Washington Department of Fish and Wildlife (WDFW)","Columbia Conservation District (CCD)","Snake River Salmon Recovery Board (SRSRB)","U.S. Forest Service"]', 'select')
