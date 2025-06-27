---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Remove-SmoDatabaseSymmetricKeyKeyEncryption

## SYNOPSIS
Removes key encryption from symmetric key.

## SYNTAX

### DatabaseName (Default)
```
Remove-SmoDatabaseSymmetricKeyKeyEncryption
	-ServerInstance <String>
	-DatabaseName <String>
	-SymmetricKeyName <String>
	-KeyEncryptionType <KeyEncryptionType>
	-KeyEncryptionValue <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Remove-SmoDatabaseSymmetricKeyKeyEncryption
	-DatabaseObject <Database>
	-SymmetricKeyName <String>
	-KeyEncryptionType <KeyEncryptionType>
	-KeyEncryptionValue <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Removes key encryption from symmetric key.

## EXAMPLES

### Example 1
```powershell
Remove-SmoDatabaseSymmetricKeyKeyEncryption -ServerInstance . -DatabaseName AdventureWorks -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCert
```

Removes certificate key encryption from MyKey in the AdventureWorks database.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Remove-SmoDatabaseSymmetricKeyKeyEncryption -DatabaseObject $DatabaseObject -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCert
```

Removes certificate key encryption from MyKey using the database object.

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

### System.Void

## NOTES

## RELATED LINKS
