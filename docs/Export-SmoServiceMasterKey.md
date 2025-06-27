---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Export-SmoServiceMasterKey

## SYNOPSIS
Exports service master key to a file.

## SYNTAX

### ServerInstance (Default)
```
Export-SmoServiceMasterKey
	-ServerInstance <String>
	-Path <FileInfo>
	-EncryptionPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServer
```
Export-SmoServiceMasterKey
	-SmoServerObject <Server>
	-Path <FileInfo>
	-EncryptionPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Exports service master key to a file.

## EXAMPLES

### Example 1
```powershell
Export-SmoServiceMasterKey -ServerInstance MyServer -DatabaseName AdventureWorks -Path C:\AdventureWorks.SMK -EncryptionPassword $(Get-Credential Encryption).Password
```

Exports service master key to the specified file.

### Example 2
```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .

Export-SmoServiceMasterKey -SmoServerObject $SmoServerObject -Path C:\AdventureWorks.SMK -EncryptionPassword $(Get-Credential Encryption).Password
```

Exports service master key to the specified file using the specified SMO server object.

## PARAMETERS

### -EncryptionPassword
Specifies the password to encrypt exported service master key.

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
Specifies the path and file name to store the service master key.

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
