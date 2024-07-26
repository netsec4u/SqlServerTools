---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Get-SmoAvailabilityGroup

## SYNOPSIS
Get SQL Availability Group.

## SYNTAX

### ServerInstance (Default)
```
Get-SmoAvailabilityGroup
	-ServerInstance <String>
	[-AvailabilityGroupName <String>]
	[<CommonParameters>]
```

### SmoServer
```
Get-SmoAvailabilityGroup
	[-AvailabilityGroupName <String>]
	-SmoServerObject <Server>
	[<CommonParameters>]
```

## DESCRIPTION
Get SQL Availability Group.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SmoAvailabilityGroup -ServerInstance MyServer
```

Lists availability groups on MyServer sql instance.

### EXAMPLE 2
```powershell
Get-SmoAvailabilityGroup -ServerInstance MyServer -AvailabilityGroupName MyAG
```

Lists MyAG availability group on MyServer sql instance.

## PARAMETERS

### -AvailabilityGroupName
Name of Availability Group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### Microsoft.SqlServer.Management.Smo.AvailabilityGroup

## NOTES

## RELATED LINKS
