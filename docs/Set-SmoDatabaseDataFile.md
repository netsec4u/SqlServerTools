---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Set-SmoDatabaseDataFile.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Set-SmoDatabaseDataFile
---

# Set-SmoDatabaseDataFile

## SYNOPSIS

Sets properties of a data file in a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Set-SmoDatabaseDataFile
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  -DataFileName <string>
  [-NewDataFileName <Object>]
  [-Growth <int>]
  [-GrowthType <FileGrowthType>]
  [-MaxSize <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Set-SmoDatabaseDataFile
  -DatabaseObject <Database>
  -FileGroupName <string>
  -DataFileName <string>
  [-NewDataFileName <Object>]
  [-Growth <int>]
  [-GrowthType <FileGrowthType>]
  [-MaxSize <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Sets properties of a data file in a SQL Server database. This cmdlet can be used to change the name, growth settings, and maximum size of an existing data file.

## EXAMPLES

### Example 1

```PowerShell
Set-SmoDatabaseDataFile -ServerInstance 'localhost' -DatabaseName 'AdventureWorks' -FileGroupName 'PRIMARY' -DataFileName 'AdventureWorks_Data' -Growth 65536 -GrowthType KB
```

Sets the growth of the 'AdventureWorks_Data' data file in the 'PRIMARY' filegroup of the 'AdventureWorks' database to 65536 KB on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance 'localhost' -Name 'AdventureWorks'
Set-SmoDatabaseDataFile -DatabaseObject $DatabaseObject -FileGroupName 'PRIMARY' -DataFileName 'AdventureWorks_Data' -Growth 65536 -GrowthType KB
```

Sets the growth of the 'AdventureWorks_Data' data file in the 'PRIMARY' filegroup of the 'AdventureWorks' database to 65536 KB on the local SQL Server instance.

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

The name of the database containing the data file to modify.

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

The database object containing the data file to modify.

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

The name of the data file to modify.

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

The name of the file group containing the data file to modify.

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

### -Growth

The amount by which the file will grow when it reaches its current size limit.

```yaml
Type: System.Int32
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

### -GrowthType

The type of growth for the data file.

```yaml
Type: Microsoft.SqlServer.Management.Smo.FileGrowthType
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

### -MaxSize

The maximum size of the data file.

```yaml
Type: System.Int32
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

### -NewDataFileName

The new name for the data file.

```yaml
Type: System.Object
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

### System.Void



## NOTES



## RELATED LINKS

