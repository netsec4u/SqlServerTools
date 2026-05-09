---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Set-SmoDatabaseFileGroup.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Set-SmoDatabaseFileGroup
---

# Set-SmoDatabaseFileGroup

## SYNOPSIS

Sets properties of a filegroup in a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Set-SmoDatabaseFileGroup
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  [-NewFileGroupName <string>]
  [-AutogrowAllFiles <bool>]
  [-IsDefault <bool>]
  [-ReadOnly <bool>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Set-SmoDatabaseFileGroup
  -DatabaseObject <Database>
  -FileGroupName <string>
  [-NewFileGroupName <string>]
  [-AutogrowAllFiles <bool>]
  [-IsDefault <bool>]
  [-ReadOnly <bool>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Sets properties of a filegroup in a SQL Server database. You can change the name of the filegroup, set it as the default filegroup, set it to read-only, and enable or disable autogrowth for all files in the filegroup.

## EXAMPLES

### Example 1

```PowerShell
Set-SmoDatabaseFileGroup -ServerInstance 'localhost' -DatabaseName 'AdventureWorks' -FileGroupName 'TestFileGroup' -IsDefault $true
```

Sets the filegroup named 'TestFileGroup' as the default filegroup for the 'AdventureWorks' database on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance 'localhost' -Name 'AdventureWorks'
Set-SmoDatabaseFileGroup -DatabaseObject $DatabaseObject -FileGroupName 'TestFileGroup' -ReadOnly $true
```

Sets the filegroup named 'TestFileGroup' to read-only for the 'AdventureWorks' database on the local SQL Server instance.

## PARAMETERS

### -AutogrowAllFiles

Specifies whether to enable or disable autogrowth for all files in the filegroup.

```yaml
Type: System.Boolean
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

The name of the database containing the filegroup to modify.

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

The database object containing the filegroup to modify.

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

The name of the filegroup to modify.

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

### -IsDefault

Specifies whether the filegroup is the default filegroup for the database.

```yaml
Type: System.Boolean
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

### -NewFileGroupName

The new name for the filegroup.

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

### -ReadOnly

Specifies whether the filegroup is read-only.

```yaml
Type: System.Boolean
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

### Microsoft.SqlServer.Management.Smo.FileGroup



## NOTES



## RELATED LINKS

