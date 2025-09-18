---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SqlClientDataSet
---

# Get-SqlClientDataSet

## SYNOPSIS

Executes Transact-SQL statement against a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Get-SqlClientDataSet
  -ServerInstance <string>
  -DatabaseName <string>
  -SqlCommandText <string>
  [-CommandType <CommandType>]
  [-SqlParameter <List`1[SqlParameter]>]
  [-OutSqlParameter <List`1[SqlParameter]>]
  [-CommandTimeout <int>]
  [-DataSetName <string>]
  [-DataTableName <string>]
  [-OutputAs <DataOutputType>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnection

```
Get-SqlClientDataSet
  -SqlConnection <SqlConnection>
  -SqlCommandText <string>
  [-DatabaseName <string>]
  [-CommandType <CommandType>]
  [-SqlParameter <List`1[SqlParameter]>]
  [-OutSqlParameter <List`1[SqlParameter]>]
  [-CommandTimeout <int>]
  [-DataSetName <string>]
  [-DataTableName <string>]
  [-OutputAs <DataOutputType>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Executes Transact-SQL statement against a SQL Server database.

## EXAMPLES

### EXAMPLE 1

Get-SqlClientDataSet -ServerInstance MyServer -DatabaseName master -SqlCommandText "SELECT * FROM sys.tables;"

Gets data set from query.

### EXAMPLE 2

$SqlConnection = Connect-SQLServerInstance -ServerInstance MyServer -DatabaseName master

Get-SqlClientDataSet -SqlConnection $SqlConnection -SqlCommandText "SELECT * FROM sys.tables;"

Gets data set from query using the specified connection.

## PARAMETERS

### -CommandTimeout

The length of time (in seconds) to wait for SQL command before terminating the attempt and throwing an exception.
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

### -CommandType

Specifies a value indicating how the CommandText property is to be interpreted.

```yaml
Type: System.Data.CommandType
DefaultValue: Text
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

### -DatabaseName

Specifies the name of the database.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DataSetName

Specifies name of data set returned.

```yaml
Type: System.String
DefaultValue: NewDataSet
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

### -DataTableName

Specifies name of data table returned.

```yaml
Type: System.String
DefaultValue: NewDataTable
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

### -OutputAs

Specifies output object type.

```yaml
Type: DataOutputType
DefaultValue: DataTable
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

### -OutSqlParameter

Specifies reference parameter that will contain output SQL parameters.

```yaml
Type: System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlParameter]
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

### -ServerInstance

Specifies the name of a SQL Server instance.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: DatabaseName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SqlCommandText

Sets the Transact-SQL statement, table name or stored procedure to execute at the data source.

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

### -SqlParameter

Specifies the SQL parameters of the Transact-SQL statement or stored procedure.

```yaml
Type: System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlParameter]
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

### System.Data.DataSet



### System.Data.DataTable



### System.Data.DataRow



### System.Boolean



## NOTES




## RELATED LINKS

None.

