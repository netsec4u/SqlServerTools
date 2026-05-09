---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Remove-SmoDatabaseFileGroup.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Remove-SmoDatabaseFileGroup
---

# Remove-SmoDatabaseFileGroup

## SYNOPSIS

Removes a filegroup from a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Remove-SmoDatabaseFileGroup
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Remove-SmoDatabaseFileGroup
  -DatabaseObject <Database>
  -FileGroupName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Removes a filegroup from a SQL Server database. The filegroup must be empty before it can be removed.

## EXAMPLES

### Example 1

```PowerShell
Remove-SmoDatabaseFileGroup -ServerInstance 'localhost' -DatabaseName 'AdventureWorks' -FileGroupName 'TestFileGroup'
```

Removes the filegroup named 'TestFileGroup' from the 'AdventureWorks' database on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance 'localhost' -Name 'AdventureWorks'
Remove-SmoDatabaseFileGroup -DatabaseObject $DatabaseObject -FileGroupName 'TestFileGroup'
```

Removes the filegroup named 'TestFileGroup' from the 'AdventureWorks' database on the local SQL Server instance.

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

The name of the database from which to remove the filegroup.

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

The database object from which to remove the filegroup.

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

The name of the filegroup to remove.

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

The name of the SQL Server instance from which to remove the filegroup.

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

