---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Get-SmoDatabaseSymmetricKeyKeyEncryption.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Get-SmoDatabaseSymmetricKeyKeyEncryption
---

# Get-SmoDatabaseSymmetricKeyKeyEncryption

## SYNOPSIS

Gets the key encryption information for a symmetric key in a SQL Server database.

## SYNTAX

### DatabaseName (Default)

```
Get-SmoDatabaseSymmetricKeyKeyEncryption
  -ServerInstance <string>
  -DatabaseName <string>
  -SymmetricKeyName <string>
  [<CommonParameters>]
```

### DatabaseObject

```
Get-SmoDatabaseSymmetricKeyKeyEncryption
  -DatabaseObject <Database>
  -SymmetricKeyName <string>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Gets the key encryption information for a symmetric key in a SQL Server database.

## EXAMPLES

### Example 1

```PowerShell
Get-SmoDatabaseSymmetricKeyKeyEncryption -ServerInstance "localhost" -DatabaseName "AdventureWorks" -SymmetricKeyName "MySymmetricKey"
```

Retrieves the key encryption information for the "MySymmetricKey" symmetric key in the "AdventureWorks" database on the local SQL Server instance.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance "localhost" -DatabaseName "AdventureWorks"
Get-SmoDatabaseSymmetricKeyKeyEncryption -DatabaseObject $DatabaseObject -SymmetricKeyName "MySymmetricKey"
```

Retrieves the key encryption information for the "MySymmetricKey" symmetric key in the "AdventureWorks" database on the local SQL Server instance.

## PARAMETERS

### -DatabaseName

The name of the database containing the symmetric key.

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

The database object containing the symmetric key.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: ''
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

The name of the SQL Server instance containing the database.

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

### -SymmetricKeyName

The name of the symmetric key for which to get encryption information.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Data.DataRow



## NOTES



## RELATED LINKS

