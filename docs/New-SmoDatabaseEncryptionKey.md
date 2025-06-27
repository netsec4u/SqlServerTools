---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# New-SmoDatabaseEncryptionKey

## SYNOPSIS
Creates database encryption key.

## SYNTAX

### DatabaseName (Default)
```
New-SmoDatabaseEncryptionKey
	-ServerInstance <String>
	-DatabaseName <String>
	-EncryptionAlgorithm <DatabaseEncryptionAlgorithm>
	-EncryptionType <DatabaseEncryptionType>
	-EncryptorName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
New-SmoDatabaseEncryptionKey
	-DatabaseObject <Database>
	-EncryptionAlgorithm <DatabaseEncryptionAlgorithm>
	-EncryptionType <DatabaseEncryptionType>
	-EncryptorName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Creates database encryption key.

## EXAMPLES

### EXAMPLE 1
```powershell
New-SmoDatabaseEncryptionKey -ServerInstance MyServer -DatabaseName AdventureWorks -EncryptionAlgorithm Aes256 -EncryptionType ServerCertificate -EncryptorName MyCert
```

Add database encryption key to AdventureWorks database.

### EXAMPLE 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseEncryptionKey -DatabaseObject $DatabaseObject -EncryptionAlgorithm Aes256 -EncryptionType ServerCertificate -EncryptorName MyCert
```

Add database encryption key to database object.

## PARAMETERS

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
SMO database object to add database encryption key.

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

### -EncryptionAlgorithm
Encryption algorithm.

```yaml
Type: DatabaseEncryptionAlgorithm
Parameter Sets: (All)
Aliases:
Accepted values: Aes128, Aes192, Aes256, TripleDes

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptionType
Encryption type.

```yaml
Type: DatabaseEncryptionType
Parameter Sets: (All)
Aliases:
Accepted values: ServerCertificate, ServerAsymmetricKey

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptorName
Name of certificate.

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

### Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey

## NOTES

## RELATED LINKS
