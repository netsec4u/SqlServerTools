---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Set-SmoDatabasePermission

## SYNOPSIS
Set Database permissions.

## SYNTAX

### DatabaseName (Default)
```
Set-SmoDatabasePermission
	-ServerInstance <String>
	-DatabaseName <String>
	-Permission <DatabasePermission>
	-Principal <String>
	-Action <PermissionAction>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseNameWithPermissionSet
```
Set-SmoDatabasePermission
	-ServerInstance <String>
	-DatabaseName <String>
	-PermissionSet <DatabasePermissionSet>
	-Principal <String>
	-Action <PermissionAction>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObjectWithPermissionSet
```
Set-SmoDatabasePermission
	-DatabaseObject <Database>
	-PermissionSet <DatabasePermissionSet>
	-Principal <String>
	-Action <PermissionAction>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

### DatabaseObject
```
Set-SmoDatabasePermission
	-DatabaseObject <Database>
	-Permission <DatabasePermission>
	-Principal <String>
	-Action <PermissionAction>
	[-WhatIf]
	[-Confirm]
	[<CommonParameters>]
```

## DESCRIPTION
Grant, deny, or revoke database permissions for user or role.

## EXAMPLES

### EXAMPLE 1
```powershell
Set-SmoDatabasePermission -ServerInstance MyServer -DatabaseName AdventureWorks -Permission ALTER -Principal DBUser -Action Grant
```

Sets database permission within AdventureWorks database to DBUSer.

### EXAMPLE 2
```powershell
$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()
[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::ALTER)

Set-SmoDatabasePermission -ServerInstance MyServer -DatabaseName AdventureWorks -PermissionSet $PermissionSet -Principal DBUser -Action Grant
```

Sets database permission within AdventureWorks database to DBUSer using specified permission set.

### EXAMPLE 3
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Set-SmoDatabasePermission -DatabaseObject $DatabaseObject -Permission ALTER -Principal DBUser -Action Grant
```

Sets database permission using database object to DBUSer.

### EXAMPLE 4
```powershell
$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()
[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::ALTER)

Set-SmoDatabasePermission -DatabaseObject $DatabaseObject -PermissionSet $PermissionSet -Principal DBUser -Action Grant
```

Sets database permission using database object to DBUSer using specified permission set.

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
Database SMO Object.

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

### -Permission
Permission to grant, deny, or revoke.

```yaml
Type: DatabasePermission
Parameter Sets: DatabaseName, DatabaseObject
Aliases:
Accepted values: Alter, AlterAnyApplicationRole, AlterAnyAssembly, AlterAnyAsymmetricKey, AlterAnyCertificate, AlterAnyContract, AlterAnyDatabaseAudit, AlterAnyDatabaseDdlTrigger, AlterAnyDatabaseEventNotification, AlterAnyDataSpace, AlterAnyExternalDataSource, AlterAnyExternalFileFormat, AlterAnyFullTextCatalog, AlterAnyMask, AlterAnyMessageType, AlterAnyRemoteServiceBinding, AlterAnyRole, AlterAnyRoute, AlterAnySchema, AlterAnySecurityPolicy, AlterAnyService, AlterAnySymmetricKey, AlterAnyUser, Authenticate, BackupDatabase, BackupLog, Checkpoint, Connect, ConnectReplication, Control, CreateAggregate, CreateAssembly, CreateAsymmetricKey, CreateCertificate, CreateContract, CreateDatabase, CreateDatabaseDdlEventNotification, CreateDefault, CreateFullTextCatalog, CreateFunction, CreateMessageType, CreateProcedure, CreateQueue, CreateRemoteServiceBinding, CreateRole, CreateRoute, CreateRule, CreateSchema, CreateService, CreateSymmetricKey, CreateSynonym, CreateTable, CreateType, CreateView, CreateXmlSchemaCollection, Delete, Execute, Insert, References, Select, ShowPlan, SubscribeQueryNotifications, TakeOwnership, Unmask, Update, ViewDatabaseState, ViewDefinition

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PermissionSet
Set of permissions to grant, deny, or revoke.

```yaml
Type: DatabasePermissionSet
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
