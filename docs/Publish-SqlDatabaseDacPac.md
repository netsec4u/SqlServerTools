---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
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

### EXAMPLE 1

Publish-SqlDatabaseDacPac -ServerInstance MyServer -DatabaseName AdventureWorks -DacPacPath C:\Database.dacpac

Publishes DacPac to AdventureWorks.

### EXAMPLE 2

$ConnectionString = 'Data Source=.;Initial Catalog=AdventureWorks;Integrated Security=True;'

Publish-SqlDatabaseDacPac -ConnectionString $ConnectionString -DacPacPath C:\Database.dacpac

Publishes DacPac to AdventureWorks.

### EXAMPLE 3

Publish-SqlDatabaseDacPac -ServerInstance MyServer -DatabaseName AdventureWorks -Credential $(Get-Credential) -DacPacPath C:\Database.dacpac

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

SQL Server host name and instance name.

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

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

None.

