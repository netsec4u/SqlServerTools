Set-StrictMode -Version Latest

#Region Enumerations
enum ApplicationIntent {
	ReadWrite
	ReadOnly
}

enum AuthenticationMode {
	AsUser
	SQL
}

enum DatabaseObjectClass {
	Assembly
	AsymmetricKey
	Certificate
	ExtendedStoredProcedure
	Schema
	StoredProcedure
	Sequences
	SymmetricKey
	Synonym
	Table
	UserDefinedFunction
	View
}

enum DatabaseObjectPermission {
	Alter
	Connect
	Control
	CreateSequence
	Delete
	Execute
	Impersonate
	Insert
	Receive
	References
	Select
	Send
	TakeOwnership
	Update
	ViewChangeTracking
	ViewDefinition
}

enum DatabasePermission {
	Alter
	AlterAnyApplicationRole
	AlterAnyAssembly
	AlterAnyAsymmetricKey
	AlterAnyCertificate
	AlterAnyContract
	AlterAnyDatabaseAudit
	AlterAnyDatabaseDdlTrigger
	AlterAnyDatabaseEventNotification
	AlterAnyDataSpace
	AlterAnyExternalDataSource
	AlterAnyExternalFileFormat
	AlterAnyFullTextCatalog
	AlterAnyMask
	AlterAnyMessageType
	AlterAnyRemoteServiceBinding
	AlterAnyRole
	AlterAnyRoute
	AlterAnySchema
	AlterAnySecurityPolicy
	AlterAnyService
	AlterAnySymmetricKey
	AlterAnyUser
	Authenticate
	BackupDatabase
	BackupLog
	Checkpoint
	Connect
	ConnectReplication
	Control
	CreateAggregate
	CreateAssembly
	CreateAsymmetricKey
	CreateCertificate
	CreateContract
	CreateDatabase
	CreateDatabaseDdlEventNotification
	CreateDefault
	CreateFullTextCatalog
	CreateFunction
	CreateMessageType
	CreateProcedure
	CreateQueue
	CreateRemoteServiceBinding
	CreateRole
	CreateRoute
	CreateRule
	CreateSchema
	CreateService
	CreateSymmetricKey
	CreateSynonym
	CreateTable
	CreateType
	CreateView
	CreateXmlSchemaCollection
	Delete
	Execute
	Insert
	References
	Select
	ShowPlan
	SubscribeQueryNotifications
	TakeOwnership
	Unmask
	Update
	ViewDatabaseState
	ViewDefinition
}

enum DataOutputType {
	DataSet
	DataTable
	DataRow
	None
}

enum PermissionAction {
	Grant
	Deny
	Revoke
}

<#
Scriptable Database Objects
	DatabaseScopedCredentials
	ExtendedStoredProcedures
	ExternalDataSources
	ExternalFileFormats
	ExternalLibraries
	SearchPropertyLists
	SensitivityClassifications
#>

enum ScriptableDatabaseObjectClass {
	ApplicationRole
	DatabaseAuditSpecification
	Default
	FullTextStopList
	FullTextCatalog
	PartitionFunction
	PartitionScheme
	PlanGuide
	Role
	Rule
	Schema
	SecurityPolicy
	Sequence
	StoredProcedure
	SqlAssembly
	SymmetricKey
	Synonym
	Table
	Trigger
	UserDefinedAggregate
	UserDefinedDataType
	UserDefinedFunction
	UserDefinedTableType
	UserDefinedType
	User
	View
	XmlSchemaCollection
}

enum ScriptableServerObjectClass {
	Audit
	BackupDevice
	Credential
	CryptographicProvider
	LinkedServer
	Login
	Role
	ServerAuditSpecification
	Trigger
	UserDefinedMessage
}
#EndRegion

#Region Classes
class TransformPath : System.Management.Automation.ArgumentTransformationAttribute {
	[object]Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object]$InputData) {
		if ([System.IO.Path]::IsPathRooted($InputData)) {
			return $InputData
		} else {
			return [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PWD.Path, $InputData))
		}

		throw [System.InvalidOperationException]::New('Unexpected error.')
	}
}

class TransformSidByteArray : System.Management.Automation.ArgumentTransformationAttribute {
	[object]Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object]$InputData) {
		if ($InputData -is [byte[]]) {
			return $InputData
		} elseif ($InputData -is [string]) {
			$SidArray = $InputData -replace '^0x', '' -split '(?<=\G\w{2})(?=\w{2})'

			$ByteArray = $SidArray | ForEach-Object { [Convert]::ToByte( $_, 16 ) }

			return $ByteArray
		}

		throw [System.InvalidOperationException]::New('Unexpected error.')
	}
}

class ValidatePathExists : System.Management.Automation.ValidateArgumentsAttribute {
	[string]$PathType = 'Any'

	ValidatePathExists([string]$PathType) {
		$this.PathType = $PathType
	}

	[void]Validate([object]$Path, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
		if([string]::IsNullOrWhiteSpace($Path)) {
			throw [System.ArgumentNullException]::New()
		}

		if(-not (Test-Path -Path $Path -PathType $this.PathType)) {
			switch ($this.PathType) {
				'Container' {
					throw [System.IO.DirectoryNotFoundException]::New()
				}
				'Leaf' {
					throw [System.IO.FileNotFoundException]::New()
				}
				Default {
					throw [System.InvalidOperationException]::New('An unexpected error has occurred.')
				}
			}
		}
	}
}

class ValidatePassword : System.Management.Automation.ValidateArgumentsAttribute {
	[void]Validate([object]$SecureString, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
		if ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)) -notmatch '(?-i)(?=.{12,})((?=.*\d)(?=.*[a-z])(?=.*[A-Z])|(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])|(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])).*') {
			throw [System.Management.Automation.ErrorRecord]::New(
				[System.ArgumentException]::New('Password does not meet complexity requirements.'),
				'1',
				[System.Management.Automation.ErrorCategory]::InvalidArgument,
				$SecureString
			)
		}
	}
}

class ValidatePathIsValid : System.Management.Automation.ValidateArgumentsAttribute {
	[void]Validate([object]$Path, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
		if([string]::IsNullOrWhiteSpace($Path)) {
			throw [System.ArgumentNullException]::New()
		}

		if ($Path -is [System.IO.DirectoryInfo]) {
			if (-not $(Test-Path -LiteralPath $Path.Parent -PathType Container)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New("Cannot find path '$Path.Directory' because it does not exist."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$Path
				)
			} elseif (-not $(Test-Path -LiteralPath $Path -PathType Container -IsValid)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New("The path '$Path.Name' is not valid."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$Path
				)
			}
		}

		if ($Path -is [System.IO.FileInfo]) {
			if (-not $(Test-Path -LiteralPath $Path.Directory -PathType Container)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New("Cannot find path '$Path.Directory' because it does not exist."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$Path
				)
			} elseif (-not $(Test-Path -LiteralPath $Path -PathType Leaf -IsValid)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New("The path '$Path.Name' is not valid."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$Path
				)
			}
		}
	}
}
#EndRegion

#Region Type Definitions
$TypeDefinition = @'
using System;
namespace SmoRestore
{
	public class BackupHeader
	{
		private Int16 _DeviceType;
		private string _DeviceTypeDescription = null;

		public string BackupName;
		public string BackupDescription;
		public Int16 BackupType;
		public string BackupTypeDescription;
		public DateTime ExpirationDate;
		public bool Compressed;
		public Int16 Position;
		public Int16 DeviceType
		{
			get
			{
				return _DeviceType;
			}
			set
			{
				_DeviceType = value;

				switch (value)
				{
					case 0:
						_DeviceTypeDescription = null;
						break;
					case 2:
						_DeviceTypeDescription = "Logical Disk";
						break;
					case 102:
						_DeviceTypeDescription = "Physical Disk";
						break;
					case 5:
						_DeviceTypeDescription = "Logical Tape";
						break;
					case 105:
						_DeviceTypeDescription = "Physical Tape";
						break;
					case 7:
						_DeviceTypeDescription = "Logical Virtual Device";
						break;
					case 107:
						_DeviceTypeDescription = "Physical Virtual Device";
						break;
					case 9:
						_DeviceTypeDescription = "Logical URL";
						break;
					case 109:
						_DeviceTypeDescription = "Physical URL";
						break;
					default:
						throw new InvalidOperationException("Unknown device type.");
				}
			}
		}
		public string DeviceTypeDescription
		{
			get
			{
				return _DeviceTypeDescription;
			}
		}
		public string UserName;
		public string ServerName;
		public string DatabaseName;
		public int DatabaseVersion;
		public DateTime DatabaseCreationDate;
		public decimal BackupSize;
		public decimal FirstLSN;
		public decimal LastLSN;
		public decimal CheckpointLSN;
		public decimal DatabaseBackupLSN;
		public DateTime BackupStartDate;
		public DateTime BackupFinishDate;
		public Int16 SortOrder;
		public Int16 CodePage;
		public int UnicodeLocaleId;
		public int UnicodeComparisonStyle;
		public byte CompatibilityLevel;
		public int SoftwareVendorId;
		public int SoftwareVersionMajor;
		public int SoftwareVersionMinor;
		public int SoftwareVersionBuild;
		public string MachineName;
		public int Flags;
		public Guid BindingID;
		public Guid RecoveryForkID;
		public string Collation;
		public Guid FamilyGUID;
		public bool HasBulkLoggedData;
		public bool IsSnapshot;
		public bool IsReadOnly;
		public bool IsSingleUser;
		public bool HasBackupChecksums;
		public bool IsDamaged;
		public bool BeginsLogChain;
		public bool HasIncompleteMetaData;
		public bool IsForceOffline;
		public bool IsCopyOnly;
		public Guid FirstRecoveryForkID;
		public decimal? ForkPointLSN;
		public string RecoveryModel;
		public decimal? DifferentialBaseLSN;
		public Guid? DifferentialBaseGUID;
		public Guid BackupSetGUID;
		public Int64 CompressedBackupSize;
		public Int16 containment;
		public string KeyAlgorithm;
		public Byte[] EncryptorThumbprint;
		public string EncryptorType;
		public DateTime? LastValidRestoreTime;
		public Int16 TimeZone;
		public string CompressionAlgorithm;
	}

	public class FileList
	{
		public string LogicalName;
		public string PhysicalName;
		public string Type;
		public string FileGroupName;
		public decimal Size;
		public decimal MaxSize;
		public Int64 FileId;
		public decimal CreateLSN;
		public decimal DropLSN;
		public Guid UniqueId;
		public decimal ReadOnlyLSN;
		public decimal ReadWriteLSN;
		public Int64 BackupSizeInBytes;
		public int SourceBlockSize;
		public int FileGroupId;
		public Guid? LogGroupGUID;
		public decimal DifferentialBaseLSN;
		public Guid DifferentialBaseGUID;
		public bool IsReadOnly;
		public bool IsPresent;
		public Byte[] TDEThumbprint;
		public string SnapshotUrl;
	}
}
'@

Add-Type -TypeDefinition $TypeDefinition

$TypeDefinition = @'
using System;
namespace SqlClient
{
	public class DataSetResult
	{
		public int UnchangedRows;
		public int InsertedRows;
		public int UpdatedRows;
		public int DeletedRows;
		public int Errors;
	}
}
'@

Add-Type -TypeDefinition $TypeDefinition

Remove-Variable -Name TypeDefinition
#EndRegion


#Region Supporting Functions
function Format-SqlInstanceName {
	<#
	.SYNOPSIS
	Formats sql instance name.
	.DESCRIPTION
	Formats sql instance name.
	.PARAMETER ServerInstance
	SQL Server host name and instance name.
	.EXAMPLE
	Format-SqlInstanceName -ServerInstance 'mysqlserver'
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([PsCustomObject])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance
	)

	begin {
	}

	process {
		if ($ServerInstance.IndexOf('\') -gt 0) {
			$ConnectionName = $ServerInstance.Split('\')[0]
			$InstanceName = $ServerInstance.Split('\')[1]
		} else {
			$ConnectionName = $ServerInstance
			$InstanceName = $null
		}

		if ($ConnectionName.IndexOf(':') -gt 0) {
			$ServerHostName = $ConnectionName.Split(':')[0]
			[nullable[int]]$TcpPort = $ConnectionName.Split(':')[1]
		} elseif ($ConnectionName.IndexOf(',') -gt 0) {
			$ServerHostName = $ConnectionName.Split(',')[0]
			[nullable[int]]$TcpPort = $ConnectionName.Split(',')[1]
		} else {
			$ServerHostName = $ConnectionName
			[nullable[int]]$TcpPort = $null
		}

		if ($ServerHostName -in @('.', '(local)')) {
			$ServerFQDN = $null
			$DomainName = $null
			$SqlInstanceName = $ServerInstance.Replace(':', ',')
		} else {
			if ($ServerHostName -as [IpAddress]) {
				$ServerFQDN = $null
				$DomainName = $null

				$SqlInstanceName = $ServerInstance.Replace(':', ',')
			} else {
				$ServerFQDN = [System.Net.Dns]::GetHostByName($ServerHostName).HostName
				$DomainName = $ServerFQDN.Substring($ServerFQDN.IndexOf('.') + 1)

				if ($null -eq $InstanceName) {
					if ($null -eq $TcpPort) {
						$SqlInstanceName = $ServerFQDN
					} else {
						$SqlInstanceName = [string]::Format('{0},{1}', $ServerFQDN, $TcpPort)
					}
				} else {
					if ($null -eq $TcpPort) {
						$SqlInstanceName = [string]::Format('{0}\{1}', $ServerFQDN, $InstanceName)
					} else {
						$SqlInstanceName = [string]::Format('{0},{1}\{2}', $ServerFQDN, $TcpPort, $InstanceName)
					}
				}
			}
		}

		[PsCustomObject][Ordered]@{
			'ServerHostName' = $ServerHostName
			'ServerFQDN' = $ServerFQDN
			'DomainName' = $DomainName
			'TcpPort' = $TcpPort
			'SqlInstance' = $InstanceName
			'SqlInstanceName' = $SqlInstanceName
		}
	}

	end {
	}
}

function Test-RunAsAdministrator {
	<#
	.SYNOPSIS
	Test for current windows identity running as administrator.
	.DESCRIPTION
	Test for current windows identity running as administrator.
	.EXAMPLE
	Test-RunAsAdministrator
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Boolean])]

	param ()

	begin {
		if ($PSVersionTable.PSEdition -eq 'Core') {
			if ($PSVersionTable.Platform -ne 'Win32NT') {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Platform not supported.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$FileGroupName
				)
			}
		}
	}

	process {
		$WindowsIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
		$WindowsPrincipal = [Security.Principal.WindowsPrincipal]::New($WindowsIdentity)

		$WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
	}

	end {
	}
}

