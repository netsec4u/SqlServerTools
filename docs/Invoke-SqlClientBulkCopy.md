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

### ServerInstance (Default)

```
Invoke-SqlClientBulkCopy
  -ServerInstance <string>
  -DatabaseName <string>
  -TableName <string>
  -DataTable <DataTable>
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnectionString

```
Invoke-SqlClientBulkCopy
  -ConnectionString <string>
  -TableName <string>
  -DataTable <DataTable>
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnection

```
Invoke-SqlClientBulkCopy
  -SqlConnection <SqlConnection>
  -TableName <string>
  -DataTable <DataTable>
  [-QueryTimeout <int>]
  [-BatchSize <int>]
  [-SqlBulkCopyOptions <SqlBulkCopyOptions>]
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

Perform bulk copy against AdventureWorks database.

### EXAMPLE 2

$DataTable = Get-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataTable
$ConnectionString = 'Data Source=.;Initial Catalog=AdventureWorks;Integrated Security=True;'

Invoke-SqlClientBulkCopy -ConnectionString $ConnectionString -TableName "MyTable" -DataTable $DataTable

Perform bulk copy using connection string.

### EXAMPLE 3

$DataTable = Get-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataTable
$SqlConnection = Connect-SqlServerInstance -ServerInstance . -DatabaseName AdventureWorks

Invoke-SqlClientBulkCopy -SqlConnection $SqlConnection -TableName "MyTable" -DataTable $DataTable

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
- Name: SqlConnectionString
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
- Name: ServerInstance
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

Data table.

```yaml
Type: System.Data.DataTable
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

### -ServerInstance

SQL Server host name and instance name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: ServerInstance
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
- Name: SqlConnection
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

