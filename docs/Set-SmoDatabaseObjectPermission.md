---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Set-SmoDatabaseObjectPermission
---

# Set-SmoDatabaseObjectPermission

## SYNOPSIS

Grant, deny, or revoke database object permissions to user or role.

## SYNTAX

### DatabaseName (Default)

```
Set-SmoDatabaseObjectPermission
  -ServerInstance <string>
  -DatabaseName <string>
  -Permission <DatabaseObjectPermission>
  -ObjectClass <DatabaseObjectClass>
  -ObjectName <string>
  -Principal <string>
  -Action <PermissionAction>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseNameWithPermissionSet

```
Set-SmoDatabaseObjectPermission
  -ServerInstance <string>
  -DatabaseName <string>
  -ObjectClass <DatabaseObjectClass>
  -ObjectName <string>
  -PermissionSet <ObjectPermissionSet>
  -Principal <string>
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
  -ObjectName <string>
  -PermissionSet <ObjectPermissionSet>
  -Principal <string>
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
  -ObjectName <string>
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

Grant, deny, or revoke database object permissions to user or role.

## EXAMPLES

### EXAMPLE 1

Set-SmoDatabaseObjectPermission -ServerInstance MyServer -DatabaseName AdventureWorks -ObjectClass Schema -ObjectName dbo -Permission ALTER -Principal DBUser -Action Grant

Sets dbo Schema object permission within the AdventureWorks database.

### EXAMPLE 2

$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()
[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::ALTER)

Set-SmoDatabaseObjectPermission -ServerInstance MyServer -DatabaseName AdventureWorks -ObjectClass Schema -ObjectName dbo -PermissionSet $PermissionSet -Principal DBUser -Action Grant

Sets dbo Schema object permission within the AdventureWorks database with the specified permission set.

### EXAMPLE 3

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Set-SmoDatabaseObjectPermission -DatabaseObject $DatabaseObject -ObjectClass Schema -ObjectName dbo -Permission ALTER -Principal DBUser -Action Grant

Sets dbo Schema object permission within using the SMO database object.

### EXAMPLE 4

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks
$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()
[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::ALTER)

Set-SmoDatabaseObjectPermission -DatabaseObject $DatabaseObject -ObjectClass Schema -ObjectName dbo -PermissionSet $PermissionSet -Principal DBUser -Action Grant

Sets dbo Schema object permission within using the SMO database object with specified permission set.

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

### -ObjectClass

Database object class.

```yaml
Type: DatabaseObjectClass
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

### -ObjectName

Database object name.

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

### -Permission

Permission to grant, deny, or revoke.

```yaml
Type: DatabaseObjectPermission
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
Type: Microsoft.SqlServer.Management.Smo.ObjectPermissionSet
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

