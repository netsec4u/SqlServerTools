---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Remove-SmoAvailabilityDatabase
---

# Remove-SmoAvailabilityDatabase

## SYNOPSIS

Remove database from Availability Group.

## SYNTAX

### ServerInstance (Default)

```
Remove-SmoAvailabilityDatabase
  -ServerInstance <string>
  -AvailabilityGroupName <string>
  -DatabaseName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoAvailabilityGroup

```
Remove-SmoAvailabilityDatabase
  -DatabaseName <string>
  -AvailabilityGroupObject <AvailabilityGroup>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Remove database from Availability Group.

## EXAMPLES

### EXAMPLE 1

Remove-SmoAvailabilityDatabase -ServerInstance MyServer -AvailabilityGroupName MyAG -DatabaseName AdventureWorks

Removes AdventureWorks database from availability group.

### EXAMPLE 2

$AGObject = Get-SmoAvailabilityGroup -ServerInstance AZ-SQL-P01-N01 -AvailabilityGroupName AZ-SQL-P01-A01

Remove-SmoAvailabilityDatabase -AvailabilityGroupObject $AGObject -DatabaseName AdventureWorks

Removes AdventureWorks database from availability group using availability group object.

## PARAMETERS

### -AvailabilityGroupName

Name of Availability Group.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
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

### -AvailabilityGroupObject

SQL Server Availability Group Object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.AvailabilityGroup
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoAvailabilityGroup
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- cf
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

### -DatabaseName

Name of database.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoAvailabilityGroup
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- wi
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

### Microsoft.SqlServer.Management.Smo.AvailabilityGroup



## NOTES




## RELATED LINKS

None.

