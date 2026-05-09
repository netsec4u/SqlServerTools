---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Add-SmoDatabaseCertificatePrivateKey.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Add-SmoDatabaseCertificatePrivateKey
---

# Add-SmoDatabaseCertificatePrivateKey

## SYNOPSIS

Adds a private key to a database certificate.

## SYNTAX

### DatabaseName (Default)

```
Add-SmoDatabaseCertificatePrivateKey
  -ServerInstance <string>
  -DatabaseName <string>
  -CertificateName <string>
  -PrivateKeyPath <FileInfo>
  -PrivateKeyDecryptionPassword <securestring>
  [-PrivateKeyEncryptionPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Add-SmoDatabaseCertificatePrivateKey
  -DatabaseObject <Database>
  -CertificateName <string>
  -PrivateKeyPath <FileInfo>
  -PrivateKeyDecryptionPassword <securestring>
  [-PrivateKeyEncryptionPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Adds a private key to a database certificate.  The private key file must be in PKCS #8 format.  If the private key file is encrypted, the decryption password must be provided.  If the private key file is unencrypted, an empty string or null can be passed for the decryption password.  Optionally, an encryption password can be provided to encrypt the private key when it is stored in the database.  If no encryption password is provided, the private key will be stored unencrypted in the database.

## EXAMPLES

### Example 1

```powershell
$DecryptionPassword = Read-Host -Prompt "Enter decryption password for private key" -AsSecureString

Add-SmoDatabaseCertificatePrivateKey -ServerInstance MyServer -DatabaseName MyDatabase -CertificateName MyCertificate -PrivateKeyPath C:\MyCertificatePrivateKey.key -PrivateKeyDecryptionPassword $DecryptionPassword
```

Adds a private key to MyCertificate in MyDatabase on MyServer.  The private key file is located at C:\MyCertificatePrivateKey.key and is encrypted, so the decryption password is read from the console.

### Example 2

```powershell
$DecryptionPassword = Read-Host -Prompt "Enter decryption password for private key" -AsSecureString
$DatabaseObject = Get-SmoDatabase -ServerInstance MyServer -DatabaseName MyDatabase
Add-SmoDatabaseCertificatePrivateKey -DatabaseObject $DatabaseObject -CertificateName MyCertificate -PrivateKeyPath C:\MyCertificatePrivateKey.key -PrivateKeyDecryptionPassword $DecryptionPassword
```

Adds a private key to MyCertificate in MyDatabase on MyServer.  The Database object is retrieved and passed to the cmdlet instead of the database name.  The private key file is located at C:\MyCertificatePrivateKey.key and is encrypted, so the decryption password is read from the console.

## PARAMETERS

### -CertificateName

The name of the certificate to which the private key will be added.

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

Name of database to which the certificate with private key will be added.

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

The database object to which the private key will be added.

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

### -PrivateKeyDecryptionPassword

The password used to decrypt the private key file.

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases:
- DecryptionPassword
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

### -PrivateKeyEncryptionPassword

The password used to encrypt the private key file.

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases:
- EncryptionPassword
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

### -PrivateKeyPath

The file path of the private key file to be added to the database certificate.  The private key file must be in PKCS #8 format.

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

The name of the SQL Server instance to which the database certificate will be added.

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

