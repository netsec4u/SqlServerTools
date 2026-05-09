---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoServerRoleMember.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoServerRoleMember
---

# Get-SmoServerRoleMember

## SYNOPSIS

Retrieves the members of a specified server role from a SQL Server instance.

## SYNTAX

### ServerInstance (Default)

```
Get-SmoServerRoleMember
  -ServerInstance <string>
  -RoleName <string>
  [<CommonParameters>]
```

### SmoServer

```
Get-SmoServerRoleMember
  -SmoServerObject <Server>
  -RoleName <string>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Retrieves the members of a specified server role from a SQL Server instance.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoServerRoleMember -ServerInstance 'localhost' -RoleName 'sysadmin'
```

Gets the members of the 'sysadmin' server role from the local SQL Server instance.

### Example 2

```PowerShell
$SmoServer = New-Object Microsoft.SqlServer.Management.Smo.Server 'localhost'
Get-SmoServerRoleMember -SmoServerObject $SmoServer -RoleName 'sysadmin'
```

Gets the members of the 'sysadmin' server role from the local SQL Server instance.

## PARAMETERS

### -RoleName

The name of the server role for which to retrieve members.

```yaml
Type: System.String
DefaultValue: ''
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

### -ServerInstance

The name of the SQL Server instance from which to retrieve server role members.

```yaml
Type: System.String
DefaultValue: ''
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

The SQL Server instance object from which to retrieve server role members.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: ''
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

### SqlServerTools.ServerRoleMember



## NOTES



## RELATED LINKS

