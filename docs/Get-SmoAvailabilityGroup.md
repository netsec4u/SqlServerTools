---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Get-SmoAvailabilityGroup
---

# Get-SmoAvailabilityGroup

## SYNOPSIS

Get SQL Availability Group.

## SYNTAX

### ServerInstance (Default)

```
Get-SmoAvailabilityGroup
  -ServerInstance <string>
  [-AvailabilityGroupName <string>]
  [<CommonParameters>]
```

### SmoServer

```
Get-SmoAvailabilityGroup
  -SmoServerObject <Server>
  [-AvailabilityGroupName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Get SQL Availability Group.

## EXAMPLES

### EXAMPLE 1

Get-SmoAvailabilityGroup -ServerInstance MyServer

Lists availability groups on MyServer sql instance.

### EXAMPLE 2

Get-SmoAvailabilityGroup -ServerInstance MyServer -AvailabilityGroupName MyAG

Lists MyAG availability group on MyServer sql instance.

## PARAMETERS

### -AvailabilityGroupName

Name of Availability Group.

```yaml
Type: System.String
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

### -ServerInstance

SQL Server host name and instance name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SmoServerObject

SQL Server Management Object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServer
  Position: Named
  IsRequired: true
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

### Microsoft.SqlServer.Management.Smo.AvailabilityGroup



## NOTES




## RELATED LINKS

None.

