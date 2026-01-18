---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Invoke-SqlClientBulkCopy
---

# Invoke-SqlClientBulkCopy

## SYNOPSIS

Use SQL Bulk copy to insert data into database table.

## SYNTAX

### ServerInstance_DataTable (Default)

```
Invoke-SqlClientBulkCopy
  -ServerInstance <string>
  -DatabaseName <string>
  -TableName <string>
  -DataTable <DataTable>
  [-RowState <DataRowState>]
  [-ColumnMappingCollection <List`1[SqlBulkCopyColumnMapping]>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-NotifyAfter <int>]
  [-EnableStreaming]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### ServerInstance_DataRow

```

Invoke-SqlClientBulkCopy
  -ServerInstance <string>
  -DatabaseName <string>
  -TableName <string>
  -DataRow <DataRow[]>
  [-ColumnMappingCollection <List`1[SqlBulkCopyColumnMapping]>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-NotifyAfter <int>]
  [-EnableStreaming]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnectionString_DataTable

```
Invoke-SqlClientBulkCopy
  -ConnectionString <string>
  -TableName <string>
  -DataTable <DataTable>
  [-RowState <DataRowState>]
  [-ColumnMappingCollection <List`1[SqlBulkCopyColumnMapping]>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-NotifyAfter <int>]
  [-EnableStreaming]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnectionString_DataRow

```
Invoke-SqlClientBulkCopy
  -ConnectionString <string>
  -TableName <string>
  -DataRow <DataRow[]>
  [-ColumnMappingCollection <List`1[SqlBulkCopyColumnMapping]>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-NotifyAfter <int>]
  [-EnableStreaming]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnection_DataTable

```
Invoke-SqlClientBulkCopy
  -SqlConnection <SqlConnection>
  -TableName <string>
  -DataTable <DataTable>
  [-RowState <DataRowState>]
  [-ColumnMappingCollection <List`1[SqlBulkCopyColumnMapping]>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-NotifyAfter <int>]
  [-EnableStreaming]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnection_DataRow

```
Invoke-SqlClientBulkCopy
  -SqlConnection <SqlConnection>
  -TableName <string>
  -DataRow <DataRow[]>
  [-ColumnMappingCollection <List`1[SqlBulkCopyColumnMapping]>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-NotifyAfter <int>]
  [-EnableStreaming]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Use SQL Bulk copy to insert data into database table.

## EXAMPLES

### EXAMPLE 1

$DataTable = $DataTableGet-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataTable

Invoke-SqlClientBulkCopy -ServerInstance "MySQLServer" -DatabaseName AdventureWorks -TableName "MyTable" -DataTable $DataTable

Perform bulk copy against AdventureWorks database using the specified data table.

### EXAMPLE 2

$DataRow = $DataTableGet-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataRow

Invoke-SqlClientBulkCopy -ServerInstance "MySQLServer" -DatabaseName AdventureWorks -TableName "MyTable" -DataTable $DataRow

Perform bulk copy against AdventureWorks database using specified data row.

### EXAMPLE 3

$DataTable = Get-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataTable
$ConnectionString = 'Data Source=.;Initial Catalog=AdventureWorks;Integrated Security=True;'

Invoke-SqlClientBulkCopy -ConnectionString $ConnectionString -TableName "MyTable" -DataTable $DataTable

Perform bulk copy using connection string.

### Example 4

$DataRow = $DataTableGet-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataRow
$ConnectionString = 'Data Source=.;Initial Catalog=AdventureWorks;Integrated Security=True;'

Invoke-SqlClientBulkCopy -ConnectionString $ConnectionString -TableName "MyTable" -DataTable $DataRow

Perform bulk copy against AdventureWorks database using specified data row.

### EXAMPLE 5

$DataTable = Get-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataTable
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName AdventureWorks

Invoke-SqlClientBulkCopy -SqlConnection $SqlConnection -TableName "MyTable" -DataTable $DataTable

Perform bulk copy using the SQL connection.

### EXAMPLE 6

$DataRow = Get-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataRow
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName AdventureWorks

Invoke-SqlClientBulkCopy -SqlConnection $SqlConnection -TableName "MyTable" -DataTable $DataRow

Perform bulk copy using the SQL connection.

## PARAMETERS

### -BatchSize

Bulk import batch size.

```yaml
Type: System.Int32
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ColumnMappingCollection

Specifies column mappings to define the relationships between columns in the data source and columns in the destination.

```yaml
Type: System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```


### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ConnectionString

SQL Server Connection string.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnectionString_DataTable
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlConnectionString_DataRow
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatabaseName

Name of database.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ServerInstance_DataTable
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_DataRow
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DataRow

Specifies data row.

```yaml
Type: System.Data.DataRow[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnectionString_DataRow
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlConnection_DataRow
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_DataRow
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DataTable

Specifies Data table.

```yaml
Type: System.Data.DataTable
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnectionString_DataTable
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlConnection_DataTable
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_DataTable
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EnableStreaming

Enables streaming.
Streaming is only applicable to max data types (i.e. VARBINARY(MAX), VARCHAR(MAX), NVARCHAR(MAX), and XML)

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NotifyAfter

Specifies the number of rows to be processed before generating a notification event.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -QueryTimeout

The length of time (in seconds) to wait for a query before terminating the query and throwing an exception.
Default is 30 seconds.

```yaml
Type: System.Int32
DefaultValue: 30
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RowState

Specifies only the rows matching the row state are copied to the destination.

```yaml
Type: System.Data.DataRowState
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnectionString_DataTable
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlConnection_DataTable
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_DataTable
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```
### -ServerInstance

SQL Server host name and instance name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: ServerInstance_DataTable
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ServerInstance_DataRow
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SqlBulkCopyOptions

Bulk copy options.

```yaml
Type: Microsoft.Data.SqlClient.SqlBulkCopyOptions
DefaultValue: Default
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SqlConnection

Specifies SQL connection object.

```yaml
Type: Microsoft.Data.SqlClient.SqlConnection
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnection_DataTable
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlConnection_DataRow
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TableName

Table name to insert data.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void



## NOTES




## RELATED LINKS

None.

