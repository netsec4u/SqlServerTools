---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# New-SmoDatabaseUser

## SYNOPSIS
Add database login to database.

## SYNTAX

### DatabaseName (Default)
```
New-SmoDatabaseUser
	-ServerInstance <String>
	-DatabaseName <String>
	-UserName <String>
	[-Password <SecureString>]
	[-DefaultSchema <String>]
	[-UserType <UserType>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
New-SmoDatabaseUser
	-DatabaseObject <Database>
	-UserName <String>
	[-Password <SecureString>]
	[-DefaultSchema <String>]
	[-UserType <UserType>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Add database login to database.

## EXAMPLES

### EXAMPLE 1
```powershell
New-SmoDatabaseUser -ServerInstance MyServer -DatabaseName AdventureWorks -UserName DBUser -DefaultSchema dbo
```

Create database user within the AdventureWorks database.

### EXAMPLE 2
```powershell
New-SmoDatabaseUser -ServerInstance MyServer -DatabaseName AdventureWorks -UserName DBUser -Password $(Get-Credential).Password -DefaultSchema dbo
```

Create contained user DBUser within the AdventureWorks database.

### EXAMPLE 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance MyServer -DatabaseName AdventureWorks

New-SmoDatabaseUser -DatabaseObject $DatabaseObject -UserName DBUser -DefaultSchema dbo
```

Create database user using the database object.

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
SMO database object to add database login.

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

### -DefaultSchema
Account default schema.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Dbo
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password for user account.

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

### -UserName
Username to create.

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

### -UserType
Specifies the type of user.

```yaml
Type: UserType
Parameter Sets: (All)
Aliases:
Accepted values: SqlLogin, SqlUser, Certificate, AsymmetricKey, NoLogin, External

Required: False
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

### Microsoft.SqlServer.Management.Smo.User

## NOTES

## RELATED LINKS
