---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoDatabaseFileGroup.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoDatabaseFileGroup
---

# Get-SmoDatabaseFileGroup

## SYNOPSIS

Gets the file groups for a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Get-SmoDatabaseFileGroup
  -ServerInstance <string>
  -DatabaseName <string>
  [-FileGroupName <string>]
  [<CommonParameters>]
```

### DatabaseObject

```
Get-SmoDatabaseFileGroup
  -DatabaseObject <Database>
  [-FileGroupName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Gets the file groups for a SQL Server database. The cmdlet can be used to retrieve information about the file groups associated with a specific database, such as their names and the files they contain.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoDatabaseFileGroup -ServerInstance "MyServer" -DatabaseName "MyDB"
```

Gets all file groups for the database "MyDB" on the SQL Server instance "MyServer".

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance "MyServer" -DatabaseName "MyDB"
Get-SmoDatabaseFileGroup -DatabaseObject $DatabaseObject -FileGroupName "PRIMARY"
```

Gets the file group named "PRIMARY" for the database "MyDB" on the SQL Server instance "MyServer".

## PARAMETERS

### -DatabaseName

The name of the database for which to retrieve the file group information.

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

The database object for which to retrieve the file group information.

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

### -FileGroupName

The name of the file group for which to retrieve information.

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

The name of the SQL Server instance for which to retrieve the file group information.

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

### Microsoft.SqlServer.Management.Smo.FileGroup



## NOTES



## RELATED LINKS

