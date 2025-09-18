---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Test-SqlBrowserConnection
---

# Test-SqlBrowserConnection

## SYNOPSIS

Test SQL Browser connectivity.

## SYNTAX

### Hostname (Default)

```
Test-SqlBrowserConnection
  -Computer <string>
  [-Port <int>]
  [-ConnectionTimeout <int>]
  [<CommonParameters>]
```

### IPAddress

```
Test-SqlBrowserConnection
  -IPAddress <ipaddress>
  [-Port <int>]
  [-ConnectionTimeout <int>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Test SQL Browser connectivity.

## EXAMPLES

### EXAMPLE 1

Test-SqlBrowserConnection -Computer MyServer

Tests browser connectivity to MyServer.

### EXAMPLE 2

Test-SqlBrowserConnection -IPAddress 10.0.0.5

Tests browser connectivity to specified IP address.

## PARAMETERS

### -Computer

Specifies the computer name to test.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Hostname
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ConnectionTimeout

The time-out value, in milliseconds.

```yaml
Type: System.Int32
DefaultValue: 5000
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IPAddress

Specifies the IP Address to test.

```yaml
Type: System.Net.IPAddress
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: IPAddress
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Port

Specifies UDP port to test.

```yaml
Type: System.Int32
DefaultValue: 1434
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean



## NOTES




## RELATED LINKS

None.

