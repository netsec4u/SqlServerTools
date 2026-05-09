---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Remove-SmoServerRole.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Remove-SmoServerRole
---

# Remove-SmoServerRole

## SYNOPSIS

Remove server role.

## SYNTAX

### ServerInstance (Default)

```
Remove-SmoServerRole
  -ServerInstance <string>
  -ServerRoleName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServer

```
Remove-SmoServerRole
  -SmoServerObject <Server>
  -ServerRoleName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Remove server role.

## EXAMPLES

### Example 1

```powershell
Remove-SmoServerRole -ServerInstance MyServer -ServerRoleName MyServerRole
```

Removes server role from SQL instance MyServer.

### Example 2

```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .
Remove-SmoServerRole -SmoServerObject $SmoServerObject -ServerRoleName MyServerRole
```

Removes server role using SMO Server Object.

## PARAMETERS

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

### -ServerInstance

The name of the SQL Server instance to connect to.

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

### -ServerRoleName

SQL role name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
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

An existing SMO Server object representing the SQL Server instance.

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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

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

### System.Void



## NOTES




## RELATED LINKS

