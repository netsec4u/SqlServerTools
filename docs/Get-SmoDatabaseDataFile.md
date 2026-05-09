---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoDatabaseDataFile.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoDatabaseDataFile
---

# Get-SmoDatabaseDataFile

## SYNOPSIS

Gets the data file for a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Get-SmoDatabaseDataFile
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  [-DataFileName <string>]
  [<CommonParameters>]
```

### DatabaseObject

```
Get-SmoDatabaseDataFile
  -DatabaseObject <Database>
  -FileGroupName <string>
  [-DataFileName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Gets the data file for a SQL Server database. The cmdlet can be used to retrieve information about the data files associated with a specific database, such as their names, sizes, and file groups.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoDatabaseDataFile -ServerInstance "MyServer" -DatabaseName "MyDB" -FileGroupName "PRIMARY"
```

Gets all data files in the "PRIMARY" file group for the database "MyDB" on the SQL Server instance "MyServer".

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance "MyServer" -DatabaseName "MyDB"
Get-SmoDatabaseDataFile -DatabaseObject $DatabaseObject -FileGroupName "PRIMARY"
```

Gets all data files in the "PRIMARY" file group for the database "MyDB" on the SQL Server instance "MyServer".  This example demonstrates how to use a SMO Database object to specify the database for which to retrieve the data file information.

## PARAMETERS

### -DatabaseName

The name of the database for which to retrieve the data file information.

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

The SMO Database object representing the database for which to retrieve the data file information.

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

### -DataFileName

The name of the data file to retrieve. If not specified, all data files for the database will be retrieved.

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

### -FileGroupName

The name of the file group to which the data file belongs.

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

The name of the SQL Server instance for which to retrieve the data file information.

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

### Microsoft.SqlServer.Management.Smo.DataFile



## NOTES



## RELATED LINKS

