---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoSqlLogin.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoSqlLogin
---

# Get-SmoSqlLogin

## SYNOPSIS

Gets SQL login properties.

## SYNTAX

### ServerInstance (Default)

```
Get-SmoSqlLogin
  -ServerInstance <string>
  [-LoginName <string>]
  [<CommonParameters>]
```

### SmoServer

```
Get-SmoSqlLogin
  -SmoServerObject <Server>
  [-LoginName <string>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Gets SQL login properties.

## EXAMPLES

### Example 1

```powershell
Get-SmoSqlLogin -ServerInstance MyServer -LoginName DBUser
```

Gets SQL login DBUser from the MyServer instance.

### Example 2

```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .
Get-SmoSqlLogin -SmoServerObject $SmoServerObject -LoginName DBUser
```

Gets SQL login DBUser using SMO Server object.

## PARAMETERS

### -LoginName

Specifies the name of the SQL login to retrieve. If not specified, all SQL logins will be retrieved.

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

The name of the SQL Server instance to connect to.

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

An existing SMO Server object representing the SQL Server instance.

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

### Microsoft.SqlServer.Management.Smo.Login



## NOTES



## RELATED LINKS

