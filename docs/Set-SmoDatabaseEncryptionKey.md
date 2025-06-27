---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Set-SmoDatabaseEncryptionKey

## SYNOPSIS
Sets database encryption key properties.

## SYNTAX

### DatabaseName (Default)
```
Set-SmoDatabaseEncryptionKey
	-ServerInstance <String>
	-DatabaseName <String>
	-EncryptionType <DatabaseEncryptionType>
	-EncryptorName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Set-SmoDatabaseEncryptionKey
	-DatabaseObject <Database>
	-EncryptionType <DatabaseEncryptionType>
	-EncryptorName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Sets database encryption key properties.

## EXAMPLES

### Example 1
```powershell
Set-SmoDatabaseEncryptionKey -ServerInstance MyServer -DatabaseName AdventureWorks -EncryptionType ServerCertificate -EncryptorName MyCert
```

Sets the database encryption key to use server certificate MyCert for the AdventureWorks database.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Set-SmoDatabaseEncryptionKey -DatabaseObject $DatabaseObject -EncryptionType ServerCertificate -EncryptorName MyCert
```

Sets the database encryption key to use server certificate MyCert using the specified database object.

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
