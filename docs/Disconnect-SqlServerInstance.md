---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Disconnect-SqlServerInstance
---

# Disconnect-SqlServerInstance

## SYNOPSIS

Disconnects connections to SQL Server.

## SYNTAX

### __AllParameterSets

```
Disconnect-SqlServerInstance
  -SqlConnection <SqlConnection>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Disconnects connections to SQL Server.

## EXAMPLES

### EXAMPLE 1

$SqlServerConnection = Connect-SQLServerInstance -ServerInstance MyServer -DatabaseName master

Disconnect-SqlServerInstance -SqlConnection $SqlServerConnection

Disconnect from SQL client connection to SQL SErver.

## PARAMETERS

### -SqlConnection

SqlConnection object.

```yaml
Type: Microsoft.Data.SqlClient.SqlConnection
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

None.

