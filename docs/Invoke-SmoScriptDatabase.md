---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 01/07/2026
PlatyPS schema version: 2024-05-01
title: Invoke-SmoScriptDatabase
---

# Invoke-SmoScriptDatabase

## SYNOPSIS

Script a SQL Server database to a file.

## SYNTAX

### DatabaseName (Default)

```
Invoke-SmoScriptDatabase
  -ServerInstance <string>
  -DatabaseName <string>
  -Path <FileInfo>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServer

```
Invoke-SmoScriptDatabase
  -SmoServerObject <Server>
  -DatabaseName <string>
  -Path <FileInfo>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Script a SQL Server database to a file using SQL Server Management Objects (SMO).

## EXAMPLES

### Example 1

Invoke-SmoScriptDatabase -ServerInstance . -DatabaseName AdventureWorks -Path "C:\Scripts\MyDatabase.sql"

Scripts the "AdventureWorks" database from the local SQL Server instance to the "C:\Scripts\MyDatabase.sql" file.

### Example 2

$smoServer = Connect-SmoServer -ServerInstance .
Invoke-SmoScriptDatabase -SmoServerObject $smoServer -DatabaseName AdventureWorks -Path "C:\Scripts\MyDatabase.sql"

Scripts the "AdventureWorks" database from the provided SMO Server object to the "C:\Scripts\MyDatabase.sql" file.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

The name of the database to script.

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

### -Path

The file path to save the scripted database.

```yaml
Type: System.IO.FileInfo
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

The name of the SQL Server instance.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: DatabaseName
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

The SMO Server object.

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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

None

