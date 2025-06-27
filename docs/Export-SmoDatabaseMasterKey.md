---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Export-SmoDatabaseMasterKey

## SYNOPSIS
Exports database master key to a file.

## SYNTAX

### DatabaseName (Default)
```
Export-SmoDatabaseMasterKey
	-ServerInstance <String>
	-DatabaseName <String>
	-Path <FileInfo>
	-EncryptionPassword <SecureString>
	[<CommonParameters>]
```

### DatabaseObject
```
Export-SmoDatabaseMasterKey
	-DatabaseObject <Database>
	-Path <FileInfo>
	-EncryptionPassword <SecureString>
	[<CommonParameters>]
```

## DESCRIPTION
Exports database master key to a file.

## EXAMPLES

### Example 1
```powershell
Export-SmoDatabaseMasterKey -ServerInstance MyServer -DatabaseName AdventureWorks -Path C:\AdventureWorks.DMK -EncryptionPassword $(Get-Credential Encryption).Password
```

Exports database master key in the AdventureWorks database to the specified file.

### Example 2
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Export-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject -Path C:\AdventureWorks.DMK -EncryptionPassword $(Get-Credential Encryption).Password
```

Exports database master key within the database object to the specified file.

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

### -EncryptionPassword
Specifies the password to encrypt exported database master key.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies the path and file name to store the database master key.

```yaml
Type: FileInfo
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS
