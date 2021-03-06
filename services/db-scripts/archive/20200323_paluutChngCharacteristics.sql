use PALUUT_DEV_GEO
go

-- Add Characteristics to Admin page
-- Create the Characteristics table
create table dbo.Characteristics
(
	Id int identity(1,1),
	CharacteristicName nvarchar(max),
	--CharacteristicUnit nvarchar(max)
	CharacteristicActive int
);

-- Populate the table
insert into dbo.Characteristics(CharacteristicName)
values ('.Alpha.-Endosulfan'),
('.Alpha.-Hexachlorocyclohexane'),
('.Beta.-Endosulfan'),
('.Beta.-Hexachlorocyclohexane'),
('.Delta.-Hexachlorocyclohexane'),
('1,2,3,4,6,7,8,9-Octachlorodibenzofuran'),
('1,2,3,4,6,7,8-Heptachlorodibenzofuran'),
('1,2,3,4,6,7,8-Heptachlorodibenzo-P-Dioxin'),
('1,2,3,4,7,8,9-Heptachlorodibenzofuran'),
('1,2,3,4,7,8-Hexachlorodibenzofuran'),
('1,2,3,4,7,8-Hexachlorodibenzo-P-Dioxin'),
('1,2,3,6,7,8-Hexachlorodibenzofuran'),
('1,2,3,6,7,8-Hexachlorodibenzo-P-Dioxin'),
('1,2,3,7,8,9-Hexachlorodibenzofuran'),
('1,2,3,7,8,9-Hexachlorodibenzo-P-Dioxin'),
('1,2,3,7,8-Pentachlorodibenzofuran'),
('1,2,3,7,8-Pentachlorodibenzo-P-Dioxin'),
('1,6,7-Trimethylnaphthalene'),
('1-Methylphenanthrene'),
('1-Methynaphthalene'),
('2,2'',3,3'',4,4'',5,5'',6-Nonachlorobiphenyl'),
('2,2''3,3'',4,4'',5,6-Octachlorobiphenyl'),
('2,2'',3,3'',4,4'',5-Heptachlorobiphenyl'),
('2,2'',3,3'',4,4''-Hexachlorobiphenyl'),
('2,2'',3,4,4'',5,5''-Heptachlorobipheny1'),
('2,2'',3,4,4'',5''-Hexachlorobiphenyl'),
('2,2'',3,4'',5,5'',6-Heptachlorobiphenyl'),
('2,2'',3,5''-Tetrachlorobiphenyl'),
('2,2'',4,4'',5,5''-Hexachlorobiphenyl'),
('2,2'',4,5,5''-Pentachlorobiphenyl'),
('2,2'',5,5''-Tetrachlorobiphenyl'),
('2,2'',5-Trichlorobiphenyl'),
('2,3,3'',4,4'',5''-Hexachlorobiphenyl'),
('2,3,3'',4,4''-Pentachlorobiphenyl'),
('2,3,3'',4'',6-Pentachlorobiphenyl'),
('2,3'',4,4'',5,5''-Hexachlorobiphenyl'),
('2,3,4,4'',5-Pentachlorobiphenyl'),
('2,3'',4,4''-Tetrachlorobiphenyl'),
('2,3,4,6,7,8-Hexachlorodibenzofuran'),
('2,3,4,7,8-Pentachlorodibenzofuran'),
('2,3,7,8-Tetrachlorodibenzofuran'),
('2,3,7,8-Tetrachlorodibenzo-P-Dioxin'),
('2,4,4''-Trichlorobiphenyl'),
('2,4,5-T'),
('2,4-D'),
('2,4''-Dichlorobiphenyl'),
('2,6-Dimethylnaphthalene'),
('2M4-DB'),
('2-Methylnapthalene'),
('3,3'',4,4'',5-Pentachlorobiphenyl'),
('3,3'',4,4''-Tetrachlorobiphenyl'),
('4-Nitrophenol'),
('Acenaphthene'),
('Acenaphthylene'),
('Aldrin'),
('Alkalinity, Bicarbonate'),
('Alkalinity, Carbonate'),
('Alkalinity, Hydroxide'),
('Alkalinity, Total'),
('Aluminum'),
('Ammonia-Nitrogen'),
('Anthracene'),
('Antimony'),
('Apparent Color'),
('Aroclor 1016'),
('Aroclor 1221'),
('Aroclor 1232'),
('Aroclor 1242'),
('Aroclor 1248'),
('Aroclor 1254'),
('Aroclor 1260'),
('Arsenic'),
('Azinphos-Methyl'),
('Barium'),
('Barometric Pressure'),
('Battery Charge'),
('Benz[A]Anthracene'),
('Benzo(B)Fluoranthene'),
('Benzo[A]Pyrene'),
('Benzo[Ghi]Perylene'),
('Benzo[K]Fluoranthene'),
('Beryllium'),
('Bicarbonate'),
('Biochemical Oxygen Demand, Standard Conditions'),
('Biphenyl'),
('Boron'),
('Bromide'),
('Bromoxynil Octanoate'),
('Cadmium'),
('Calcium'),
('Carbonate'),
('Cerium'),
('Chlordane'),
('Chlordanes'),
('Chloride'),
('Chlorophyll A'),
('Chlorpyrifos'),
('Chromium'),
('Chrysene'),
('Cobalt'),
('Conductivity'),
('Conductivity-Actual'),
('Conductivity-Spec Cond'),
('Specific Conductivity'),
('Conductivity-TDS'),
('Copper'),
('Coumaphos'),
('d(18O/16O)'),
('d(2H/1H)'),
('Dalapon'),
('Decachlorobiphenyl'),
('Demeton'),
('Depth'),
('Depth, bottom'),
('Diazinon'),
('Dibenz[A,H]Anthracene'),
('Dibenzothiophene'),
('Dicamba'),
('Dichlorprop'),
('Dichlorvos'),
('Dieldrin'),
('Dimethoate'),
('Dinoseb'),
('Dissolved oxygen (DO)'),
('Dissolved oxygen saturation'),
('Dissolved oxygen local'),
('Disulfoton'),
('Dry bulk density'),
('Dysprosium'),
('Endosulfan sulfate'),
('Endrin'),
('Endrin Aldehyde'),
('Endrin Ketone'),
('Escherichia coli'),
('Ethoprop'),
('Fecal Coliform'),
('Fensulfothion'),
('Fenthion'),
('Fluoranthene'),
('Fluorene'),
('Fluoride'),
('Gallium'),
('Germanium'),
('Glyphosate'),
('Grain Density'),
('Heptachlor'),
('Heptachlor Epoxide'),
('Heptachlorodibenzofuran'),
('Heptachlorodibenzo-P-Dioxin'),
('Hexachlorobenzene'),
('Hexachlorodibenzofuran'),
('Hexachlorodibenzo-P-Dioxin'),
('Holmium'),
('Indeno[1,2,3-Cd]Pyrene'),
('Inorganic Nitrogen (Nitrate and Nitrite)'),
('Iron'),
('Kjeldahl Nitrogen'),
('Lanthanum'),
('Lead'),
('Lindane'),
('Lithium'),
('Lutetium'),
('Magnesium'),
('Manganese'),
('Mercury'),
('Merphos'),
('Methoxychlor'),
('Methyl Parathion'),
('Methylmercury(1+)'),
('Mevinphos'),
('Mirex'),
('Molybdenum'),
('Naled'),
('Naphthalene'),
('Neodymium'),
('Nickel'),
('Nitrate'),
('Nitrate (NO3-)'),
('Nitrate-Nitrogen (NO3-N)'),
('Nitrite'),
('NULL'),
('O,P''-DDD'),
('O,P''-DDE'),
('O,P''-DDT'),
('O-Ethyl O-(P-Nitrophenyl) Phenylphosphonothioate'),
('Organic Carbon'),
('Orthophosphate'),
('P,P''-DDD'),
('P,P''-DDE'),
('P,P''-DDT'),
('Parathion'),
('Pentachlorodibenzofuran'),
('Pentachlorodibenzo-P-Dioxin'),
('Pentachloronitrobenzene'),
('Pentachlorophenol'),
('pH'),
('pH mV'),
('pH, Lab'),
('Phenanthrene'),
('Phorate'),
('Phosphate (PO43-)'),
('Phosphate-Phosphorus'),
('Phosphorus'),
('Potassium'),
('Praseodymium'),
('Prothiofos'),
('Pyrene'),
('Rhodium'),
('Ronnel'),
('Rubidium'),
('Samarium'),
('Sand'),
('Saturated Bulk Density'),
('Salinity'),
('Scandium'),
('Selenium'),
('Silica'),
('Silicon'),
('Silver'),
('Silvex'),
('Sodium'),
('Specific Conductance'),
('Strontium'),
('Sulfate'),
('Sulfotep'),
('Sulprofos'),
('Susceptibility Avg'),
('Temperature, water'),
('Terbium'),
('Tetrachlorodibenzofuran'),
('Tetrachlorodibenzo-P-Dioxin'),
('Tetrachlorvinphos'),
('Thallium'),
('Thulium'),
('Tin'),
('Titanium'),
('Total Coliform'),
('Total Dissolved Solids'),
('Total Hardness'),
('Total Solids'),
('Total Suspended Solids'),
('Toxaphene'),
('Trans-Nonachlor'),
('Tributyl Phosphate'),
('Trichloronate'),
('Triphenyl Phosphate'),
('Turbidity'),
('Vanadium'),
('Wiper Peak Current'),
('Ytterbium'),
('Yttrium'),
('Zinc'),
('Zirconium'),
('Water Temperature'),
('int_RelativeHumidity'),
('System Battery'),
('Sonde Battery'),
('Cable Power'),
('Relative Humidity in Box'),
('Power to Storm3'),
('Wiper Position'),
('Appended Battery'),
('Air Temperature'),
('Streamflow'),
('Stream Stage')

