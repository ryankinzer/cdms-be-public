-- NOTE - this isn't ready to run yet... 

CREATE TABLE [dbo].[COVID_EmployeesWork] (
    [Id] [int] NOT NULL IDENTITY,
    [EmployeeId] int NOT NULL,
	WorkDate datetime NOT NULL,
	WorkStatus varchar(max)
    CONSTRAINT [PK_dbo.COVID_EmployeesWork] PRIMARY KEY ([Id])
)

CREATE TABLE COVID_Employees (
    [Id] [int] NOT NULL IDENTITY,
    [RecordStatus] int NULL,
    [Name] NVarChar(255) NULL,
    [Program] NVarChar(255) NULL,
    [Department] NVarChar(255) NULL,
    [Title] NVarChar(255) NULL,
    [Email] NVarChar(255) NULL,
    [Status] NVarChar(255) NULL,
    [SupervisorUsername] NVarChar(255) NULL,
    [DeptSupervisorUsername] NVarChar(255) NULL,
    [Access] NVarChar(255) NULL,
    IsHighRisk NVarChar(20) NULL,
    IsUnique NVarChar(20) NULL,
    IsSick NVarChar(20) NULL,
    Notes NVarChar(max) NULL
    CONSTRAINT [PK_dbo.COVID_Employees] PRIMARY KEY ([Id])
)

CREATE INDEX [IX_COVIDWorkEmployeeId] ON [dbo].[COVID_EmployeesWork]([EmployeeId])
-- ALTER TABLE COVID_Employees ADD RecordStatus int NULL;

go

SET IDENTITY_INSERT COVID_Employees ON;
insert into COVID_Employees (Id, Name, Program, Department, Title, Email, Status, SupervisorUsername, Access, IsHighRisk, IsUnique, Notes, IsSick, DeptSupervisorUsername)
select Id, Name, Program, Department, Title, Email, Status, SupervisorUsername, Access, IsHighRisk, IsUnique, Notes, IsSick, DeptSupervisorUsername from CDMS_TEST.dbo.COVID_Employees;
SET IDENTITY_INSERT COVID_Employees OFF;

go

-- notes below, don't run...

update COVID_Employees set DeptSupervisorUsername = 'katb' where department = 'Board of Trustees'
update COVID_Employees set DeptSupervisorUsername = 'juliet' where department = 'Children and Family Services'
update COVID_Employees set DeptSupervisorUsername = 'janeh' where department = 'Communications'
update COVID_Employees set DeptSupervisorUsername = 'billt' where department = 'Economic and Community Development'
update COVID_Employees set DeptSupervisorUsername = 'modestam' where department = 'Education'
update COVID_Employees set DeptSupervisorUsername = 'tonim' where department = 'Enrollment'
update COVID_Employees set DeptSupervisorUsername = 'paulr' where department = 'Finance'
update COVID_Employees set DeptSupervisorUsername = 'maureenm' where department = 'Gaming Commission'
update COVID_Employees set DeptSupervisorUsername = 'lindseyw' where department = 'General Council'
update COVID_Employees set DeptSupervisorUsername = 'marcusl' where department = 'Housing'
update COVID_Employees set DeptSupervisorUsername = 'kathrynb' where department = 'Human Resources'
update COVID_Employees set DeptSupervisorUsername = 'tedw' where department = 'Office of Executive Director'
update COVID_Employees set DeptSupervisorUsername = 'naomis' where department = 'Office of Legal Counsel'
update COVID_Employees set DeptSupervisorUsername = 'robb' where department = 'Public Safety'
update COVID_Employees set DeptSupervisorUsername = 'franka' where department = 'Public Works'
update COVID_Employees set DeptSupervisorUsername = 'bobbiec' where department = 'Tamastslikt Cultural Institute'
update COVID_Employees set DeptSupervisorUsername = 'williamj' where department = 'Umatilla Tribal Court'


update covid_employees set supervisorusername = 'kokoh' where program = 'Land Acquisition'
update covid_employees set supervisorusername = 'kevinh' where program = 'Farming'
update covid_employees set supervisorusername = 'keyshaa' where program = 'Early Childhood Development'
update covid_employees set supervisorusername = 'lloydc' where program = 'Head Start'
update covid_employees set supervisorusername = 'brandiew' where program = 'Higher Education'
update covid_employees set supervisorusername = 'katrinam' where program = 'Language'
update covid_employees set supervisorusername = 'brads' where program = 'Inspectors' and department = 'Gaming Commission'
update covid_employees set supervisorusername = 'abbyn' where program = 'Surveillance'
update covid_employees set supervisorusername = 'tannerm' where program = 'Maintenance' and department = 'Housing'
update covid_employees set supervisorusername = 'susiec' where program = 'Voc Rehab' 
update covid_employees set supervisorusername = 'tearaf' where program = 'CRPP' 
update covid_employees set supervisorusername = 'masonkm' where program = 'Energy and Environmental Science' 
update covid_employees set supervisorusername = 'chrism' where program = 'FFPP' 
update covid_employees set supervisorusername = 'garyj' where program = 'Fisheries' 
update covid_employees set supervisorusername = 'gordys' where program = 'RAF' 
update covid_employees set supervisorusername = 'davidh' where program = 'Water' 
update covid_employees set supervisorusername = 'carls' where program = 'Wildlife' 
update covid_employees set supervisorusername = 'danaq' where program = 'Office of Executive Director' 
update covid_employees set supervisorusername = 'stacys' where program = 'GIS' 
update covid_employees set supervisorusername = 'theresau' where program = 'ITS' 
update covid_employees set supervisorusername = 'janenem' where program = 'Records' 
update covid_employees set supervisorusername = 'jdtovey' where program = 'Planning' 
update covid_employees set supervisorusername = 'erinb' where program = 'CSE' 
update covid_employees set supervisorusername = 'robb' where program = 'Fire' 
update covid_employees set supervisorusername = 'propserp' where program = 'Facilities' and department = 'Public Safety' 
update covid_employees set supervisorusername = 'kellys' where program = 'Tribal Court' 




-- update the supervisorusername to a list
update e 
	set SupervisorUsername = concat('["', ce.supervisorusername, '"]')
from covid_employees e 
join covid_employees ce
	on ce.Id = e.Id
	where e.SupervisorUsername is not null;


