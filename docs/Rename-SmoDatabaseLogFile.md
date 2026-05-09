---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Rename-SmoDatabaseLogFile.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Rename-SmoDatabaseLogFile
---

# Rename-SmoDatabaseLogFile

## SYNOPSIS

Rename log file.

## SYNTAX

### DatabaseName (Default)

```
Rename-SmoDatabaseLogFile
  -ServerInstance <string>
  -DatabaseName <string>
  -LogicalFileName <string>
  -NewLogicalFileName <string>
  -NewPhysicalFileName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Rename-SmoDatabaseLogFile
  -DatabaseObject <Database>
  -LogicalFileName <string>
  -NewLogicalFileName <string>
  -NewPhysicalFileName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### LogFileObject

```
Rename-SmoDatabaseLogFile
  -LogFileObject <LogFile>
  -NewLogicalFileName <string>
  -NewPhysicalFileName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Rename log file.

## EXAMPLES

### Example 1

```powershell
Rename-SmoDatabaseLogFile -ServerInstance MyServer -DatabaseName AdventureWorks -LogicalFileName Log -NewLogicalFileName AdventureWorks_Log -NewPhysicalFileName AdventureWorks_log.ldf
```

Renames AdventureWorks log file logical and physical name.

### Example 2

```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
Rename-SmoDatabaseLogFile -DatabaseObject $DatabaseObject -LogicalFileName Log -NewLogicalFileName AdventureWorks_Log -NewPhysicalFileName AdventureWorks_log.ldf
```

Renames log file logical and physical name using SMO database object.

### Example 3

```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
$LogFileObject = $DatabaseObject.LogFiles
Rename-SmoDatabaseLogFile -LogFileObject $LogFileObject -NewLogicalFileName AdventureWorks_Log -NewPhysicalFileName AdventureWorks_log.ldf
```

Renames log file logical and physical name using SMO log file object object.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

Name of database.

```yaml
Type: System.String
DefaultValue: None
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

An existing SMO Database object representing the database.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: None
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

### -LogFileObject

Name of log file object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.LogFile
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: LogFileObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -LogicalFileName

Data file name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### -NewLogicalFileName

New logical file name.

```yaml
Type: System.String
DefaultValue: None
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

### -NewPhysicalFileName

New physical file name.

```yaml
Type: System.String
DefaultValue: None
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

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: None
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
DefaultValue: False
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

