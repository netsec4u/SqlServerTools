---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Disconnect-SmoServer

## SYNOPSIS
Disconnect from SQL Server.

## SYNTAX

```
Disconnect-SmoServer
	-SmoServerObject <Server>
	[<CommonParameters>]
```

## DESCRIPTION
Disconnect from SQL Management Objects.

## EXAMPLES

### EXAMPLE 1
```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .

Disconnect-SmoServer -SmoServerObject $SmoServerObject
```

Disconnects from SQL Management Objects.

## PARAMETERS

### -SmoServerObject
SMO Server object

```yaml
Type: Server
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
