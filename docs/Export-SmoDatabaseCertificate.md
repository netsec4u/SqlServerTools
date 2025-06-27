---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Export-SmoDatabaseCertificate

## SYNOPSIS
Exports database certificate and private key to files.

## SYNTAX

### DatabaseName (Default)
```
Export-SmoDatabaseCertificate
	-ServerInstance <String>
	-DatabaseName <String>
	-CertificateName <String>
	[-PrivateKeyDecryptionPassword <SecureString>]
	-CertificatePath <FileInfo>
	-PrivateKeyPath <FileInfo>
	-PrivateKeyEncryptionPassword <SecureString>
	[<CommonParameters>]
```

### DatabaseObject
```
Export-SmoDatabaseCertificate
	-DatabaseObject <Database>
	-CertificateName <String>
	[-PrivateKeyDecryptionPassword <SecureString>]
	-CertificatePath <FileInfo>
	-PrivateKeyPath <FileInfo>
	-PrivateKeyEncryptionPassword <SecureString>
	[<CommonParameters>]
```

## DESCRIPTION
Exports database certificate and private key to files.

## EXAMPLES

### Example 1
```powershell
Export-SmoDatabaseCertificate -ServerInstance MyServer -DatabaseName AdventureWorks -CertificateName MyCertificate -CertificatePath C:\certificate.cer -PrivateKeyPath C:\certificate.key -PrivateKeyEncryptionPassword $(Get-Credential Encryption).Password
```

Exports database certificate in the AdventureWorks database to specified files.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Export-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName MyCertificate -CertificatePath C:\certificate.cer -PrivateKeyPath C:\certificate.key -PrivateKeyEncryptionPassword $(Get-Credential Encryption).Password
```

Exports database certificate within the database object to specified files.

## PARAMETERS

### -CertificateName
Specifies the name of the database certificate to export.

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
Specifies the path and file name to export the certificate to.

```yaml
Type: FileInfo
Parameter Sets: (All)
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
Parameter Sets: DatabaseName
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
Parameter Sets: DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyDecryptionPassword
Specifies the password to decrypt private key in database.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: DecryptionPassword

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyEncryptionPassword
Specifies the password to encrypt exported certificate.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: EncryptionPassword

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyPath
Specifies the path and file name to export the private key to.

```yaml
Type: FileInfo
Parameter Sets: (All)
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
Parameter Sets: DatabaseName
Aliases: SqlServer

Required: True
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

### System.Void

## NOTES

## RELATED LINKS