function Rename-CIMFile {
	<#
	.SYNOPSIS
	Rename file.
	.DESCRIPTION
	Rename file using WMI method.
	.PARAMETER SourcePath
	Path of file to rename.
	.PARAMETER DestinationPath
	Path of new file name.
	.PARAMETER ComputerName
	Computer name where file is located.
	.PARAMETER Credential
	SQL Server authentication credentials.
	.EXAMPLE
	Rename-CIMFile -SourcePath c:\working\Test.txt -DestinationPath c:\working\Test2.txt -ComputerName localhost
	.EXAMPLE
	Rename-CIMFile -SourcePath c:\working\Test.txt -DestinationPath c:\working\Test2.txt -ComputerName MyServer -Credential $(Get-Credential)
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'High'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.IO.FileInfo]$SourcePath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.IO.FileInfo]$DestinationPath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$ComputerName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Management.Automation.PSCredential]$Credential
	)

	begin {
	}

	process {
		try {
			$CimSessionParameters = @{
				'Name' = 'RenameCIMDataFile'
			}

			if ($ComputerName -in @('localhost', [System.Net.Dns]::GetHostName(), [System.Net.Dns]::GetHostEntry([System.Net.Dns]::GetHostName()).HostName)) {
				if ($PSBoundParameters.ContainsKey('Credential')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Credentials cannot be used to connect to local machine.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$ComputerName
					)
				}
			} else {
				$CimSessionParameters.Add('ComputerName', $ComputerName)

				if ($PSBoundParameters.ContainsKey('Credential')) {
					$CimSessionParameters.Add('Credential', $Credential)
				}
			}

			$CimSession = New-CimSession @CimSessionParameters

			if ($null -eq $CimSession) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Unable to open CIM Session on host.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$ComputerName
				)
			}

			$CimInstanceParameters = @{
				'CimSession' = $CimSession
				'ClassName' = 'CIM_DataFile'
				'Filter' = "Name='" + $($SourcePath.FullName.Replace('\', '\\')) + "'"
			}

			$CIMDataFile = Get-CimInstance @CimInstanceParameters

			if ($null -eq $CIMDataFile) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.IO.FileNotFoundException]::New('File not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SourcePath.FullName
				)
			}

			$Return = $CIMDataFile | Invoke-CimMethod -MethodName Rename -Arguments @{FileName = "$($DestinationPath.FullName.Replace('\', '\\'))"}

			switch ($Return.ReturnValue) {
				0 {
					# No error
				}
				2 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[System.AccessViolationException]::New('You do not have access to perform the operation.'),
						'1',
						[System.Management.Automation.ErrorCategory]::PermissionDenied,
						$SourcePath.FullName
					)
				}
				8 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('The operation failed for an undefined reason.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidResult,
						$SourcePath.FullName
					)
				}
				9 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('The name specified as a target does not point to a real file or directory.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$SourcePath.FullName
					)
				}
				10 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('The file or directory specified as a target already exists and cannot be overwritten.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$SourcePath.FullName
					)
				}
				11 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('You have attempted to perform an NTFS operation on a non-NTFS filesystem.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$SourcePath.FullName
					)
				}
				12 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('You have attempted to perform an NT/2000-specific operation on a non-NT/2000 platform.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$SourcePath.FullName
					)
				}
				13 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('You have attempted to perform an operation across drives that can be carried out within only a single drive.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$SourcePath.FullName
					)
				}
				14 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('You have attempted to delete a directory that is not empty.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$SourcePath.FullName
					)
				}
				15 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('There has been a sharing violation. Another process is using the file you are attempting to manipulate.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$SourcePath.FullName
					)
				}
				16 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('You are attempting to act on a nonexistent file.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$SourcePath.FullName
					)
				}
				17 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('You do not have the relevant NT security privileges to carry out the operation.'),
						'1',
						[System.Management.Automation.ErrorCategory]::PermissionDenied,
						$SourcePath.FullName
					)
				}
				21 {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('You have supplied an invalid parameter to the method.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$SourcePath.FullName
					)
				}
				default {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Unknown exception.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidResult,
						$SourcePath.FullName
					)
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($null -ne $CimSession) {
				Remove-CimSession -CimSession $CimSession
			}
		}
	}

	end {
	}
}

function Test-SqlBrowserConnection {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'Hostname'
	)]

	[OutputType([System.Boolean])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Hostname'
		)]
		[string]$Computer,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'IPAddress'
		)]
		[System.Net.IPAddress]$IPAddress,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 65535)]
		[int]$Port = 1434,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, 86400000)]
		[int]$ConnectionTimeout = 5000
	)

	begin {
		$ASCIIEncoding = [System.Text.ASCIIEncoding]::New()
		[byte[]]$UDPPacket = 0x02,0x00	#,0x00
	}

	process {
		Try {
			if ($PSBoundParameters.ContainsKey('Computer')) {
				$IPAddress = [System.Net.Dns]::Resolve($Computer).AddressList[0]
			}

			$UDPClient = [System.Net.Sockets.UdpClient]::New()

			$UDPClient.Client.ReceiveTimeout = $ConnectionTimeout
			$UDPClient.Client.Blocking = $true

			$UDPClient.Connect($IPAddress, $Port)

			$IPEndPoint = [System.Net.IPEndPoint]::New([System.Net.IPAddress]::Any, 14340)

			[void]$UDPClient.Send($UDPPacket, $UDPPacket.length)

			$BytesReceived = $UDPClient.Receive([ref]$IPEndPoint)

			[string]$Response = $ASCIIEncoding.GetString($BytesReceived)

			if ($Response) {
				Write-Verbose $Response

				$true
			}
		}
		Catch [System.Management.Automation.MethodInvocationException] {
			Write-Warning 'Hidden SQL instances will not be included in response.  When all instances are hidden, the SQL browser will not provide a response.'

			$false
		}
		Catch {
			throw $_
		}
		finally {
			if (Test-Path -Path variable:\UDPClient) {
				$UDPClient.Close()
				$UDPClient.Dispose()
			}
		}
	}

	end {
	}
}

function Test-SqlConnection {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'Hostname'
	)]

	[OutputType([System.Boolean])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'Hostname'
		)]
		[string]$Computer,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'IPAddress'
		)]
		[System.Net.IPAddress]$IPAddress,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 65535)]
		[int]$Port = 1433,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Management.Automation.PSCredential]$Credential,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, 86400)]
		[int]$ConnectionTimeout = 15
	)

	begin {
		try {
			$TcpClient = [System.Net.Sockets.TcpClient]::New()
			$TcpClient.SendTimeout = $ConnectionTimeout

			$SqlConnection = [Microsoft.Data.SqlClient.SqlConnection]::New()

			$ConnectionStringParameters = @{
				'DatabaseName' = 'master'
				'ConnectionTimeout' = $ConnectionTimeout
			}

			if ($PSBoundParameters.ContainsKey('Computer')) {
				$FormatStringArray = @(
					$Computer,
					$Port
				)
			} else {
				$FormatStringArray = @(
					$IPAddress,
					$Port
				)
			}

			$ConnectionStringParameters.Add('ServerInstance', [string]::Format('{0},{1}', $FormatStringArray))

			if ($PSBoundParameters.ContainsKey('Credential')) {
				$ConnectionStringParameters.Add('Credential', $Credential)
			}

			$SqlConnection.ConnectionString = Build-SqlClientConnectionString @ConnectionStringParameters
		}
		catch {
			if (Test-Path -Path variable:\TcpClient) {
				$TcpClient.Dispose()
			}

			if (Test-Path -Path variable:\SqlConnection) {
				$SqlConnection.Dispose()
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('Computer')) {
				switch ($Computer) {
					'.' {
						[void]$TcpClient.Connect([System.Net.Dns]::GetHostName(), $Port)
					}
					'localhost' {
						[void]$TcpClient.Connect([System.Net.Dns]::GetHostName(), $Port)
					}
					Default {
						[void]$TcpClient.Connect($Computer, $Port)
					}
				}

			} else {
				[void]$TcpClient.Connect($IPAddress, $Port)
			}

			if ($TcpClient.Connected) {
				Write-Verbose 'TCP Connected'

				$TcpClient.Close()

				$SqlConnection.Open()
				$SqlConnection.Close()
			} else {
				throw $_
			}

			$true
		} catch {
			$false
		}
		finally {
			if (Test-Path -Path variable:\TcpClient) {
				$TcpClient.Dispose()
			}

			if (Test-Path -Path variable:\SqlConnection) {
				$SqlConnection.Dispose()
			}
		}
	}

	end {
	}
}
#EndRegion

#Region SMO Functions
function Add-SmoAvailabilityDatabase {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.AvailabilityDatabase])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[string]$AvailabilityGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoAvailabilityGroup'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoAvailabilityGroup'
		)]
		[Microsoft.SqlServer.Management.Smo.AvailabilityGroup]$AvailabilityGroupObject
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$AvailabilityGroupObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'AvailabilityGroupName' = $AvailabilityGroupName
				}

				$AvailabilityGroupObject = Get-SmoAvailabilityGroup @AvailabilityGroupObjectParameters
			}
		}
		catch {
			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($DatabaseName, 'Add database to availability group.')) {
				$SmoAvailabilityDatabase = [Microsoft.SqlServer.Management.Smo.AvailabilityDatabase]::New($AvailabilityGroupObject, $DatabaseName)
				$SmoAvailabilityDatabase.Create()

				if (-not $SmoAvailabilityDatabase.IsJoined) {
					$SmoAvailabilityDatabase.JoinAvailabilityGroup()
				}

				[void]$SmoAvailabilityDatabase.Initialize()

				$SmoAvailabilityDatabase
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Add-SmoAssembly {
	<#
	.SYNOPSIS
	Load SMO assemblies.
	.DESCRIPTION
	Load SMO assemblies.
	.EXAMPLE
	Add-SmoCoreAssembly
	.NOTES
	Missing:
		Microsoft.SqlServer.ConnectionInfoExtended.dll
		Microsoft.Data.SqlClient.SNI.x64.dll
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	param ()

	begin {
		$Assemblies = @(
			'Microsoft.SqlServer.Dac.dll'
			#'Microsoft.SqlServer.Management.XEvent.dll'
		)
	}

	process {
		try {
			[System.IO.FileInfo]$SmoPath = [AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.Smo.dll'}).Location

			foreach ($Assembly in $Assemblies) {
				Add-Type -Path $(Join-Path -Path $SmoPath.Directory.FullName -ChildPath $Assembly -Resolve) -ErrorAction Stop

				<#
				if ($PSVersionTable.PSEdition -eq 'Desktop') {
					[void]([Reflection.Assembly]::LoadFrom((Join-Path -Path $SmoPath.Directory.FullName -ChildPath $Assembly -Resolve)))
				} else {
					Add-Type -Path (Join-Path -Path $SmoPath.Directory.FullName -ChildPath $Assembly -Resolve) -ErrorAction Stop
				}
				#>
			}
		}
		catch {
			throw $_
		}
	}

	end {
		$Error.Clear()
	}
}

function Add-SmoDatabaseAsymmetricKeyPrivateKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$AsymmetricKeyName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$PrivateKeyPassword
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$AsymmetricKey = Get-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName $AsymmetricKeyName

			if ($null -eq $AsymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Asymmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$AsymmetricKeyName
				)
			}

			if ($PSCmdlet.ShouldProcess($AsymmetricKeyName, "Adding database Asymmetric key.")) {
				$AsymmetricKey.AddPrivateKey(
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyPassword))
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Add-SmoDatabaseDataFile {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.DataFile])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[ValidateLength(1, 128)]
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileGroupObject'
		)]
		[Microsoft.SqlServer.Management.SMO.FileGroup]$FileGroupObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DataFileName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.IO.FileInfo][TransformPath()]$DataFilePath
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
				$DatabaseObject.Refresh()
			}

			if ($PSBoundParameters.ContainsKey('FileGroupName')) {
				$FileGroupObject = $DatabaseObject.FileGroups[$FileGroupName]
			}

			if ($null -eq $FileGroupObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('FileGroup not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$FileGroupName
				)
			}

			$FileGroupObject.Refresh()
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$DataFileObject = [Microsoft.SqlServer.Management.SMO.DataFile]::New($FileGroupObject, $DataFileName)
			$DataFileObject.FileName = $DataFilePath.FullName

			if ($PSCmdlet.ShouldProcess($FileGroupObject.name, "Creating data file $DataFileName")) {
				$DataFileObject.Create()

				$DataFileObject
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Add-SmoDatabaseMasterKeyPasswordEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$EncryptionPassword
	)

	begin {
	}

	process {
		try {
			$MasterKey = $DatabaseObject.MasterKey

			if ($null -eq $MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database does not contain master key.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Add database master key password encryption')) {
				$MasterKey.AddPasswordEncryption([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptionPassword)))
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Add-SmoDatabaseMasterKeyServiceKeyEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
	}

	process {
		try {
			$MasterKey = $DatabaseObject.MasterKey

			if ($null -eq $MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database does not contain master key.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Add database master key service key encryption')) {
				$MasterKey.AddServiceKeyEncryption()
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Add-SmoDatabaseRoleMember {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleMemberName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters

				if ($null -eq $DatabaseObject.Roles[$RoleName]) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Database role not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$RoleName
					)
				}
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.Users[$RoleMemberName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database user not found.'),
					'2',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$RoleMemberName
				)
			}

			if ($RoleMemberName -notin $DatabaseObject.Roles[$RoleName].EnumMembers()) {
				if ($PSCmdlet.ShouldProcess($RoleName, "Adding $RoleMemberName")) {
					$DatabaseObject.Roles[$RoleName].AddMember($RoleMemberName)
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Add-SmoDatabaseSymmetricKeyKeyEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SymmetricKeyName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.KeyEncryptionType]$KeyEncryptionType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$KeyEncryptionValue
	)

	begin {
	}

	process {
		try {
			$SymmetricKey = Get-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName $SymmetricKeyName

			if ($null -eq $SymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Symmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SymmetricKeyName
				)
			}

			if ($SymmetricKey.IsOpen -eq $false) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Symmetric key is not open.'),
					'1',
					[System.Management.Automation.ErrorCategory]::OpenError,
					$SymmetricKeyName
				)
			}

			$KeyEncryption = [Microsoft.SqlServer.Management.Smo.SymmetricKeyEncryption]::New(
				$KeyEncryptionType,
				$KeyEncryptionValue
			)

			if ($PSCmdlet.ShouldProcess($SymmetricKeyName, "Add database symmetric key encryption.")) {
				$SymmetricKey.AddKeyEncryption($KeyEncryption)
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Add-SmoServerRoleMember {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Credential])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleMemberName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}

			if ($ServerRoleName -NotIn $SmoServerObject.Roles.Name) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Server role not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$ServerRoleName
				)
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $SmoServerObject.Logins[$ServerRoleMemberName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Server login not found.'),
					'2',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$ServerRoleMemberName
				)
			}

			$SmoServerRole = $SmoServerObject.Roles[$ServerRoleName]

			if ($PSCmdlet.ShouldProcess($ServerRoleMemberName, 'Add server role member')) {
				$SmoServerRole.AddMember($ServerRoleMemberName)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Close-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
	}

	process {
		try {
			if ($null -eq $DatabaseObject.MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database Master Key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			$DatabaseObject.MasterKey.Close()
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Close-SmoDatabaseSymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SymmetricKeyName
	)

	begin {
	}

	process {
		try {
			$SymmetricKey = Get-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName $SymmetricKeyName

			if ($null -eq $SymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Symmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SymmetricKeyName
				)
			}

			$SymmetricKey.Close()
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Connect-SmoServer {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'SqlInstanceName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Server])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateLength(1, 128)]
		[Alias('Database')]
		[string]$DatabaseName = 'master',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[AuthenticationMode]$AuthenticationMode = 'SQL',

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[System.Management.Automation.PSCredential]$Credential,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateNotNullOrEmpty()]
		[string]$ApplicationName = 'PowerShell SMO',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ApplicationIntent]$ApplicationIntent = 'ReadWrite',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$ConnectTimeout = 15,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$StatementTimeout = 600,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[switch]$EncryptConnection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[switch]$StrictEncryption,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[switch]$TrustServerCertificate,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlInstanceName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[Microsoft.SqlServer.Management.Common.NetworkProtocol]$NetworkProtocol,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
	)

	begin {
	}

	process {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'SqlConnection') {
				$ServerConnection = [Microsoft.SqlServer.Management.Common.ServerConnection]::New($SqlConnection)
			} else {
				$SqlInstanceName = Format-SqlInstanceName -ServerInstance $ServerInstance

				$ServerConnection = [Microsoft.SqlServer.Management.Common.ServerConnection]::New($SqlInstanceName.SqlInstanceName)

				$ServerConnection.ApplicationIntent = $ApplicationIntent
				$ServerConnection.ApplicationName = $ApplicationName
				$ServerConnection.ConnectTimeout = $ConnectTimeout
				$ServerConnection.DatabaseName = $DatabaseName
				$ServerConnection.EncryptConnection = $EncryptConnection
				$ServerConnection.StatementTimeout = $StatementTimeout
				$ServerConnection.TrustServerCertificate = $TrustServerCertificate
				$ServerConnection.WorkstationId = [System.Net.Dns]::GetHostName()

				if ($ServerConnection.PSObject.Properties.Name -contains 'StrictEncryption') {
					$ServerConnection.StrictEncryption = $StrictEncryption
				} else {
					if ($PSBoundParameters.ContainsKey('StrictEncryption')) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Strict encryption requires SQLServer module version 22.0.59 or above.'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidArgument,
							'StrictEncryption'
						)
					}
				}

				if ($PSBoundParameters.ContainsKey('NetworkProtocol')) {
					$ServerConnection.NetworkProtocol = $NetworkProtocol
				}

				if ($PSCmdlet.ParameterSetName -eq 'WithCredential') {
					switch ($AuthenticationMode) {
						'AsUser' {
							$ServerConnection.LoginSecure = $true
							$ServerConnection.ConnectAsUser = $true
							$ServerConnection.ConnectAsUserName = $Credential.username
							$ServerConnection.ConnectAsUserPassword = $Credential.GetNetworkCredential().Password
						}
						'SQL' {
							$ServerConnection.LoginSecure = $false
							$ServerConnection.Login = $Credential.UserName
							$ServerConnection.SecurePassword = $Credential.Password
						}
					}
				}

				[void]$ServerConnection.Connect()
			}

			$SmoServerObject = [Microsoft.SqlServer.Management.Smo.Server]::New($ServerConnection)

			$SmoServerObject
		}
		Catch [Microsoft.SqlServer.Management.Common.ConnectionFailureException] {
			throw $_
		}
		Catch {
			throw $_
		}
	}

	end {
	}
}

function Disable-SmoTransparentDatabaseEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($DatabaseObject.EncryptionEnabled) {
				if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Disabling database encryption')) {
					$DatabaseObject.EncryptionEnabled = $false
					$DatabaseObject.Alter()
					$DatabaseObject.Refresh()
				}
			} else {
				Write-Output 'Encryption is not enabled.'
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Disconnect-SmoServer {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
	}

	process {
		try {
			if ($SmoServerObject.ConnectionContext.IsOpen -eq $true) {
				$SmoServerObject.ConnectionContext.Disconnect()
			}

			[Microsoft.Data.SqlClient.SqlConnection]::ClearPool($SmoServerObject.ConnectionContext.SqlConnectionObject)
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Enable-SmoTransparentDatabaseEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Enabling database encryption')) {
				$DatabaseObject.EncryptionEnabled = $true
				$DatabaseObject.Alter()
				$DatabaseObject.Refresh()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Export-SmoDatabaseCertificate {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$CertificateName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Alias('DecryptionPassword')]
		[SecureString]$PrivateKeyDecryptionPassword,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathIsValid()]
		[System.IO.FileInfo][TransformPath()]$CertificatePath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathIsValid()]
		[System.IO.FileInfo][TransformPath()]$PrivateKeyPath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Alias('EncryptionPassword')]
		[ValidatePassword()]
		[SecureString]$PrivateKeyEncryptionPassword
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$Certificate = Get-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName $CertificateName

			if ($null -eq $Certificate) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Certificate not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$CertificateName
				)
			}

			if ($PSBoundParameters.ContainsKey('PrivateKeyDecryptionPassword')) {
				$Certificate.Export(
					$CertificatePath.FullName,
					$PrivateKeyPath.FullName,
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyEncryptionPassword)),
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyDecryptionPassword))
				)
			} else {
				$Certificate.Export(
					$CertificatePath.FullName,
					$PrivateKeyPath.FullName,
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyEncryptionPassword))
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Export-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathIsValid()]
		[System.IO.FileInfo][TransformPath()]$Path,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$EncryptionPassword
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database Master Key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			$DatabaseObject.MasterKey.Export(
				$Path.FullName,
				[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptionPassword))
			)
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Export-SmoServiceMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathIsValid()]
		[System.IO.FileInfo][TransformPath()]$Path,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$EncryptionPassword
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($Path, 'Export Service Master Key')) {
				$SmoServerObject.ServiceMasterKey.Export(
					$Path.FullName,
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptionPassword))
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoAvailabilityGroup {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.AvailabilityGroup])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$AvailabilityGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		Try {
			if ($PSBoundParameters.ContainsKey('AvailabilityGroupName')) {
				$AvailabilityGroups = $SmoServerObject.AvailabilityGroups[$AvailabilityGroupName]

				if ($null -eq $AvailabilityGroups) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Availability Group not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$AvailabilityGroupName
					)
				}
			} else {
				$AvailabilityGroups = $SmoServerObject.AvailabilityGroups
			}

			$AvailabilityGroups
		}
		Catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoBackupFileList {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SmoRestore.FileList])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo]$DatabaseBackupPath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
		try {
			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			if ($PSCmdlet.ParameterSetName -in ('ServerInstance')) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $ServerInstance
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SmoRestore.Devices.AddDevice((Resolve-Path -Path $DatabaseBackupPath).ProviderPath, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

			$FileList = $SmoRestore.ReadFileList($SmoServerObject)

			foreach ($File in $FileList) {
				$BackupFileList = [SmoRestore.FileList]::New()

				foreach ($Column in $FileList.Columns) {
					if ($File.item($Column) -IsNot [DBNull]) {
						$BackupFileList.$($Column.ColumnName) = $File.item($Column)
					}
				}

				$BackupFileList
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in ('ServerInstance')) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoBackupHeader {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SmoRestore.BackupHeader])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo]$DatabaseBackupPath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
		try {
			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			if ($PSCmdlet.ParameterSetName -in ('ServerInstance')) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $ServerInstance
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SmoRestore.Devices.AddDevice((Resolve-Path -Path $DatabaseBackupPath).ProviderPath, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

			$BackupHeaders = $SmoRestore.ReadBackupHeader($SmoServerObject)

			foreach ($Row in $BackupHeaders.Rows) {
				$SmoBackupHeader = [SmoRestore.BackupHeader]::New()

				foreach ($Column in $BackupHeaders.Columns) {
					if ($Row.item($Column) -IsNot [DBNull]) {
						$SmoBackupHeader.$($Column.ColumnName) = $Row.item($Column)
					}
				}

				$SmoBackupHeader
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in ('ServerInstance')) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseAsymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.AsymmetricKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$AsymmetricKeyName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('AsymmetricKeyName')) {
				$DatabaseObject.AsymmetricKeys[$AsymmetricKeyName]
			} else {
				$DatabaseObject.AsymmetricKeys
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseCertificate {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Certificate])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$CertificateName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('CertificateName')) {
				$DatabaseObject.Certificates[$CertificateName]
			} else {
				$DatabaseObject.Certificates
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if([string]::IsNullOrWhiteSpace($DatabaseObject.DatabaseEncryptionKey.Thumbprint)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database encryption key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			$DatabaseObject.DatabaseEncryptionKey
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.MasterKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -ne $DatabaseObject.MasterKey) {
				$DatabaseObject.MasterKey
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseObject {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Database])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}

			if ($PSCmdlet.ParameterSetName -eq 'SmoServer') {
				if (-not $PSBoundParameters.ContainsKey('DatabaseName')) {
					$DatabaseName = $SmoServerObject.ConnectionContext.CurrentDatabase
				}
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		Try {
			$DatabaseObject = $SmoServerObject.Databases[$DatabaseName]

			if ($null -eq $DatabaseObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseName
				)
			}

			$DatabaseObject
		}
		Catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseSymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.SymmetricKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SymmetricKeyName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSBoundParameters.ContainsKey('SymmetricKeyName')) {
				$DatabaseObject.SymmetricKeys[$SymmetricKeyName]
			} else {
				$DatabaseObject.SymmetricKeys
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Import-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$Path,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[SecureString]$DecryptionPassword,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$EncryptionPassword,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Force
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database Master Key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			if ($PSCmdlet.ShouldProcess($Path, 'Import Database Master Key')) {
				$DatabaseObject.MasterKey.Import(
					$Path.FullName,
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DecryptionPassword)),
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptionPassword)),
					$Force
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Import-SmoServiceMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$Path,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[SecureString]$DecryptionPassword
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($Path, 'Import Service Master Key')) {
				$SmoServerObject.ServiceMasterKey.Import(
					$Path.FullName,
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DecryptionPassword))
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Invoke-SmoScriptDatabase {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathIsValid()]
		[System.IO.FileInfo][TransformPath()]$Path
	)
	
	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}
	
	process {
		Try {
			$DatabaseObject = $SmoServerObject.Databases[$DatabaseName]

			if ($null -eq $DatabaseObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseName
				)
			}

			$SmoScripter = [Microsoft.SqlServer.Management.Smo.Scripter]::New($SmoServerObject)

			$ScriptingOptions = [Microsoft.SqlServer.Management.Smo.ScriptingOptions]::New()

			$ScriptingOptions.ScriptBatchTerminator = $true
			$ScriptingOptions.IncludeHeaders = $true
			$ScriptingOptions.ExtendedProperties = $true
			$ScriptingOptions.ToFileOnly = $true
			$ScriptingOptions.Filename = $Path.FullName
			$ScriptingOptions.Encoding = [System.Text.Encoding]::UTF8

			$SmoScripter.Options = $ScriptingOptions

			$SmoTransfer = [Microsoft.SqlServer.Management.Smo.Transfer]::New($DatabaseObject)

			$ScriptingOptions = [Microsoft.SqlServer.Management.Smo.ScriptingOptions]::New()

			$ScriptingOptions.ExtendedProperties = $true
			$ScriptingOptions.DriAll = $true
			$ScriptingOptions.Indexes = $true
			$ScriptingOptions.Triggers = $true
			$ScriptingOptions.ScriptBatchTerminator = $true
			$ScriptingOptions.IncludeHeaders = $true
			$ScriptingOptions.Permissions = $true
			$ScriptingOptions.Statistics = $true
			$ScriptingOptions.ToFileOnly = $true
			$ScriptingOptions.IncludeIfNotExists = $true
			$ScriptingOptions.FileName = $Path.FullName
			$ScriptingOptions.AppendToFile = $true
			$ScriptingOptions.IncludeIfNotExists = $false
			$ScriptingOptions.Encoding = [System.Text.Encoding]::UTF8
<#
			if ($ContinueScriptingOnError) {
				$ScriptingOptions.ContinueScriptingOnError = $true
			}
#>
			$SmoTransfer.Options = $ScriptingOptions

			if ($PSCmdlet.ShouldProcess($Urn, 'Script Database')) {
				$SmoScripter.Script($DatabaseObject)

				Add-Content -Path $Path.FullName -Value $([string]::Format("`r`nUSE [{0}];`r`nGO`r`n", $DatabaseName))

				$SmoTransfer.ScriptTransfer()
			}
		}
		Catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}
	
	end {
	}
}

function Invoke-SmoScriptDatabaseObject {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathIsValid()]
		[System.IO.FileInfo][TransformPath()]$Path,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ScriptableDatabaseObjectClass]$ObjectClass,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ObjectName
