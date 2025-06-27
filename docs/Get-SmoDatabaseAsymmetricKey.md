---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Get-SmoDatabaseAsymmetricKey

## SYNOPSIS
Returns a database asymmetric key.

## SYNTAX

### DatabaseName (Default)
```
Get-SmoDatabaseAsymmetricKey
	-ServerInstance <String>
	-DatabaseName <String>
	[-AsymmetricKeyName <String>]
	[<CommonParameters>]
```

### DatabaseObject
```
Get-SmoDatabaseAsymmetricKey
	-DatabaseObject <Database>
	[-AsymmetricKeyName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Returns a database asymmetric key.

## EXAMPLES

### Example 1
```powershell
Get-SmoDatabaseAsymmetricKey -ServerInstance . -DatabaseName AdventureWorks
```

Gets database asymmetric keys in the AdventureWorks database.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Get-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject
```

Gets database asymmetric keys within the database object.

## PARAMETERS

### -AsymmetricKeyName
Specifies the name of the asymmetric key.

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

### Microsoft.SqlServer.Management.Smo.AsymmetricKey

## NOTES

## RELATED LINKS
