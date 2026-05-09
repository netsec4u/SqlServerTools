---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: https://github.com/netsec4u/SqlServerTools/blob/main/docs/Set-SmoDatabaseQueryStore.md
Locale: en-US
Module Name: SqlServerTools
ms.date: 05/07/2026
PlatyPS schema version: 2024-05-01
title: Set-SmoDatabaseQueryStore
---

# Set-SmoDatabaseQueryStore

## SYNOPSIS

Sets query store properties.

## SYNTAX

### DatabaseName (Default)

```
Set-SmoDatabaseQueryStore
  -ServerInstance <string>
  -DatabaseName <string>
  [-QueryStoreOperationMode <QueryStoreOperationMode>]
  [-QueryCaptureMode <QueryStoreCaptureMode>]
  [-MaxPlansPerQuery <int>]
  [-MaxStorageSizeInMB <int>]
  [-StaleQueryThresholdInDays <int>]
  [-SizeBasedCleanupMode <QueryStoreSizeBasedCleanupMode>]
  [-StatisticsCollectionIntervalInMinutes <int>]
  [-DataFlushIntervalInSeconds <int>]
  [-WaitStatsCaptureMode <QueryStoreWaitStatsCaptureMode>]
  [-CapturePolicyStaleThresholdInHrs <int>]
  [-CapturePolicyExecutionCount <int>]
  [-CapturePolicyTotalCompileCpuTimeInMS <int>]
  [-CapturePolicyTotalExecutionCpuTimeInMS <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Set-SmoDatabaseQueryStore
  -DatabaseObject <Database>
  [-QueryStoreOperationMode <QueryStoreOperationMode>]
  [-QueryCaptureMode <QueryStoreCaptureMode>]
  [-MaxPlansPerQuery <int>]
  [-MaxStorageSizeInMB <int>]
  [-StaleQueryThresholdInDays <int>]
  [-SizeBasedCleanupMode <QueryStoreSizeBasedCleanupMode>]
  [-StatisticsCollectionIntervalInMinutes <int>]
  [-DataFlushIntervalInSeconds <int>]
  [-WaitStatsCaptureMode <QueryStoreWaitStatsCaptureMode>]
  [-CapturePolicyStaleThresholdInHrs <int>]
  [-CapturePolicyExecutionCount <int>]
  [-CapturePolicyTotalCompileCpuTimeInMS <int>]
  [-CapturePolicyTotalExecutionCpuTimeInMS <int>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Sets query store properties.

## EXAMPLES

### Example 1

```PowerShell
Set-SmoDatabaseQueryStore -ServerInstance 'localhost' -DatabaseName 'AdventureWorks' -MaxStorageSizeInMB 4096
```

Sets the query store property MaxStorageSizeInMB in the AdventureWorks database on the local host.

### Example 2

```PowerShell
$DatabaseObject = Get-SmoDatabase -ServerInstance 'localhost' -DatabaseName 'AdventureWorks'
Set-SmoDatabaseQueryStore -DatabaseObject $DatabaseObject -MaxStorageSizeInMB 4096
```

Sets the query store property MaxStorageSizeInMB in the AdventureWorks database using the database object.

## PARAMETERS

### -CapturePolicyExecutionCount

Defines the number of times a query is executed over the evaluation period.  Requires capture mode to be Custom.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -CapturePolicyStaleThresholdInHrs

Defines the evaluation interval period to determine if a query should be captured.  Requires capture mode to be Custom.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -CapturePolicyTotalCompileCpuTimeInMS

Defines total elapsed compile CPU time used by a query over the evaluation period.  Requires capture mode to be Custom.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -CapturePolicyTotalExecutionCpuTimeInMS

Defines total elapsed execution CPU time used by a query over the evaluation period.  Requires capture mode to be Custom.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

The name of the database for which to set the query store properties.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
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

The database object for which to set the query store properties.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
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

### -DataFlushIntervalInSeconds

Specifies the frequency at which data written to the Query Store is persisted to disk.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -MaxPlansPerQuery

Defines the maximum number of plans maintained for each query.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -MaxStorageSizeInMB

Specifies the space issued to the Query Store.  Requires SizeBasedCleanupMode to be set to Auto.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -QueryCaptureMode

Designates the currently active query capture mode.

```yaml
Type: Microsoft.SqlServer.Management.Smo.QueryStoreCaptureMode
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -QueryStoreOperationMode

Specifies the operation mode of the Query Store.

```yaml
Type: Microsoft.SqlServer.Management.Smo.QueryStoreOperationMode
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -ServerInstance

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
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

### -SizeBasedCleanupMode

Controls whether cleanup automatically activates when the total amount of data gets close to maximum size.

```yaml
Type: Microsoft.SqlServer.Management.Smo.QueryStoreSizeBasedCleanupMode
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -StaleQueryThresholdInDays

Defines the evaluation interval period to determine if a query should be captured.  Requires capture mode to be Custom.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -StatisticsCollectionIntervalInMinutes

Specifies the number of minutes for which the information for a query is kept in the Query Store.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -WaitStatsCaptureMode

Controls whether wait statistics are captured per query.

```yaml
Type: Microsoft.SqlServer.Management.Smo.QueryStoreWaitStatsCaptureMode
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