<#
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.Urn]$Urn
#>
	)
	
	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}

		$ObjectClassWithDependencies = @(
			'DdlTrigger',
			'Default',
			'PartitionFunction',
			'PartitionScheme',
			'PlanGuide',
			'Rule',
			'SecurityPolicy',
			'Sequence',
			'SqlAssembly',
			'StoredProcedure',
			'Synonym',
			'Table',
			'Trigger',
			'UnresolvedEntity',
			'UserDefinedAggregate',
			'UserDefinedDataType',
			'UserDefinedFunction',
			'UserDefinedType',
			'UserDefinedTableType',
			'View',
			'XmlSchemaCollection'
		)
	}
	
	process {
		Try {
			$DatabaseObject = $SmoServerObject.Databases[$DatabaseName]

			if ($null -eq $DatabaseObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseName
				)
			}

			$ScriptingOptions = [Microsoft.SqlServer.Management.Smo.ScriptingOptions]::New()

			$ScriptingOptions.ExtendedProperties = $true
			$ScriptingOptions.SchemaQualify = $true
			$ScriptingOptions.DriAllConstraints = $true
			$ScriptingOptions.Indexes = $true
			$ScriptingOptions.Triggers = $true
			$ScriptingOptions.ScriptBatchTerminator = $true
			$ScriptingOptions.IncludeHeaders = $true
			$ScriptingOptions.Permissions = $true
			$ScriptingOptions.Statistics = $true
			$ScriptingOptions.ToFileOnly = $true
			$ScriptingOptions.IncludeIfNotExists = $true
			$ScriptingOptions.FileName = $Path.FullName
			$ScriptingOptions.AppendToFile = $true
			$ScriptingOptions.IncludeIfNotExists = $false
			$ScriptingOptions.Encoding = [System.Text.Encoding]::UTF8

			if ($ObjectClass -in $ObjectClassWithDependencies) {
				$ScriptingOptions.WithDependencies = $true
			}

<#
			if ($ContinueScriptingOnError) {
				$ScriptingOptions.ContinueScriptingOnError = $true
			}
#>

			$SmoScripter = [Microsoft.SqlServer.Management.Smo.Scripter]::New($SmoServerObject)

			$SmoScripter.Options = $ScriptingOptions

			$Urn = [Microsoft.SqlServer.Management.Sdk.Sfc.Urn]::New([string]::Format("{0}/{1}[@Name='{2}']", $DatabaseObject.Urn.ToString(), $ObjectClass, $ObjectName))

			if ($PSCmdlet.ShouldProcess($Urn, 'Script Database Object')) {
				$SmoScripter.Script($Urn)
			}
		}
		Catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}
	
	end {
	}
}

function Invoke-SmoScriptServerObject {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathIsValid()]
		[System.IO.FileInfo][TransformPath()]$Path,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ScriptableServerObjectClass]$ObjectClass,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ObjectName
	)
	
	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}
	
	process {
		Try {
			$ScriptingOptions = [Microsoft.SqlServer.Management.Smo.ScriptingOptions]::New()

			$ScriptingOptions.ExtendedProperties = $true
			$ScriptingOptions.ScriptBatchTerminator = $true
			$ScriptingOptions.IncludeHeaders = $true
			$ScriptingOptions.Permissions = $true
			$ScriptingOptions.ToFileOnly = $true
			$ScriptingOptions.IncludeIfNotExists = $true
			$ScriptingOptions.FileName = $Path.FullName
			$ScriptingOptions.AppendToFile = $true
			$ScriptingOptions.IncludeIfNotExists = $false
			$ScriptingOptions.Encoding = [System.Text.Encoding]::UTF8

			$SmoScripter = [Microsoft.SqlServer.Management.Smo.Scripter]::New($SmoServerObject)

			$SmoScripter.Options = $ScriptingOptions

			$Urn = [Microsoft.SqlServer.Management.Sdk.Sfc.Urn]::New([string]::Format("{0}/{1}[@Name='{2}']", $SmoServerObject.Urn.ToString(), $ObjectClass, $ObjectName))

			if ($PSCmdlet.ShouldProcess($Urn, 'Script Server Object')) {
				$SmoScripter.Script($Urn)
			}
		}
		Catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}
	
	end {
	}
}

function Invoke-SmoNonQuery {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName_CommandText'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName_CommandText'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName_InputFile'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName_CommandText'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName_InputFile'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject_CommandText'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject_InputFile'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName_InputFile'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject_InputFile'
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$InputFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName_CommandText'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject_CommandText'
		)]
		[string]$SqlCommandText
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName_CommandText', 'DatabaseName_InputFile')) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName_CommandText', 'DatabaseName_InputFile')) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		Try {
			if (-not $PSBoundParameters.ContainsKey('SqlCommandText')) {
				$SqlCommandText = Get-Content -LiteralPath $InputFile -Raw
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Executing $InputFile")) {
				$DatabaseObject.ExecuteNonQuery($SqlCommandText)
			}
		}
		Catch [System.Management.Automation.MethodException] {
			$BaseException = $_.Exception.GetBaseException()

			if ($PSBoundParameters.ContainsKey('InputFile')) {
				$PSCmdlet.WriteError(
					[System.Management.Automation.ErrorRecord]::New(
						[Exception]::New("Failed to execute SQL non-query file `"$($InputFile.Name)`" at `"$(Split-Path -Parent $InputFile -Resolve)`""),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidArgument,
						$InputFile.Name
					)
				)
			}

			throw [System.Management.Automation.ErrorRecord]::New(
				$BaseException,
				'1',
				[System.Management.Automation.ErrorCategory]::InvalidOperation,
				$null
			)
		}
		Catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName_CommandText', 'DatabaseName_InputFile')) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoCredential {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Credential])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$Name,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$Identity,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Security.SecureString]$Password
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($SmoServerObject.name, "Creating Credential $Name.")) {
				$SmoCredential = [Microsoft.SqlServer.Management.Smo.Credential]::New($SmoServerObject, $Name)

				$SmoCredential.Create($Identity, $Password)

				$SmoCredential
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseAsymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName-EncryptionAlgorithm'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.AsymmetricKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-EncryptionAlgorithm'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-SourceType'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-EncryptionAlgorithm'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-SourceType'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-EncryptionAlgorithm'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-SourceType'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$AsymmetricKeyName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-EncryptionAlgorithm'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-EncryptionAlgorithm'
		)]
		[Microsoft.SqlServer.Management.Smo.AsymmetricKeyEncryptionAlgorithm]$EncryptionAlgorithm,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-SourceType'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-SourceType'
		)]
		[Microsoft.SqlServer.Management.Smo.AsymmetricKeySourceType]$SourceType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-SourceType'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-SourceType'
		)]
		[string]$KeySource,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$KeyPassword
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName-EncryptionAlgorithm', 'DatabaseName-SourceType')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$AsymmetricKey = [Microsoft.SqlServer.Management.Smo.AsymmetricKey]::New($DatabaseObject, $AsymmetricKeyName)

			if ($PSCmdlet.ShouldProcess($AsymmetricKeyName, "Creating database asymmetric key.")) {
				switch ($PSCmdlet.ParameterSetName) {
					{$_ -in @('DatabaseName-EncryptionAlgorithm', 'DatabaseObject-EncryptionAlgorithm')} {
						if ($PSBoundParameters.ContainsKey('KeyPassword')) {
							$AsymmetricKey.Create(
								$EncryptionAlgorithm,
								[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($KeyPassword))
							)
						} else {
							$AsymmetricKey.Create($EncryptionAlgorithm)
						}
					}

					{$_ -in @('DatabaseName-SourceType', 'DatabaseObject-SourceType')} {
						if ($PSBoundParameters.ContainsKey('KeyPassword')) {
							$AsymmetricKey.Create(
								$KeySource,
								$SourceType,
								[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($KeyPassword))
							)
						} else {
							$AsymmetricKey.Create(
								$KeySource,
								$SourceType
							)
						}
					}

					Default {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Unknown Parameter set.'),
							'2',
							[System.Management.Automation.ErrorCategory]::InvalidType,
							$PSCmdlet.ParameterSetName
						)
					}
				}

				$AsymmetricKey
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseCertificate {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Certificate])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFile'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFileWithKey'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFile'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFileWithKey'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFile'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFileWithKey'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$CertificateName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[string]$Subject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFile'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFileWithKey'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFile'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFileWithKey'
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$CertificatePath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFileWithKey'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFileWithKey'
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$PrivateKeyPath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFileWithKey'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFileWithKey'
		)]
		[Alias('DecryptionPassword')]
		[SecureString]$PrivateKeyDecryptionPassword,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Alias('EncryptionPassword')]
		[ValidatePassword()]
		[SecureString]$PrivateKeyEncryptionPassword
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName', 'DatabaseName-CertFile', 'DatabaseName-CertFileWithKey')
			$CertFileParameterSets = @('DatabaseName-CertFile', 'DatabaseName-CertFileWithKey', 'DatabaseObject-CertFile', 'DatabaseObject-CertFileWithKey')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$Certificate = [Microsoft.SqlServer.Management.Smo.Certificate]::New($DatabaseObject, $CertificateName)

			if ($PSCmdlet.ShouldProcess($CertificateName, "Creating database certificate.")) {
				if ($PSCmdlet.ParameterSetName -in $CertFileParameterSets) {
					if ($PSBoundParameters.ContainsKey('PrivateKeyPath')) {
						if ($PSBoundParameters.ContainsKey('PrivateKeyEncryptionPassword')) {
							$Certificate.Create(
								$CertificatePath.FullName,
								[Microsoft.SqlServer.Management.Smo.CertificateSourceType]::File,
								$PrivateKeyPath.FullName,
								[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyDecryptionPassword)),
								[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyEncryptionPassword))
							)
						} else {
							$Certificate.Create(
								$CertificatePath.FullName,
								[Microsoft.SqlServer.Management.Smo.CertificateSourceType]::File,
								$PrivateKeyPath.FullName,
								[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyDecryptionPassword))
							)
						}
					} else {
						$Certificate.Create($CertificatePath, [Microsoft.SqlServer.Management.Smo.CertificateSourceType]::File)
					}
				} else {
					$Certificate.Subject = $Subject

					if ($PSBoundParameters.ContainsKey('PrivateKeyEncryptionPassword')) {
						$Certificate.Create(
							[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyEncryptionPassword))
						)
					} else {
						$Certificate.Create()
					}
				}

				$Certificate
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.DatabaseEncryptionAlgorithm]$EncryptionAlgorithm,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.DatabaseEncryptionType]$EncryptionType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$EncryptorName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$DatabaseEncryptionKey = [Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey]::New()
			$DatabaseEncryptionKey.Parent = $DatabaseObject
			$DatabaseEncryptionKey.EncryptionAlgorithm = $EncryptionAlgorithm
			$DatabaseEncryptionKey.EncryptionType = $EncryptionType
			$DatabaseEncryptionKey.EncryptorName = $EncryptorName

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Adding database encryption key')) {
				$DatabaseEncryptionKey.Create()

				$DatabaseObject.Alter()
				$DatabaseObject.Refresh()

				$DatabaseEncryptionKey
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseFileGroup {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.FileGroup])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$FileGroupName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -ne $DatabaseObject.FileGroups[$FileGroupName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('File group exists.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ResourceExists,
					$DatabaseObject.FileGroups[$FileGroupName]
				)
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Creating file group $FileGroupName")) {
				$FileGroupObject = [Microsoft.SqlServer.Management.SMO.FileGroup]::New($DatabaseObject, $FileGroupName)
				$FileGroupObject.Create()

				$FileGroupObject
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.MasterKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFile'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFile'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFile'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$EncryptionPassword,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFile'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFile'
		)]
		[System.IO.FileInfo][TransformPath()]$Path,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-CertFile'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-CertFile'
		)]
		[SecureString]$DecryptionPassword
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName', 'DatabaseName-CertFile')
			$CertFileParameterSets = @('DatabaseName-CertFile', 'DatabaseObject-CertFile')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -ne $DatabaseObject.MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('There is already a master key in the database.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ResourceExists,
					$DatabaseObject.Name
				)
			}

			$MasterKey = [Microsoft.SqlServer.Management.Smo.MasterKey]::New()

			$MasterKey.Parent = $DatabaseObject

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Create database master key')) {
				if ($PSCmdlet.ParameterSetName -in $CertFileParameterSets) {
					$MasterKey.Create(
						$Path.FullName,
						[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DecryptionPassword)),
						[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptionPassword))
					)
				} else {
					$MasterKey.Create(
						[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptionPassword))
					)
				}

				$DatabaseObject.Alter()
				$DatabaseObject.Refresh()

				$MasterKey
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseRole {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.DatabaseRole])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleOwner
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -ne $DatabaseObject.Roles[$RoleName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database role exists.'),
					'2',
					[System.Management.Automation.ErrorCategory]::ResourceExists,
					$DatabaseObject.Roles[$RoleName]
				)
			}

			$RoleObject = [Microsoft.SqlServer.Management.SMO.DatabaseRole]::New($DatabaseObject, $RoleName)
			$RoleObject.Owner = $RoleOwner

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Creating database role $RoleName")) {
				$RoleObject.Create()

				$RoleObject
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseSchema {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.Schema])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SchemaName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SchemaOwner
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($null -ne $DatabaseObject.Schemas[$SchemaName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database schema exists.'),
					'2',
					[System.Management.Automation.ErrorCategory]::ResourceExists,
					$DatabaseObject.Schemas[$SchemaName]
				)
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SchemaObject = [Microsoft.SqlServer.Management.SMO.Schema]::New($DatabaseObject, $SchemaName)
			$SchemaObject.Owner = $SchemaOwner

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Creating database schema $SchemaName")) {
				$SchemaObject.Create()

				$SchemaObject
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseSymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.SymmetricKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-PassPhrase'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-PassPhrase'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-PassPhrase'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SymmetricKeyName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.KeyEncryptionType]$KeyEncryptionType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$KeyEncryptionValue,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.SymmetricKeyEncryptionAlgorithm]$KeyEncryptionAlgorithm,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-PassPhrase'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-PassPhrase'
		)]
		[ValidatePassword()]
		[SecureString]$PassPhrase,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName-PassPhrase'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-PassPhrase'
		)]
		[string]$IdentityPhrase
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName', 'DatabaseName-PassPhrase')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SymmetricKey = [Microsoft.SqlServer.Management.Smo.SymmetricKey]::New($DatabaseObject, $SymmetricKeyName)
			$KeyEncryption = [Microsoft.SqlServer.Management.Smo.SymmetricKeyEncryption]::New($KeyEncryptionType, $KeyEncryptionValue)

			if ($PSCmdlet.ShouldProcess($SymmetricKeyName, "Creating database symmetric key.")) {
				switch ($PSCmdlet.ParameterSetName) {
					{$_ -in @('DatabaseName', 'DatabaseObject')} {
						$SymmetricKey.Create(
							$KeyEncryption,
							$KeyEncryptionAlgorithm
						)
					}

					{$_ -in @('DatabaseName-PassPhrase', 'DatabaseObject-PassPhrase')} {
						if ($PSBoundParameters.ContainsKey('IdentityPhrase')) {
							$SymmetricKey.Create(
								$KeyEncryption,
								$KeyEncryptionAlgorithm,
								$PassPhrase,
								$IdentityPhrase
							)
						} else {
							$SymmetricKey.Create(
								$KeyEncryption,
								$KeyEncryptionAlgorithm,
								$PassPhrase
							)
						}
					}

					Default {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Unknown Parameter set.'),
							'2',
							[System.Management.Automation.ErrorCategory]::InvalidType,
							$PSCmdlet.ParameterSetName
						)
					}
				}

				$SymmetricKey
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoDatabaseUser {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.User])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$UserName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Security.SecureString]$Password,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DefaultSchema = 'dbo',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.UserType]$UserType = 'SqlUser'
	)

	begin {
		Try {
			if ($UserType -in @('AsymmetricKey', 'Certificate', 'External')) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('User type is not implemented.'),
					'1',
					[System.Management.Automation.ErrorCategory]::NotImplemented,
					$UserType
				)
			}

			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($PSBoundParameters.ContainsKey('Password')) {
				if ($UserType -ne 'SqlUser') {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Password parameter not valid for UserType.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidArgument,
						$UserType
					)
				}

				if ($DatabaseObject.ContainmentType -ne 'Partial') {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Containment type must be Partial to create contained users.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$DatabaseObject.ContainmentType
					)
				}
			}

			if ($null -ne $DatabaseObject.Users[$UserName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database user exists.'),
					'2',
					[System.Management.Automation.ErrorCategory]::ResourceExists,
					$DatabaseObject.Users[$UserName]
				)
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$UserObject = [Microsoft.SqlServer.Management.SMO.User]::New($DatabaseObject, $UserName)

			$UserObject.DefaultSchema = $DefaultSchema
			$UserObject.UserType = $UserType

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Creating database login $UserName.")) {
				if ($PSBoundParameters.ContainsKey('Password')) {
					$UserObject.Create($Password)
				} else {
					if ($UserType -in @('SqlLogin', 'SqlUser')) {
						$UserObject.Login = $UserName
					}

					$UserObject.Create()
				}

				$UserObject
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function New-SmoServerRole {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.ServerRole])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleOwner
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SmoServerRole = [Microsoft.SqlServer.Management.Smo.ServerRole]::New($SmoServerObject, $ServerRoleName)
			$SmoServerRole.Owner = $ServerRoleOwner

			if ($PSCmdlet.ShouldProcess($SmoServerObject.name, "Creating server role $ServerRoleName.")) {
				$SmoServerRole.Create()

				$SmoServerRole
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}

			throw $_
		}
	}

	end {
	}
}

