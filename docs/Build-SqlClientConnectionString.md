---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Build-SqlClientConnectionString
---

# Build-SqlClientConnectionString

## SYNOPSIS

Builds connection strings for a SQL Server database.

## SYNTAX

### IntegratedSecurity (Default)

```
Build-SqlClientConnectionString
  -ServerInstance <string>
  -DatabaseName <string>
  [-FailoverPartnerServerInstance <string>]
  [-IntegratedSecurity <bool>]
  [-ConnectionTimeout <int>]
  [-CommandTimeout <int>]
  [-EncryptConnection <bool>]
  [-HostNameInCertificate <string>]
  [-IPAddressPreference <SqlConnectionIPAddressPreference>]
  [-TrustServerCertificate <bool>]
  [-MultipleActiveResultSets <bool>]
  [-PacketSize <int>]
  [-ApplicationName <string>]
  [-ApplicationIntent <ApplicationIntent>]
  [-MultiSubnetFailover <bool>]
  [-ConnectRetryCount <int>]
  [-ConnectRetryInterval <int>]
  [-MinPoolSize <int>]
  [-MaxPoolSize <int>]
  [-ConnectionLifetime <int>]
  [<CommonParameters>]
```

### WithCredential

```
Build-SqlClientConnectionString
  -ServerInstance <string>
  -DatabaseName <string>
  -Credential <pscredential>
  [-FailoverPartnerServerInstance <string>]
  [-ConnectionTimeout <int>]
  [-CommandTimeout <int>]
  [-EncryptConnection <bool>]
  [-HostNameInCertificate <string>]
  [-IPAddressPreference <SqlConnectionIPAddressPreference>]
  [-TrustServerCertificate <bool>]
  [-MultipleActiveResultSets <bool>]
  [-PacketSize <int>]
  [-ApplicationName <string>]
  [-ApplicationIntent <ApplicationIntent>]
  [-MultiSubnetFailover <bool>]
  [-ConnectRetryCount <int>]
  [-ConnectRetryInterval <int>]
  [-MinPoolSize <int>]
  [-MaxPoolSize <int>]
  [-ConnectionLifetime <int>]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Builds connection strings for a SQL Server database.

## EXAMPLES

### EXAMPLE 1

Build-SqlClientConnectionString -ServerInstance MyServer -DatabaseName master

Creates SQL Client connection string.

### EXAMPLE 2

Build-SqlClientConnectionString -ServerInstance MyServer -DatabaseName AdventureWorks -Credential $(Get-Credential)

Creates SQL Client connection string with credential.

## PARAMETERS

### -ApplicationIntent

Declares the application workload type when connecting to a database in an SQL Server Availability Group.

```yaml
Type: Microsoft.Data.SqlClient.ApplicationIntent
DefaultValue: ReadWrite
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

### -ApplicationName

Specifies the name of the application associated with the connection string.

```yaml
Type: System.String
DefaultValue: PowerShell SqlClient
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

### -CommandTimeout

The wait time (in seconds) before terminating the attempt to execute a command and generating an error.
The default is 30 seconds.

```yaml
Type: System.Int32
DefaultValue: 30
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

### -ConnectionLifetime

When a connection is returned to the pool, its creation time is compared with the current time, and the connection is destroyed if that time span (in seconds) exceeds the value specified by Connection Lifetime.

A value of zero (0) causes pooled connections to have the maximum connection timeout.

```yaml
Type: System.Int32
DefaultValue: 600
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

### -ConnectionTimeout

The length of time (in seconds) to wait for a connection to the server before terminating the attempt and throwing an exception.
Default is 15 seconds.

```yaml
Type: System.Int32
DefaultValue: 15
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

### -ConnectRetryCount

The number of reconnection attempted after identifying that there was an idle connection failure.

```yaml
Type: System.Int32
DefaultValue: 2
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

### -ConnectRetryInterval

Amount of time (in seconds) between each reconnection attempt after identifying that there was an idle connection failure.

```yaml
Type: System.Int32
DefaultValue: 10
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

Specifies the name of the database associated with the connection.

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

### -EncryptConnection

Boolean value that indicates whether SQL Server uses SSL encryption for all data sent between the client and server if the server has a certificate installed.

```yaml
Type: System.Boolean
DefaultValue: True
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

### -FailoverPartnerServerInstance

Specifies name or address of the partner server to connect to if the primary server is down.

```yaml
Type: System.String
DefaultValue: None
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

### -HostNameInCertificate

Specifies the host name to use when validating the server certificate for the connection.
When not specified, the server name from the Data Source is used for certificate validation.

```yaml
Type: System.String
DefaultValue: None
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

### -IntegratedSecurity

Indicates whether User ID and Password are specified in the connection (when false) or whether the current Windows account credentials are used for authentication (when true).

```yaml
Type: System.Boolean
DefaultValue: True
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: IntegratedSecurity
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IPAddressPreference

Specifies the IP address family preference when establishing TCP connections.

```yaml
Type: Microsoft.Data.SqlClient.SqlConnectionIPAddressPreference
DefaultValue: None
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

### -MaxPoolSize

The maximum number of connections that are allowed in the pool.

```yaml
Type: System.Int32
DefaultValue: 100
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

### -MinPoolSize

The minimum number of connections that are allowed in the pool.

Zero (0) in this field means no minimum connections are initially opened.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -MultipleActiveResultSets

Specifies that an application can maintain multiple active result sets (MARS).

```yaml
Type: System.Boolean
DefaultValue: None
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

### -MultiSubnetFailover

If your application is connecting to an AlwaysOn availability group (AG) on different subnets, setting MultiSubnetFailover=true provides faster detection of and connection to the (currently) active server.

```yaml
Type: System.Boolean
DefaultValue: False
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

### -PacketSize

Specifies the size in bytes of the network packets used to communicate with an instance of SQL Server.

```yaml
Type: System.Int32
DefaultValue: 8000
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

Specifies the name or network address of the instance of SQL Server to connect to.

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

### -TrustServerCertificate

Indicates whether the channel will be encrypted while bypassing walking the certificate chain to validate trust.

```yaml
Type: System.Boolean
DefaultValue: False
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String



## NOTES

The following connection string options are not implemented:

* AttachDBFilename

* AttestationProtocol

* Authentication

* ColumnEncryptionSetting

* CurrentLanguage

* EnclaveAttestationUrl

* Enlist

* FailoverPartnerSPN

* IsFixedSize

* PersistSecurityInfo

* PoolBlockingPeriod

* Pooling

* Replication

* ServerCertificate

* ServerSPN

* TransactionBinding

* TypeSystemVersion

* UserInstance


## RELATED LINKS

None.

