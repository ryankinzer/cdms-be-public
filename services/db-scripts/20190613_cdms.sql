-- CDMS: add two new fields

-- add columnindex field to datasetfields for grouping fields in the UI
ALTER TABLE [dbo].[DatasetFields] ADD [ColumnIndex] [int]
go

-- add itemid to file for cross-referencing permitnumber and in the future, correspondenceitems, etc.
ALTER TABLE [dbo].[Files] ADD [ItemId] [int]
go