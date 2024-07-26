---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Remove-SmoSqlLogin

## SYNOPSIS
Remove SQL Login.

## SYNTAX

### ServerInstance (Default)
```
Remove-SmoSqlLogin
	-ServerInstance <String>
	-LoginName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServer
```
Remove-SmoSqlLogin
	-SmoServerObject <Server>
	-LoginName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Remove SQL Login.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-SmoSqlLogin -ServerInstance MyServer -LoginName MySqlLogin
```

Removes SQL Login from MyServer SQL Instance.

### EXAMPLE 2
```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .

Remove-SmoSqlLogin -SmoServerObject $SmoServerObject -LoginName MySqlLogin
```

Removes SQL Login using SMO Server Object.

## PARAMETERS

### -LoginName
SQL Login name.

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

### System.Void

## NOTES

## RELATED LINKS
