---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Set-SmoDatabaseAsymmetricKey

## SYNOPSIS
Sets database asymmetric key properties.

## SYNTAX

### DatabaseName (Default)
```
Set-SmoDatabaseAsymmetricKey
	-ServerInstance <String>
	-DatabaseName <String>
	-AsymmetricKeyName <String>
	-PrivateKeyPassword <SecureString>
	-NewPrivateKeyPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Set-SmoDatabaseAsymmetricKey
	-DatabaseObject <Database>
	-AsymmetricKeyName <String>
	-PrivateKeyPassword <SecureString>
	-NewPrivateKeyPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Sets database asymmetric key properties.

## EXAMPLES

### Example 1
```powershell
Set-SmoDatabaseAsymmetricKey -ServerInstance . -DatabaseName AdventureWorks -AsymmetricKeyName MyKey -PrivateKeyPassword $(Get-Credential KeyPassword).Password -NewPrivateKeyPassword $(Get-Credential NewKeyPassword).Password
```

Sets new key password for private key in AdventureWorks database for MyKey.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Set-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName MyKey -PrivateKeyPassword $(Get-Credential KeyPassword).Password -NewPrivateKeyPassword $(Get-Credential NewKeyPassword).Password

```

Sets new key password for private key for MyKey using the database object.

## PARAMETERS

### -AsymmetricKeyName
Specifies the name of the asymmetric key.

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
Parameter Sets: DatabaseName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseObject
SMO database object

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

### -NewPrivateKeyPassword
Specifies new private key password.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateKeyPassword
Specifies current private key password.

```yaml
Type: SecureString
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

### System.Void

## NOTES

## RELATED LINKS
