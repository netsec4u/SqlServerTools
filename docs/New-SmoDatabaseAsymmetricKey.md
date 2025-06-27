---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# New-SmoDatabaseAsymmetricKey

## SYNOPSIS
Create a database asymmetric key.

## SYNTAX

### DatabaseName-EncryptionAlgorithm (Default)
```
New-SmoDatabaseAsymmetricKey
	-ServerInstance <String>
	-DatabaseName <String>
	-AsymmetricKeyName <String>
	-EncryptionAlgorithm <AsymmetricKeyEncryptionAlgorithm>
	[-KeyPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseName-SourceType
```
New-SmoDatabaseAsymmetricKey
	-ServerInstance <String>
	-DatabaseName <String>
	-AsymmetricKeyName <String>
	-SourceType <AsymmetricKeySourceType>
	-KeySource <String>
	[-KeyPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject-SourceType
```
New-SmoDatabaseAsymmetricKey
	-DatabaseObject <Database>
	-AsymmetricKeyName <String>
	-SourceType <AsymmetricKeySourceType>
	-KeySource <String>
	[-KeyPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject-EncryptionAlgorithm
```
New-SmoDatabaseAsymmetricKey
	-DatabaseObject <Database>
	-AsymmetricKeyName <String>
	-EncryptionAlgorithm <AsymmetricKeyEncryptionAlgorithm>
	[-KeyPassword <SecureString>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Create a database asymmetric key.

## EXAMPLES

### Example 1
```powershell
New-SmoDatabaseAsymmetricKey -ServerInstance . -DatabaseName AdventureWorks -AsymmetricKeyName MyKey -EncryptionAlgorithm Rsa4096
```

Creates asymmetric key in the AdventureWorks.

### Example 2
```powershell
New-SmoDatabaseAsymmetricKey -ServerInstance . -DatabaseName AdventureWorks -AsymmetricKeyName MyKey -SourceType File -KeySource C:\MyKey.key
```

Creates asymmetric key in the AdventureWorks from key file provided.

### Example 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName MyKey -SourceType File -KeySource C:\MyKey.key
```

Creates asymmetric key in the AdventureWorks from key file provided using the database object.

### Example 4
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName MyKey -EncryptionAlgorithm Rsa4096
```

Creates asymmetric key in the AdventureWorks using the database object.

## PARAMETERS

### -AsymmetricKeyName
Specifies the Asymmetric key name to create.

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

### -DatabaseName
Name of database.

```yaml
Type: String
Parameter Sets: DatabaseName-EncryptionAlgorithm, DatabaseName-SourceType
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
Parameter Sets: DatabaseObject-SourceType, DatabaseObject-EncryptionAlgorithm
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptionAlgorithm
Specifies the encryption algorithm.

```yaml
Type: AsymmetricKeyEncryptionAlgorithm
Parameter Sets: DatabaseName-EncryptionAlgorithm, DatabaseObject-EncryptionAlgorithm
Aliases:
Accepted values: Rsa512, Rsa1024, Rsa2048, Rsa3072, Rsa4096, CryptographicProviderDefined

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyPassword
Specifies the password with which to create the key.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeySource
Specifies the key source to create key from.

```yaml
Type: String
Parameter Sets: DatabaseName-SourceType, DatabaseObject-SourceType
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
Parameter Sets: DatabaseName-EncryptionAlgorithm, DatabaseName-SourceType
Aliases: SqlServer

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceType
Specifies the type for the key source.

```yaml
Type: AsymmetricKeySourceType
Parameter Sets: DatabaseName-SourceType, DatabaseObject-SourceType
Aliases:
Accepted values: File, Executable, SqlAssembly, Provider

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

### Microsoft.SqlServer.Management.Smo.AsymmetricKey

## NOTES

## RELATED LINKS
