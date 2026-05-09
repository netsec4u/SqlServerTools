---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoDatabaseRole.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoDatabaseRole
---

# Get-SmoDatabaseRole

## SYNOPSIS

Gets the database roles.

## SYNTAX

### DatabaseName (Default)

```
Get-SmoDatabaseRole
  -ServerInstance <string>
  -DatabaseName <string>
  [-RoleName <string>]
  [<CommonParameters>]
```

### DatabaseObject

```
Get-SmoDatabaseRole
  -DatabaseObject <Database>
  [-RoleName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases
  None

## DESCRIPTION

Gets the database roles for a specified database. If a role name is specified, only the database role with that name will be returned. If no role name is specified, all database roles for the specified database will be returned.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoDatabaseRole -ServerInstance 'localhost' -DatabaseName 'AdventureWorks' -RoleName 'db_datareader'
```

Gets the database role named 'db_datareader' for the 'AdventureWorks' database on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance 'localhost' -DatabaseName 'AdventureWorks'
Get-SmoDatabaseRole -DatabaseObject $DatabaseObject
```

Gets all database roles for the 'AdventureWorks' database on the local SQL Server instance by first retrieving the database object and then passing it to the Get-SmoDatabaseRole cmdlet.

## PARAMETERS

### -DatabaseName

The name of the database for which to retrieve database roles.

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

The database object for which to retrieve database roles.

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

### -RoleName

The name of the role to retrieve. If not specified, all roles for the specified database will be returned.

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

### Microsoft.SqlServer.Management.Smo.DatabaseRole



## NOTES



## RELATED LINKS

