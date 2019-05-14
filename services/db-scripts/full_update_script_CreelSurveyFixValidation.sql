update dbo.Fields
set [Rule] = '{"DefaultValue": "0","OnValidate": "if(row[''NumberAnglersInterviewed''] > row[''NumberAnglersObserved'']) row_errors.push(''[NumberAnglersObserved] cannot be less than NumberAnglersInterviewed'');"}'
where DbColumnName = 'NumberAnglersObserved'

update dbo.Fields
set [Rule] = '{"DefaultValue": "0","OnValidate": "if(row[''NumberAnglersInterviewed''] > row[''NumberAnglersObserved'']) row_errors.push(''[NumberAnglersInterviewed] cannot be greater than Number Anglers Observed'');"}'
where DbColumnName = 'NumberAnglersInterviewed'

update dbo.Fields
set [Rule] = '{"DefaultValue": "0","OnValidate": "if ((typeof row[''InterviewTime''] !== ''undefined'' && row[''InterviewTime''] !== null) && ((typeof event.scope.row[''NumberAnglersInterviewed''] === ''undefined'') || (event.scope.row[''NumberAnglersInterviewed''] === ''0'') || (event.scope.row[''NumberAnglersInterviewed''] === 0))) row_errors.push(''An interview cannot be present, when NumberAnglersInterviewed = 0'');"}'
where DatastoreId in (select Id from dbo.Datastores where TablePrefix like '%Creel%') and DbColumnName = 'InterviewTime'