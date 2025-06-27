---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Add-SmoDatabaseAsymmetricKeyPrivateKey

## SYNOPSIS
Adds private key to asymmetric key.

## SYNTAX

### DatabaseName (Default)
```
Add-SmoDatabaseAsymmetricKeyPrivateKey
	-ServerInstance <String>
	-DatabaseName <String>
	-AsymmetricKeyName <String>
	-PrivateKeyPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Add-SmoDatabaseAsymmetricKeyPrivateKey
	-DatabaseObject <Database>
	-AsymmetricKeyName <String>
	-PrivateKeyPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Adds private key to asymmetric key.

## EXAMPLES

### Example 1
```powershell
Add-SmoDatabaseAsymmetricKeyPrivateKey -ServerInstance . -DatabaseName AdventureWorks -AsymmetricKeyName MyKey -PrivateKeyPassword $(Get-Credential PrivateKey).Password
```

Adds private key to MyKey in the AdventureWorks database.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Add-SmoDatabaseAsymmetricKeyPrivateKey -DatabaseObject $DatabaseObject -AsymmetricKeyName MyKey -PrivateKeyPassword $(Get-Credential PrivateKey).Password
```

Adds private key to MyKey using the database object.

## PARAMETERS

### -AsymmetricKeyName
Specifies the asymmetric key name.

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

### -PrivateKeyPassword
Specifies the password with which to create the key.

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
