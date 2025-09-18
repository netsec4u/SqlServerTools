---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Connect-SmoServer
---

# Connect-SmoServer

## SYNOPSIS

Connect to SQL Server using SQL Management Object.

## SYNTAX

### SqlInstanceName (Default)

```
Connect-SmoServer
  -ServerInstance <string>
  [-DatabaseName <string>]
  [-ApplicationName <string>]
  [-ApplicationIntent <ApplicationIntent>]
  [-ConnectTimeout <int>]
  [-StatementTimeout <int>]
  [-EncryptConnection]
  [-StrictEncryption]
  [-TrustServerCertificate]
  [-NetworkProtocol <NetworkProtocol>]
  [<CommonParameters>]
```

### WithCredential

```
Connect-SmoServer
  -ServerInstance <string>
  -Credential <pscredential>
  [-DatabaseName <string>]
  [-AuthenticationMode <AuthenticationMode>]
  [-ApplicationName <string>]
  [-ApplicationIntent <ApplicationIntent>]
  [-ConnectTimeout <int>]
  [-StatementTimeout <int>]
  [-EncryptConnection]
  [-StrictEncryption]
  [-TrustServerCertificate]
  [-NetworkProtocol <NetworkProtocol>]
  [<CommonParameters>]
```

### SqlConnection

```
Connect-SmoServer
  -SqlConnection <SqlConnection>
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Connect to SQL Server using SQL Management Object.

## EXAMPLES

### EXAMPLE 1

Connect-SmoServer -ServerInstance MyServer -DatabaseName AdventureWorks

Connect ot SQL Management Objects in the context of the AdventureWorks database.

### EXAMPLE 2

Connect-SmoServer -ServerInstance MyServer -DatabaseName AdventureWorks -Credential $(Get-Credential)

Connect ot SQL Management Objects in the context of the AdventureWorks database with specified credentials.

### EXAMPLE 3

Connect-SmoServer -ServerInstance MyServer -DatabaseName AdventureWorks -AuthenticationMode AsUser -Credential $(Get-Credential)

Connect ot SQL Management Objects in the context of the AdventureWorks database with specified credentials.

## PARAMETERS

### -ApplicationIntent

The application intent of the connection.

```yaml
Type: ApplicationIntent
DefaultValue: ReadWrite
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ApplicationName

The name of the application.

```yaml
Type: System.String
DefaultValue: PowerShell SMO
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AuthenticationMode

Authentication method.

```yaml
Type: AuthenticationMode
DefaultValue: SQL
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ConnectTimeout

The length of time (in seconds) to wait for a connection to the server before terminating the attempt and throwing an exception.
Default is 15 seconds.

```yaml
Type: System.Int32
DefaultValue: 15
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Credential

Specifies a user account that has permission to perform this action.

```yaml
Type: System.Management.Automation.PSCredential
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatabaseName

Name of database.

```yaml
Type: System.String
DefaultValue: Master
SupportsWildcards: false
Aliases:
- Database
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EncryptConnection

Encrypt connection to SQL Server.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NetworkProtocol

Identifies the client network protocol that is used to connect to SQL Server.
If you do not specify a network and you use a local server, shared memory is used.
If you do not specify a network and you use a remote server, the one of the configured client protocols is used.

```yaml
Type: Microsoft.SqlServer.Management.Common.NetworkProtocol
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
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

SQL Server host name and instance name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SqlConnection

Use SqlConnection object to create connection.

```yaml
Type: Microsoft.Data.SqlClient.SqlConnection
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SqlConnection
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StatementTimeout

The number of seconds that a statement is attempted to be sent to the server before it fails.

```yaml
Type: System.Int32
DefaultValue: 600
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -StrictEncryption

Specifies to use strict encryption.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TrustServerCertificate

Specifies to trust server certificate.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WithCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SqlInstanceName
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

### System.String



### Microsoft.Data.SqlClient.SqlConnection



## OUTPUTS

### Microsoft.SqlServer.Management.Smo.Server



## NOTES




## RELATED LINKS

None.

