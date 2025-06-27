---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Close-SmoDatabaseMasterKey

## SYNOPSIS
Closes database master key.

## SYNTAX

```
Close-SmoDatabaseMasterKey
	-DatabaseObject <Database>
	[<CommonParameters>]
```

## DESCRIPTION
Closes database master key.

## EXAMPLES

### Example 1
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Close-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject
```

Closes database master key within the database object.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS
