---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Disconnect-SqlServerInstance

## SYNOPSIS
Disconnects connections to SQL Server.

## SYNTAX

```
Disconnect-SqlServerInstance
	-SqlConnection <SqlConnection>
	[<CommonParameters>]
```

## DESCRIPTION
Disconnects connections to SQL Server.

## EXAMPLES

### EXAMPLE 1
```powershell
$SqlServerConnection = Connect-SQLServerInstance -ServerInstance MyServer -DatabaseName master

Disconnect-SqlServerInstance -SqlConnection $SqlServerConnection
```

Disconnect from SQL client connection to SQL SErver.

## PARAMETERS

### -SqlConnection
SqlConnection object.

```yaml
Type: SqlConnection
Parameter Sets: (All)
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

### System.Void

## NOTES

## RELATED LINKS
