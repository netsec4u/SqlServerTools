---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Get-SmoBackupHeader

## SYNOPSIS
Returns backup header information.

## SYNTAX

### ServerInstance (Default)
```
Get-SmoBackupHeader
	-DatabaseBackupPath <FileInfo>
	-ServerInstance <String>
	[<CommonParameters>]
```

### SmoServer
```
Get-SmoBackupHeader
	-DatabaseBackupPath <FileInfo>
	-SmoServerObject <Server>
	[<CommonParameters>]
```

## DESCRIPTION
Returns backup header information.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SmoBackupHeader -DatabaseBackupPath "D:\MSSQL\Backup\MyBackup.bak" -ServerInstance MySQLServer
```

List backup header from SQL Server backup.

### EXAMPLE 2
```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .

Get-SmoBackupHeader -DatabaseBackupPath "D:\MSSQL\Backup\MyBackup.bak" -SmoServerObject $SmoServerObject
```

List backup header from SQL Server backup using SQL ServerManagement Objects.

## PARAMETERS

### -DatabaseBackupPath
Backup Root folder.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
SQL Server host name and instance name.

```yaml
Type: String
Parameter Sets: ServerInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmoServerObject
SQL Server Management Object.

```yaml
Type: Server
Parameter Sets: SmoServer
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### SmoRestore.BackupHeader

## NOTES

## RELATED LINKS
