---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Remove-SmoAvailabilityDatabase

## SYNOPSIS
Remove database from Availability Group.

## SYNTAX

### ServerInstance (Default)
```
Remove-SmoAvailabilityDatabase
	-ServerInstance <String>
	-AvailabilityGroupName <String>
	-DatabaseName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoAvailabilityGroup
```
Remove-SmoAvailabilityDatabase
	-DatabaseName <String>
	-AvailabilityGroupObject <AvailabilityGroup>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Remove database from Availability Group.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-SmoAvailabilityDatabase -ServerInstance MyServer -AvailabilityGroupName MyAG -DatabaseName AdventureWorks
```

Removes AdventureWorks database from availability group.

### EXAMPLE 2
```powershell
$AGObject = Get-SmoAvailabilityGroup -ServerInstance AZ-SQL-P01-N01 -AvailabilityGroupName AZ-SQL-P01-A01

Remove-SmoAvailabilityDatabase -AvailabilityGroupObject $AGObject -DatabaseName AdventureWorks
```

Removes AdventureWorks database from availability group using availability group object.

## PARAMETERS

### -AvailabilityGroupName
Name of Availability Group.

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

### -AvailabilityGroupObject
SQL Server Availability Group Object.

```yaml
Type: AvailabilityGroup
Parameter Sets: SmoAvailabilityGroup
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Name of database.

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
Parameter Sets: ServerInstance
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

### Microsoft.SqlServer.Management.Smo.AvailabilityGroup

## NOTES

## RELATED LINKS
