---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 01/07/2026
PlatyPS schema version: 2024-05-01
title: Invoke-SmoScriptServerObject
---

# Invoke-SmoScriptServerObject

## SYNOPSIS

Script a SQL Server object to a file.

## SYNTAX

### ServerInstance (Default)

```
Invoke-SmoScriptServerObject
  -ServerInstance <string>
  -Path <FileInfo>
  -ObjectClass <ScriptableServerObjectClass>
  -ObjectName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServer

```
Invoke-SmoScriptServerObject
  -SmoServerObject <Server>
  -Path <FileInfo>
  -ObjectClass <ScriptableServerObjectClass>
  -ObjectName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Script a SQL Server object to a file using SQL Server Management Objects (SMO).

## EXAMPLES

### Example 1

Invoke-SmoScriptServerObject -ServerInstance . -Path 'C:\Scripts\Login.sql' -ObjectClass 'Login' -ObjectName 'MyLogin'

Scripts the login 'MyLogin' from the local SQL Server instance to the specified file.

### Example 2

$server = Connect-SmoServer -ServerInstance .
Invoke-SmoScriptServerObject -SmoServerObject $server -Path 'C:\Scripts\ServerRole.sql' -ObjectClass 'ServerRole' -ObjectName 'MyServerRole'

Scripts the server role 'MyServerRole' using an existing SMO Server object.

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

### -ObjectClass

The class of the SQL Server object to script (e.g., 'Login', 'Database', 'ServerRole').

```yaml
Type: ScriptableServerObjectClass
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

### -ObjectName

The name of the SQL Server object to script.

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

The file path to save the scripted object to.

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

An existing SMO Server object to use for the connection.

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

