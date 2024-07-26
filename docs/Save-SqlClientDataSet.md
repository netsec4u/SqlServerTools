---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Save-SqlClientDataSet

## SYNOPSIS
Save dataset to data adapter.

## SYNTAX

```
Save-SqlClientDataSet
	-DataSet <DataSet>
	[-SqlDataAdapter <SqlDataAdapter>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Save dataset to SQL Server.

## EXAMPLES

### EXAMPLE 1
```powershell
$DataSet = Get-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText "SELECT * FROM dbo.Customers;"

Save-SqlClientDataSet -DataSet $DataSet
```

Saves specified dataset to data adapter.

## PARAMETERS

### -DataSet
Data set object.

```yaml
Type: DataSet
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlDataAdapter
Data adapter object.

```yaml
Type: SqlDataAdapter
Parameter Sets: (All)
Aliases:

Required: False
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
