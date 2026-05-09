---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoServerRole.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoServerRole
---

# Get-SmoServerRole

## SYNOPSIS

Retrieves the server roles from a SQL Server instance.

## SYNTAX

### ServerInstance (Default)

```
Get-SmoServerRole -ServerInstance <string> [-RoleName <string>] [<CommonParameters>]
```

### SmoServer

```
Get-SmoServerRole -SmoServerObject <Server> [-RoleName <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Retrieves the server roles from a SQL Server instance. You can specify the server instance by name or by passing a SMO Server object. Optionally, you can filter the results by role name.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoServerRole -ServerInstance 'localhost' -RoleName 'sysadmin'
```

Gets the 'sysadmin' server role from the local SQL Server instance.

### Example 2

```PowerShell
$SmoServer = New-Object Microsoft.SqlServer.Management.Smo.Server 'localhost'
Get-SmoServerRole -SmoServerObject $SmoServer -RoleName 'sysadmin'
```

Gets the 'sysadmin' server role from the local SQL Server instance using a SMO Server object.

## PARAMETERS

### -RoleName

The name of the server role to retrieve. If not specified, all server roles will be returned.

```yaml
Type: System.String
DefaultValue: ''
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

The name of the SQL Server instance from which to retrieve server roles.

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

A SMO Server object representing the SQL Server instance from which to retrieve server roles.

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

### Microsoft.SqlServer.Management.Smo.ServerRole



## NOTES



## RELATED LINKS

