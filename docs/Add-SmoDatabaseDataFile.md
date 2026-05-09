---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Add-SmoDatabaseDataFile.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Add-SmoDatabaseDataFile
---

# Add-SmoDatabaseDataFile

## SYNOPSIS

Add data file to database file group.

## SYNTAX

### DatabaseName (Default)

```
Add-SmoDatabaseDataFile
  -ServerInstance <string>
  -DatabaseName <string>
  -FileGroupName <string>
  -DataFileName <string>
  -DataFilePath <FileInfo>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Add-SmoDatabaseDataFile
  -DatabaseObject <Database>
  -FileGroupName <string>
  -DataFileName <string>
  -DataFilePath <FileInfo>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### FileGroupObject

```
Add-SmoDatabaseDataFile
  -FileGroupObject <FileGroup>
  -DataFileName <string>
  -DataFilePath <FileInfo>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Add data file to database file group.

## EXAMPLES

### Example 1

```powershell
Add-SmoDatabaseDataFile -ServerInstance MyServer -DatabaseName AdventureWorks -FileGroupName HL7FG -DataFileName HL7 -DataFilePath D:\MSSQL12.MSSQLSERVER\Data\AdventureWorks.ndf
```

Add data file to AdventureWorks database.

### Example 2

```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
Add-SmoDatabaseDataFile -DatabaseObject $DatabaseObject -FileGroupName HL7FG -DataFileName HL7 -DataFilePath D:\MSSQL12.MSSQLSERVER\Data\AdventureWorks.ndf
```

Add data file to database object.

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
DefaultValue: None
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

### -DataFileName

Data file name.

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

### -DataFilePath

Data file physical path and name.

```yaml
Type: System.IO.FileInfo
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

### -FileGroupName

Name of file group to add data file.

```yaml
Type: System.String
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

### -FileGroupObject

Name of file group object to add data file.

```yaml
Type: Microsoft.SqlServer.Management.Smo.FileGroup
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FileGroupObject
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
DefaultValue: None
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

### Microsoft.SqlServer.Management.Smo.DataFile



## NOTES

DataFilePath needs validation that functions for local and remote.


## RELATED LINKS

