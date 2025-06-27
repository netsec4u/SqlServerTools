---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Open-SmoDatabaseSymmetricKey

## SYNOPSIS
Opens database symmetric key.

## SYNTAX

### DatabaseObject (Default)
```
Open-SmoDatabaseSymmetricKey
	-DatabaseObject <Database>
	-SymmetricKeyName <String>
	-DecryptionPassword <SecureString>
	[<CommonParameters>]
```

### DatabaseObject-WithSymmetricKey
```
Open-SmoDatabaseSymmetricKey
	-DatabaseObject <Database>
	-SymmetricKeyName <String>
	-DecryptionSymmetricKeyName <String>
	[<CommonParameters>]
```

### DatabaseObject-WithCertificate
```
Open-SmoDatabaseSymmetricKey
	-DatabaseObject <Database>
	-SymmetricKeyName <String>
	-CertificateName <String>
	[-PrivateKeyPassword <SecureString>]
	[<CommonParameters>]
```

## DESCRIPTION
Opens database symmetric key.

## EXAMPLES

### Example 1
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Open-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MySymmetricKey -DEcryptionPassword $(Get-Credential KeyPassword).Password
```

Opens symmetric key with a password using the database object.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Open-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MySymmetricKey -DecryptionSymmetricKeyName DecryptionKey
```

Opens symmetric key with a symmetric key using the database object.

### Example 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Open-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MySymmetricKey -CertificateName MyCertificate
```

Opens symmetric key with a certificate using the database object.

## PARAMETERS

### -CertificateName
Specifies the certificate to decrypt symmetric key.

```yaml
Type: String
Parameter Sets: DatabaseObject-WithCertificate
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
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DecryptionPassword
Specifies the symmetric key password.

```yaml
Type: SecureString
Parameter Sets: DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DecryptionSymmetricKeyName
Specifies the name of the symmetric key to decrypt symmetric key.

```yaml
Type: String
Parameter Sets: DatabaseObject-WithSymmetricKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyPassword
Specifies private key password.

```yaml
Type: SecureString
Parameter Sets: DatabaseObject-WithCertificate
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SymmetricKeyName
Specifies the name of the symmetric key.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS
