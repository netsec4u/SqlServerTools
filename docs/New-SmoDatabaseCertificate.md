---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# New-SmoDatabaseCertificate

## SYNOPSIS
Creates database certificate.

## SYNTAX

### DatabaseName (Default)
```
New-SmoDatabaseCertificate
	-ServerInstance <String>
	-DatabaseName <String>
	-CertificateName <String>
	-Subject <String>
	[-PrivateKeyEncryptionPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseName-CertFileWithKey
```
New-SmoDatabaseCertificate
	-ServerInstance <String>
	-DatabaseName <String>
	-CertificateName <String>
	-CertificatePath <FileInfo>
	-PrivateKeyPath <FileInfo>
	-PrivateKeyDecryptionPassword <SecureString>
	[-PrivateKeyEncryptionPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseName-CertFile
```
New-SmoDatabaseCertificate
	-ServerInstance <String>
	-DatabaseName <String>
	-CertificateName <String>
	-CertificatePath <FileInfo>
	[-PrivateKeyEncryptionPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject-CertFileWithKey
```
New-SmoDatabaseCertificate
	-DatabaseObject <Database>
	-CertificateName <String>
	-CertificatePath <FileInfo>
	-PrivateKeyPath <FileInfo>
	-PrivateKeyDecryptionPassword <SecureString>
	[-PrivateKeyEncryptionPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject-CertFile
```
New-SmoDatabaseCertificate
	-DatabaseObject <Database>
	-CertificateName <String>
	-CertificatePath <FileInfo>
	[-PrivateKeyEncryptionPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
New-SmoDatabaseCertificate
	-DatabaseObject <Database>
	-CertificateName <String>
	-Subject <String>
	[-PrivateKeyEncryptionPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Creates database certificate.

## EXAMPLES

### Example 1
```powershell
New-SmoDatabaseCertificate -ServerInstance . -DatabaseName AdventureWorks -CertificateName MyCert -Subject MyCert
```

Creates database certificate within the AdventureWorks database.

### Example 2
```powershell
New-SmoDatabaseCertificate -ServerInstance . -DatabaseName AdventureWorks -CertificateName MyCert -CertificatePath C:\MyCert.cer -PrivateKeyPath C:\MyCert.key -PrivateKeyDecryptionPassword $(Get-Credential Decrypt).Password
```

Creates database certificate within the AdventureWorks database from certificate file and key.

### Example 3
```powershell
New-SmoDatabaseCertificate -ServerInstance . -DatabaseName AdventureWorks -CertificateName MyCert -CertificatePath C:\MyCert.cer
```

Creates database certificate within the AdventureWorks database from certificate file.

### Example 4
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -DatabaseName AdventureWorks -CertificateName MyCert -Subject MyCert
```

Creates database certificate Using the database object.

### Example 5
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName MyCert -CertificateName MyCert -CertificatePath C:\MyCert.cer -PrivateKeyPath C:\MyCert.key -PrivateKeyDecryptionPassword $(Get-Credential Decrypt).Password
```

Creates database certificate from certificate file and key using database object.

### Example 6
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName MyCert -CertificatePath C:\MyCert.cer
```

Creates database certificate from certificate file using database object.

## PARAMETERS

### -CertificateName
Specifies the name of the certificate.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CertificatePath
Specifies the path and name of the certificate.

```yaml
Type: FileInfo
Parameter Sets: DatabaseName-CertFileWithKey, DatabaseName-CertFile, DatabaseObject-CertFileWithKey, DatabaseObject-CertFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Name of database.

```yaml
Type: String
Parameter Sets: DatabaseName, DatabaseName-CertFileWithKey, DatabaseName-CertFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseObject
SMO database object.

```yaml
Type: Database
Parameter Sets: DatabaseObject-CertFileWithKey, DatabaseObject-CertFile, DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyDecryptionPassword
Specifies the decryption password from file to import.

```yaml
Type: SecureString
Parameter Sets: DatabaseName-CertFileWithKey, DatabaseObject-CertFileWithKey
Aliases: DecryptionPassword

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyEncryptionPassword
Specifies the password to encrypt private key within the database.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: EncryptionPassword

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyPath
Specifies the path and file name of private key.

```yaml
Type: FileInfo
Parameter Sets: DatabaseName-CertFileWithKey, DatabaseObject-CertFileWithKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
SQL Server host name and instance name.

```yaml
Type: String
Parameter Sets: DatabaseName, DatabaseName-CertFileWithKey, DatabaseName-CertFile
Aliases: SqlServer

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
Specifies the subject for the certificate.

```yaml
Type: String
Parameter Sets: DatabaseName, DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Microsoft.SqlServer.Management.Smo.Certificate

## NOTES

## RELATED LINKS
