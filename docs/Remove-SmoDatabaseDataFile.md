---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Remove-SmoDatabaseDataFile.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Remove-SmoDatabaseDataFile
---

# Remove-SmoDatabaseDataFile

## SYNOPSIS

Removes a data file from a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Remove-SmoDatabaseDataFile
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  -DataFileName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Remove-SmoDatabaseDataFile
  -DatabaseObject <Database>
  -FileGroupName <string>
  -DataFileName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Removes a data file from a SQL Server database. You can specify the database by name or by passing a SMO Database object.

## EXAMPLES

### Example 1

```PowerShell
Remove-SmoDatabaseDataFile -ServerInstance 'localhost' -DatabaseName 'AdventureWorks' -FileGroupName 'PRIMARY' -DataFileName 'TempDB_Data'
```

Removes the data file named 'TempDB_Data' from the 'PRIMARY' file group in the 'AdventureWorks' database on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance 'localhost' -DatabaseName 'AdventureWorks'
Remove-SmoDatabaseDataFile -DatabaseObject $DatabaseObject -FileGroupName 'PRIMARY' -DataFileName 'TempDB_Data'
```

Removes the data file named 'TempDB_Data' from the 'PRIMARY' file group in the 'AdventureWorks' database using a SMO Database object.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

The name of the database from which to remove the data file.

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

The SMO Database object from which to remove the data file.

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

The name of the data file to remove.

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

### -FileGroupName

The name of the file group from which to remove the data file.

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

The name of the SQL Server instance from which to remove the data file.

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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

