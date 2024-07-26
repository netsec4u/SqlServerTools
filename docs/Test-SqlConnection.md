---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Test-SqlConnection

## SYNOPSIS
Test SQL Server connectivity.

## SYNTAX

### Hostname (Default)
```
Test-SqlConnection
	-Computer <String>
	[-Port <Int32>]
	[-Credential <PSCredential>]
	[-ConnectionTimeout <Int32>]
	[<CommonParameters>]
```

### IPAddress
```
Test-SqlConnection
	-IPAddress <IPAddress>
	[-Port <Int32>]
	[-Credential <PSCredential>]
	[-ConnectionTimeout <Int32>]
	[<CommonParameters>]
```

## DESCRIPTION
Test SQL Server connectivity.

## EXAMPLES

### EXAMPLE 1
```powershell
Test-SqlConnection -Computer MyServer
```

Tests SQL connectivity to MyServer.

### EXAMPLE 2
```powershell
Test-SqlConnection -IPAddress 10.0.0.5
```

Tests SQL connectivity via IP address.

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
The length of time (in seconds) to wait for a connection to the server before terminating the attempt and throwing an exception.
Default is 15 seconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies a user account that has permission to perform this action.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
Default value: 1433
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
