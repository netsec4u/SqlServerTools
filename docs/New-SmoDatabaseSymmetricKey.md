---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# New-SmoDatabaseSymmetricKey

## SYNOPSIS
Creates database symmetric key.

## SYNTAX

### DatabaseName (Default)
```
New-SmoDatabaseSymmetricKey
	-ServerInstance <String>
	-DatabaseName <String>
	-SymmetricKeyName <String>
	-KeyEncryptionType <KeyEncryptionType>
	-KeyEncryptionValue <String>
	-KeyEncryptionAlgorithm <SymmetricKeyEncryptionAlgorithm>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseName-PassPhrase
```
New-SmoDatabaseSymmetricKey
	-ServerInstance <String>
	-DatabaseName <String>
	-SymmetricKeyName <String>
	-KeyEncryptionType <KeyEncryptionType>
	-KeyEncryptionValue <String>
	-KeyEncryptionAlgorithm <SymmetricKeyEncryptionAlgorithm>
	-PassPhrase <SecureString>
	[-IdentityPhrase <String>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject-PassPhrase
```
New-SmoDatabaseSymmetricKey
	-DatabaseObject <Database>
	-SymmetricKeyName <String>
	-KeyEncryptionType <KeyEncryptionType>
	-KeyEncryptionValue <String>
	-KeyEncryptionAlgorithm <SymmetricKeyEncryptionAlgorithm>
	-PassPhrase <SecureString>
	[-IdentityPhrase <String>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
New-SmoDatabaseSymmetricKey
	-DatabaseObject <Database>
	-SymmetricKeyName <String>
	-KeyEncryptionType <KeyEncryptionType>
	-KeyEncryptionValue <String>
	-KeyEncryptionAlgorithm <SymmetricKeyEncryptionAlgorithm>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Creates database symmetric key.

## EXAMPLES

### Example 1
```powershell
New-SmoDatabaseSymmetricKey -ServerInstance . -DatabaseName AdventureWorks -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCertificate -KeyEncryptionAlgorithm Aes256
```

Creates symmetric key in AdventureWorks database.

### Example 2
```powershell
New-SmoDatabaseSymmetricKey -ServerInstance . -DatabaseName AdventureWorks -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCertificate -KeyEncryptionAlgorithm Aes256 -PassPhrase $(Get-Credential KeyPassword).Password
```

Creates symmetric key in AdventureWorks database with pass phrase.

### Example 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MyKey> -KeyEncryptionType Certificate -KeyEncryptionValue MyCertificate -KeyEncryptionAlgorithm Aes256 -PassPhrase $(Get-Credential KeyPassword).Password
```

Creates symmetric key with pass phrase using the database object.

### Example 4
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCertificate -KeyEncryptionAlgorithm Aes256
```

Creates symmetric key in AdventureWorks database using the database object.

## PARAMETERS

### -DatabaseName
Name of database.

```yaml
Type: String
Parameter Sets: DatabaseName, DatabaseName-PassPhrase
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
Parameter Sets: DatabaseObject-PassPhrase, DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdentityPhrase
The IdentityPhrase parameter is used to tag data (using a GUID based on the identity phrase) that is encrypted with the key.

```yaml
Type: String
Parameter Sets: DatabaseName-PassPhrase, DatabaseObject-PassPhrase
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyEncryptionAlgorithm
Specifies the encryption method.

```yaml
Type: SymmetricKeyEncryptionAlgorithm
Parameter Sets: (All)
Aliases:
Accepted values: RC2, RC4, Des, TripleDes, DesX, Aes128, Aes192, Aes256, TripleDes3Key, CryptographicProviderDefined

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyEncryptionType
Specifies key encryption type.

```yaml
Type: KeyEncryptionType
Parameter Sets: (All)
Aliases:
Accepted values: SymmetricKey, Certificate, Password, AsymmetricKey, Provider

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyEncryptionValue
Specifies object name or password based on the value of the KeyEncryptionType parameter.

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

### -PassPhrase
Specifies a pass phrase from which the symmetric key can be derived.

```yaml
Type: SecureString
Parameter Sets: DatabaseName-PassPhrase, DatabaseObject-PassPhrase
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
Parameter Sets: DatabaseName, DatabaseName-PassPhrase
Aliases: SqlServer

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SymmetricKeyName
Specifies the symmetric key name.

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

### Microsoft.SqlServer.Management.Smo.SymmetricKey

## NOTES

## RELATED LINKS
