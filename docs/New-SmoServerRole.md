---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# New-SmoServerRole

## SYNOPSIS
Create server role.

## SYNTAX

### ServerInstance (Default)
```
New-SmoServerRole
	-ServerInstance <String>
	-ServerRoleName <String>
	-ServerRoleOwner <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServer
```
New-SmoServerRole
	-SmoServerObject <Server>
	-ServerRoleName <String>
	-ServerRoleOwner <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Create server role.

## EXAMPLES

### EXAMPLE 1
```powershell
New-SmoServerRole -ServerInstance MyServer -ServerRoleName MyServerRole -ServerRoleOwner sa
```

Create server role in SQL instance MyServer.

### EXAMPLE 2
```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .

New-SmoServerRole -SmoServerObject $SmoServerObject -ServerRoleName MyServerRole -ServerRoleOwner sa
```

Create server role using SMO server object.

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

### -ServerRoleName
Name of server role to create.

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

### -ServerRoleOwner
Server role owner.

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

### Microsoft.SqlServer.Management.Smo.ServerRole

## NOTES

## RELATED LINKS