-- Make all the items Active, for now.
update dbo.Characteristics set CharacteristicActive = 1

-- Now add the other stuff
insert into dbo.Datastores ([Name], [Description], TablePrefix, OwnerUserId, LocationTypeId, DefaultConfig, TableType)
values('Characteristics','Characteristics','Characteristics',1081,null,'{}','Single');

update dbo.Fields set PossibleValues = null, DataSource = 'select [Id], CharacteristicName from dbo.Characteristics' where Id = 2172

insert into dbo.Datasets(ProjectId, DefaultRowQAStatusId, StatusId, CreateDateTime, [Name], [Description], DefaultActivityQAStatusId, DatastoreId, Config)
values(11043, 1, 1, (select convert(varchar, getdate(), 121)), 'WQ-Characteristics', 'Characteristics Lookup Table', 5, (select Id from dbo.Datastores where TablePrefix = 'Characteristics'), null)

insert into dbo.LookupTables([Name], Label, [Description], DatasetId)
values ('Characteristics Lookup Fields', 'Characteristics', 'Characteristics Lookup Table', (select Id from dbo.Datasets where [Name] = 'WQ-Characteristics'))

--update dbo.Projects
--set Config = '{"Lookups":[{"Id":"3","Label":"Instruments"},{"Id":"5","Label":"Characteristics","DatasetId":1292}]}'
--where [Name] = 'WRP Surface Water Monitoring'

