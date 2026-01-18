---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 01/07/2026
PlatyPS schema version: 2024-05-01
title: Invoke-SmoScriptDatabaseObject
---

# Invoke-SmoScriptDatabaseObject

## SYNOPSIS

Script a specific database object to a file.

## SYNTAX

### DatabaseName (Default)

```
Invoke-SmoScriptDatabaseObject
  -ServerInstance <string>
  -DatabaseName <string>
  -Path <FileInfo>
  -ObjectClass <ScriptableDatabaseObjectClass>
  -ObjectName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServer

```
Invoke-SmoScriptDatabaseObject
  -SmoServerObject <Server>
  -DatabaseName <string>
  -Path <FileInfo>
  -ObjectClass <ScriptableDatabaseObjectClass>
  -ObjectName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Script a specific database object to a file.

## EXAMPLES

### Example 1

Invoke-SmoScriptDatabaseObject -ServerInstance . -DatabaseName 'TestDB' -Path 'C:\Scripts\TestDB_Object.sql' -ObjectClass 'Table' -ObjectName 'MyTable'

Scripts the specified table 'MyTable' from the 'TestDB' database on the local SQL Server instance to the specified file path.

### Example 2

	$server = Connect-SmoServer -ServerInstance .
	Invoke-SmoScriptDatabaseObject -SmoServerObject $server -DatabaseName 'TestDB' -Path 'C:\Scripts\TestDB_Object.sql' -ObjectClass 'View' -ObjectName 'MyView'

	Scripts the specified view 'MyView' from the 'TestDB' database using the provided SMO Server object to the specified file path.

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

The name of the database.

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

### -ObjectClass

The class of the database object to script.

```yaml
Type: ScriptableDatabaseObjectClass
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

The name of the database object to script.

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

The file path to script the database object to.

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