function New-SmoSqlLogin {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Login])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$LoginName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Security.SecureString]$Password,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$PasswordIsHashed,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.LoginType]$LoginType,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DefaultDatabase = 'master',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[byte[]][TransformSidByteArray()]$Sid,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$PasswordExpirationEnabled = $true,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$PasswordPolicyEnforced = $true,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$LoginDisabled = $false,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$MustChangePassword = $false
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}

			if ($LoginType -NotIn ('SqlLogin', 'WindowsGroup', 'WindowsUser')) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Login type not supported.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$LoginType
				)
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SmoLogin = [Microsoft.SqlServer.Management.Smo.Login]::New($SmoServerObject, $LoginName)

			$SmoLogin.LoginType = $LoginType
			$SmoLogin.DefaultDatabase = $DefaultDatabase
			$SmoLogin.PasswordExpirationEnabled = $PasswordExpirationEnabled
			$SmoLogin.PasswordPolicyEnforced = $PasswordPolicyEnforced

			if ($PSBoundParameters.ContainsKey('Sid')) {
				$SmoLogin.Set_SID($Sid)
			}

			$LoginCreateOptions = [Microsoft.SqlServer.Management.Smo.LoginCreateOptions]::None

			if ($PasswordIsHashed) {
				$LoginCreateOptions += [Microsoft.SqlServer.Management.Smo.LoginCreateOptions]::IsHashed
			}

			if ($MustChangePassword) {
				$LoginCreateOptions += [Microsoft.SqlServer.Management.Smo.LoginCreateOptions]::MustChange
			}

			if ($PSCmdlet.ShouldProcess($SmoServerObject.name, "Creating login $LoginName.")) {
				$SmoLogin.Create($Password, $LoginCreateOptions)

				if ($LoginDisabled) {
					$SmoLogin.Disable()
				}

				$SmoLogin
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}

			throw $_
		}
	}

	end {
	}
}

