CREATE TABLE [dbo].[COVID_EmployeesWork] (
    [Id] [int] NOT NULL IDENTITY,
    [EmployeeId] int NOT NULL,
	WorkDate datetime NOT NULL,
	WorkStatus varchar(max)
    CONSTRAINT [PK_dbo.COVID_EmployeesWork] PRIMARY KEY ([Id])
)
