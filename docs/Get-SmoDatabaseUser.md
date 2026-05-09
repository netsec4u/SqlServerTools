---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoDatabaseUser.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoDatabaseUser
---

# Get-SmoDatabaseUser

## SYNOPSIS

Retrieves information about a database user in SQL Server.

## SYNTAX

### DatabaseName (Default)

```
Get-SmoDatabaseUser
  -ServerInstance <string>
  -DatabaseName <string>
  [-UserName <string>]
  [<CommonParameters>]
```

### DatabaseObject

```
Get-SmoDatabaseUser
  -DatabaseObject <Database>
  [-UserName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Retrieves information about a database user in SQL Server. You can specify the database user by name, or you can specify the database and return all users in that database.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoDatabaseUser -ServerInstance "localhost" -DatabaseName "AdventureWorks2019" -UserName "MYDOMAIN\JSmith"
```

Gets the database user named "MYDOMAIN\JSmith" from the "AdventureWorks2019" database on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance "localhost" -DatabaseName "AdventureWorks2019"
Get-SmoDatabaseUser -DatabaseObject $DatabaseObject
```

Gets all database users from the "AdventureWorks2019" database on the local SQL Server instance by first retrieving the database object and then passing it to Get-SmoDatabaseUser.

## PARAMETERS

### -DatabaseName

The name of the database containing the user(s) to retrieve.

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

The database object containing the user(s) to retrieve.

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

The name of the SQL Server instance containing the database and user(s) to retrieve.

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

### -UserName

The name of the user to retrieve.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Microsoft.SqlServer.Management.Smo.User



## NOTES



## RELATED LINKS

