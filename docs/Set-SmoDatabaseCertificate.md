---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Set-SmoDatabaseCertificate

## SYNOPSIS
Sets database certificate properties.

## SYNTAX

### DatabaseName (Default)
```
Set-SmoDatabaseCertificate
	-ServerInstance <String>
	-DatabaseName <String>
	-CertificateName <String>
	-PrivateKeyPassword <SecureString>
	-NewPrivateKeyPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Set-SmoDatabaseCertificate
	-DatabaseObject <Database>
	-CertificateName <String>
	-PrivateKeyPassword <SecureString>
	-NewPrivateKeyPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Sets database certificate properties.

## EXAMPLES

### Example 1
```powershell
Set-SmoDatabaseCertificate -ServerInstance . -DatabaseName AdventureWorks -CertificateName MyCert -PrivateKeyPassword $(Get-Credential KeyPassword).Password -NewPrivateKeyPassword $(Get-Credential NewKeyPassword).Password
```

Sets private key password for MyCert certificate in the AdventureWorks database.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Set-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName MyCert -PrivateKeyPassword $(Get-Credential KeyPassword).Password -NewPrivateKeyPassword $(Get-Credential NewKeyPassword).Password
```

Sets private key password for MyCert certificate using the database object.

## PARAMETERS

### -CertificateName
Specifies the name of the certificate.

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