--update dbo.Projects set Config = '{"Lookups":[{"Id":"3","Label":"Instruments"},{"Id":"5","Label":"Characteristics","DatasetId":1295}],"ShowDelete":"false"}'
--where [Name] = 'WRP Surface Water Monitoring'
update dbo.Projects set Config = '{"Lookups":[{"Id":"3","Label":"Instruments"},{"Id":"5","Label":"Characteristics","DatasetId":1296}],"ShowDelete":"false"}'
where [Name] = 'WRP Surface Water Monitoring'

insert into dbo.Fields(TechnicalName, [Name], [Description], Units, Validation, DataType, PossibleValues, [Rule], DbColumnName, ControlType, DataSource, DatastoreId, FieldRoleId)
values(null, 'Characteristic Name', 'Name of characteristic', null, null, 'string', null, null, 'CharacteristicName', 'text', null, (select Id from dbo.Datastores where TablePrefix = 'Characteristics'), 2),
(null, 'Characteristic Active', 'Is the characteristic active?', null, null, 'int', null, null, 'CharacteristicActive', 'number', null, (select Id from dbo.Datastores where TablePrefix = 'Characteristics'), 2)

update dbo.Fields
set PossibleValues = null, ControlType = 'select-number', DataSource = 'select Id, CharacteristicName as Label from dbo.Characteristics where CharacteristicActive = 1'
where DatastoreId = 6 and DbColumnName = 'CharacteristicName'
--update dbo.Fields set ControlType = 'select-number' where [Id] = 2172

