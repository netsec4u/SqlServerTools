---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoDatabaseQueryStore.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoDatabaseQueryStore
---

# Get-SmoDatabaseQueryStore

## SYNOPSIS

Gets the query store properties.

## SYNTAX

### DatabaseName (Default)

```
Get-SmoDatabaseQueryStore
  -ServerInstance <string>
  -DatabaseName <string>
  [<CommonParameters>]
```

### DatabaseObject

```
Get-SmoDatabaseQueryStore
  -DatabaseObject <Database>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Gets the query store properties.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoDatabaseQueryStore -ServerInstance 'localhost' -DatabaseName 'AdventureWorks'
```

Gets the query store properties in the AdventureWorks database on the local host.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance 'localhost' -DatabaseName 'AdventureWorks'
Get-SmoDatabaseQueryStore -DatabaseObject $DatabaseObject
```

Gets the query store properties in the AdventureWorks database using the database object.

## PARAMETERS

### -DatabaseName

The name of the database for which to get the query store properties.

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

The database object for which to get the query store properties.

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

### Microsoft.SqlServer.Management.Smo.QueryStoreOptions



## NOTES



## RELATED LINKS

