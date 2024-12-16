---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Set-SmoSqlLogin

## SYNOPSIS
Set SQL login properties.

## SYNTAX

### ServerInstance (Default)
```
Set-SmoSqlLogin
	-ServerInstance <String>
	-LoginName <String>
	[-NewLoginName <String>]
	[-Password <SecureString>]
	[-DefaultDatabase <String>]
	[-PasswordExpirationEnabled <Boolean>]
	[-PasswordPolicyEnforced <Boolean>]
	[-LoginDisabled <Boolean>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServer
```
Set-SmoSqlLogin
	-SmoServerObject <Server>
	-LoginName <String>
	[-NewLoginName <String>]
	[-Password <SecureString>]
	[-DefaultDatabase <String>]
	[-PasswordExpirationEnabled <Boolean>]
	[-PasswordPolicyEnforced <Boolean>]
	[-LoginDisabled <Boolean>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Set SQL login properties.

## EXAMPLES

### Example 1
```powershell
Set-SmoSqlLogin -ServerInstance MyServer -LoginName DBUser -LoginDisabled $false
```

Sets SQL login properties with the specified values.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . 

Set-SmoSqlLogin -DatabaseObject $DatabaseObject -LoginName DBUser -LoginDisabled $false
```

Sets SQL login properties using database object.

## PARAMETERS

### -DefaultDatabase
Specifies default database for login.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginDisabled
Login disabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginName
Login name.

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

### -NewLoginName
New login name to rename login.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password for login.

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

### -PasswordExpirationEnabled
Specifies password expiration to be enabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasswordPolicyEnforced
Password policy enforced.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
SQL Server host name and instance name.

```yaml
Type: String
Parameter Sets: ServerInstance
Aliases: SqlServer

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmoServerObject
SQL Server Management Object.

```yaml
Type: Server
Parameter Sets: SmoServer
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

### Microsoft.SqlServer.Management.Smo.Login

## NOTES

## RELATED LINKS