insert into dbo.DatasetFields(DatasetId, FieldId, FieldRoleId, CreateDateTime, Label, DbColumnName, [Validation], SourceId, InstrumentId, OrderIndex, ControlType, [Rule], ColumnIndex)
values ((select Id from dbo.Datasets where [Name] = 'WQ-Characteristics'), 
(select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'Characteristics') and DbColumnName = 'CharacteristicName'),
2,
(select convert(varchar, getdate(), 121)),
'Characteristic Name',
'CharacteristicName',
null, 1, null, null, 'text', null, null
),
((select Id from dbo.Datasets where [Name] = 'WQ-Characteristics'), 
(select Id from dbo.Fields where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'Characteristics') and DbColumnName = 'CharacteristicActive'),
2,
(select convert(varchar, getdate(), 121)),
'Characteristic Active',
'CharacteristicActive',
null, 1, null, null, 'text', null, null
)

--Code above here, since last posting, posted to Test on 4/9/2020

update dbo.Fields set ControlType = 'select-number', PossibleValues = '{"0":"Active","1":"Inactive"}' where [Id] in (select Id from dbo.Fields where DbColumnName = 'CharacteristicActive' and DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'Characteristics'))

update dbo.DatasetFields set ControlType = 'select-number' where [Id] in (select Id from dbo.DatasetFields where DatasetId in (select Id from dbo.Datasets where DatastoreId in (select Id from dbo.Datastores where TablePrefix = 'Characteristics')) and DbColumnName = 'CharacteristicActive')

update dbo.Characteristics set CharacteristicActive = 0

--Code above here, since last posting, posted to Test on 4/10/2020

update dbo.Fields
set DataSource = 'select Id, CharacteristicName as Label from dbo.Characteristics where CharacteristicActive = 0'
where DataSource = 'select Id, CharacteristicName as Label from dbo.Characteristics where CharacteristicActive = 1'

--Code above here, since last posting, posted to Test on 4/13/2020

update dbo.Datastores set TableType = 'Single' where TablePrefix = 'Characteristics'

--select * from dbo.Fields where PossibleValues = '{"0":"Active","1":"Inactive"}' or [Id] = 2294

/*
select * from dbo.Datastores where Id in (24,27,42)

select * from dbo.Datasets where DatastoreId in (24,27,42)

select * from dbo.DatasetFields where DatasetId in (1262, 1275, 1295)

--
update dbo.Fields set ControlType = 'select-number' where [Id] = 2172
*/

--select * from dbo.Fields where DbColumnName = 'CharacteristicName'