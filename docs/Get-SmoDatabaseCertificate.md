---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Get-SmoDatabaseCertificate

## SYNOPSIS
Returns a database certificates.

## SYNTAX

### DatabaseName (Default)
```
Get-SmoDatabaseCertificate
	-ServerInstance <String>
	-DatabaseName <String>
	[-CertificateName <String>]
	[<CommonParameters>]
```

### DatabaseObject
```
Get-SmoDatabaseCertificate
	-DatabaseObject <Database>
	[-CertificateName <String>]
	[<CommonParameters>]
```

## DESCRIPTION
Returns a database certificates.

## EXAMPLES

### Example 1
```powershell
Get-SmoDatabaseCertificate -ServerInstance MyServer -DatabaseName AdventureWorks
```

Gets database certificates in the AdventureWorks database.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Get-SmoDatabaseCertificate -DatabaseObject $DatabaseObject
```

Gets database certificates within the database object.

## PARAMETERS

### -CertificateName
Specifies the name of the certificate.

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

### Microsoft.SqlServer.Management.Smo.Certificate

## NOTES

## RELATED LINKS
