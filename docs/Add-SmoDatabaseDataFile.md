---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Add-SmoDatabaseDataFile

## SYNOPSIS
Add data file to database file group.

## SYNTAX

### DatabaseName (Default)
```
Add-SmoDatabaseDataFile
	-ServerInstance <String>
	-DatabaseName <String>
	-FileGroupName <String>
	-DataFileName <String>
	-DataFilePath <FileInfo>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Add-SmoDatabaseDataFile
	-DatabaseObject <Database>
	-FileGroupName <String>
	-DataFileName <String>
	-DataFilePath <FileInfo>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### FileGroupObject
```
Add-SmoDatabaseDataFile
	-FileGroupObject <FileGroup>
	-DataFileName <String>
	-DataFilePath <FileInfo>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Add data file to database file group.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-SmoDatabaseDataFile -ServerInstance MyServer -DatabaseName AdventureWorks -FileGroupName HL7FG -DataFileName HL7 -DataFilePath D:\MSSQL12.MSSQLSERVER\Data\AdventureWorks.ndf
```

Add data file to AdventureWorks database.

### EXAMPLE 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Add-SmoDatabaseDataFile -DatabaseObject $DatabaseObject -FileGroupName HL7FG -DataFileName HL7 -DataFilePath D:\MSSQL12.MSSQLSERVER\Data\AdventureWorks.ndf
```

Add data file to database object.

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
Name of database object to add data file.

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

### -DataFileName
Data file name.

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

### -DataFilePath
Data file physical path and name.

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

### -FileGroupName
Name of file group to add data file.

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

### -FileGroupObject
Name of file group object to add data file.

```yaml
Type: FileGroup
Parameter Sets: FileGroupObject
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

### Microsoft.SqlServer.Management.Smo.DataFile

## NOTES
DataFilePath needs validation that functions for local and remote.

## RELATED LINKS
