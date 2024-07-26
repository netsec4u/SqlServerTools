---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Rename-SmoDatabaseDataFile

## SYNOPSIS
Rename data file.

## SYNTAX

### DatabaseName (Default)
```
Rename-SmoDatabaseDataFile
	-ServerInstance <String>
	-DatabaseName <String>
	-FileGroupName <String>
	-LogicalFileName <String>
	-NewLogicalFileName <String>
	-NewPhysicalFileName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Rename-SmoDatabaseDataFile
	-DatabaseObject <Database>
	-FileGroupName <String>
	-LogicalFileName <String>
	-NewLogicalFileName <String>
	-NewPhysicalFileName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### FileGroupObject
```
Rename-SmoDatabaseDataFile
	-FileGroupObject <FileGroup>
	-LogicalFileName <String>
	-NewLogicalFileName <String>
	-NewPhysicalFileName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Rename data file.

## EXAMPLES

### EXAMPLE 1
```powershell
Rename-SmoDatabaseDataFile -ServerInstance MyServer -DatabaseName AdventureWorks -FileGroupName HL7FG -LogicalFileName HL7 -NewLogicalFileName IPC -NewPhysicalFileName AdventureWorks.ndf
```

Renames AdventureWorks data file logical and physical file name.

### EXAMPLE 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Rename-SmoDatabaseDataFile -DatabaseObject $DatabaseObject -FileGroupName HL7FG -LogicalFileName HL7 -NewLogicalFileName IPC -NewPhysicalFileName AdventureWorks.ndf
```

Renames data file logical and physical file name using SMO database object.

### EXAMPLE 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
$FileGroupObject = $DatabaseObject.FileGroups['PRIMARY']

Rename-SmoDatabaseDataFile -FileGroupObject $FileGroupObject -LogicalFileName HL7 -NewLogicalFileName IPC -NewPhysicalFileName AdventureWorks.ndf
```

Renames data file logical and physical file name using SMO file group object.

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
Name of database object to rename dat file.

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
Name of file group object.

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

### -LogicalFileName
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
