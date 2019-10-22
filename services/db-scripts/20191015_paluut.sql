-- add IN to permittypes

insert into permittypes (name, permittypestatus, permitnumberprefix, feerequired, stamprequired, currentpermitnumber)
values ('Information',0,'IN',0,0,1)

-- add PLSS, CreateDate to PermitParcel so that we can store a snapshot of what it was at the time the relationship is created
ALTER TABLE [dbo].[PermitParcels] 
    ADD PLSS nvarchar(max);

ALTER TABLE [dbo].[PermitParcels] 
    ADD CreateDate datetime not null DEFAULT (GETDATE());

go

-- RAN on test 10/22