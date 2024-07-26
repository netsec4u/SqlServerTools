---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Remove-SmoDatabaseEncryptionKey

## SYNOPSIS
Remove database encryption key.

## SYNTAX

### DatabaseName (Default)
```
Remove-SmoDatabaseEncryptionKey
	-ServerInstance <String>
	-DatabaseName <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Remove-SmoDatabaseEncryptionKey
	-DatabaseObject <Database>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Remove database encryption key.

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-SmoDatabaseEncryptionKey -ServerInstance MyServer -DatabaseName AdventureWorks
```

Removes database encryption key from AdventureWorks database.

### EXAMPLE 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Remove-SmoDatabaseEncryptionKey -DatabaseObject $DatabaseObject
```

Removes database encryption key using database object.

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
Name of database object to remove database encryption key.

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
