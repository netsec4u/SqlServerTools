---
external help file: SqlServerTools-help.xml
Module Name: SqlServerTools
online version:
schema: 2.0.0
---

# Connect-SmoServer

## SYNOPSIS
Connect to SQL Server.

## SYNTAX

### SqlInstanceName (Default)
```
Connect-SmoServer
	-ServerInstance <String>
	[-DatabaseName <String>]
	[-ApplicationName <String>]
	[-ApplicationIntent <ApplicationIntent>]
	[-ConnectTimeout <Int32>]
	[-StatementTimeout <Int32>]
	[-EncryptConnection] [-StrictEncryption]
	[-TrustServerCertificate]
	[-NetworkProtocol <NetworkProtocol>]
	[<CommonParameters>]
```

### WithCredential
```
Connect-SmoServer
	-ServerInstance <String>
	[-DatabaseName <String>]
	[-AuthenticationMode <AuthenticationMode>]
	-Credential <PSCredential>
	[-ApplicationName <String>]
	[-ApplicationIntent <ApplicationIntent>]
	[-ConnectTimeout <Int32>]
	[-StatementTimeout <Int32>]
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

## DESCRIPTION
Connect to SQL Server using SQL Management Object.

## EXAMPLES

### EXAMPLE 1
```powershell
Connect-SmoServer -ServerInstance MyServer -DatabaseName AdventureWorks
```

Connect ot SQL Management Objects in the context of the AdventureWorks database.

### EXAMPLE 2
```powershell
Connect-SmoServer -ServerInstance MyServer -DatabaseName AdventureWorks -Credential $(Get-Credential)
```

Connect ot SQL Management Objects in the context of the AdventureWorks database with specified credentials.

### EXAMPLE 3
```powershell
Connect-SmoServer -ServerInstance MyServer -DatabaseName AdventureWorks -AuthenticationMode AsUser -Credential $(Get-Credential)
```

Connect ot SQL Management Objects in the context of the AdventureWorks database with specified credentials.

## PARAMETERS

### -ApplicationIntent
The application intent of the connection.

```yaml
Type: ApplicationIntent
Parameter Sets: SqlInstanceName, WithCredential
Aliases:
Accepted values: ReadWrite, ReadOnly

Required: False
Position: Named
Default value: ReadWrite
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationName
The name of the application.

```yaml
Type: String
Parameter Sets: SqlInstanceName, WithCredential
Aliases:

Required: False
Position: Named
Default value: PowerShell SMO
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -ConnectTimeout
The length of time (in seconds) to wait for a connection to the server before terminating the attempt and throwing an exception.
Default is 15 seconds.

```yaml
Type: Int32
Parameter Sets: SqlInstanceName, WithCredential
Aliases:

Required: False
Position: Named
Default value: 15
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
Name of database.

```yaml
Type: String
Parameter Sets: SqlInstanceName, WithCredential
Aliases: Database

Required: False
Position: Named
Default value: Master
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptConnection
Encrypt connection to SQL Server.

```yaml
Type: SwitchParameter
Parameter Sets: SqlInstanceName, WithCredential
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkProtocol
Identifies the client network protocol that is used to connect to SQL Server.
If you do not specify a network and you use a local server, shared memory is used.
If you do not specify a network and you use a remote server, the one of the configured client protocols is used.

```yaml
Type: NetworkProtocol
Parameter Sets: SqlInstanceName, WithCredential
Aliases:
Accepted values: TcpIp, NamedPipes, Multiprotocol, AppleTalk, BanyanVines, Via, SharedMemory, NWLinkIpxSpx, NotSpecified

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
Parameter Sets: SqlInstanceName, WithCredential
Aliases: SqlServer

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SqlConnection
Use SqlConnection object to create connection.

```yaml
Type: SqlConnection
Parameter Sets: SqlConnection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -StatementTimeout
The number of seconds that a statement is attempted to be sent to the server before it fails.

```yaml
Type: Int32
Parameter Sets: SqlInstanceName, WithCredential
Aliases:

Required: False
Position: Named
Default value: 600
Accept pipeline input: False
Accept wildcard characters: False
```

### -StrictEncryption
Specifies to use strict encryption.

```yaml
Type: SwitchParameter
Parameter Sets: SqlInstanceName, WithCredential
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TrustServerCertificate
Specifies to trust server certificate.

```yaml
Type: SwitchParameter
Parameter Sets: SqlInstanceName, WithCredential
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

### System.String

### Microsoft.Data.SqlClient.SqlConnection

## OUTPUTS

### Microsoft.SqlServer.Management.Smo.Server

## NOTES

## RELATED LINKS