function Open-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Medium'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[SecureString]$DecryptionPassword
	)

	begin {
	}

	process {
		try {
			if ($null -eq $DatabaseObject.MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database Master Key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			$DatabaseObject.MasterKey.Open(
				[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DecryptionPassword))
			)
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Open-SmoDatabaseSymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseObject'
	)]

	[OutputType([System.Void])]

	param (

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-WithCertificate'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-WithSymmetricKey'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SymmetricKeyName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[SecureString]$DecryptionPassword,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-WithCertificate'
		)]
		[string]$CertificateName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-WithCertificate'
		)]
		[SecureString]$PrivateKeyPassword,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject-WithSymmetricKey'
		)]
		[string]$DecryptionSymmetricKeyName
	)

	begin {
	}

	process {
		try {
			$SymmetricKey = Get-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName $SymmetricKeyName

			if ($null -eq $SymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Symmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SymmetricKeyName
				)
			}

			switch ($PSCmdlet.ParameterSetName) {
				'DatabaseObject' {
					$SymmetricKey.Open(
						[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DecryptionPassword))
					)
				}
				'DatabaseObject-WithCertificate' {
					if ($PSBoundParameters.ContainsKey('PrivateKeyPassword')) {
						$SymmetricKey.OpenWithCertificate(
							$CertificateName,
							[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyPassword))
						)
					} else {
						$SymmetricKey.OpenWithCertificate($CertificateName)
					}
				}
				'DatabaseObject-WithSymmetricKey' {
					$SymmetricKey.OpenWithSymmetricKey($DecryptionSymmetricKeyName)
				}
				Default {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Unknown Parameter set.'),
						'2',
						[System.Management.Automation.ErrorCategory]::InvalidType,
						$PSCmdlet.ParameterSetName
					)
				}
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Remove-SmoAvailabilityDatabase {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.AvailabilityGroup])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[string]$AvailabilityGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoAvailabilityGroup'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoAvailabilityGroup'
		)]
		[Microsoft.SqlServer.Management.Smo.AvailabilityGroup]$AvailabilityGroupObject
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$AvailabilityGroupObject = Get-SmoAvailabilityGroup -ServerInstance $ServerInstance -AvailabilityGroupName $AvailabilityGroupName
			}
		}
		catch {
			throw $_
		}
	}

	process {
		try {
			if ($DatabaseName -NotIn $AvailabilityGroupObject.AvailabilityDatabases.Name) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database not found in availability group.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseName
				)
			}

			$SmoAvailabilityDatabase = $AvailabilityGroupObject.AvailabilityDatabases[$DatabaseName]

			if ($PSCmdlet.ShouldProcess($DatabaseName, 'Remove database from availability group')) {
				$SmoAvailabilityDatabase.Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $AvailabilityGroupObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoCredential {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$Name
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($Name -NotIn $SmoServerObject.Credentials.Name) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Credential not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$Name
				)
			}

			$SmoCredential = $SmoServerObject.Credentials[$Name]

			if ($PSCmdlet.ShouldProcess($Name, 'Remove credential')) {
				$SmoCredential.Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseAsymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$AsymmetricKeyName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$RemoveProviderKey
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$AsymmetricKey = Get-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName $AsymmetricKeyName

			if ($null -eq $AsymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Asymmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$AsymmetricKeyName
				)
			}

			if ($PSCmdlet.ShouldProcess($AsymmetricKey.name, 'Removing asymmetric key')) {
				$AsymmetricKey.Drop($RemoveProviderKey)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseAsymmetricKeyPrivateKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$AsymmetricKeyName
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$AsymmetricKey = Get-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName $AsymmetricKeyName

			if ($null -eq $AsymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Asymmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$AsymmetricKeyName
				)
			}

			if ($PSCmdlet.ShouldProcess($AsymmetricKeyName, "Removing database Asymmetric key.")) {
				$AsymmetricKey.RemovePrivateKey()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseCertificate {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$CertificateName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$Certificate = Get-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName $CertificateName

			if ($null -eq $Certificate) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Certificate not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$CertificateName
				)
			}

			if ($PSCmdlet.ShouldProcess($Certificate.name, 'Removing database certificate')) {
				$Certificate.Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($DatabaseObject.EncryptionEnabled) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database Encryption Key cannot be removed when Transparent Data Encryption is enabled.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$DatabaseObject
				)
			}

			if ($DatabaseObject.HasDatabaseEncryptionKey) {
				$ProgressParameters = @{
					'Id' = 0
					'Status' = 'Decryption In Progress'
					'Activity' = 'Decryption In Progress'
					'PercentComplete' = 0
				}

				while ($DatabaseObject.DatabaseEncryptionKey.EncryptionState -eq 'DecryptionInProgress') {
					$DatabaseObject.Refresh()

					for ($i = 0; $i -lt 5; $i++) {
						$ProgressParameters.PercentComplete = $i / 5 * 100

						Write-Progress @ProgressParameters

						Start-Sleep -Seconds 1
					}
				}

				Write-Progress -Id 0 -Activity 'Decryption In Progress' -Completed

				if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Removing database encryption key')) {
					$DatabaseObject.DatabaseEncryptionKey.Drop()

					$DatabaseObject.Refresh()
				}
			} else {
				Write-Output 'Database does not have an encryption key.'
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database Master Key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.Name, 'Remove Database Master Key')) {
				$DatabaseObject.MasterKey.Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseMasterKeyPasswordEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[SecureString]$DecryptionPassword
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$MasterKey = $DatabaseObject.MasterKey

			if ($null -eq $MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database does not contain master key.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			if ($MasterKey.IsOpen  -eq $false) {
				Open-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject -DecryptionPassword $DecryptionPassword
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Remove database master key password encryption')) {
				$MasterKey.DropPasswordEncryption([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DecryptionPassword)))
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseMasterKeyServiceKeyEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$MasterKey = $DatabaseObject.MasterKey

			if ($null -eq $MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database does not contain master key.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Remove database master key service key encryption')) {
				$MasterKey.DropServiceKeyEncryption()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseRole {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.Roles[$RoleName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database role not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$RoleName
				)
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Removing database role $RoleName")) {
				$DatabaseObject.Roles[$RoleName].Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseRoleMember {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleMemberName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters

				if ($null -eq $DatabaseObject.Roles[$RoleName]) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Database role not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$RoleName
					)
				}

				if ($null -eq $DatabaseObject.Users[$RoleMemberName]) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Database user not found.'),
						'2',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$RoleMemberName
					)
				}
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($RoleName, "Removing $RoleMemberName")) {
				$DatabaseObject.Roles[$RoleName].DropMember($RoleMemberName)
				$DatabaseObject.Alter()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseSchema {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SchemaName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.Schemas[$SchemaName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database schema not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SchemaName
				)
			}

			$SchemaObject = $DatabaseObject.Schemas[$SchemaName]

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Dropping database schema $SchemaName")) {
				$SchemaObject.Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseSymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SymmetricKeyName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$RemoveProviderKey
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SymmetricKey = Get-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName $SymmetricKeyName

			if ($null -eq $SymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Symmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SymmetricKeyName
				)
			}

			if ($PSCmdlet.ShouldProcess($SymmetricKey.name, 'Removing symmetric key')) {
				$SymmetricKey.Drop($RemoveProviderKey)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseSymmetricKeyKeyEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SymmetricKeyName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.KeyEncryptionType]$KeyEncryptionType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$KeyEncryptionValue
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName', 'DatabaseName-WithCertificate')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SymmetricKey = Get-SmoDatabaseSymmetricKey -DatabaseObject $DatabaseObject -SymmetricKeyName $SymmetricKeyName

			if ($null -eq $SymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Symmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SymmetricKeyName
				)
			}

			$KeyEncryption = [Microsoft.SqlServer.Management.Smo.SymmetricKeyEncryption]::New($KeyEncryptionType, $KeyEncryptionValue)

			if ($PSCmdlet.ShouldProcess($SymmetricKeyName, "Remove database symmetric key encryption.")) {
				$SymmetricKey.DropKeyEncryption($KeyEncryption)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseUser {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$UserName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.Users[$UserName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database user not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$UserName
				)
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Remove Database User $UserName")) {
				$DatabaseObject.Users[$UserName].Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoServerRole {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($ServerRoleName -NotIn $SmoServerObject.Roles.Name) {
				throw[System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Server role not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$ServerRoleName
				)
			}

			$SmoServerRole = $SmoServerObject.Roles[$ServerRoleName]

			if ($PSCmdlet.ShouldProcess($ServerRoleName, 'Remove server role')) {
				$SmoServerRole.Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Remove-SmoServerRoleMember {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Credential])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleMemberName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($ServerRoleName -NotIn $SmoServerObject.Roles.Name) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Server role not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$ServerRoleName
				)
			}

			$SmoServerRole = $SmoServerObject.Roles[$ServerRoleName]

			if ($PSCmdlet.ShouldProcess($ServerRoleMemberName, 'Remove server role member')) {
				$SmoServerRole.DropMember($ServerRoleMemberName)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Remove-SmoSqlLogin {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$LoginName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($LoginName -NotIn $SmoServerObject.Logins.Name) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('SQL Login not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$LoginName
				)
			}

			$SmoServerLogin = $SmoServerObject.Logins[$LoginName]

			if ($PSCmdlet.ShouldProcess($LoginName, 'Remove SQL Login')) {
				$SmoServerLogin.Drop()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Rename-SmoDatabaseDataFile {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[OutputType([System.Void])]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[System.Diagnostics.DebuggerStepThrough()]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[ValidateLength(1, 128)]
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'FileGroupObject'
		)]
		[Microsoft.SqlServer.Management.SMO.FileGroup]$FileGroupObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$LogicalFileName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$NewLogicalFileName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(5, 128)]
		[string]$NewPhysicalFileName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($PSCmdlet.ParameterSetName -eq 'FileGroupObject') {
				$DatabaseObject = $FileGroupObject.Parent
			}

			$DatabaseObject.Refresh()

			if ($PSBoundParameters.ContainsKey('FileGroupName')) {
				$FileGroupObject = $DatabaseObject.FileGroups[$FileGroupName]
			}

			if ($null -eq $FileGroupObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('FileGroup not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$FileGroupName
				)
			}

			$FileGroupObject.Refresh()

			$DataFileObject = $FileGroupObject.Files[$LogicalFileName]

			if ($null -eq $DataFileObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Logical file name not found in file group.'),
					'2',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$LogicalFileName
				)
			}

			if ($PSCmdlet.ParameterSetName -eq 'FileGroupObject') {
				$ComputerName = $FileGroupObject.Parent.Parent.NetName
			} else {
				$ComputerName = $DatabaseObject.Parent.NetName
			}

			if ([System.Net.Dns]::GetHostName() -eq $ComputerName) {
				switch ($PSVersionTable.PSEdition) {
					'Core' {
						if ($PSVersionTable.Platform -eq 'Win32NT') {
							if (-not $(Test-RunAsAdministrator)) {
								Write-Warning 'Database file management may fail.  Run as Administrator to resolve.'
							}
						}
					}
					'Desktop' {
						if (-not $(Test-RunAsAdministrator)) {
							Write-Warning 'Database file management may fail.  Run as Administrator to resolve.'
						}
					}
					Default {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Unknown PowerShell Edition.'),
							'2',
							[System.Management.Automation.ErrorCategory]::InvalidType,
							$PSVersionTable.PSEdition
						)
					}
				}
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}

		$TestPathScriptBlock = {
			param ($Path)

			Test-Path -Path $Path -PathType Leaf
		}
	}

	process {
		try {
			if ($LogicalFileName -ne $NewLogicalFileName) {
				Write-Verbose "Renaming logical file name $LogicalFileName to $NewLogicalFileName"

				if ($PSCmdlet.ShouldProcess($DataFileObject.Name, "Renaming logical file $LogicalFileName to $NewLogicalFileName")) {
					$DataFileObject.Rename($NewLogicalFileName)
					$DatabaseObject.Alter()
				}
			}

			if ((Split-Path $DataFileObject.FileName -Leaf) -ne $NewPhysicalFileName) {
				Write-Verbose 'Renaming physical file name'

				$ParentPath = Split-Path -Path $DataFileObject.FileName -Parent
				$OldPath = $DataFileObject.FileName
				$NewPath = ([System.IO.FileInfo]([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($ParentPath, $NewPhysicalFileName)))).FullName

				if ($ComputerName -in [System.Net.Dns]::GetHostName(), 'localhost') {
					if (Test-Path -Path $NewPath -PathType Leaf) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Database data file exists.'),
							'2',
							[System.Management.Automation.ErrorCategory]::ResourceExists,
							$NewPath
						)
					}
				} else {
					if (Invoke-Command -ComputerName $ComputerName -ScriptBlock $TestPathScriptBlock -ArgumentList $NewPath) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Database data file exists.'),
							'3',
							[System.Management.Automation.ErrorCategory]::ResourceExists,
							$NewPath
						)
					}
				}

				if ($PSCmdlet.ShouldProcess($DataFileObject.Name, "Renaming physical file $OldPath to $NewPath")) {
					$DataFileObject.FileName = $NewPath
					$DatabaseObject.Alter()

					$($DatabaseObject.Parent).KillAllProcesses($DatabaseObject.Name)
					$DatabaseObject.SetOffline()

					$CIMDataFileProperties = @{
						'SourcePath' = $OldPath
						'DestinationPath' = $NewPath
						'ComputerName' = $ComputerName
					}

					Rename-CIMFile @CIMDataFileProperties

					$DatabaseObject.SetOnline()
				}
			}
		}
		Catch {
			if ($null -ne $DataFileObject) {
				$DataFileObject.FileName = $OldPath

				$DatabaseObject.Alter()
				$DatabaseObject.SetOnline()
			}

			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Rename-SmoDatabaseLogFile {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'LogFileObject'
		)]
		[Microsoft.SqlServer.Management.Smo.LogFile]$LogFileObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[ValidateLength(1, 128)]
		[string]$LogicalFileName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$NewLogicalFileName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(5, 128)]
		[string]$NewPhysicalFileName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($PSCmdlet.ParameterSetName -eq 'LogFileObject') {
				$DatabaseObject = $LogFileObject.Parent
			}

			$DatabaseObject.Refresh()

			if ($PSBoundParameters.ContainsKey('LogicalFileName')) {
				$LogFileObject = $DatabaseObject.LogFiles[$LogicalFileName]
			}

			if ($null -eq $LogFileObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database logical file not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$LogicalFileName
				)
			}

			$LogFileObject.Refresh()

			if ($PSCmdlet.ParameterSetName -eq 'LogFileObject') {
				$ComputerName = $LogFileObject.Parent.Parent.NetName
			} else {
				$ComputerName = $DatabaseObject.Parent.NetName
			}

			if ([System.Net.Dns]::GetHostName() -eq $ComputerName) {
				switch ($PSVersionTable.PSEdition) {
					'Core' {
						if ($PSVersionTable.Platform -eq 'Win32NT') {
							if (-not $(Test-RunAsAdministrator)) {
								Write-Warning 'Database file management may fail.  Run as Administrator to resolve.'
							}
						}
					}
					'Desktop' {
						if (-not $(Test-RunAsAdministrator)) {
							Write-Warning 'Database file management may fail.  Run as Administrator to resolve.'
						}
					}
					Default {
						throw [System.Management.Automation.ErrorRecord]::new(
							[Exception]::New('Unknown PowerShell Edition'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidType,
							$PSVersionTable.PSEdition
						)
					}
				}
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}

		$TestPathScriptBlock = {
			param ($Path)

			Test-Path -Path $Path -PathType Leaf
		}
	}

	process {
		try {
			if ($LogFileObject.Name -ne $NewLogicalFileName) {
				Write-Verbose "Renaming logical file name $($LogFileObject.Name) to $NewLogicalFileName"

				if ($PSCmdlet.ShouldProcess($LogFileObject.Name, "Renaming logical file $($LogFileObject.Name) to $NewLogicalFileName")) {
					$LogFileObject.Rename($NewLogicalFileName)
					$DatabaseObject.Alter()
				}
			}

			if ((Split-Path $LogFileObject.FileName -Leaf) -ne $NewPhysicalFileName) {
				Write-Verbose 'Renaming physical file name'

				$ParentPath = Split-Path -Path $LogFileObject.FileName -Parent
				$OldPath = $LogFileObject.FileName
				$NewPath = ([System.IO.FileInfo]([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($ParentPath, $NewPhysicalFileName)))).FullName

				if ($ComputerName -in [System.Net.Dns]::GetHostName(), 'localhost') {
					if (Test-Path -Path $NewPath -PathType Leaf) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('File exists.'),
							'2',
							[System.Management.Automation.ErrorCategory]::ResourceExists,
							$NewPath
						)
					}
				} else {
					if (Invoke-Command -ComputerName $ComputerName -ScriptBlock $TestPathScriptBlock -ArgumentList $NewPath) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('File exists.'),
							'3',
							[System.Management.Automation.ErrorCategory]::ResourceExists,
							$NewPath
						)
					}
				}

				if ($PSCmdlet.ShouldProcess($LogFileObject.Name, "Renaming physical file $OldPath to $NewPath")) {
					$LogFileObject.FileName = $NewPath

					$DatabaseObject.Alter()
					$DatabaseObject.Parent.KillAllProcesses($DatabaseObject.Name)
					$DatabaseObject.SetOffline()

					$CIMDataFileProperties = @{
						'SourcePath' = $OldPath
						'DestinationPath' = $NewPath
						'ComputerName' = $ComputerName
					}

					Rename-CIMFile @CIMDataFileProperties

					$DatabaseObject.SetOnline()
				}
			}
		}
		Catch {
			if (Test-Path -Path variable:\OldPath) {
				$LogFileObject.FileName = $OldPath

				$DatabaseObject.Alter()
			}

			throw $_
		}
		finally {
			$DatabaseObject.SetOnline()

			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Reset-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.DatabaseEncryptionAlgorithm]$EncryptionAlgorithm
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Regenerating database encryption key')) {
				$DatabaseObject.DatabaseEncryptionKey.Regenerate($EncryptionAlgorithm)

				$DatabaseObject.Alter()
				$DatabaseObject.Refresh()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Reset-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$EncryptionPassword,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Force
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.MasterKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database Master Key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DatabaseObject.Name
				)
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Regenerating database master key')) {
				$DatabaseObject.MasterKey.Regenerate(
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptionPassword)),
					$Force
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Reset-SmoServiceMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Force
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess('Service Master Key', 'Regenerate')) {
				if ($Force) {
					$SmoServerObject.ServiceMasterKey.Regenerate($Force)
				} else {
					$SmoServerObject.ServiceMasterKey.Regenerate()
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Set-SmoCredential {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Credential])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$Name,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$Identity,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Security.SecureString]$Password
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($Name -NotIn $SmoServerObject.Credentials.Name) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Credential not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$Name
				)
			}

			$SmoCredential = $SmoServerObject.Credentials[$Name]

			$SmoCredential.Identity = [System.Management.Automation.PSCredential]::New($Identity, $Password)

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Altering database role $RoleName")) {
				$SmoCredential.Alter()
				$SmoCredential.Refresh()

				$SmoCredential
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Set-SmoDatabaseAsymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$AsymmetricKeyName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[SecureString]$PrivateKeyPassword,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$NewPrivateKeyPassword
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$AsymmetricKey = Get-SmoDatabaseAsymmetricKey -DatabaseObject $DatabaseObject -AsymmetricKeyName $AsymmetricKeyName

			if ($null -eq $AsymmetricKey) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Asymmetric key not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$AsymmetricKeyName
				)
			}

			if ($PSCmdlet.ShouldProcess($AsymmetricKeyName, "Updating database Asymmetric key.")) {
				$AsymmetricKey.ChangePrivateKeyPassword(
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyPassword)),
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPrivateKeyPassword))
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoDatabaseCertificate {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$CertificateName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[SecureString]$PrivateKeyPassword,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[SecureString]$NewPrivateKeyPassword
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$Certificate = Get-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName $CertificateName

			if ($null -eq $Certificate) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Certificate not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$CertificateName
				)
			}

			if ($PSCmdlet.ShouldProcess($CertificateName, "Updating database certificate.")) {
				$Certificate.ChangePrivateKeyPassword(
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyPassword)),
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPrivateKeyPassword))
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.DatabaseEncryptionType]$EncryptionType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$EncryptorName
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Regenerating database encryption key')) {
				$DatabaseObject.DatabaseEncryptionKey.Reencrypt($EncryptorName, $EncryptionType)

				$DatabaseObject.Alter()
				$DatabaseObject.Refresh()
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoDatabaseObjectPermission {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseNameWithPermissionSet'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseNameWithPermissionSet'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObjectWithPermissionSet'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[DatabaseObjectPermission]$Permission,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[DatabaseObjectClass]$ObjectClass,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[String]$ObjectName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseNameWithPermissionSet'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObjectWithPermissionSet'
		)]
		[Microsoft.SqlServer.Management.SMO.ObjectPermissionSet]$PermissionSet,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$Principal,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[PermissionAction]$Action
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName', 'DatabaseNameWithPermissionSet')) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($PSBoundParameters.ContainsKey('Permission')) {
				$PermissionSet = [Microsoft.SqlServer.Management.Smo.ObjectPermissionSet]::New()

				[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.ObjectPermission]::$Permission)
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName', 'DatabaseNameWithPermissionSet')) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if (($DatabaseObject.Users.where({$_.name -eq $Principal})) -or ($DatabaseObject.Roles.where({$_.name -eq $Principal}))) {
				switch ($ObjectClass) {
					'Assembly' {
						$ClassObject = $DatabaseObject.Assemblies[$ObjectName]
					}
					'AsymmetricKey' {
						$ClassObject = $DatabaseObject.AsymmetricKeys[$ObjectName]
					}
					'Certificate' {
						$ClassObject = $DatabaseObject.Certificates[$ObjectName]
					}
					'ExtendedStoredProcedure' {
						$ClassObject = $DatabaseObject.ExtendedStoredProcedures[$ObjectName]
					}
					'Schema' {
						$ClassObject = $DatabaseObject.Schemas[$ObjectName]
					}
					'StoredProcedure' {
						$ClassObject = $DatabaseObject.StoredProcedures[$ObjectName]
					}
					'Sequence' {
						$ClassObject = $DatabaseObject.Sequences[$ObjectName]
					}
					'SymmetricKey' {
						$ClassObject = $DatabaseObject.SymmetricKeys[$ObjectName]
					}
					'Synonym' {
						$ClassObject = $DatabaseObject.Synonyms[$ObjectName]
					}
					'Table' {
						$ClassObject = $DatabaseObject.Tables[$ObjectName]
					}
					'UserDefinedFunction' {
						$ClassObject = $DatabaseObject.UserDefinedFunctions[$ObjectName]
					}
					'View' {
						$ClassObject = $DatabaseObject.Views[$ObjectName]
					}
					default {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Unknown class.'),
							'1',
							[System.Management.Automation.ErrorCategory]::ObjectNotFound,
							$ObjectName
						)
					}
				}

				if ($null -eq $ClassObject) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Object not found.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$ObjectName
					)
				}

				if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "$Action database object $ObjectName permissions to principal $Principal")) {
					switch ($Action) {
						'Grant' {
							$ClassObject.Grant($PermissionSet, $Principal)
						}
						'Deny' {
							$ClassObject.Deny($PermissionSet, $Principal)
						}
						'Revoke' {
							$ClassObject.Revoke($PermissionSet, $Principal)
						}
					}

					$ClassObject.Alter()
				}
			} else {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database principal not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$Principal
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName', 'DatabaseNameWithPermissionSet')) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoDatabasePermission {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseNameWithPermissionSet'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseNameWithPermissionSet'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObjectWithPermissionSet'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[DatabasePermission]$Permission,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseNameWithPermissionSet'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObjectWithPermissionSet'
		)]
		[Microsoft.SqlServer.Management.Smo.DatabasePermissionSet]$PermissionSet,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$Principal,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[PermissionAction]$Action
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName', 'DatabaseNameWithPermissionSet')) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($PSBoundParameters.ContainsKey('Permission')) {
				$PermissionSet = [Microsoft.SqlServer.Management.Smo.DatabasePermissionSet]::New()

				[void]$PermissionSet.Add([Microsoft.SqlServer.Management.SMO.DatabasePermission]::$Permission)
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName', 'DatabaseNameWithPermissionSet')) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if (($DatabaseObject.Users.where({$_.name -eq $Principal})) -or ($DatabaseObject.Roles.where({$_.name -eq $Principal}))) {
				if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "$Action database permissions to principal $Principal")) {
					switch ($Action) {
						'Grant' {
							$DatabaseObject.Grant($PermissionSet, $Principal)
						}
						'Deny' {
							$DatabaseObject.Deny($PermissionSet, $Principal)
						}
						'Revoke' {
							$DatabaseObject.Revoke($PermissionSet, $Principal)
						}
					}
				}
			} else {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database principal not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$Principal
				)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName', 'DatabaseNameWithPermissionSet')) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoDatabaseRole {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.DatabaseRole])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleOwner
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($null -eq $DatabaseObject.Roles[$RoleName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database role not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$RoleName
				)
			}

			$RoleObject = $DatabaseObject.Roles[$RoleName]
			$RoleObject.Owner = $RoleOwner

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Creating database role $RoleName")) {
				$RoleObject.Alter()
				$RoleObject.Refresh()

				$RoleObject
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoDatabaseSchema {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.Schema])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SchemaName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$SchemaOwner
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($null -eq $DatabaseObject.Schemas[$SchemaName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database schema not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$SchemaName
				)
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			$SchemaObject = $DatabaseObject.Schemas[$SchemaName]
			$SchemaObject.Owner = $SchemaOwner

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Creating database schema $SchemaName")) {
				$SchemaObject.Alter()
				$SchemaObject.Refresh()

				$SchemaObject
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoDatabaseUser {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.User])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseObject'
		)]
		[Microsoft.SqlServer.Management.Smo.Database]$DatabaseObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$UserName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$NewUserName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Security.SecureString]$Password,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DefaultSchema
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($null -eq $DatabaseObject.Users[$UserName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database user not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$UserName
				)
			}

			$UserObject = $DatabaseObject.Users[$UserName]

			if ($PSBoundParameters.ContainsKey('Password')) {
				if ($UserObject.AuthenticationType -ne [Microsoft.SqlServer.Management.Smo.AuthenticationType]::Database) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Password parameter not valid for AuthenticationType.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidArgument,
						$UserObject.AuthenticationType
					)
				}
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Setting database login $UserName properties.")) {
				$IsAltered = $false

				if ($PSBoundParameters.ContainsKey('NewUserName')) {
					$UserObject.Rename($NewUserName)

					$IsAltered = $true
				}

				if ($PSBoundParameters.ContainsKey('Password')) {
					$UserObject.ChangePassword($Password)

					$IsAltered = $true
				}

				if ($PSBoundParameters.ContainsKey('DefaultSchema')) {
					if ($UserObject.DefaultSchema -ne $DefaultSchema) {
						$UserObject.DefaultSchema = $DefaultSchema

						$IsAltered = $true
					}
				}

				if ($IsAltered) {
					$UserObject.Alter()
					$UserObject.Refresh()
				}

				$UserObject
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoServerRole {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.ServerRole])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$ServerRoleOwner
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($Name -NotIn $SmoServerObject.Roles.Name) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Credential not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$ServerRoleName
				)
			}

			$SmoServerRole = $SmoServerObject.Roles[$ServerRoleName]

			$SmoServerRole.Owner = $ServerRoleOwner

			if ($PSCmdlet.ShouldProcess($SmoServerObject.name, "Altering server role $ServerRoleName.")) {
				$SmoServerRole.Alter()
				$SmoServerRole.Refresh()

				$SmoServerRole
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}

			throw $_
		}
	}

	end {
	}
}

