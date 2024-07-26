---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Remove-SmoDatabaseRoleMember

## SYNOPSIS
Remove member from database role.

## SYNTAX

### DatabaseName (Default)
```
Remove-SmoDatabaseRoleMember
	-ServerInstance <String>
	-DatabaseName <String>
	-RoleName <String>
	-RoleMemberName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Remove-SmoDatabaseRoleMember
	-DatabaseObject <Database>
	-RoleName <String>
	-RoleMemberName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Remove database principal from database role.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-SmoDatabaseRoleMember -ServerInstance MyServer -DatabaseName AdventureWorks -RoleName db_HL7 -RoleMemberName JSmith
```

Removes JSmith database role member from db_HL7 role.

### EXAMPLE 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Remove-SmoDatabaseRoleMember -DatabaseObject $DatabaseObject -RoleName db_HL7 -RoleMemberName JSmith
```

Removes JSmith database role member from db_HL7 role using database object.

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
Name of database object.

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

### -RoleMemberName
Name of database user to remove from role.

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

### -RoleName
Name of Role to remove members from.

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

### System.Void

## NOTES

## RELATED LINKS
