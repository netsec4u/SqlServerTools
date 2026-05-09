---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoDatabaseSchema.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoDatabaseSchema
---

# Get-SmoDatabaseSchema

## SYNOPSIS

Retrieves the schema of a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Get-SmoDatabaseSchema
  -ServerInstance <string>
  -DatabaseName <string>
  [-SchemaName <string>]
  [<CommonParameters>]
```

### DatabaseObject

```
Get-SmoDatabaseSchema
  -DatabaseObject <Database>
  [-SchemaName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Retrieves the schema of a SQL Server database. The schema can be specified by name or by providing a Database object.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoDatabaseSchema -ServerInstance "localhost" -DatabaseName "AdventureWorks" -SchemaName "Sales"
```

Retrieves the schema of the "Sales" schema in the "AdventureWorks" database on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance "localhost" -DatabaseName "AdventureWorks"
Get-SmoDatabaseSchema -DatabaseObject $DatabaseObject
```

Retrieves the schema of the "AdventureWorks" database on the local SQL Server instance.

## PARAMETERS

### -DatabaseName

The name of the database from which to retrieve the schema.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -DatabaseObject

The database object from which to retrieve the schema.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SchemaName

The name of the schema to retrieve.

```yaml
Type: System.String
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

### -ServerInstance

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: ''
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Microsoft.SqlServer.Management.Smo.Schema



## NOTES



## RELATED LINKS

