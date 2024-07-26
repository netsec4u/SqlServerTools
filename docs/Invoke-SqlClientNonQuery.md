---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Invoke-SqlClientNonQuery

## SYNOPSIS
Executes stored procedure to execute against a SQL Server database.

## SYNTAX

### DatabaseName (Default)
```
Invoke-SqlClientNonQuery
	-ServerInstance <String>
	-DatabaseName <String>
	-SqlCommandText <String>
	[-CommandTimeout <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SqlConnection
```
Invoke-SqlClientNonQuery
	-SqlConnection <SqlConnection>
	-SqlCommandText <String>
	[-CommandTimeout <Int32>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Executes stored procedure to execute against a SQL Server database.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SqlClientNonQuery -ServerInstance MyServer -DatabaseName AdventureWorks -SqlCommandText "EXEC SPMyProcedure;"
```

Execute SQL statement against AdventureWorks database.

### EXAMPLE 2
```powershell
$SqlConnection = Connect-SQLServerInstance -ServerInstance MyServer -DatabaseName master

Invoke-SqlClientNonQuery -SqlConnection $SqlConnection -SqlCommandText "EXEC SPMyProcedure;"
```

Execute SQL statement against AdventureWorks database.

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

### System.Boolean

## NOTES

## RELATED LINKS
