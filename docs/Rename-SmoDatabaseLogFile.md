---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Rename-SmoDatabaseLogFile

## SYNOPSIS
Rename log file.

## SYNTAX

### DatabaseName (Default)
```
Rename-SmoDatabaseLogFile
	-ServerInstance <String>
	-DatabaseName <String>
	-LogicalFileName <String>
	-NewLogicalFileName <String>
	-NewPhysicalFileName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Rename-SmoDatabaseLogFile
	-DatabaseObject <Database>
	-LogicalFileName <String>
	-NewLogicalFileName <String>
	-NewPhysicalFileName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### LogFileObject
```
Rename-SmoDatabaseLogFile
	-LogFileObject <LogFile>
	-NewLogicalFileName <String>
	-NewPhysicalFileName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Rename log file.

## EXAMPLES

### EXAMPLE 1
```powershell
Rename-SmoDatabaseLogFile -ServerInstance MyServer -DatabaseName AdventureWorks -LogicalFileName Log -NewLogicalFileName AdventureWorks_Log -NewPhysicalFileName AdventureWorks_log.ldf
```

Renames AdventureWorks log file logical and physical name.

### EXAMPLE 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Rename-SmoDatabaseLogFile -DatabaseObject $DatabaseObject -LogicalFileName Log -NewLogicalFileName AdventureWorks_Log -NewPhysicalFileName AdventureWorks_log.ldf
```

Renames log file logical and physical name using SMO database object.

### EXAMPLE 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
$LogFileObject = $DatabaseObject.LogFiles

Rename-SmoDatabaseLogFile -LogFileObject $LogFileObject -NewLogicalFileName AdventureWorks_Log -NewPhysicalFileName AdventureWorks_log.ldf
```

Renames log file logical and physical name using SMO log file object object.

## PARAMETERS

### -DatabaseName
Name of database.

```yaml
Type: String
Parameter Sets: DatabaseName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseObject
SMO database object.

```yaml
Type: Database
Parameter Sets: DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFileObject
Name of log file object.

```yaml
Type: LogFile
Parameter Sets: LogFileObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogicalFileName
Data file name.

```yaml
Type: String
Parameter Sets: DatabaseName, DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewLogicalFileName
New logical file name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewPhysicalFileName
New physical file name.

```yaml
Type: String
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
Parameter Sets: DatabaseName
Aliases: SqlServer

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
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

### System.Void

## NOTES

## RELATED LINKS
