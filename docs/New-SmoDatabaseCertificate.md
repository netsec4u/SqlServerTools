---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: New-SmoDatabaseCertificate
---

# New-SmoDatabaseCertificate

## SYNOPSIS

Creates database certificate.

## SYNTAX

### DatabaseName (Default)

```
New-SmoDatabaseCertificate
  -ServerInstance <string>
  -DatabaseName <string>
  -CertificateName <string>
  -Subject <string>
  [-PrivateKeyEncryptionPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseName-CertFileWithKey

```
New-SmoDatabaseCertificate
  -ServerInstance <string>
  -DatabaseName <string>
  -CertificateName <string>
  -CertificatePath <FileInfo>
  -PrivateKeyPath <FileInfo>
  -PrivateKeyDecryptionPassword <securestring>
  [-PrivateKeyEncryptionPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseName-CertFile

```
New-SmoDatabaseCertificate
  -ServerInstance <string>
  -DatabaseName <string>
  -CertificateName <string>
  -CertificatePath <FileInfo>
  [-PrivateKeyEncryptionPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject-CertFileWithKey

```
New-SmoDatabaseCertificate
  -DatabaseObject <Database>
  -CertificateName <string>
  -CertificatePath <FileInfo>
  -PrivateKeyPath <FileInfo>
  -PrivateKeyDecryptionPassword <securestring>
  [-PrivateKeyEncryptionPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject-CertFile

```
New-SmoDatabaseCertificate
  -DatabaseObject <Database>
  -CertificateName <string>
  -CertificatePath <FileInfo>
  [-PrivateKeyEncryptionPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
New-SmoDatabaseCertificate
  -DatabaseObject <Database>
  -CertificateName <string>
  -Subject <string>
  [-PrivateKeyEncryptionPassword <securestring>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Creates database certificate.

## EXAMPLES

### Example 1

New-SmoDatabaseCertificate -ServerInstance . -DatabaseName AdventureWorks -CertificateName MyCert -Subject MyCert

Creates database certificate within the AdventureWorks database.

### Example 2

New-SmoDatabaseCertificate -ServerInstance . -DatabaseName AdventureWorks -CertificateName MyCert -CertificatePath C:\MyCert.cer -PrivateKeyPath C:\MyCert.key -PrivateKeyDecryptionPassword $(Get-Credential Decrypt).Password

Creates database certificate within the AdventureWorks database from certificate file and key.

### Example 3

New-SmoDatabaseCertificate -ServerInstance . -DatabaseName AdventureWorks -CertificateName MyCert -CertificatePath C:\MyCert.cer

Creates database certificate within the AdventureWorks database from certificate file.

### Example 4

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -DatabaseName AdventureWorks -CertificateName MyCert -Subject MyCert

Creates database certificate Using the database object.

### Example 5

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName MyCert -CertificateName MyCert -CertificatePath C:\MyCert.cer -PrivateKeyPath C:\MyCert.key -PrivateKeyDecryptionPassword $(Get-Credential Decrypt).Password

Creates database certificate from certificate file and key using database object.

### Example 6

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName MyCert -CertificatePath C:\MyCert.cer

Creates database certificate from certificate file using database object.

## PARAMETERS

### -CertificateName

Specifies the name of the certificate.

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

Specifies the path and name of the certificate.

```yaml
Type: System.IO.FileInfo
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-CertFileWithKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseObject-CertFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-CertFileWithKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-CertFile
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
- Name: DatabaseName-CertFileWithKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-CertFile
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
- Name: DatabaseObject-CertFileWithKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseObject-CertFile
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

### -PrivateKeyDecryptionPassword

Specifies the decryption password from file to import.

```yaml
Type: System.Security.SecureString
DefaultValue: None
SupportsWildcards: false
Aliases:
- DecryptionPassword
ParameterSets:
- Name: DatabaseObject-CertFileWithKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-CertFileWithKey
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

Specifies the password to encrypt private key within the database.

```yaml
Type: System.Security.SecureString
DefaultValue: None
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

Specifies the path and file name of private key.

```yaml
Type: System.IO.FileInfo
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-CertFileWithKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-CertFileWithKey
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
- Name: DatabaseName-CertFileWithKey
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-CertFile
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

### -Subject

Specifies the subject for the certificate.

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

### Microsoft.SqlServer.Management.Smo.Certificate



## NOTES




## RELATED LINKS

None.

