---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoDatabaseRoleMember.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoDatabaseRoleMember
---

# Get-SmoDatabaseRoleMember

## SYNOPSIS

Retrieves the members of a database role.

## SYNTAX

### DatabaseName (Default)

```
Get-SmoDatabaseRoleMember
  -ServerInstance <string>
  -DatabaseName <string>
  -RoleName <string>
  [<CommonParameters>]
```

### DatabaseObject

```
Get-SmoDatabaseRoleMember
  -DatabaseObject <Database>
  -RoleName <string>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Retrieves the members of a database role. You can specify the database by name or by passing a Database object. This cmdlet returns objects representing the members of the specified database role.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoDatabaseRoleMember -ServerInstance 'localhost' -DatabaseName 'AdventureWorks2019' -RoleName 'db_datareader'
```

Gets the members of the 'db_datareader' role in the 'AdventureWorks2019' database on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance 'localhost' -Name 'AdventureWorks2019'
Get-SmoDatabaseRoleMember -DatabaseObject $DatabaseObject -RoleName 'db_datareader'
```

Gets the members of the 'db_datareader' role in the 'AdventureWorks2019' database by first retrieving a Database object for the database and then passing it to Get-SmoDatabaseRoleMember.

## PARAMETERS

### -DatabaseName

The name of the database containing the role for which to retrieve members.

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

The Database object representing the database containing the role for which to retrieve members.

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

The name of the database role for which to retrieve members.

```yaml
Type: System.String
DefaultValue: ''
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

### -ServerInstance

The name of the SQL Server instance containing the database.

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

### SqlServerTools.DatabaseRoleMember



## NOTES



## RELATED LINKS