function Set-SmoSqlLogin {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Login])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer'
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$LoginName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$NewLoginName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Security.SecureString]$Password,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DefaultDatabase,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$PasswordExpirationEnabled,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$PasswordPolicyEnforced,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$LoginDisabled
	)

	begin {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					if ($SmoServerObject -is [Microsoft.SqlServer.Management.Smo.Server]) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	process {
		try {
			if ($LoginName -NotIn $SmoServerObject.Logins.Name) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('SQL Login not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$LoginName
				)
			}

			$SmoLogin = $SmoServerObject.Logins[$LoginName]

			if ($PSBoundParameters.ContainsKey('DefaultDatabase')) {
				$SmoLogin.DefaultDatabase = $DefaultDatabase
			}

			if ($PSBoundParameters.ContainsKey('Password')) {
				$SmoLogin.ChangePassword($Password)
			}

			if ($PSBoundParameters.ContainsKey('PasswordExpirationEnabled')) {
				$SmoLogin.PasswordExpirationEnabled = $PasswordExpirationEnabled
			}

			if ($PSBoundParameters.ContainsKey('PasswordPolicyEnforced')) {
				$SmoLogin.PasswordPolicyEnforced = $PasswordPolicyEnforced
			}

			if ($PSBoundParameters.ContainsKey('LoginDisabled')) {
				$SmoLogin.Disable()
			}

			if ($PSBoundParameters.ContainsKey('NewLoginName')) {
				$SmoLogin.Rename($NewLoginName)
			}

			if ($PSCmdlet.ShouldProcess($LoginName, "Alter login.")) {
				$SmoLogin.Alter()
				$SmoLogin.Refresh()

				$SmoLogin
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}

			throw $_
		}
	}

	end {
	}
}
#EndRegion

#Region SQL Client Functions
function Add-SqlClientAssembly {
	<#
	.SYNOPSIS
	Load SQL Client assemblies.
	.DESCRIPTION
	Load SQL Client assemblies.
	.EXAMPLE
	Add-SqlClientCoreAssembly
	.NOTES
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	param ()

	begin {
	}

	process {
		try {
			[System.IO.FileInfo]$SqlClientPath = [AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.Data.SqlClient.dll'}).Location

			if ($null -eq $SqlClientPath) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Assembly not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					'Microsoft.Data.SqlClient'
				)
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Build-SqlClientConnectionString {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'IntegratedSecurity'
	)]

	[OutputType([System.String])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$FailoverPartnerServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'IntegratedSecurity'
		)]
		[bool]$IntegratedSecurity = $true,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[System.Management.Automation.PSCredential]$Credential,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$ConnectionTimeout = 15,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$CommandTimeout = 30,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$EncryptConnection = $true,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$HostNameInCertificate,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.Data.SqlClient.SqlConnectionIPAddressPreference]$IPAddressPreference,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$TrustServerCertificate = $false,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$MultipleActiveResultSets = $false,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$PacketSize = 8000,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$ApplicationName = 'PowerShell SqlClient',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.Data.SqlClient.ApplicationIntent]$ApplicationIntent = 'ReadWrite',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$MultiSubnetFailover = $false,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, 255)]
		[int]$ConnectRetryCount = 2,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 60)]
		[int]$ConnectRetryInterval = 10,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$MinPoolSize = 0,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$MaxPoolSize = 100,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$ConnectionLifetime = 600
	)

	begin {
		$SqlConnectionStringBuilder = [Microsoft.Data.SqlClient.SqlConnectionStringBuilder]::New()
	}

	process {
		try {
			$SqlInstanceName = Format-SqlInstanceName -ServerInstance $ServerInstance

			$SqlConnectionStringBuilder['Data Source'] = $SqlInstanceName.SqlInstanceName

			if ($PSBoundParameters.ContainsKey('FailoverPartnerServerInstance')) {
				$SqlConnectionStringBuilder['Failover Partner'] = $FailoverPartnerServerInstance
			}

			$SqlConnectionStringBuilder['Initial Catalog'] = $DatabaseName

			if ($PSCmdlet.ParameterSetName -ne 'WithCredential') {
				$SqlConnectionStringBuilder['Integrated Security'] = $IntegratedSecurity
			}

			if ($PSCmdlet.ParameterSetName -eq 'WithCredential') {
				$SqlConnectionStringBuilder['User ID'] = $Credential.username
				$SqlConnectionStringBuilder['Password'] = $Credential.GetNetworkCredential().Password
			}

			if ($PSBoundParameters.ContainsKey('EncryptConnection')) {
				if ($EncryptConnection) {
					$SqlConnectionStringBuilder['Encrypt'] = [Microsoft.Data.SqlClient.SqlConnectionEncryptOption]::Mandatory.ToString()
				} else {
					$SqlConnectionStringBuilder['Encrypt'] = [Microsoft.Data.SqlClient.SqlConnectionEncryptOption]::Optional.ToString()
				}
			} else {
				$SqlConnectionStringBuilder['Encrypt'] = [Microsoft.Data.SqlClient.SqlConnectionEncryptOption]::Optional.ToString()
			}

			if ($PSBoundParameters.ContainsKey('HostNameInCertificate')) {
				$SqlConnectionStringBuilder['HostNameInCertificate'] = $HostNameInCertificate
			}

			if ($PSBoundParameters.ContainsKey('IPAddressPreference')) {
				$SqlConnectionStringBuilder['IPAddressPreference'] = $IPAddressPreference
			}

			$SqlConnectionStringBuilder['Pooling'] = $true
			$SqlConnectionStringBuilder['Min Pool Size'] = $MinPoolSize
			$SqlConnectionStringBuilder['Max Pool Size'] = $MaxPoolSize
			$SqlConnectionStringBuilder['Connection Lifetime'] = $ConnectionLifetime
			$SqlConnectionStringBuilder['Connect Timeout'] = $ConnectionTimeout
			$SqlConnectionStringBuilder['Command Timeout'] = $CommandTimeout
			$SqlConnectionStringBuilder['TrustServerCertificate'] = $TrustServerCertificate
			$SqlConnectionStringBuilder['Packet Size'] = $PacketSize
			$SqlConnectionStringBuilder['Application Name'] = $ApplicationName
			$SqlConnectionStringBuilder['Workstation ID'] = [System.Net.Dns]::GetHostName()
			$SqlConnectionStringBuilder['ApplicationIntent'] = $ApplicationIntent
			$SqlConnectionStringBuilder['MultipleActiveResultSets'] = $MultipleActiveResultSets
			$SqlConnectionStringBuilder['MultiSubnetFailover'] = $MultiSubnetFailover
			$SqlConnectionStringBuilder['ConnectRetryCount'] = $ConnectRetryCount
			$SqlConnectionStringBuilder['ConnectRetryInterval'] = $ConnectRetryInterval

			$SqlConnectionStringBuilder.ConnectionString
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Connect-SqlServerInstance {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.Data.SqlClient.SqlConnection])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[AuthenticationMode]$AuthenticationMode = 'SQL',

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[System.Management.Automation.PSCredential]$Credential,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ConnectionString'
		)]
		[string]$ConnectionString,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$ConnectionTimeout,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'WithCredential'
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$CommandTimeout
	)

	begin {
		if ($PSCmdlet.ParameterSetName -eq 'WithCredential') {
			$Credential.Password.MakeReadOnly()
		}
	}

	process {
		try {
			if (-not ($PSBoundParameters.ContainsKey('ConnectionString'))) {
				$ConnectionStringParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				if ($PSBoundParameters.ContainsKey('ConnectionTimeout')) {
					$ConnectionStringParameters.Add('ConnectionTimeout', $ConnectionTimeout)
				}

				if ($PSBoundParameters.ContainsKey('CommandTimeout')) {
					$ConnectionStringParameters.Add('CommandTimeout', $CommandTimeout)
				}

				if ($PSCmdlet.ParameterSetName -eq 'WithCredential') {
					$ConnectionStringParameters.Add('Credential', $Credential)
				}

				$ConnectionString = Build-SqlClientConnectionString @ConnectionStringParameters
			}

			$SqlConnection = [Microsoft.Data.SqlClient.SqlConnection]::New()
			$SqlConnection.ConnectionString = $ConnectionString

			$SqlConnection.Open()

			if ($PSBoundParameters['Verbose']) {
				$SqlInfoMessageEventHandler = [Microsoft.Data.SqlClient.SqlInfoMessageEventHandler] {
					param ([Object]$SqlSender, [Microsoft.Data.SqlClient.SqlInfoMessageEventArgs]$SqlEvent)

					[void]$SqlSender
					Write-Verbose $SqlEvent.Message
				}

				$SqlConnection.add_InfoMessage($SqlInfoMessageEventHandler)
				$SqlConnection.FireInfoMessageEventOnUserErrors = $false  #True will change the SQL Exception to information.
			}

			$SqlConnection
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Disconnect-SqlServerInstance {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
	)

	begin {
	}

	process {
		if ($SqlConnection.State -eq [System.Data.ConnectionState]::Open) {
			$SqlConnection.Close()
		}

		[Microsoft.Data.SqlClient.SqlConnection]::ClearPool($SqlConnection)

		$SqlConnection.Dispose()
	}

	end {
	}
}

function Get-SqlClientDataSet {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType(
		[System.Data.DataSet],
		[System.Data.DataTable],
		[System.Data.DataRow],
		[System.Boolean]
	)]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$SqlCommandText,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Data.CommandType]$CommandType = [System.Data.CommandType]::Text,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Collections.Generic.List[Microsoft.Data.SqlClient.SqlParameter]]$SqlParameter,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Collections.Generic.List[Microsoft.Data.SqlClient.SqlParameter]]$OutSqlParameter,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$CommandTimeout = 30,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DataSetName = 'NewDataSet',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DataTableName = 'NewDataTable',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[DataOutputType]$OutputAs = 'DataTable'
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$SqlServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$SqlConnection = Connect-SqlServerInstance @SqlServerParameters
			} else {
				if ($PSBoundParameters.ContainsKey('DatabaseName')) {
					$SqlConnection.ChangeDatabase($DatabaseName)
				}
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if ($(Test-Path -Path variable:SqlConnection) -and $null -ne $SqlConnection) {
					Disconnect-SqlServerInstance -SqlConnection $SqlConnection
				}
			}

			throw $_
		}

		$TableDirectFormatString = 'SELECT * FROM [{0}].[{1}];'
	}

	process {
		try {
			$SqlCommand = [Microsoft.Data.SqlClient.SqlCommand]::New()
			$SqlCommand.Connection = $SqlConnection

			if ($CommandType -eq [System.Data.CommandType]::TableDirect) {
				if ($SqlCommandText -match '^(\[?[^.\]]+\]?)\.(\[?[^.\]]+\]?)$') {
					$SchemaName = $Matches[1].Trim('[]')
					$TableName = $Matches[2].Trim('[]')
				} else {
					$SchemaName = 'dbo'

					if ($SqlCommandText -match '^\[.*\]$') {
						$TableName = $SqlCommandText.Trim('[]')
					} else {
						$TableName = $SqlCommandText
					}
				}

				$SqlCommand.CommandText = [string]::Format($TableDirectFormatString, $SchemaName.Replace(']', ']]'), $TableName.Replace(']', ']]'))
				$SqlCommand.CommandType = [System.Data.CommandType]::Text
			} else {
				$SqlCommand.CommandText = $SqlCommandText
				$SqlCommand.CommandType = $CommandType
			}

			$SqlCommand.CommandTimeout = $CommandTimeout

			if ($PSBoundParameters.ContainsKey('SqlParameter')) {
				foreach ($ListItem in $SqlParameter) {
					$Parameter = $ListItem.PSObject.Copy()

					[void]$SqlCommand.Parameters.Add($Parameter)
				}
			}

			if ($OutputAs -eq 'None') {
				$Result = $SqlCommand.ExecuteNonQuery()

				if ($Result -eq -1 -or $Result -gt 0) {
					$true
				} else {
					$false
				}
			} else {
				$SqlDataAdapter = [Microsoft.Data.SqlClient.SqlDataAdapter]::New($SqlCommand)

				$OutputDataset = [System.Data.DataSet]::New()
				$OutputDataset.DataSetName = $DataSetName
				$OutputDataset.ExtendedProperties['SqlCommand'] = $SqlCommandText
				$OutputDataset.ExtendedProperties['SqlConnection'] = $SqlConnection

				if ($PSCmdlet.ShouldProcess($DataSetName, 'Get SQL dataset')) {
					[void]$SqlDataAdapter.Fill($OutputDataset, $DataTableName)

					if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
						Disconnect-SqlServerInstance -SqlConnection $SqlConnection
					}

					foreach ($Parameter in $SqlCommand.Parameters.Where({$_.Direction -eq [System.Data.ParameterDirection]::Output})) {
						$OutSqlParameter.Add($Parameter)
					}

					switch ($OutputAs) {
						'DataSet' {
							$OutputDataset
						}
						'DataTable' {
							$OutputDataset.Tables
						}
						'DataRow' {
							foreach ($DataTable in $OutputDataset.Tables) {
								foreach ($DataRow in $DataTable.Rows) {
									$DataRow
								}
							}
						}
					}
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			if (Test-Path -Path variable:\SqlCommand) {
				$SqlCommand.Dispose()
			}

			if (Test-Path -Path variable:\SqlDataAdapter) {
				$SqlDataAdapter.Dispose()
			}
		}
	}

	end {
	}
}

