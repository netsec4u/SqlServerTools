---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Open-SmoDatabaseMasterKey

## SYNOPSIS
Opens database master key.

## SYNTAX

```
Open-SmoDatabaseMasterKey
	-DatabaseObject <Database>
	-DecryptionPassword <SecureString>
	[<CommonParameters>]
```

## DESCRIPTION
Opens database master key.

## EXAMPLES

### Example 1
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Open-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject -DecryptionPassword $(Get-Credential Decrypt).Password
```

Opens database master key using the database object.

## PARAMETERS

### -DatabaseObject
SMO database object.

```yaml
Type: Database
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DecryptionPassword
Specifies the decryption password.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS
