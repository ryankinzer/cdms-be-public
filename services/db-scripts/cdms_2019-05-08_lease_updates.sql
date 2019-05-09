--Update Lease view:

ALTER view Lease_AvailableFields_VW as

--fields without any lease ever
select 
	lsf.*,
	null as LeaseAcres,
	null as FSATractNumber,
	null as TAAMSNumber,
	null as DateAvailable,
	null as LastLeaseId,
	'n/a' as Expiration from LeaseFields_VW lsf where FieldId not in (select LeaseField_FieldId from LeaseFieldLeases)

union

--lease is expired or expiring in the next 9 months
select
	lf.*,
	ls.LeaseAcres,
	ls.FSATractNumber,
	ls.TAAMSNumber,
	dateadd(day,1,ls.LeaseEnd) ,
	ls.Id,
	case 
		when ls.LeaseEnd < getdate() THEN 'Expired'
		else concat(datediff(month, getdate(), ls.LeaseEnd), ' months')
	end
	from LeaseFields_VW as lf
join leasefieldleases lfl on lfl.LeaseField_FieldId = lf.FieldId
join leases ls on lfl.Lease_Id = ls.Id
where (ls.status not in (3) --not pending 
		and ls.LeaseEnd = (select max(s_ls.LeaseEnd) from LeaseFields_VW as s_lf
					join leasefieldleases s_lfl on s_lfl.LeaseField_FieldId = s_lf.FieldId
					join leases s_ls on s_lfl.Lease_Id = s_ls.Id 
					where s_lf.FieldId = lf.FieldId
			)
		)
		and ls.LeaseEnd < dateadd(month, 9, getdate())
		
union 

-- allotments without any fields
SELECT 
null AS FieldId, 
null AS FieldLandUse, 
null AS FieldAcres, 
cad.OBJECTID AS CadasterObjectid, 
cad.ALLOTMENT AS AllotmentName, 
cad.TAXLOT, 
cad.PARCELID, 
cad.ACRES_CTY AS AcresCty, 
cad.ACRES_GIS AS AcresGIS, 
cad.PLSS, 
cad.PLSS2, 
cad.PLSS3, 
cad.PLSS_label AS PLSSLabel, 
cad.last_edited_date AS LastEditedDate,
null as LeaseAcres,
null as FSATractNumber,
null as TAAMSNumber,
null as DateAvailable,
null as LastLeaseId,
'n/a' as Expiration
FROM sdevector.sde.Cadaster_evw AS cad 
WHERE 
cad.ALLOTMENT is not null AND cad.ALLOTMENT != ''
AND
cad.ALLOTMENT not in (select distinct allotmentname from LeaseFields_VW);

GO

