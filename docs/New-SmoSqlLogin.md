---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# New-SmoSqlLogin

## SYNOPSIS
Create SQL login.

## SYNTAX

### ServerInstance (Default)
```
New-SmoSqlLogin
	-ServerInstance <String>
	-LoginName <String>
	-Password <SecureString>
	-LoginType <LoginType>
	[-DefaultDatabase <String>]
	[-Sid <String>]
	[-SidByteArray <Byte[]>]
	[-PasswordExpirationEnabled <Boolean>]
	[-PasswordPolicyEnforced <Boolean>]
	[-LoginDisabled <Boolean>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServer
```
New-SmoSqlLogin
	-SmoServerObject <Server>
	-LoginName <String>
	-Password <SecureString>
	-LoginType <LoginType>
	[-DefaultDatabase <String>]
	[-Sid <String>]
	[-SidByteArray <Byte[]>]
	[-PasswordExpirationEnabled <Boolean>]
	[-PasswordPolicyEnforced <Boolean>]
	[-LoginDisabled <Boolean>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Create SQL login.

## EXAMPLES

### EXAMPLE 1
```powershell
New-SmoSqlLogin -ServerInstance MyServer -LoginName MyLogin -Password $(Get-Credential).Password
```

Creates SQL login on MyServer SQL instance.

### EXAMPLE 2
```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .

New-SmoSqlLogin -SmoServerObject $SmoServerObject -LoginName MyLogin -Password $(Get-Credential).Password
```

Creates SQL login using SMO server object.

### EXAMPLE 3
```powershell
New-SmoSqlLogin -ServerInstance MyServer -LoginName MyLogin -Password $(Get-Credential).Password -Sid '0x615C96F6296B18438C6DF0304CD56CE0'
```

Creates SQL login using specified SID.

### EXAMPLE 4
```powershell
$SqlLogin = Get-SqlLogin -ServerInstance SomeServer -LoginName MyLogin

New-SmoSqlLogin -ServerInstance MyServer -LoginName MyLogin -Password $(Get-Credential).Password -Sid $SqlLogin.Sid
```

Create SQL login using SID retrieved from Get-SqlLogin.

## PARAMETERS

### -DefaultDatabase
Specifies default database for login.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Master
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
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginName
login name.

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

### -LoginType
Specifies type of SQL login.

```yaml
Type: LoginType
Parameter Sets: (All)
Aliases:
Accepted values: WindowsUser, WindowsGroup, SqlLogin, Certificate, AsymmetricKey, ExternalUser, ExternalGroup

Required: True
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

Required: True
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
Default value: True
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
Default value: True
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

### -Sid
Specifies Sid for login.

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

### -SidByteArray
Specifies Sid for login on byte array.

```yaml
Type: Byte[]
Parameter Sets: (All)
Aliases:

Required: False
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
