---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Export-SmoDatabaseCertificate
---

# Export-SmoDatabaseCertificate

## SYNOPSIS

Exports database certificate and private key to files.

## SYNTAX

### DatabaseName (Default)

```
Export-SmoDatabaseCertificate
  -ServerInstance <string>
  -DatabaseName <string>
  -CertificateName <string>
  -CertificatePath <FileInfo>
  -PrivateKeyPath <FileInfo>
  -PrivateKeyEncryptionPassword <securestring>
  [-PrivateKeyDecryptionPassword <securestring>]
  [<CommonParameters>]
```

### DatabaseObject

```
Export-SmoDatabaseCertificate
  -DatabaseObject <Database>
  -CertificateName <string>
  -CertificatePath <FileInfo>
  -PrivateKeyPath <FileInfo>
  -PrivateKeyEncryptionPassword <securestring>
  [-PrivateKeyDecryptionPassword <securestring>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Exports database certificate and private key to files.

## EXAMPLES

### Example 1

Export-SmoDatabaseCertificate -ServerInstance MyServer -DatabaseName AdventureWorks -CertificateName MyCertificate -CertificatePath C:\certificate.cer -PrivateKeyPath C:\certificate.key -PrivateKeyEncryptionPassword $(Get-Credential Encryption).Password

Exports database certificate in the AdventureWorks database to specified files.

### Example 2

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Export-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName MyCertificate -CertificatePath C:\certificate.cer -PrivateKeyPath C:\certificate.key -PrivateKeyEncryptionPassword $(Get-Credential Encryption).Password

Exports database certificate within the database object to specified files.

## PARAMETERS

### -CertificateName

Specifies the name of the database certificate to export.

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

### -CertificatePath

Specifies the path and file name to export the certificate to.

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

### -PrivateKeyDecryptionPassword

Specifies the password to decrypt private key in database.

```yaml
Type: System.Security.SecureString
DefaultValue: None
SupportsWildcards: false
Aliases:
- DecryptionPassword
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

### -PrivateKeyEncryptionPassword

Specifies the password to encrypt exported certificate.

```yaml
Type: System.Security.SecureString
DefaultValue: None
SupportsWildcards: false
Aliases:
- EncryptionPassword
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

### -PrivateKeyPath

Specifies the path and file name to export the private key to.

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

### -ServerInstance

SQL Server host name and instance name.

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

