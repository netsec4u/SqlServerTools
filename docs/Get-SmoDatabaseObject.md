---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Get-SmoDatabaseObject

## SYNOPSIS
Get database object.

## SYNTAX

### DatabaseName (Default)
```
Get-SmoDatabaseObject
	-ServerInstance <String>
	-DatabaseName <String>
	[<CommonParameters>]
```

### SmoServer
```
Get-SmoDatabaseObject
	[-DatabaseName <String>]
	-SmoServerObject <Server>
	[<CommonParameters>]
```

## DESCRIPTION
Get database object.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SmoDatabaseObject -ServerInstance MyServer -DatabaseName AdventureWorks
```

Gets AdventureWorks Database object from SQL Management Object.

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

```yaml
Type: String
Parameter Sets: SmoServer
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
Parameter Sets: DatabaseName
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

### Microsoft.SqlServer.Management.Smo.Database

## NOTES

## RELATED LINKS
