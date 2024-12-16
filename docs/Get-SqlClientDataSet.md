---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Get-SqlClientDataSet

## SYNOPSIS
Executes Transact-SQL statement against a SQL Server database.

## SYNTAX

### DatabaseName (Default)
```
Get-SqlClientDataSet
	-ServerInstance <String>
	-DatabaseName <String>
	-SqlCommandText <String>
	[-CommandType <CommandType>]
	[-SqlParameter <System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlParameter]>]
	[-OutSqlParameter <System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlParameter]>]
	[-CommandTimeout <Int32>]
	[-DataSetName <String>]
	[-DataTableName <String>]
	[-OutputAs <DataOutputType>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SqlConnection
```
Get-SqlClientDataSet
	-SqlConnection <SqlConnection>
	[-DatabaseName <String>]
	-SqlCommandText <String>
	[-CommandType <CommandType>]
	[-SqlParameter <System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlParameter]>]
	[-OutSqlParameter <System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlParameter]>]
	[-CommandTimeout <Int32>]
	[-DataSetName <String>]
	[-DataTableName <String>]
	[-OutputAs <DataOutputType>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Executes Transact-SQL statement against a SQL Server database.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-SqlClientDataSet -ServerInstance MyServer -DatabaseName master -SqlCommandText "SELECT * FROM sys.tables;"
```

Gets data set from query.

### EXAMPLE 2
```powershell
$SqlConnection = Connect-SQLServerInstance -ServerInstance MyServer -DatabaseName master

Get-SqlClientDataSet -SqlConnection $SqlConnection -SqlCommandText "SELECT * FROM sys.tables;"
```

Gets data set from query using the specified connection.

## PARAMETERS

### -CommandTimeout
The length of time (in seconds) to wait for SQL command before terminating the attempt and throwing an exception.
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

### -CommandType
Specifies a value indicating how the CommandText property is to be interpreted.

```yaml
Type: CommandType
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Text
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Specifies the name of the database.

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

```yaml
Type: String
Parameter Sets: SqlConnection
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSetName
Specifies name of data set returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: NewDataSet
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataTableName
Specifies name of data table returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: NewDataTable
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputAs
Specifies output object type.

```yaml
Type: DataOutputType
Parameter Sets: (All)
Aliases:
Accepted values: DataSet, DataTable, DataRow

Required: False
Position: Named
Default value: DataTable
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutSqlParameter
Specifies reference parameter that will contain output SQL parameters.

```yaml
Type: System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlParameter]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name of a SQL Server instance.

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

### -SqlCommandText
Sets the Transact-SQL statement, table name or stored procedure to execute at the data source.

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

### -SqlConnection
Specifies SQL connection object.

```yaml
Type: SqlConnection
Parameter Sets: SqlConnection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlParameter
Specifies the SQL parameters of the Transact-SQL statement or stored procedure.

```yaml
Type: System.Collections.Generic.List`1[Microsoft.Data.SqlClient.SqlParameter]
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

### System.Data.DataSet

### System.Data.DataTable

### System.Data.DataRow

## NOTES

## RELATED LINKS
