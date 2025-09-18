---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SmoBackupHeader
---

# Get-SmoBackupHeader

## SYNOPSIS

Returns backup header information.

## SYNTAX

### ServerInstance (Default)

```
Get-SmoBackupHeader
  -DatabaseBackupPath <FileInfo>
  -ServerInstance <string>
  [<CommonParameters>]
```

### SmoServer

```
Get-SmoBackupHeader
  -DatabaseBackupPath <FileInfo>
  -SmoServerObject <Server>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Returns backup header information.

## EXAMPLES

### EXAMPLE 1

Get-SmoBackupHeader -DatabaseBackupPath "D:\MSSQL\Backup\MyBackup.bak" -ServerInstance MySQLServer

List backup header from SQL Server backup.

### EXAMPLE 2

$SmoServerObject = Connect-SmoServer -ServerInstance .

Get-SmoBackupHeader -DatabaseBackupPath "D:\MSSQL\Backup\MyBackup.bak" -SmoServerObject $SmoServerObject

List backup header from SQL Server backup using SQL ServerManagement Objects.

## PARAMETERS

### -DatabaseBackupPath

Backup Root folder.

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

### SmoRestore.BackupHeader



## NOTES




## RELATED LINKS

None.

