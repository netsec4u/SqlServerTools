---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SmoBackupFileList
---

# Get-SmoBackupFileList

## SYNOPSIS

Returns backup file information.

## SYNTAX

### ServerInstance (Default)

```
Get-SmoBackupFileList
  -DatabaseBackupPath <FileInfo>
  -ServerInstance <string>
  [<CommonParameters>]
```

### SmoServer

```
Get-SmoBackupFileList
  -DatabaseBackupPath <FileInfo>
  -SmoServerObject <Server>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Returns backup file information.

## EXAMPLES

### EXAMPLE 1

Get-SmoBackupFileList -DatabaseBackupPath "D:\MSSQL\Backup\MyBackup.bak" -ServerInstance MySQLServer

List file list within SQL database backup.

### EXAMPLE 2

$SmoServerObject = Connect-SmoServer -ServerInstance .

Get-SmoBackupFileList -DatabaseBackupPath "D:\MSSQL\Backup\MyBackup.bak" -SmoServerObject $SmoServerObject

List file list within SQL database backup using SMO database object.

## PARAMETERS

### -DatabaseBackupPath

Database backup file path.

```yaml
Type: System.IO.FileInfo
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

SQL Server host name and instance name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
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

SQL Server Management Object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SmoRestore.FileList



## NOTES




## RELATED LINKS

None.

