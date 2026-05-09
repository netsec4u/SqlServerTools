---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Publish-SqlDatabaseDacPac.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Publish-SqlDatabaseDacPac
---

# Publish-SqlDatabaseDacPac

## SYNOPSIS

Publish DacPac to SQL Server.

## SYNTAX

### ServerInstance (Default)

```
Publish-SqlDatabaseDacPac
  -ServerInstance <string>
  -DatabaseName <string>
  -DacPacPath <FileInfo>
  [-DeployOptions <DacDeployOptions>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SqlConnectionString

```
Publish-SqlDatabaseDacPac
  -ConnectionString <string>
  -DacPacPath <FileInfo>
  [-DeployOptions <DacDeployOptions>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Publish DacPac to SQL Server.

## EXAMPLES

### Example 1

```powershell
Publish-SqlDatabaseDacPac -ServerInstance MyServer -DatabaseName AdventureWorks -DacPacPath C:\Database.dacpac
```

Publishes DacPac to AdventureWorks.

### Example 2

```powershell
$ConnectionString = 'Data Source=.;Initial Catalog=AdventureWorks;Integrated Security=True;'
Publish-SqlDatabaseDacPac -ConnectionString $ConnectionString -DacPacPath C:\Database.dacpac
```

Publishes DacPac to AdventureWorks.

### Example 3

```powershell
Publish-SqlDatabaseDacPac -ServerInstance MyServer -DatabaseName AdventureWorks -Credential $(Get-Credential) -DacPacPath C:\Database.dacpac
```

Publishes DacPac to AdventureWorks using credential.

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

### -ConnectionString

SQL Server Connection string.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnectionString
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DacPacPath

Path to DacPac file.

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

### -DatabaseName

Name of database.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
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

### -DeployOptions

Defines options that affect the behavior of package deployment to a database.

```yaml
Type: Microsoft.SqlServer.Dac.DacDeployOptions
DefaultValue: None
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
DefaultValue: None
SupportsWildcards: false
Aliases: []
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

NetworkLibrary not yet implemented.


## RELATED LINKS

