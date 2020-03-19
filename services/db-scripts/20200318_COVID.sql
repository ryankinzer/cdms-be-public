CREATE TABLE [dbo].[COVID_EmployeesWork] (
    [Id] [int] NOT NULL IDENTITY,
    [EmployeeId] int NOT NULL,
	WorkDate datetime NOT NULL,
	WorkStatus varchar(max)
    CONSTRAINT [PK_dbo.COVID_EmployeesWork] PRIMARY KEY ([Id])
)

CREATE TABLE COVID_Employees (
    [Id] [int] NOT NULL IDENTITY,
    [Name] NVarChar(255) NULL,
    [Program] NVarChar(255) NULL,
    [Department] NVarChar(255) NULL,
    [Title] NVarChar(255) NULL,
    [Email] NVarChar(255) NULL,
    [Status] NVarChar(255) NULL,
    [SupervisorUsername] NVarChar(255) NULL,
    [Access] NVarChar(255) NULL,
    IsHighRisk NVarChar(20) NULL,
    IsUnique NVarChar(20) NULL,
    IsSick NVarChar(20) NULL,
    Notes NVarChar(max) NULL
    CONSTRAINT [PK_dbo.COVID_Employees] PRIMARY KEY ([Id])
)