---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 10/29/2026
PlatyPS schema version: 2024-05-01
title: Restore-SmoDatabase
---

# Restore-SmoDatabase

## SYNOPSIS

Restores SQL database.

## SYNTAX

### ServerInstance (Default)

```
Restore-SmoDatabase
  -ServerInstance <string>
  -RestoreActionType <RestoreActionType>
  -BackupFile <string[]>
  -DatabaseName <string>
  [-DatabasePage <string[]>]
  [-FileGroup <string[]>]
  [-LogicalFile <string[]>]
  [-RelocateFile <RelocateFile[]>]
  [-NoRecovery]
  [-StandByFile <FileInfo>]
  [-ReplaceDatabase]
  [-RestrictedUser]
  [-BackupSetFileNumber <int>]
  [-MediaName <string>]
  [-BlockSize <int>]
  [-BufferCount <int>]
  [-MaxTransferSize <int>]
  [-Checksum] [-KeepReplication]
  [-KeepTemporalRetention]
  [-ToPointInTime <datetime>]
  [-StopAtMarkName <string>]
  [-StopAtMarkAfterDate <datetime>]
  [-StopBeforeMarkName <string>]
  [-StopBeforeMarkAfterDate <datetime>]
  [-ScriptRestore]
  [-WhatIf]
  [-Confirm]
```

### SmoServer

```
Restore-SmoDatabase
  -SmoServerObject <Server>
  -RestoreActionType <RestoreActionType>
  -BackupFile <string[]>
  -DatabaseName <string>
  [-DatabasePage <string[]>]
  [-FileGroup <string[]>]
  [-LogicalFile <string[]>]
  [-RelocateFile <RelocateFile[]>]
  [-NoRecovery]
  [-StandByFile <FileInfo>]
  [-ReplaceDatabase]
  [-RestrictedUser]
  [-BackupSetFileNumber <int>]
  [-MediaName <string>]
  [-BlockSize <int>]
  [-BufferCount <int>]
  [-MaxTransferSize <int>]
  [-Checksum]
  [-KeepReplication]
  [-KeepTemporalRetention]
  [-ToPointInTime <datetime>]
  [-StopAtMarkName <string>]
  [-StopAtMarkAfterDate <datetime>]
  [-StopBeforeMarkName <string>]
  [-StopBeforeMarkAfterDate <datetime>]
  [-ScriptRestore]
  [-WhatIf]
  [-Confirm]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Restores SQL database from backup file.

## EXAMPLES

### Example 1

```powershell
Restore-SmoDatabase -ServerInstance MyServer -RestoreActionType Database -DatabaseName AdventureWorks -BackupType Database -BackupFile 'C:\Backups\AdventureWorks.bak'
```

Restores database AdventureWorks from specified backup file.

### Example 2

```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .
Restore-SmoDatabase -SmoServerObject $SmoServerObject -RestoreActionType Database -DatabaseName AdventureWorks -BackupFile 'C:\Backups\AdventureWorks.bak'
```

Restores database AdventureWorks from specified backup file using the specified SMO server object.

## PARAMETERS

### -BackupFile

Specifies the path to the back up file.

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

### -BackupSetFileNumber

Identifies the backup set within the backup set to be restored.  When not specified, the default is 1.

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

### -BlockSize

Specifies the physical block size, in bytes. The supported sizes are 512, 1024, 2048, 4096, 8192, 16384, 32768, and 65536 (64 KB) bytes.

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

### -BufferCount

Specifies the total number of I/O buffers to be used for the backup operation.

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

### -Checksum

Specifies that backup checksums must be verified.  If the backup lacks backup checksums, the restore operation will fail with a message indicating that checksums are not present.

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

### -DatabaseName

Specifies the database name to restore database to.

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

### -DatabasePage

Specifies a list of one or more pages for a page restore (which is supported only for databases using the full or bulk-logged recovery models).
RestoreActionType must be OnlinePage to use parameter.

```yaml
Type: System.String[]
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

### -FileGroup

Specifies the name of a filegroup or filegroups to restore.
Parameter can be used when RestoreActionType is Files, Log, OnlineFiles, or OnlinePage.

```yaml
Type: System.String[]
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

### -KeepReplication

Specifies to keep replication after restore action.
Parameter can be used when RestoreActionType is Database, Files, or Log.

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

### -KeepTemporalRetention

Specifies to keep temporal retention policy settings from being removed during a restore.
Parameter can be used when RestoreActionType is Database, Files, or Log.

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

### -LogicalFile

Specifies the name of a logical file or logical files to restore.
Parameter can be used when RestoreActionType is Database, Files, or OnlineFiles.

```yaml
Type: System.String[]
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

### -MaxTransferSize

Specifies the largest unit of transfer in bytes to be used between SQL Server and the backup media. The possible values are multiples of 65536 bytes (64 KB) ranging up to 4194304 bytes (4 MB).

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

### -MediaName

Specifies the name for the media to restore.

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

### -NoRecovery

Instructs the restore operation to not roll back any uncommitted transactions.

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

### -RelocateFile

Specifies that the data or log file whose logical name is specified by logical_file_name_in_backup should be moved by restoring it to the location specified by operating_system_file_name.

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

### -ReplaceDatabase

Specifies that SQL Server should create the specified database and its related files even if another database already exists with the same name. In such a case, the existing database is deleted.
Parameter can be used when RestoreActionType is Database or Files.

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

### -RestoreActionType

Specifies the kind of restore action to perform.

```yaml
Type: Microsoft.SqlServer.Management.Smo.RestoreActionType
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

### -RestrictedUser

Restricts access for the newly restored database to members of the db_owner, dbcreator, or sysadmin roles.

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

### -ScriptRestore

Indicates to output a Transact-SQL script that performs the restore operation.

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

Specifies the SMO server object for the restore operation.

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

### -StandByFile

Specifies a standby file that allows the recovery effects to be undone.
Parameter can be used when RestoreActionType is Database or Log.

```yaml
Type: System.IO.FileInfo
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

### -StopAtMarkAfterDate

Specifies to stop at mark is after date.
Parameter can be used when RestoreActionType is Log.

```yaml
Type: System.DateTime
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

### -StopAtMarkName

Specifies recovery to a specified recovery point by LSN or mark name. The specified transaction is included in the recovery, but it is committed only if it was originally committed when the transaction was actually generated.
Parameter can be used when RestoreActionType is Log.

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

### -StopBeforeMarkAfterDate

Specifies to stop before mark that is after date.
Parameter can be used when RestoreActionType is Log.

```yaml
Type: System.DateTime
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

### -StopBeforeMarkName

Specifies recovery up to a specified recovery point. The specified transaction is not included in the recovery, and is rolled back when WITH RECOVERY is used.
Parameter can be used when RestoreActionType is Log.

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

### -ToPointInTime

Specifies that the database be restored to the state it was in as of the date and time specified by the datetime.
Parameter can be used when RestoreActionType is Log.

```yaml
Type: System.DateTime
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

### System.String



### SqlServerTools.Restore



## NOTES



## RELATED LINKS



