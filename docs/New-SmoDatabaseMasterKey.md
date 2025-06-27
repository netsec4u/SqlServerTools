---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# New-SmoDatabaseMasterKey

## SYNOPSIS
Creates database master key.

## SYNTAX

### DatabaseName (Default)
```
New-SmoDatabaseMasterKey
	-ServerInstance <String>
	-DatabaseName <String>
	-EncryptionPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseName-CertFile
```
New-SmoDatabaseMasterKey
	-ServerInstance <String>
	-DatabaseName <String>
	-EncryptionPassword <SecureString>
	-Path <FileInfo>
	-DecryptionPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject-CertFile
```
New-SmoDatabaseMasterKey
	-DatabaseObject <Database>
	-EncryptionPassword <SecureString>
	-Path <FileInfo>
	-DecryptionPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
New-SmoDatabaseMasterKey
	-DatabaseObject <Database>
	-EncryptionPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Creates database master key.

## EXAMPLES

### Example 1
```powershell
New-SmoDatabaseMasterKey -ServerInstance . -DatabaseName AdventureWorks -EncryptionPassword $(Get-Credential Encrypt).Password
```

Creates new database master key and encrypt with specified password.

### Example 2
```powershell
New-SmoDatabaseMasterKey -ServerInstance . -DatabaseName AdventureWorks -EncryptionPassword $(Get-Credential Encrypt).Password -Path C:\AdventureWorks.DMK -DecryptionPassword $(Get-Credential Decrypt).Password
```

Creates new database master key and encrypt with specified password from file.

### Example 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject -EncryptionPassword $(Get-Credential Encrypt).Password -Path C:\AdventureWorks.DMK -DecryptionPassword $(Get-Credential Decrypt).Password
```

Creates new database master key and encrypt with specified password from file using the database object.

### Example 4
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject -EncryptionPassword $(Get-Credential Encrypt).Password
```

Creates new database master key and encrypt with specified password using the database object.

## PARAMETERS

### -DatabaseName
Name of database.

```yaml
Type: String
Parameter Sets: DatabaseName, DatabaseName-CertFile
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
Parameter Sets: DatabaseObject-CertFile, DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DecryptionPassword
Specifies the decryption password from file to create master key from.

```yaml
Type: SecureString
Parameter Sets: DatabaseName-CertFile, DatabaseObject-CertFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptionPassword
Specifies the encryption password for database master key.

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
Path to database master key to create master key from.

```yaml
Type: FileInfo
Parameter Sets: DatabaseName-CertFile, DatabaseObject-CertFile
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
Parameter Sets: DatabaseName, DatabaseName-CertFile
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

### Microsoft.SqlServer.Management.Smo.MasterKey

## NOTES

## RELATED LINKS
