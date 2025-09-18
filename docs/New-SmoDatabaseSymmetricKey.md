---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: New-SmoDatabaseSymmetricKey
---

# New-SmoDatabaseSymmetricKey

## SYNOPSIS

Creates database symmetric key.

## SYNTAX

### DatabaseName (Default)

```
New-SmoDatabaseSymmetricKey
  -ServerInstance <string>
  -DatabaseName <string>
  -SymmetricKeyName <string>
  -KeyEncryptionType <KeyEncryptionType>
  -KeyEncryptionValue <string>
  -KeyEncryptionAlgorithm <SymmetricKeyEncryptionAlgorithm>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseName-PassPhrase

```
New-SmoDatabaseSymmetricKey
  -ServerInstance <string>
  -DatabaseName <string>
  -SymmetricKeyName <string>
  -KeyEncryptionType <KeyEncryptionType>
  -KeyEncryptionValue <string>
  -KeyEncryptionAlgorithm <SymmetricKeyEncryptionAlgorithm>
  -PassPhrase <securestring>
  [-IdentityPhrase <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject-PassPhrase

```
New-SmoDatabaseSymmetricKey
  -DatabaseObject <Database>
  -SymmetricKeyName <string>
  -KeyEncryptionType <KeyEncryptionType>
  -KeyEncryptionValue <string>
  -KeyEncryptionAlgorithm <SymmetricKeyEncryptionAlgorithm>
  -PassPhrase <securestring>
  [-IdentityPhrase <string>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
New-SmoDatabaseSymmetricKey
  -DatabaseObject <Database>
  -SymmetricKeyName <string>
  -KeyEncryptionType <KeyEncryptionType>
  -KeyEncryptionValue <string>
  -KeyEncryptionAlgorithm <SymmetricKeyEncryptionAlgorithm>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Creates database symmetric key.

## EXAMPLES

### Example 1

New-SmoDatabaseSymmetricKey -ServerInstance . -DatabaseName AdventureWorks -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCertificate -KeyEncryptionAlgorithm Aes256

Creates symmetric key in AdventureWorks database.

### Example 2

New-SmoDatabaseSymmetricKey -ServerInstance . -DatabaseName AdventureWorks -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCertificate -KeyEncryptionAlgorithm Aes256 -PassPhrase $(Get-Credential KeyPassword).Password

Creates symmetric key in AdventureWorks database with pass phrase.

### Example 3

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MyKey> -KeyEncryptionType Certificate -KeyEncryptionValue MyCertificate -KeyEncryptionAlgorithm Aes256 -PassPhrase $(Get-Credential KeyPassword).Password

Creates symmetric key with pass phrase using the database object.

### Example 4

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCertificate -KeyEncryptionAlgorithm Aes256

Creates symmetric key in AdventureWorks database using the database object.

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
- Name: DatabaseName-PassPhrase
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

### -DatabaseObject

SMO database object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-PassPhrase
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### -IdentityPhrase

The IdentityPhrase parameter is used to tag data (using a GUID based on the identity phrase) that is encrypted with the key.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-PassPhrase
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-PassPhrase
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -KeyEncryptionAlgorithm

Specifies the encryption method.

```yaml
Type: Microsoft.SqlServer.Management.Smo.SymmetricKeyEncryptionAlgorithm
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

### -KeyEncryptionType

Specifies key encryption type.

```yaml
Type: Microsoft.SqlServer.Management.Smo.KeyEncryptionType
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

### -KeyEncryptionValue

Specifies object name or password based on the value of the KeyEncryptionType parameter.

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

### -PassPhrase

Specifies a pass phrase from which the symmetric key can be derived.

```yaml
Type: System.Security.SecureString
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-PassPhrase
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-PassPhrase
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
- Name: DatabaseName-PassPhrase
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

### -SymmetricKeyName

Specifies the symmetric key name.

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

### Microsoft.SqlServer.Management.Smo.SymmetricKey



## NOTES




## RELATED LINKS

None.

