---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Invoke-SqlClientBulkCopy

## SYNOPSIS
Bulk copy data table to SQL table.

## SYNTAX

### ServerInstance (Default)
```
Invoke-SqlClientBulkCopy
	-ServerInstance <String>
	-DatabaseName <String>
	-TableName <String>
	[-QueryTimeout <Int32>]
	[-BatchSize <Int32>]
	-DataTable <DataTable>
	[-SqlBulkCopyOptions <SqlBulkCopyOptions>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SqlConnectionString
```
Invoke-SqlClientBulkCopy
	-ConnectionString <String>
	-TableName <String>
	[-QueryTimeout <Int32>]
	[-BatchSize <Int32>]
	-DataTable <DataTable>
	[-SqlBulkCopyOptions <SqlBulkCopyOptions>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Use SQL Bulk copy to insert data into database table.

## EXAMPLES

### EXAMPLE 1
```powershell
$DataTable = $DataTableGet-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataTable

Invoke-SqlClientBulkCopy -ServerInstance "MySQLServer" -DatabaseName AdventureWorks -TableName "MyTable" -DataTable $DataTable
```

Perform bulk copy against AdventureWorks database.

### EXAMPLE 2
```powershell
$DataTable = $DataTableGet-SqlClientDataSet -ServerInstance . -DatabaseName AdventureWorks -SqlCommandText 'SELECT * FROM sys.tables;*' -OutputAs DataTable
$ConnectionString = 'Data Source=.;Initial Catalog=AdventureWorks;Integrated Security=True;'

Invoke-SqlClientBulkCopy -ConnectionString $ConnectionString -TableName "MyTable" -DataTable $DataTable
```

Perform bulk copy using connection string.

## PARAMETERS

### -BatchSize
Bulk import batch size.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionString
SQL Server Connection string.

```yaml
Type: String
Parameter Sets: SqlConnectionString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Name of database.

```yaml
Type: String
Parameter Sets: ServerInstance
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataTable
Data table.

```yaml
Type: DataTable
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryTimeout
The length of time (in seconds) to wait for a query before terminating the query and throwing an exception.
Default is 30 seconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 30
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

### -SqlBulkCopyOptions
Bulk copy options.

```yaml
Type: SqlBulkCopyOptions
Parameter Sets: (All)
Aliases:
Accepted values: Default, KeepIdentity, CheckConstraints, TableLock, KeepNulls, FireTriggers, UseInternalTransaction, AllowEncryptedValueModifications

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -TableName
Table name to insert data.

```yaml
Type: String
Parameter Sets: (All)
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
