---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Publish-SqlDatabaseDacPac

## SYNOPSIS
Publish DacPac to SQL Server.

## SYNTAX

### ServerInstance (Default)
```
Publish-SqlDatabaseDacPac
	-ServerInstance <String>
	-DatabaseName <String>
	-DacPacPath <FileInfo>
	[-DeployOptions <DacDeployOptions>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### SqlConnectionString
```
Publish-SqlDatabaseDacPac
	-ConnectionString <String>
	-DacPacPath <FileInfo>
	[-DeployOptions <DacDeployOptions>]
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Publish DacPac to SQL Server.

## EXAMPLES

### EXAMPLE 1
```powershell
Publish-SqlDatabaseDacPac -ServerInstance MyServer -DatabaseName AdventureWorks -DacPacPath C:\Database.dacpac
```

Publishes DacPac to AdventureWorks.

### EXAMPLE 2
```powershell
$ConnectionString = 'Data Source=.;Initial Catalog=AdventureWorks;Integrated Security=True;'

Publish-SqlDatabaseDacPac -ConnectionString $ConnectionString -DacPacPath C:\Database.dacpac
```

Publishes DacPac to AdventureWorks.

### EXAMPLE 3
```powershell
Publish-SqlDatabaseDacPac -ServerInstance MyServer -DatabaseName AdventureWorks -Credential $(Get-Credential) -DacPacPath C:\Database.dacpac
```

Publishes DacPac to AdventureWorks using credential.

## PARAMETERS

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

### -DacPacPath
Path to DacPac file.

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

### -DeployOptions
Defines options that affect the behavior of package deployment to a database.

```yaml
Type: DacDeployOptions
Parameter Sets: (All)
Aliases:

Required: False
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
NetworkLibrary not yet implemented.

## RELATED LINKS