function Invoke-SqlClientBulkCopy {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance_DataTable'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_DataRow'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_DataTable'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_DataRow'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_DataTable'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnectionString_DataRow'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnectionString_DataTable'
		)]
		[string]$ConnectionString,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection_DataRow'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection_DataTable'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$TableName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_DataRow'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection_DataRow'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnectionString_DataRow'
		)]
		[System.Data.DataRow[]]$DataRow,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_DataTable'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection_DataTable'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnectionString_DataTable'
		)]
		[System.Data.DataTable]$DataTable,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_DataTable'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection_DataTable'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnectionString_DataTable'
		)]
		[System.Data.DataRowState]$RowState,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Collections.Generic.List[Microsoft.Data.SqlClient.SqlBulkCopyColumnMapping]]$ColumnMappingCollection,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.Data.SqlClient.SqlBulkCopyOptions]$SqlBulkCopyOptions = 'Default',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$QueryTimeout = 30,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$BatchSize,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$NotifyAfter,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$EnableStreaming
	)

	begin {
		$ServerInstanceParameterSets = @('ServerInstance_DataRow', 'ServerInstance_DataTable')
		$SqlConnectionParameterSets = @('SqlConnection_DataRow', 'SqlConnection_DataTable')
		$DataTableParameterSets = @('ServerInstance_DataTable', 'SqlConnection_DataTable', 'SqlConnectionString_DataTable')
		$DataRowParameterSets = @('ServerInstance_DataRow', 'SqlConnection_DataRow', 'SqlConnectionString_DataRow')

		if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
			$ConnectionString = Build-SqlClientConnectionString -ServerInstance $ServerInstance -DatabaseName $DatabaseName
		}

		$eventHandler = {
			param(
				$EventSender,
				$SqlRowsCopiedEventArgs 
			)

			$ProgressParameters.Activity = 'Bulk Copy SQL Data.'
			$ProgressParameters.Status = [string]::Format('Row {0} of {1}', $SqlRowsCopiedEventArgs.RowsCopied, $Script:TotalRows)
			$ProgressParameters.CurrentOperation = 'Writing DataTable to server.'
			$ProgressParameters.PercentComplete = ($SqlRowsCopiedEventArgs.RowsCopied / $Script:TotalRows) * 100

			Write-Verbose $ProgressParameters.CurrentOperation
			Write-Progress @ProgressParameters
		}

		$ProgressParameters = @{
			'Id' = 1
			'Activity' = 'Bulk Copy SQL Data.'
			'Status' = [string]::Format('Row {0} of {1}', 0, 1)
			'CurrentOperation' = 'Writing DataTable to server.'
			'PercentComplete' = 0
		}
	}

	process {
		try {
			$Script:TotalRowsCopied = 0
			$Script:TotalRows = $DataTable.Rows.Count

			if ($PSCmdlet.ParameterSetName -in $SqlConnectionParameterSets) {
				$SqlBulkCopy = [Microsoft.Data.SqlClient.SqlBulkCopy]::New($SqlConnection, $SqlBulkCopyOptions, $null)
			} else {
				$SqlBulkCopy = [Microsoft.Data.SqlClient.SqlBulkCopy]::New($ConnectionString, $SqlBulkCopyOptions)
			}

			$SqlBulkCopy.DestinationTableName = $TableName
			$SqlBulkCopy.BulkCopyTimeout = $QueryTimeout

			if ($PSBoundParameters.ContainsKey('BatchSize')) {
				$SqlBulkCopy.NotifyAfter = $NotifyAfter
			} else {
				$SqlBulkCopy.NotifyAfter = [System.Math]::Ceiling($Script:TotalRows / 20)
			}

			if ($PSBoundParameters.ContainsKey('BatchSize')) {
				$SqlBulkCopy.BatchSize = $BatchSize
			}

			if ($PSBoundParameters.ContainsKey('ColumnMappingCollection')) {
				foreach ($ColumnMapping in $ColumnMappingCollection) {
					[void]$SqlBulkCopy.ColumnMappings.Add($ColumnMapping)
				}
			} else {
				foreach ($Column in $DataTable.Columns) {
					[void]$SqlBulkCopy.ColumnMappings.Add($Column.ColumnName, $Column.ColumnName)
				}
			}

			if ($EnableStreaming) {
				$SqlBulkCopy.EnableStreaming = $true
			}

			$SqlBulkCopy.add_SqlRowsCopied($eventHandler)

			$ProgressParameters.Activity = 'Bulk Copy SQL Data.'
			$ProgressParameters.Status = [string]::Format('Row {0} of {1}', 0, $Script:TotalRows)
			$ProgressParameters.CurrentOperation = 'Writing DataTable to server.'
			$ProgressParameters.PercentComplete = (0 / $Script:TotalRows) * 100

			Write-Verbose $ProgressParameters.CurrentOperation
			Write-Progress @ProgressParameters

			if ($PSCmdlet.ShouldProcess($TableName, 'Bulk insert into table')) {
				switch ($PSCmdlet.ParameterSetName) {
					{$_ -in $DataRowParameterSets} {
						$SqlBulkCopy.WriteToServer($DataRow)
					}
					{$_ -in $DataTableParameterSets} {
						if ($PSBoundParameters.ContainsKey('RowState')) {
							$SqlBulkCopy.WriteToServer($DataTable, $RowState)
						} else {
							$SqlBulkCopy.WriteToServer($DataTable)
						}
					}
					Default {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('Unknown parameter set.'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidOperation,
							$PSCmdlet.ParameterSetName
						)
					}
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			Write-Progress -Id 0 -Activity 'Bulk Copy SQL Data.' -Completed

			if (Test-Path -Path variable:\SqlBulkCopy) {
				$SqlBulkCopy.Close()
				$SqlBulkCopy.Dispose()
			}
		}
	}

	end {
	}
}

function Invoke-SqlClientNonQuery {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Boolean])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'DatabaseName'
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnection'
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$SqlCommandText,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$CommandTimeout = 30
	)

	begin {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$SqlServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$SqlConnection = Connect-SqlServerInstance @SqlServerParameters
			}
		}
		catch {
			throw $_
		}
	}

	process {
		try {
			$SqlCommand = [Microsoft.Data.SqlClient.SqlCommand]::New()
			$SqlCommand.Connection = $SqlConnection
			$SqlCommand.CommandText = $SqlCommandText
			$SqlCommand.CommandType = [System.Data.CommandType]::Text
			$SqlCommand.CommandTimeout = $CommandTimeout

			if ($PSCmdlet.ShouldProcess($SqlConnection.Database, 'Invoke SQL non-query')) {
				$Result = $SqlCommand.ExecuteNonQuery()
			}

			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}

			if ($Result -eq -1 -or $Result -gt 0) {
				$true
			} else {
				$false
			}
		}
		catch {
			throw $_
		}
		finally {
			if (Test-Path -Path variable:\SqlCommand) {
				$SqlCommand.Dispose()
			}

			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Publish-SqlDatabaseDacPac {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$ServerInstance,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1,128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SqlConnectionString'
		)]
		[string]$ConnectionString,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$DacPacPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Dac.DacDeployOptions]$DeployOptions
	)

	begin {
		if ($PSBoundParameters.ContainsKey('FailoverPartnerServerInstance')) {
			$ConnectionString = Build-SqlClientConnectionString -ServerInstance $ServerInstance -DatabaseName $DatabaseName -IntegratedSecurity $true
		}
	}

	process {
		try {
			$DacService = [Microsoft.SqlServer.Dac.DacServices]::New($ConnectionString)

			$DacPackage = [Microsoft.SqlServer.Dac.DacPackage]::Load($DacPacPath)

			if ($PSCmdlet.ShouldProcess($DatabaseName, "Deploying DacPac $($DacPacPath.Name)")) {
				$DacService.Deploy($DacPackage, $DatabaseName, $true, $DeployOptions, $null)
			}
		}
		catch {
			throw $_
		}
	}

	end {
	}
}

function Save-SqlClientDataSet {
	<#
	.EXTERNALHELP
	SqlServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low'
	)]

	[OutputType([SqlClient.DataSetResult])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Data.DataSet]$DataSet,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$DataSetTableName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.Data.SqlClient.SqlDataAdapter]$SqlDataAdapter
	)

	begin {
		$SqlRowUpdatingEventHandler = [Microsoft.Data.SqlClient.SqlRowUpdatingEventHandler]{
			param(
				$EventSender,
				$SqlRowUpdatingEventArgs 
			)

			switch ($SqlRowUpdatingEventArgs.StatementType) {
				'Insert' {
					$Output.InsertedRows++
				}
				'Update' {
					$Output.UpdatedRows++
				}
				'Delete' {
					$Output.DeletedRows++
				}
				Default {}
			}
		}

		$SqlRowUpdatedEventHandler = [Microsoft.Data.SqlClient.SqlRowUpdatedEventHandler]{
			param(
				$EventSender,
				$SqlRowUpdatedEventArgs 
			)

			$Script:CurrentRow += $SqlRowUpdatedEventArgs.RecordsAffected

			$ProgressParameters.Activity = [string]::Format('Row Number: {0}', $Script:CurrentRow)
			$ProgressParameters.Status = [string]::Format('Row {0} of {1}', $Script:CurrentRow, $Script:TotalChangedRows)
			$ProgressParameters.CurrentOperation = [string]::Format('Row: {0}', $Script:CurrentRow)
			$ProgressParameters.PercentComplete = $Script:CurrentRow / $Script:TotalChangedRows * 100

			Write-Verbose $ProgressParameters.CurrentOperation
			Write-Progress @ProgressParameters

			if ($null -eq $SqlRowUpdatedEventArgs.Errors) {
				if ($SqlRowUpdatedEventArgs.RowCount -ne $SqlRowUpdatedEventArgs.RecordsAffected) {
					$PSCmdlet.WriteError(
						[System.Management.Automation.ErrorRecord]::New(
							[Exception]::New("$($SqlRowUpdatedEventArgs.StatementType) resulted in fewer rows added or updated than expected."),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidResult,
							$SqlRowUpdatedEventArgs.StatementType
						)
					)

					$SqlRowUpdatedEventArgs.Status = 'ErrorsOccurred'
				}
			} else {
				# To be determined...
			}
		}

		$FillErrorEventHandler = [System.Data.FillErrorEventHandler]{
			param(
				$EventSender,
				$FillErrorEventArgs 
			)

			foreach ($ErrorObject in $FillErrorEventArgs.Errors) {
				$Output.Errors++

				$PSCmdlet.WriteError(
					$ErrorObject
				)

				foreach ($Property in $ErrorObject.PSObject.Properties) {
					Write-Host "   $($Property.Name): $($Property.Value)" -ForegroundColor Yellow
				}
			}

			$FillErrorEventArgs.Continue = $true
		}

		$ProgressParameters = @{
			'Id' = 1
			'ParentId' = 0
			'Activity' = 'Saving dataset.'
			'Status' = [string]::Format('Row {0} of {1}', 0, 1)
			'CurrentOperation' = ''
			'PercentComplete' = 0
		}
	}

	process {
		try {
			$Output = [SqlClient.DataSetResult]::New()
			$Output.UnchangedRows = $DataSet.Tables[$DataSetTableName].Rows.where({$_.RowState -eq 'Unchanged'}).Count

			$Script:CurrentRow = 0
			$Script:TotalChangedRows = $DataSet.Tables[$DataSetTableName].Rows.Count - $Output.UnchangedRows

			if (-not $PSBoundParameters.ContainsKey('SqlDataAdapter')) {
				$SqlCommandBuilder = [Microsoft.Data.SqlClient.SqlCommandBuilder]::New($SqlDataAdapter)

				$SqlDataAdapter = [Microsoft.Data.SqlClient.SqlDataAdapter]::New($DataSet.ExtendedProperties['SqlCommand'], $DataSet.ExtendedProperties['SqlConnection'])

				$SqlDataAdapter.UpdateCommand = $SqlCommandBuilder.GetUpdateCommand()
				$SqlDataAdapter.InsertCommand = $SqlCommandBuilder.GetInsertCommand()
				$SqlDataAdapter.DeleteCommand = $SqlCommandBuilder.GetDeleteCommand()
			}

			$SqlDataAdapter.add_RowUpdating($SqlRowUpdatingEventHandler)
			$SqlDataAdapter.add_RowUpdated($SqlRowUpdatedEventHandler)
			$SqlDataAdapter.add_FillError($FillErrorEventHandler)

			$SqlDataAdapter.ContinueUpdateOnError = $true

			if ($PSCmdlet.ShouldProcess($DataSet.ExtendedProperties['SqlConnection'].Database, 'Save dataset')) {
				[void]$SqlDataAdapter.Update($DataSet, $DataSetTableName)
			}

			$Output
		}
		catch {
			throw $_
		}
		finally {
			Write-Progress -Id 1 -Activity 'Import SQL Data.' -Completed

			if (Test-Path -Path variable:\SqlCommandBuilder) {
				$SqlCommandBuilder.Dispose()
			}

			if (-not $PSBoundParameters.ContainsKey('SqlDataAdapter')) {
				if (Test-Path -Path variable:\SqlDataAdapter) {
					$SqlDataAdapter.Dispose()
				}
			}
		}
	}

	end {
	}
}
#EndRegion


try {
	Add-SqlClientAssembly
	Add-SmoAssembly

	New-Alias -Name Add-SmoDatabaseEncryptionKey -Value New-SmoDatabaseEncryptionKey

	#Region Export Module Members
	Export-ModuleMember	-Alias Add-SmoDatabaseEncryptionKey
	#EndRegion
}
catch {
	throw $_
}
