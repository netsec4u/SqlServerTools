---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Build-SqlClientConnectionString

## SYNOPSIS
Builds connection strings for a SQL Server database.

## SYNTAX

### IntegratedSecurity (Default)
```
Build-SqlClientConnectionString
	-ServerInstance <String>
	[-FailoverPartnerServerInstance <String>]
	-DatabaseName <String>
	[-IntegratedSecurity <Boolean>]
	[-ConnectionTimeout <Int32>]
	[-CommandTimeout <Int32>]
	[-EncryptConnection <Boolean>]
	[-HostNameInCertificate <String>]
	[-IPAddressPreference <SqlConnectionIPAddressPreference>]
	[-MultipleActiveResultSets <Boolean>]
	[-TrustServerCertificate <Boolean>]
	[-PacketSize <Int32>]
	[-ApplicationName <String>]
	[-ApplicationIntent <ApplicationIntent>]
	[-MultiSubnetFailover <Boolean>]
	[-ConnectRetryCount <Int32>]
	[-ConnectRetryInterval <Int32>]
	[<CommonParameters>]
```

### WithCredential
```
Build-SqlClientConnectionString
	-ServerInstance <String>
	[-FailoverPartnerServerInstance <String>]
	-DatabaseName <String>
	-Credential <PSCredential>
	[-ConnectionTimeout <Int32>]
	[-CommandTimeout <Int32>]
	[-EncryptConnection <Boolean>]
	[-HostNameInCertificate <String>]
	[-IPAddressPreference <SqlConnectionIPAddressPreference>]
	[-MultipleActiveResultSets <Boolean>]
	[-TrustServerCertificate <Boolean>]
	[-PacketSize <Int32>]
	[-ApplicationName <String>]
	[-ApplicationIntent <ApplicationIntent>]
	[-MultiSubnetFailover <Boolean>]
	[-ConnectRetryCount <Int32>]
	[-ConnectRetryInterval <Int32>]
	[<CommonParameters>]
```

## DESCRIPTION
Builds connection strings for a SQL Server database.

## EXAMPLES

### EXAMPLE 1
```powershell
Build-SqlClientConnectionString -ServerInstance MyServer -DatabaseName master
```

Creates SQL Client connection string.

### EXAMPLE 2
```powershell
Build-SqlClientConnectionString -ServerInstance MyServer -DatabaseName AdventureWorks -Credential $(Get-Credential)
```

Creates SQL Client connection string with credential.

## PARAMETERS

### -ApplicationIntent
Declares the application workload type when connecting to a database in an SQL Server Availability Group.

```yaml
Type: ApplicationIntent
Parameter Sets: (All)
Aliases:
Accepted values: ReadWrite, ReadOnly

Required: False
Position: Named
Default value: ReadWrite
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationName
Specifies the name of the application associated with the connection string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: PowerShell SqlClient
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandTimeout
The wait time (in seconds) before terminating the attempt to execute a command and generating an error.
The default is 30 seconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionTimeout
The length of time (in seconds) to wait for a connection to the server before terminating the attempt and throwing an exception.
Default is 15 seconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectRetryCount
The number of reconnection attempted after identifying that there was an idle connection failure.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectRetryInterval
Amount of time (in seconds) between each reconnection attempt after identifying that there was an idle connection failure.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 10
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
Specifies the name of the database associated with the connection.

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

### -EncryptConnection
Boolean value that indicates whether SQL Server uses SSL encryption for all data sent between the client and server if the server has a certificate installed.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailoverPartnerServerInstance
Specifies name or address of the partner server to connect to if the primary server is down.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostNameInCertificate
Specifies the host name to use when validating the server certificate for the connection. When not specified, the server name from the Data Source is used for certificate validation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntegratedSecurity
Indicates whether User ID and Password are specified in the connection (when false) or whether the current Windows account credentials are used for authentication (when true).

```yaml
Type: Boolean
Parameter Sets: IntegratedSecurity
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPAddressPreference
Specifies the IP address family preference when establishing TCP connections.

```yaml
Type: SqlConnectionIPAddressPreference
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MultipleActiveResultSets
Specifies that an application can maintain multiple active result sets (MARS).

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MultiSubnetFailover
If your application is connecting to an AlwaysOn availability group (AG) on different subnets, setting MultiSubnetFailover=true provides faster detection of and connection to the (currently) active server.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PacketSize
Specifies the size in bytes of the network packets used to communicate with an instance of SQL Server.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 8000
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Specifies the name or network address of the instance of SQL Server to connect to.

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

### -TrustServerCertificate
Indicates whether the channel will be encrypted while bypassing walking the certificate chain to validate trust.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

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
* LoadBalanceTimeout
* MaxPoolSize
* MinPoolSize
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
