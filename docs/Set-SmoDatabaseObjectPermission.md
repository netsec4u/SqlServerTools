---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Set-SmoDatabaseObjectPermission

## SYNOPSIS
Set Database object permissions.

## SYNTAX

### DatabaseName (Default)
```
Set-SmoDatabaseObjectPermission
	-ServerInstance <String>
	-DatabaseName <String>
	-Permission <DatabaseObjectPermission>
	-ObjectClass <DatabaseObjectClass>
	-ObjectName <String>
	-Principal <String>
	-Action <PermissionAction>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseNameWithPermissionSet
```
Set-SmoDatabaseObjectPermission
	-ServerInstance <String>
	-DatabaseName <String>
	-ObjectClass <DatabaseObjectClass>
	-ObjectName <String>
	-PermissionSet <ObjectPermissionSet>
	-Principal <String>
	-Action <PermissionAction>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObjectWithPermissionSet
```
Set-SmoDatabaseObjectPermission
	-DatabaseObject <Database>
	-ObjectClass <DatabaseObjectClass>
	-ObjectName <String>
	-PermissionSet <ObjectPermissionSet>
	-Principal <String>
	-Action <PermissionAction>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Set-SmoDatabaseObjectPermission
	-DatabaseObject <Database>
	-Permission <DatabaseObjectPermission>
	-ObjectClass <DatabaseObjectClass>
	-ObjectName <String>
	-Principal <String>
	-Action <PermissionAction>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Grant, deny, or revoke database object permissions to user or role.

## EXAMPLES

### EXAMPLE 1
```powershell
Set-SmoDatabaseObjectPermission -ServerInstance MyServer -DatabaseName AdventureWorks -ObjectClass Schema -ObjectName dbo -Permission ALTER -Principal DBUser -Action Grant
```

Sets dbo Schema object permission within the AdventureWorks database.

### EXAMPLE 2
```powershell
$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()
[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::ALTER)

Set-SmoDatabaseObjectPermission -ServerInstance MyServer -DatabaseName AdventureWorks -ObjectClass Schema -ObjectName dbo -PermissionSet $PermissionSet -Principal DBUser -Action Grant
```

Sets dbo Schema object permission within the AdventureWorks database with the specified permission set.

### EXAMPLE 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Set-SmoDatabaseObjectPermission -DatabaseObject $DatabaseObject -ObjectClass Schema -ObjectName dbo -Permission ALTER -Principal DBUser -Action Grant
```

Sets dbo Schema object permission within using the SMO database object.

### EXAMPLE 4
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()
[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::ALTER)

Set-SmoDatabaseObjectPermission -DatabaseObject $DatabaseObject -ObjectClass Schema -ObjectName dbo -PermissionSet $PermissionSet -Principal DBUser -Action Grant
```

Sets dbo Schema object permission within using the SMO database object with specified permission set.

## PARAMETERS

### -Action
Action to perform.

```yaml
Type: PermissionAction
Parameter Sets: (All)
Aliases:
Accepted values: Grant, Deny, Revoke

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
Database Name.

```yaml
Type: String
Parameter Sets: DatabaseName, DatabaseNameWithPermissionSet
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
Parameter Sets: DatabaseObjectWithPermissionSet, DatabaseObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectClass
Database object class.

```yaml
Type: DatabaseObjectClass
Parameter Sets: (All)
Aliases:
Accepted values: Assembly, AsymmetricKey, Certificate, ExtendedStoredProcedure, Schema, StoredProcedure, Sequences, SymmetricKey, Synonym, Table, UserDefinedFunction, View

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectName
Database object name.

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

### -Permission
Permission to grant, deny, or revoke.

```yaml
Type: DatabaseObjectPermission
Parameter Sets: DatabaseName, DatabaseObject
Aliases:
Accepted values: Alter, Connect, Control, CreateSequence, Delete, Execute, Impersonate, Insert, Receive, References, Select, Send, TakeOwnership, Update, ViewChangeTracking, ViewDefinition

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PermissionSet
Set of permissions to grant, deny, or revoke.

```yaml
Type: ObjectPermissionSet
Parameter Sets: DatabaseNameWithPermissionSet, DatabaseObjectWithPermissionSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Principal
User or role name to grant, deny, or revoke permissions.

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

### -ServerInstance
SQL Server Instance Name.

```yaml
Type: String
Parameter Sets: DatabaseName, DatabaseNameWithPermissionSet
Aliases: SqlServer

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
