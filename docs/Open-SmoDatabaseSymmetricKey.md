---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Open-SmoDatabaseSymmetricKey
---

# Open-SmoDatabaseSymmetricKey

## SYNOPSIS

Opens database symmetric key.

## SYNTAX

### DatabaseObject (Default)

```
Open-SmoDatabaseSymmetricKey
  -DatabaseObject <Database>
  -SymmetricKeyName <string>
  -DecryptionPassword <securestring>
  [<CommonParameters>]
```

### DatabaseObject-WithSymmetricKey

```
Open-SmoDatabaseSymmetricKey
  -DatabaseObject <Database>
  -SymmetricKeyName <string>
  -DecryptionSymmetricKeyName <string>
  [<CommonParameters>]
```

### DatabaseObject-WithCertificate

```
Open-SmoDatabaseSymmetricKey
  -DatabaseObject <Database>
  -SymmetricKeyName <string>
  -CertificateName <string>
  [-PrivateKeyPassword <securestring>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Opens database symmetric key.

## EXAMPLES

### Example 1

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Open-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MySymmetricKey -DEcryptionPassword $(Get-Credential KeyPassword).Password

Opens symmetric key with a password using the database object.

### Example 2

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Open-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MySymmetricKey -DecryptionSymmetricKeyName DecryptionKey

Opens symmetric key with a symmetric key using the database object.

### Example 3

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Open-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MySymmetricKey -CertificateName MyCertificate

Opens symmetric key with a certificate using the database object.

## PARAMETERS

### -CertificateName

Specifies the certificate to decrypt symmetric key.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-WithCertificate
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
- Name: DatabaseObject-WithSymmetricKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseObject-WithCertificate
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

### -DecryptionPassword

Specifies the symmetric key password.

```yaml
Type: System.Security.SecureString
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

### -DecryptionSymmetricKeyName

Specifies the name of the symmetric key to decrypt symmetric key.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-WithSymmetricKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PrivateKeyPassword

Specifies private key password.

```yaml
Type: System.Security.SecureString
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-WithCertificate
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SymmetricKeyName

Specifies the name of the symmetric key.

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

None.

