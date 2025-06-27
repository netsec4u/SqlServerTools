---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Invoke-SmoNonQuery

## SYNOPSIS
Invoke sql script.

## SYNTAX

### DatabaseName_CommandText (Default)
```
Invoke-SmoNonQuery
	-ServerInstance <String>
	-DatabaseName <String>
	-SqlCommandText <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseName_InputFile
```
Invoke-SmoNonQuery
	-ServerInstance <String>
	-DatabaseName <String>
	-InputFile <FileInfo>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject_InputFile
```
Invoke-SmoNonQuery
	-DatabaseObject <Database>
	-InputFile <FileInfo>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject_CommandText
```
Invoke-SmoNonQuery
	-DatabaseObject <Database>
	-SqlCommandText <String>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Invoke sql script.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-SmoNonQuery -ServerInstance MyServer -DatabaseName AdventureWorks -InputFile C:\files\script.sql
```

Execute SQL Script against AdventureWorks database.

### EXAMPLE 2
```powershell
Invoke-SmoNonQuery -ServerInstance MyServer -DatabaseName AdventureWorks -SqlCommandText "EXEC SPMyProcedure;"
```

Execute SQL statement against AdventureWorks database.

### EXAMPLE 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance MyServer -DatabaseName AdventureWorks

Invoke-SmoNonQuery -DatabaseObject $DatabaseObject -SqlCommandText "EXEC SPMyProcedure;"
```

Execute SQL statement against AdventureWorks database.

## PARAMETERS

### -DatabaseName
Name of database to to invoke script.

```yaml
Type: String
Parameter Sets: DatabaseName_CommandText, DatabaseName_InputFile
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
Parameter Sets: DatabaseObject_InputFile, DatabaseObject_CommandText
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputFile
Input script file.

```yaml
Type: FileInfo
Parameter Sets: DatabaseName_InputFile, DatabaseObject_InputFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
SQL Server host name and instance name

```yaml
Type: String
Parameter Sets: DatabaseName_CommandText, DatabaseName_InputFile
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
Parameter Sets: DatabaseName_CommandText, DatabaseObject_CommandText
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
