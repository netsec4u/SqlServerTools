---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Add-SmoDatabaseMasterKeyServiceKeyEncryption.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Add-SmoDatabaseMasterKeyServiceKeyEncryption
---

# Add-SmoDatabaseMasterKeyServiceKeyEncryption

## SYNOPSIS

Adds service key encryption to database master key.

## SYNTAX

### DatabaseName (Default)

```
Add-SmoDatabaseMasterKeyServiceKeyEncryption
  -ServerInstance <string>
  -DatabaseName <string>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Add-SmoDatabaseMasterKeyServiceKeyEncryption
  -DatabaseObject <Database>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Adds service key encryption to database master key.

## EXAMPLES

### Example 1

```powershell
Add-SmoDatabaseMasterKeyServiceKeyEncryption -ServerInstance . -DatabaseName AdventureWorks
```

Adds service key encryption encryption to database master key in the AdventureWorks database.

### Example 2

```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
Add-SmoDatabaseMasterKeyServiceKeyEncryption -DatabaseObject $DatabaseObject
```

Adds service key encryption encryption to database master key using the database object.

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

### -DatabaseName

Name of database.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -DatabaseObject

An existing SMO Database object representing the database.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject
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

