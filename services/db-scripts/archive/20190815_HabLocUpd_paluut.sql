update dbo.Datasets set Config = '{"ActivitiesPage":{"Route":"habitatsites"},"LocationsPage":{"HideDataset":"true"}}'
where [Name] like '%Sites%'