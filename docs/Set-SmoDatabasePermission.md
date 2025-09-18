---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Set-SmoDatabasePermission
---

# Set-SmoDatabasePermission

## SYNOPSIS

Grant, deny, or revoke database permissions for user or role.

## SYNTAX

### DatabaseName (Default)

```
Set-SmoDatabasePermission
  -ServerInstance <string>
  -DatabaseName <string>
  -Permission <DatabasePermission>
  -Principal <string>
  -Action <PermissionAction>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseNameWithPermissionSet

```
Set-SmoDatabasePermission
  -ServerInstance <string>
  -DatabaseName <string>
  -PermissionSet <DatabasePermissionSet>
  -Principal <string>
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
  -Principal <string>
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
  -Principal <string>
  -Action <PermissionAction>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Grant, deny, or revoke database permissions for user or role.

## EXAMPLES

### EXAMPLE 1

Set-SmoDatabasePermission -ServerInstance MyServer -DatabaseName AdventureWorks -Permission ALTER -Principal DBUser -Action Grant

Sets database permission within AdventureWorks database to DBUSer.

### EXAMPLE 2

$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()
[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::ALTER)

Set-SmoDatabasePermission -ServerInstance MyServer -DatabaseName AdventureWorks -PermissionSet $PermissionSet -Principal DBUser -Action Grant

Sets database permission within AdventureWorks database to DBUSer using specified permission set.

### EXAMPLE 3

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Set-SmoDatabasePermission -DatabaseObject $DatabaseObject -Permission ALTER -Principal DBUser -Action Grant

Sets database permission using database object to DBUSer.

### EXAMPLE 4

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()
[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::ALTER)

Set-SmoDatabasePermission -DatabaseObject $DatabaseObject -PermissionSet $PermissionSet -Principal DBUser -Action Grant

Sets database permission using database object to DBUSer using specified permission set.

## PARAMETERS

### -Action

Action to perform.

```yaml
Type: PermissionAction
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatabaseName

Database Name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseNameWithPermissionSet
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatabaseObject

SMO database object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObjectWithPermissionSet
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Permission

Permission to grant, deny, or revoke.

```yaml
Type: DatabasePermission
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PermissionSet

Set of permissions to grant, deny, or revoke.

```yaml
Type: Microsoft.SqlServer.Management.Smo.DatabasePermissionSet
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObjectWithPermissionSet
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseNameWithPermissionSet
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Principal

User or role name to grant, deny, or revoke permissions.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServerInstance

SQL Server Instance Name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: DatabaseNameWithPermissionSet
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void



## NOTES




## RELATED LINKS

None.

