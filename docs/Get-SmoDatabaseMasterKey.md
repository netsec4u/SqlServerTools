---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Get-SmoDatabaseMasterKey

## SYNOPSIS
Gets database master key.

## SYNTAX

### DatabaseName (Default)
```
Get-SmoDatabaseMasterKey
	-ServerInstance <String>
	-DatabaseName <String>
	[<CommonParameters>]
```

### DatabaseObject
```
Get-SmoDatabaseMasterKey
	-DatabaseObject <Database>
	[<CommonParameters>]
```

## DESCRIPTION
Gets database master key.

## EXAMPLES

### Example 1
```powershell
Get-SmoDatabaseMasterKey -ServerInstance MyServer -DatabaseName AdventureWorks
```

Gets database master key in the AdventureWorks database.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Get-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject
```

Gets database master key within the database object.

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
SMO database object.

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

### Microsoft.SqlServer.Management.Smo.MasterKey

## NOTES

## RELATED LINKS
