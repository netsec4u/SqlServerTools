---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoBackupLabel.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 10/04/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoBackupLabel
---

# Get-SmoBackupLabel

## SYNOPSIS

Returns backup label information.

## SYNTAX

### ServerInstance (Default)

```
Get-SmoBackupLabel
  -DatabaseBackupPath <FileInfo>
  -ServerInstance <string>
  [<CommonParameters>]
```

### SmoServer

```
Get-SmoBackupLabel
  -DatabaseBackupPath <FileInfo>
  -SmoServerObject <Server>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Returns backup label information.

## EXAMPLES

### Example 1

```powershell
Get-SmoBackupLabel -DatabaseBackupPath "D:\MSSQL\Backup\MyBackup.bak" -ServerInstance MySQLServer
```

List backup label from SQL Server backup.

### Example 2

```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .
Get-SmoBackupLabel -DatabaseBackupPath "D:\MSSQL\Backup\MyBackup.bak" -SmoServerObject $SmoServerObject
```

List backup label from SQL Server backup using SQL ServerManagement Objects.

## PARAMETERS

### -DatabaseBackupPath

Backup file path.

```yaml
Type: System.IO.FileInfo
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

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: ''
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SmoRestore.BackupLabel



## NOTES




## RELATED LINKS

