---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: New-SmoDatabaseAsymmetricKey
---

# New-SmoDatabaseAsymmetricKey

## SYNOPSIS

Create a database asymmetric key.

## SYNTAX

### DatabaseName-EncryptionAlgorithm (Default)

```
New-SmoDatabaseAsymmetricKey
  -ServerInstance <string>
  -DatabaseName <string>
  -AsymmetricKeyName <string>
  -EncryptionAlgorithm <AsymmetricKeyEncryptionAlgorithm>
  [-KeyPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseName-SourceType

```
New-SmoDatabaseAsymmetricKey
  -ServerInstance <string>
  -DatabaseName <string>
  -AsymmetricKeyName <string>
  -SourceType <AsymmetricKeySourceType>
  -KeySource <string>
  [-KeyPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject-SourceType

```
New-SmoDatabaseAsymmetricKey
  -DatabaseObject <Database>
  -AsymmetricKeyName <string>
  -SourceType <AsymmetricKeySourceType>
  -KeySource <string>
  [-KeyPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject-EncryptionAlgorithm

```
New-SmoDatabaseAsymmetricKey
  -DatabaseObject <Database>
  -AsymmetricKeyName <string>
  -EncryptionAlgorithm <AsymmetricKeyEncryptionAlgorithm>
  [-KeyPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Create a database asymmetric key.

## EXAMPLES

### Example 1

New-SmoDatabaseAsymmetricKey -ServerInstance . -DatabaseName AdventureWorks -AsymmetricKeyName MyKey -EncryptionAlgorithm Rsa4096

Creates asymmetric key in the AdventureWorks.

### Example 2

New-SmoDatabaseAsymmetricKey -ServerInstance . -DatabaseName AdventureWorks -AsymmetricKeyName MyKey -SourceType File -KeySource C:\MyKey.key

Creates asymmetric key in the AdventureWorks from key file provided.

### Example 3

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName MyKey -SourceType File -KeySource C:\MyKey.key

Creates asymmetric key in the AdventureWorks from key file provided using the database object.

### Example 4

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName MyKey -EncryptionAlgorithm Rsa4096

Creates asymmetric key in the AdventureWorks using the database object.

## PARAMETERS

### -AsymmetricKeyName

Specifies the Asymmetric key name to create.

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
- Name: DatabaseName-SourceType
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-EncryptionAlgorithm
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

SMO database object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-SourceType
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseObject-EncryptionAlgorithm
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EncryptionAlgorithm

Specifies the encryption algorithm.

```yaml
Type: Microsoft.SqlServer.Management.Smo.AsymmetricKeyEncryptionAlgorithm
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-EncryptionAlgorithm
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-EncryptionAlgorithm
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -KeyPassword

Specifies the password with which to create the key.

```yaml
Type: System.Security.SecureString
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

### -KeySource

Specifies the key source to create key from.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-SourceType
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-SourceType
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

SQL Server host name and instance name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: DatabaseName-SourceType
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-EncryptionAlgorithm
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SourceType

Specifies the type for the key source.

```yaml
Type: Microsoft.SqlServer.Management.Smo.AsymmetricKeySourceType
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-SourceType
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-SourceType
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

### Microsoft.SqlServer.Management.Smo.AsymmetricKey



## NOTES




## RELATED LINKS

None.

