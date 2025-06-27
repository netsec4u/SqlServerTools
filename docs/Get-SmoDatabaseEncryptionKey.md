---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Get-SmoDatabaseEncryptionKey

## SYNOPSIS
Gets database encryption key.

## SYNTAX

### DatabaseName (Default)
```
Get-SmoDatabaseEncryptionKey
	-ServerInstance <String>
	-DatabaseName <String>
	[<CommonParameters>]
```

### DatabaseObject
```
Get-SmoDatabaseEncryptionKey
	-DatabaseObject <Database>
	[<CommonParameters>]
```

## DESCRIPTION
Gets database encryption key.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SmoDatabaseEncryptionKey -ServerInstance MyServer -DatabaseName AdventureWorks
```

Gets database encryption key from AdventureWorks database.

### EXAMPLE 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Get-SmoDatabaseEncryptionKey -DatabaseObject $DatabaseObject
```

Gets database encryption key using the database object.

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
SMO database object to add database encryption key.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey

## NOTES

## RELATED LINKS
