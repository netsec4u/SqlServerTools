---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Add-SmoDatabaseSymmetricKeyKeyEncryption

## SYNOPSIS
Adds key encryption to symmetric key.

## SYNTAX

```
Add-SmoDatabaseSymmetricKeyKeyEncryption
	-DatabaseObject <Database>
	-SymmetricKeyName <String>
	-KeyEncryptionType <KeyEncryptionType>
	-KeyEncryptionValue <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Adds key encryption to symmetric key.

## EXAMPLES

### Example 1
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Add-SmoDatabaseSymmetricKeyKeyEncryption -DatabaseObject $DatabaseObject -SymmetricKeyName MyKey -KeyEncryptionType Certificate -KeyEncryptionValue MyCert
```

Adds certificate key encryption to MyKey using the database object.

## PARAMETERS

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
