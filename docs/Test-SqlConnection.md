---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Test-SqlConnection
---

# Test-SqlConnection

## SYNOPSIS

Test SQL Server connectivity.

## SYNTAX

### Hostname (Default)

```
Test-SqlConnection
  -Computer <string>
  [-Port <int>]
  [-Credential <pscredential>]
  [-ConnectionTimeout <int>]
  [<CommonParameters>]
```

### IPAddress

```
Test-SqlConnection
  -IPAddress <ipaddress>
  [-Port <int>]
  [-Credential <pscredential>]
  [-ConnectionTimeout <int>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Test SQL Server connectivity.

## EXAMPLES

### EXAMPLE 1

Test-SqlConnection -Computer MyServer

Tests SQL connectivity to MyServer.

### EXAMPLE 2

Test-SqlConnection -IPAddress 10.0.0.5

Tests SQL connectivity via IP address.

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

The length of time (in seconds) to wait for a connection to the server before terminating the attempt and throwing an exception.
Default is 15 seconds.

```yaml
Type: System.Int32
DefaultValue: 15
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

### -Credential

Specifies a user account that has permission to perform this action.

```yaml
Type: System.Management.Automation.PSCredential
DefaultValue: None
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
DefaultValue: 1433
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

