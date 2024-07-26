---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Add-SmoServerRoleMember

## SYNOPSIS
Add member to server role.

## SYNTAX

### ServerInstance (Default)
```
Add-SmoServerRoleMember
	-ServerInstance <String>
	-ServerRoleName <String>
	-ServerRoleMemberName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServer
```
Add-SmoServerRoleMember
	-SmoServerObject <Server>
	-ServerRoleName <String>
	-ServerRoleMemberName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Add member to server role.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-SmoServerRoleMember -ServerInstance MyServer -ServerRoleName MyServerRole -ServerRoleMemberName JSmith
```

Add JSmith to server role MyServerRole.

### EXAMPLE 2
```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .

Add-SmoServerRoleMember -SmoServerObject $SmoServerObject -RoleName MyServerRole -ServerRoleMemberName JSmith
```

Add JSmith to server role MyServerRole using Smo Server Object.

## PARAMETERS

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

### -ServerRoleMemberName
Name of SQL user to add to role.

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

### -ServerRoleName
Name of Server Role to add members to.

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

### Microsoft.SqlServer.Management.Smo.Credential

## NOTES

## RELATED LINKS
