-- CDMS: add two new fields

-- add columnindex field to datasetfields for grouping fields in the UI
ALTER TABLE [dbo].[DatasetFields] ADD [ColumnIndex] [int]
go

-- add itemid to file for cross-referencing permitnumber and in the future, correspondenceitems, etc.
ALTER TABLE [dbo].[Files] ADD [ItemId] [int]
go

-- Above updated on TEST previously

alter table leases
alter column GrazeStart [nvarchar](max);

alter table leases
alter column GrazeEnd [nvarchar](max);
go

alter table leaserevisions
alter column GrazeStart [nvarchar](max);

alter table leaserevisions
alter column GrazeEnd [nvarchar](max);
go

update leases set GrazeStart=FORMAT(try_convert(Date,GrazeStart),'MM/dd/yyyy');
update leases set GrazeEnd=FORMAT(try_convert(Date,GrazeStart),'MM/dd/yyyy'); 
go

alter table LeaseProductions add GrazingRentalRate [decimal](9, 2);
go