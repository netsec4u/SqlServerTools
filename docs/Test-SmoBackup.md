---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 10/25/2026
PlatyPS schema version: 2024-05-01
title: Test-SmoBackup
---

# Test-SmoBackup

## SYNOPSIS

Verifies the backup without restoring it.

## SYNTAX

### ServerInstance (Default)

```
Test-SmoBackup
  -ServerInstance <string>
  -BackupFile <string[]>
  [-RelocateFile <RelocateFile[]>]
  [-MediaName <string>]
  [-Checksum]
  [-WhatIf]
  [-Confirm]
```

### SmoServer

```
Test-SmoBackup
  -SmoServerObject <Server>
  -BackupFile <string[]>
  [-RelocateFile <RelocateFile[]>]
  [-MediaName <string>]
  [-Checksum]
  [-WhatIf]
  [-Confirm]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Verifies the backup without restoring it.  It verifies the backup set is complete and the entire backup is readable.

## EXAMPLES

### Example 1

```powershell
Test-SmoBackup -ServerInstance MyServer -BackupFile 'C:\Backups\AdventureWorks.bak'
```

Tests the specified backup file.

### Example 2

```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance MyServer
Test-SmoBackup -SmoServerObject $SmoServerObject -BackupFile 'C:\Backups\AdventureWorks.bak'
```

Tests the specified backup file using Smo Server Object.

## PARAMETERS

### -BackupFile

Specifies the path and filenames for the backup.

```yaml
Type: System.String[]
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

### -Checksum

Indicates that a checksum value is calculated during the operation, overriding the server-level default.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -MediaName

Specifies the names used to identify the media set.

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

### -RelocateFile

Specifies new paths for data files.

```yaml
Type: Microsoft.SqlServer.Management.Smo.RelocateFile[]
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

Specifies the name of a SQL Server instance that is the target of the restore operation.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SmoServerObject

An existing SMO Server object representing the SQL Server instance.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServer
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

### System.Boolean



## NOTES



## RELATED LINKS



