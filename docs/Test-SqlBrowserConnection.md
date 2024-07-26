---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Test-SqlBrowserConnection

## SYNOPSIS
Test SQL Browser connectivity.

## SYNTAX

### Hostname (Default)
```
Test-SqlBrowserConnection
	-Computer <String>
	[-Port <Int32>]
	[-ConnectionTimeout <Int32>]
	[<CommonParameters>]
```

### IPAddress
```
Test-SqlBrowserConnection
	-IPAddress <IPAddress>
	[-Port <Int32>]
	[-ConnectionTimeout <Int32>]
	[<CommonParameters>]
```

## DESCRIPTION
Test SQL Browser connectivity.

## EXAMPLES

### EXAMPLE 1
```powershell
Test-SqlBrowserConnection -Computer MyServer
```

Tests browser connectivity to MyServer.

### EXAMPLE 2
```powershell
Test-SqlBrowserConnection -IPAddress 10.0.0.5
```

Tests browser connectivity to specified IP address.

## PARAMETERS

### -Computer
Specifies the computer name to test.

```yaml
Type: String
Parameter Sets: Hostname
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionTimeout
The time-out value, in milliseconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5000
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPAddress
Specifies the IP Address to test.

```yaml
Type: IPAddress
Parameter Sets: IPAddress
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Specifies UDP port to test.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1434
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Boolean

## NOTES

## RELATED LINKS
