---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Connect-SqlServerInstance

## SYNOPSIS
Connect to SQL Instance.

## SYNTAX

### ServerInstance (Default)
```
Connect-SqlServerInstance
	-ServerInstance <String>
	-DatabaseName <String>
	[-ConnectionTimeout <Int32>]
	[-CommandTimeout <Int32>]
	[<CommonParameters>]
```

### WithCredential
```
Connect-SqlServerInstance
	-ServerInstance <String>
	-DatabaseName <String>
	[-AuthenticationMode <AuthenticationMode>]
	-Credential <PSCredential>
	[-ConnectionTimeout <Int32>]
	[-CommandTimeout <Int32>]
	[<CommonParameters>]
```

### ConnectionString
```
Connect-SqlServerInstance
	-ConnectionString <String>
	[<CommonParameters>]
```

## DESCRIPTION
Connect to SQL Instance.

## EXAMPLES

### EXAMPLE 1
```powershell
Connect-SQLServerInstance -ServerInstance MyServer -DatabaseName master
```

Connect to sql instance using SQL client.

## PARAMETERS

### -AuthenticationMode
Authentication method.

```yaml
Type: AuthenticationMode
Parameter Sets: WithCredential
Aliases:
Accepted values: AsUser, SQL

Required: False
Position: Named
Default value: SQL
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandTimeout
The wait time (in seconds) before terminating the attempt to execute a command and generating an error.

```yaml
Type: Int32
Parameter Sets: ServerInstance, WithCredential
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionString
Specifies connection string.

```yaml
Type: String
Parameter Sets: ConnectionString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionTimeout
The length of time (in seconds) to wait for a connection to the server before terminating the attempt and throwing an exception.

```yaml
Type: Int32
Parameter Sets: ServerInstance, WithCredential
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies a user account that has permission to perform this action.

```yaml
Type: PSCredential
Parameter Sets: WithCredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Specifies the name of the database.

```yaml
Type: String
Parameter Sets: ServerInstance, WithCredential
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
Parameter Sets: ServerInstance, WithCredential
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

### Microsoft.Data.SqlClient.SqlConnection

## NOTES

## RELATED LINKS
