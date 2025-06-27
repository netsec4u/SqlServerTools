---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Import-SmoServiceMasterKey

## SYNOPSIS
Imports service master key from file.

## SYNTAX

### ServerInstance (Default)
```
Import-SmoServiceMasterKey
	-ServerInstance <String>
	-Path <FileInfo>
	-DecryptionPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SmoServer
```
Import-SmoServiceMasterKey
	-SmoServerObject <Server>
	-Path <FileInfo>
	-DecryptionPassword <SecureString>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Imports service master key from file.

## EXAMPLES

### Example 1
```powershell
Import-SmoServiceMasterKey -ServerInstance MyServer -DatabaseName AdventureWorks -Path C:\AdventureWorks.SMK -DecryptionPassword $(Get-Credential Decrypt).Password
```

Imports service master key from specified file into AdventureWorks database.

### Example 2
```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .

Import-SmoServiceMasterKey -SmoServerObject $SmoServerObject -Path C:\AdventureWorks.DMK -DecryptionPassword $(Get-Credential Decrypt).Password
```

Imports service master key from specified file using Smo server connection.

## PARAMETERS

### -DecryptionPassword
Specifies the decryption password from file to import.

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
Path to service master key to import.

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
