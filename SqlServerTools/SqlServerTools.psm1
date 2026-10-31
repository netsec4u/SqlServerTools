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
	BrokerService
	Certificate
	ExtendedStoredProcedure
	MessageType
	Schema
	StoredProcedure
	Sequences
	ServiceContract
	ServiceQueue
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

enum SqlConnectionEncryption {
	Mandatory
	Optional
	Strict
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
		private Int16? _DeviceType;
		private string _DeviceTypeDescription = null;
		private Int16? _TimeZone;

		public string BackupName;
		public string BackupDescription;
		public Int16? BackupType;
		public string BackupTypeDescription;
		public DateTime? ExpirationDate;
		public bool? Compressed;
		public Int16 Position;
		public Int16? DeviceType
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
		public int? DatabaseVersion;
		public DateTime? DatabaseCreationDate;
		public decimal? BackupSize;
		public decimal? FirstLSN;
		public decimal? LastLSN;
		public decimal? CheckpointLSN;
		public decimal? DatabaseBackupLSN;
		public DateTime? BackupStartDate;
		public DateTime? BackupFinishDate;
		public Int16? SortOrder;
		public Int16? CodePage;
		public int? UnicodeLocaleId;
		public int? UnicodeComparisonStyle;
		public byte? CompatibilityLevel;
		public int? SoftwareVendorId;
		public int? SoftwareVersionMajor;
		public int? SoftwareVersionMinor;
		public int? SoftwareVersionBuild;
		public string MachineName;
		public int? Flags;
		public Guid? BindingID;
		public Guid? RecoveryForkID;
		public string Collation;
		public Guid? FamilyGUID;
		public bool? HasBulkLoggedData;
		public bool? IsSnapshot;
		public bool? IsReadOnly;
		public bool? IsSingleUser;
		public bool? HasBackupChecksums;
		public bool? IsDamaged;
		public bool? BeginsLogChain;
		public bool? HasIncompleteMetaData;
		public bool? IsForceOffline;
		public bool? IsCopyOnly;
		public Guid? FirstRecoveryForkID;
		public decimal? ForkPointLSN;
		public string RecoveryModel;
		public decimal? DifferentialBaseLSN;
		public Guid? DifferentialBaseGUID;
		public Guid? BackupSetGUID;
		public Int64? CompressedBackupSize;
		public Int16? containment;
		public string KeyAlgorithm;
		public Byte[] EncryptorThumbprint;
		public string EncryptorType;
		public DateTime? LastValidRestoreTime;
		public Int16? TimeZone
		{
			get
			{
				return _TimeZone;
			}
			set
			{
				if (value < -48 || value > 48 || value == 127)
				{
					_TimeZone = 0;
				}
				else
				{
					_TimeZone = (Int16)(value * 15);
				}
			}
		}
		public string CompressionAlgorithm;
	}

	public class BackupLabel
	{
		public string MediaName;
		public Guid MediaSetId;
		public int FamilyCount;
		public int FamilySequenceNumber;
		public Guid MediaFamilyId;
		public int MediaSequenceNumber;
		public byte MediaLabelPresent;
		public string MediaDescription;
		public string SoftwareName;
		public int SoftwareVendorId;
		public DateTime MediaDate;
		public int MirrorCount;
		public bool IsCompressed;
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

$ReferencedAssemblies = @(
	[AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.Smo.dll'}).Location
	[AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.SqlEnum.dll'}).Location
)

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

$TypeDefinition = @'
using System;

namespace SqlServerTools
{
	public class Backup
	{
		public string DatabaseName;
		public string BackupType;
		public int Pages;
		public int Seconds;
		public decimal MBPerSecond;
		public BackupLogicalFile[] LogicalFiles;
	}

	public class BackupLogicalFile
	{
		public string LogicalFileName;
		public int Pages;
	}

	public class DatabaseRoleMember
	{
		public string Principal;
		public Microsoft.SqlServer.Management.Smo.PrincipalType? PrincipalType;
	}

	public class Restore
	{
		public string DatabaseName;
		public string RestoreType;
		public int Pages;
		public int Seconds;
		public decimal MBPerSecond;
		public BackupLogicalFile[] LogicalFiles;
	}

	public class ServerRoleMember
	{
		public string Principal;
		public Microsoft.SqlServer.Management.Smo.PrincipalType? PrincipalType;
	}
}
'@

$ReferencedAssemblies = @(
	[AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.Smo.dll'}).Location
	[AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.SqlServer.SqlEnum.dll'}).Location
)

$TypeParameters = @{
	TypeDefinition = $TypeDefinition
	ReferencedAssemblies = $ReferencedAssemblies
	WarningAction = 'Ignore'
	IgnoreWarnings = $true
}

Add-Type @TypeParameters

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
			if ($CimSession -is [Microsoft.Management.Infrastructure.CimSession]) {
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
	SqlServerTools-Help.xml
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
			if (Test-Path -Path Variable:\UDPClient) {
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
	SqlServerTools-Help.xml
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
			if (Test-Path -Path Variable:\TcpClient) {
				$TcpClient.Dispose()
			}

			if (Test-Path -Path Variable:\SqlConnection) {
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
			if (Test-Path -Path Variable:\TcpClient) {
				$TcpClient.Dispose()
			}

			if (Test-Path -Path Variable:\SqlConnection) {
				$SqlConnection.Dispose()
			}
		}
	}

	end {
	}
}
#EndRegion

#Region SMO Functions
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($AsymmetricKeyName, 'Adding database Asymmetric key.')) {
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
	SqlServerTools-Help.xml
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
		[ValidatePathIsValid()]
		[System.IO.FileInfo][TransformPath()]$DataFilePath
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
		[ValidatePassword()]
		[SecureString]$EncryptionPassword
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Add database master key password encryption')) {
				$MasterKey.AddPasswordEncryption([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($EncryptionPassword)))
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

function Add-SmoDatabaseMasterKeyServiceKeyEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Add database master key service key encryption')) {
				$MasterKey.AddServiceKeyEncryption()
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

function Add-SmoDatabaseRoleMember {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($SymmetricKeyName, 'Add database symmetric key encryption.')) {
				$SymmetricKey.AddKeyEncryption($KeyEncryption)
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

function Add-SmoDatabaseCertificatePrivateKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
		[string]$CertificateName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePathExists('Leaf')]
		[System.IO.FileInfo][TransformPath()]$PrivateKeyPath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$Certificate = $DatabaseObject.Certificates[$CertificateName]

			if ($null -eq $Certificate) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Certificate not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$CertificateName
				)
			}

			if ($PSBoundParameters.ContainsKey('PrivateKeyEncryptionPassword')) {
				$Certificate.AddPrivateKey(
					$PrivateKeyPath,
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyDecryptionPassword)),
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyEncryptionPassword))
				)
			} else {
				$Certificate.AddPrivateKey(
					$PrivateKeyPath,
					[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PrivateKeyDecryptionPassword))
				)
			}

			if ($PSCmdlet.ShouldProcess($CertificateName, 'Add database certificate private key.')) {
				$Certificate.Alter()
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

function Add-SmoServerRoleMember {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Backup-SmoDatabase {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType(
		[string],
		[SqlServerTools.Backup]
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
		[Microsoft.SqlServer.Management.Smo.BackupSetType]$BackupType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string[]]$BackupFile,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 255)]
		[string]$BackupSetDescription,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$BackupSetName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 255)]
		[string]$MediaDescription,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$MediaName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string[]]$FileGroup,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string[]]$LogicalFile,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateSet(512, 1024, 2048, 4096, 8192, 16384, 32768, 65536)]
		[int]$BlockSize,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$BufferCount,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateScript({ $_ % 65536 -eq 0 })]
		[ValidateRange(65536, 4194304)]
		[int]$MaxTransferSize,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Checksum,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.BackupCompressionOptions]$BackupCompression,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$CopyOnly,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$RetainDays,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$TailLog,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$ScriptBackup
	)

	begin {
		Try {
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($BackupType -notin @('FileOrFileGroup', 'FileOrFileGroupDifferential')) {
				if ($PSBoundParameters.ContainsKey('FileGroup') -or $PSBoundParameters.ContainsKey('LogicalFile')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Filegroup or LogicalFile cannot be used with specified backup type.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$BackupType
					)
				}
			}

			if ($BackupType -ne 'Log' -and $TailLog) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Tail log backup is only valid for transaction log backups.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$BackupType
				)
			}

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
				if (Test-Path -Path Variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}

		$InformationEventHandler = [Microsoft.SqlServer.Management.Common.ServerMessageEventHandler] {
			# $SmoBackup = $args[0]
			$ServerMessageEventArgs =$args[1]

			if ($ServerMessageEventArgs.Error.Number -eq 4035) {
				$RegExPattern = "(?i)Processed (?<Pages>\d+) pages for database '(?<Database>[^']+)', file '(?<LogicalFile>[^']+)' on file (?<FileNumber>\d+)\."

				$RegEx = [regex]::New($RegExPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
				$RegExMatches = $RegEx.Matches($ServerMessageEventArgs.Error.Message)

				$BackupLogicalFile = [SqlServerTools.BackupLogicalFile]::New()

				$BackupLogicalFile.LogicalFileName = $RegExMatches.Groups.Where({$_.Name -eq 'LogicalFile'}).Value
				$BackupLogicalFile.Pages = $RegExMatches.Groups.Where({$_.Name -eq 'Pages'}).Value

				$script:BackupLogicalFileList.Add($BackupLogicalFile)
			} else {
				Write-Information "$($ServerMessageEventArgs.Error.Number) - $($ServerMessageEventArgs.Error.Message)"
			}
		}

		$PercentCompleteEventHandler = [Microsoft.SqlServer.Management.Smo.PercentCompleteEventHandler] {
			$SmoBackup = $args[0]
			$ServerMessageEventArgs =$args[1]

			$ProgressParameters = @{
				'Id' = 0
				'Activity' = 'SQL Backup Progress'
				'Status' = "Backup $($SmoBackup.Database) - $($ServerMessageEventArgs.Message)"
				'CurrentOperation' = "Database: $($SmoBackup.Database)"
				'PercentComplete' = $ServerMessageEventArgs.Percent
			}

			Write-Progress @ProgressParameters
		}

		$ServerMessageEventHandler = [Microsoft.SqlServer.Management.Common.ServerMessageEventHandler] {
			$SmoBackup = $args[0]
			$ServerMessageEventArgs =$args[1]

			if ($ServerMessageEventArgs.Error.Number -eq 3014) {
				$RegExPattern = '(?<Start>\sprocessed\s)(?<Pages>\d{1,})\spages\sin\s(?<Seconds>(\d{1,}(\.\d{1,})?))\sseconds\s\((?<MBPerSecond>(\d{1,}(\.\d{1,})?)).*'

				$RegEx = [regex]::New($RegExPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
				$RegExMatches = $RegEx.Matches($ServerMessageEventArgs.Error.Message)

				$Backup = [SqlServerTools.Backup]::New()

				$Backup.DatabaseName = $SmoBackup.Database

				switch ($SmoBackup.Action) {
					'Database' {
						if ($SmoBackup.DatabaseFiles.Count -gt 0 -or $SmoBackup.DatabaseFileGroups.Count -gt 0) {
							if ($SmoBackup.Incremental) {
								$Backup.BackupType = 'Differential Partial'
							} else {
								$Backup.BackupType = 'Partial'
							}
						} else {
							if ($SmoBackup.Incremental) {
								$Backup.BackupType = 'Database Differential'
							} else {
								$Backup.BackupType = 'Database'
							}
						}
					}
					'Files' {
						if ($SmoBackup.Incremental) {
							$Backup.BackupType = 'Differential File'
						} else {
							$Backup.BackupType = 'File'
						}
					}
					'Log' {
						$Backup.BackupType = 'Transaction Log'
					}
				}

				$Backup.Pages = $RegExMatches.Groups.Where({$_.Name -eq 'Pages'}).Value
				$Backup.Seconds = $RegExMatches.Groups.Where({$_.Name -eq 'Seconds'}).Value
				$Backup.MBPerSecond = $RegExMatches.Groups.Where({$_.Name -eq 'MBPerSecond'}).Value
				$Backup.LogicalFiles = $script:BackupLogicalFileList

				$script:Output = $Backup
			} else {
				Write-Error "$($ServerMessageEventArgs.Error.Number) - $($ServerMessageEventArgs.Error.Message)"

				$script:Output = $null
			}
		}
	}

	process {
		try {
			$script:BackupLogicalFileList = [System.Collections.Generic.List[SqlServerTools.BackupLogicalFile]]::New()

			$SmoBackup = [Microsoft.SqlServer.Management.Smo.Backup]::New()

			$SmoBackup.PercentCompleteNotification = 5

			switch ($BackupType) {
				{$_ -in @('Database', 'Differential')} {
					$SmoBackup.Action = [Microsoft.SqlServer.Management.Smo.BackupActionType]::Database
				}
				{$_ -in @('FileOrFileGroup', 'FileOrFileGroupDifferential')} {
					$SmoBackup.Action = [Microsoft.SqlServer.Management.Smo.BackupActionType]::Files

					if ($PSBoundParameters.ContainsKey('FileGroup')) {
						foreach ($Item in $FileGroup) {
							[void]$($SmoBackup.DatabaseFileGroups.Add($Item))
						}
					} elseif ($PSBoundParameters.ContainsKey('LogicalFile')) {
						foreach ($Item in $LogicalFile) {
							[void]$($SmoBackup.DatabaseFiles.Add($Item))
						}
					} else {
						foreach ($FileGroup in $DatabaseObject.FileGroups.Name) {
							[void]$($SmoBackup.DatabaseFileGroups.Add($FileGroup))
						}
					}
				}
				'Log' {
					$SmoBackup.Action = [Microsoft.SqlServer.Management.Smo.BackupActionType]::Log

					if ($TailLog) {
						$SmoBackup.NoRecovery = $true
					}
				}
			}

			if ($BackupType -in @('Differential', 'FileOrFileGroupDifferential')) {
				if($CopyOnly) { Write-Warning 'CopyOnly parameter is ignored when performing Differential backups.'}

				$SmoBackup.Incremental = $true
			}

			if ($PSBoundParameters.ContainsKey('CopyOnly')) {
				$SmoBackup.CopyOnly = $CopyOnly
			}

			foreach ($File in $BackupFile) {
				$SmoBackupDeviceItem = [Microsoft.SqlServer.Management.SMO.BackupDeviceItem]::New($File, [Microsoft.SqlServer.Management.SMO.DeviceType]::File)

				$SmoBackup.Devices.Add($SmoBackupDeviceItem)
			}

			$SmoBackup.Database = $DatabaseObject.Name

			if ($PSBoundParameters.ContainsKey('BackupSetDescription')) {
				$SmoBackup.BackupSetDescription = $BackupSetDescription
			} else {
				$SmoBackup.BackupSetDescription = [string]::Format('{0} backup of {1}', $BackupType, $DatabaseObject.Name)
			}

			if ($PSBoundParameters.ContainsKey('BackupSetName')) {
				$SmoBackup.BackupSetName = $BackupSetName
			} else {
				$SmoBackup.BackupSetName = [string]::Format('{0} {1}', $Database.Name, $BackupTimestamp)
			}

			if ($PSBoundParameters.ContainsKey('MediaDescription')) {
				$SmoBackup.MediaDescription = $MediaDescription
			} else {
				$SmoBackup.MediaDescription = [string]::Format('{0} database backup of {1}', $BackupType, $Database.Name)
			}

			if ($PSBoundParameters.ContainsKey('MediaName')) {
				$SmoBackup.MediaName = $MediaName
			} else {
				$SmoBackup.MediaName = [string]::Format('{0} Backup', $Database.Name)
			}

			if ($PSBoundParameters.ContainsKey('BackupCompression')) {
				$SmoBackup.CompressionOption = $BackupCompression
			} else {
				$SmoBackup.CompressionOption = [Microsoft.SqlServer.Management.Smo.BackupCompressionOptions]::Default
			}

			if ($PSBoundParameters.ContainsKey('BlockSize')) {
				$SmoBackup.BlockSize = $BlockSize
			}

			if ($PSBoundParameters.ContainsKey('BufferCount')) {
				$SmoBackup.BufferCount = $BufferCount
			}

			if ($PSBoundParameters.ContainsKey('MaxTransferSize')) {
				$SmoBackup.MaxTransferSize = $MaxTransferSize
			}
			else {
				$SmoBackup.MaxTransferSize = 1048576
			}

			if ($PSBoundParameters.ContainsKey('Checksum')) {
				$SmoBackup.Checksum = $Checksum
			} else {
				$SmoBackup.Checksum = [bool]$DatabaseObject.Parent.Configuration.DefaultBackupChecksum.RunValue
			}

			if ($PSBoundParameters.ContainsKey('RetainDays')) {
				$SmoBackup.RetainDays = $RetainDays
			} else {
				$SmoBackup.RetainDays = $DatabaseObject.Parent.Configuration.MediaRetention.RunValue
			}

			$SmoBackup.add_PercentComplete($PercentCompleteEventHandler)
			$SmoBackup.add_Information($InformationEventHandler)
			$SmoBackup.add_Complete($ServerMessageEventHandler)

			if ($ScriptBackup) {
				if ($PSCmdlet.ShouldProcess($DatabaseObject.Name, "Script $BackupType backup")) {
					$SmoBackup.Script($DatabaseObject.Parent)
				}
			} else {
				if ($PSCmdlet.ShouldProcess($DatabaseObject.Name, "$BackupType backup")) {
					$SmoBackup.SqlBackup($DatabaseObject.Parent)

					$script:Output
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			$SmoBackup.remove_PercentComplete($PercentCompleteEventHandler)
			$SmoBackup.remove_Information($InformationEventHandler)
			$SmoBackup.remove_Complete($ServerMessageEventHandler)

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Clear-SmoDatabaseQueryStore {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$QueryStoreOptions = $DatabaseObject.QueryStoreOptions

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Disabling Query Store')) {
				$QueryStoreOptions.PurgeQueryStoreData()
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

function Close-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
	SqlServerTools-Help.xml
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
	SqlServerTools-Help.xml
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

function Disable-SmoDatabaseQueryStore {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$QueryStoreOptions = $DatabaseObject.QueryStoreOptions

			$QueryStoreOptions.DesiredState = [Microsoft.SqlServer.Management.Smo.QueryStoreOperationMode]::Off

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Disabling Query Store')) {
				$QueryStoreOptions.PurgeQueryStoreData()

				$QueryStoreOptions.Alter()
				$QueryStoreOptions.Refresh()
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

function Disable-SmoTransparentDatabaseEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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

function Enable-SmoDatabaseQueryStore {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$QueryStoreOptions = $DatabaseObject.QueryStoreOptions

			$QueryStoreOptions.DesiredState = [Microsoft.SqlServer.Management.Smo.QueryStoreOperationMode]::ReadWrite
			$QueryStoreOptions.QueryCaptureMode = [Microsoft.SqlServer.Management.Smo.QueryStoreCaptureMode]::Auto
			$QueryStoreOptions.MaxPlansPerQuery = 200
			$QueryStoreOptions.MaxStorageSizeInMB = 2048
			$QueryStoreOptions.StaleQueryThresholdInDays = 30
			$QueryStoreOptions.SizeBasedCleanupMode = [Microsoft.SqlServer.Management.Smo.QueryStoreSizeBasedCleanupMode]::Auto
			$QueryStoreOptions.StatisticsCollectionIntervalInMinutes = 60
			$QueryStoreOptions.DataFlushIntervalInSeconds = 900
			$QueryStoreOptions.WaitStatsCaptureMode = [Microsoft.SqlServer.Management.Smo.QueryStoreWaitStatsCaptureMode]::On
			$QueryStoreOptions.CapturePolicyStaleThresholdInHrs = 24
			$QueryStoreOptions.CapturePolicyExecutionCount = 30
			$QueryStoreOptions.CapturePolicyTotalCompileCpuTimeInMS = 1000
			$QueryStoreOptions.CapturePolicyTotalExecutionCpuTimeInMS = 100

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Enabling Query Store')) {
				$QueryStoreOptions.Alter()
				$QueryStoreOptions.Refresh()
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

function Enable-SmoTransparentDatabaseEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
		[System.IO.FileInfo][TransformPath()]$CertificatePath,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $ServerInstance
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			$SmoRestore.Devices.AddDevice($DatabaseBackupPath, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $ServerInstance
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			$SmoRestore.Devices.AddDevice($DatabaseBackupPath, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoBackupLabel {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SmoRestore.BackupLabel])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $ServerInstance
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			$SmoRestore.Devices.AddDevice($DatabaseBackupPath, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

			$MediaHeaders = $SmoRestore.ReadMediaHeader($SmoServerObject)

			foreach ($Row in $MediaHeaders.Rows) {
				$SmoBackupLabel = [SmoRestore.BackupLabel]::New()

				foreach ($Column in $MediaHeaders.Columns) {
					if ($Row.item($Column) -IsNot [DBNull]) {
						$SmoBackupLabel.$($Column.ColumnName) = $Row.item($Column)
					}
				}

				$SmoBackupLabel
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseDataFile {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.DataFile])]

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
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DataFileName

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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$FileGroupObject = $DatabaseObject.FileGroups[$FileGroupName]

			if ($null -eq $FileGroupObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('File group not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$FileGroupName
				)
			}

			if ($PSBoundParameters.ContainsKey('DataFileName')) {
				$FileGroupObject.Files[$DataFileName]
			} else {
				$FileGroupObject.Files
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

function Get-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseFileGroup {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.FileGroup])]

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
		[string]$FileGroupName
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSBoundParameters.ContainsKey('FileGroupName')) {
				$DatabaseObject.FileGroups[$FileGroupName]
			} else {
				$DatabaseObject.FileGroups
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

function Get-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')
			$SmoServerParameterSets = @('SmoServer')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}

			if ($PSCmdlet.ParameterSetName -in $SmoServerParameterSets) {
				if (-not $PSBoundParameters.ContainsKey('DatabaseName')) {
					$DatabaseName = $SmoServerObject.ConnectionContext.CurrentDatabase
				}
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseQueryStore {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.QueryStoreOptions])]

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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$DatabaseObject.QueryStoreOptions
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

function Get-SmoDatabaseRole {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.DatabaseRole])]

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
		[string]$RoleName
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSBoundParameters.ContainsKey('RoleName')) {
				$DatabaseObject.Roles[$RoleName]
			} else {
				$DatabaseObject.Roles
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

function Get-SmoDatabaseRoleMember {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([SqlServerTools.DatabaseRoleMember])]

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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$Role = $DatabaseObject.Roles[$RoleName]

			if ($null -ne $Role) {
				$RoleMembers = $Role.EnumMembers()
			}
			else {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database role not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$RoleName
				)
			}

			foreach ($RoleMember in $RoleMembers) {
				$DatabaseRoleMember = [SqlServerTools.DatabaseRoleMember]::New()

				$DatabaseRoleMember.Principal = $RoleMember

				if ($DatabaseObject.Users[$RoleMember] -is [Microsoft.SqlServer.Management.Smo.User]) {
					$DatabaseRoleMember.PrincipalType = [Microsoft.SqlServer.Management.Smo.PrincipalType]::User
				} elseif ($DatabaseObject.Roles[$RoleMember] -is [Microsoft.SqlServer.Management.Smo.Role]) {
					$DatabaseRoleMember.PrincipalType = [Microsoft.SqlServer.Management.Smo.PrincipalType]::DatabaseRole
				} else {
					$DatabaseRoleMember.PrincipalType = $null
				}

				$DatabaseRoleMember
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

function Get-SmoDatabaseSchema {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Schema])]

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
		[string]$SchemaName
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSBoundParameters.ContainsKey('SchemaName')) {
				$DatabaseObject.Schemas[$SchemaName]
			} else {
				$DatabaseObject.Schemas
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

function Get-SmoDatabaseSymmetricKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Get-SmoDatabaseSymmetricKeyKeyEncryption {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Data.DataRow])]

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
		[string]$SymmetricKeyName
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			$SymmetricKey.EnumKeyEncryptions()
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

function Get-SmoDatabaseUser {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.User])]

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
		[string]$UserName
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSBoundParameters.ContainsKey('UserName')) {
				$DatabaseObject.Users[$UserName]
			} else {
				$DatabaseObject.Users
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

function Get-SmoServerRole {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
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
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$RoleName
	)

	begin {
		Try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSBoundParameters.ContainsKey('RoleName')) {
				$ServerRoles = $SmoServerObject.Roles[$RoleName]
			} else {
				$ServerRoles = $SmoServerObject.Roles
			}

			$ServerRoles
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoServerRoleMember {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SqlServerTools.ServerRoleMember])]

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
		[string]$RoleName
	)

	begin {
		Try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			$ServerRole = $SmoServerObject.Roles[$RoleName]

			if ($null -ne $ServerRole) {
				$RoleMembers = $ServerRole.EnumMemberNames()
			}
			else {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Server role not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$RoleName
				)
			}

			foreach ($RoleMember in $RoleMembers) {
				$ServerRoleMember = [SqlServerTools.ServerRoleMember]::New()

				$ServerRoleMember.Principal = $RoleMember

				if ($SmoServerObject.Logins[$RoleMember] -is [Microsoft.SqlServer.Management.Smo.Login]) {
					$ServerRoleMember.PrincipalType = [Microsoft.SqlServer.Management.Smo.PrincipalType]::Login
				} elseif ($SmoServerObject.Roles[$RoleMember] -is [Microsoft.SqlServer.Management.Smo.ServerRole]) {
					$ServerRoleMember.PrincipalType = [Microsoft.SqlServer.Management.Smo.PrincipalType]::ServerRole
				} else {
					$ServerRoleMember.PrincipalType = $null
				}

				$ServerRoleMember
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Get-SmoSqlLogin {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
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
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$LoginName
	)

	begin {
		Try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSBoundParameters.ContainsKey('LoginName')) {
				$SmoLogin = $SmoServerObject.Logins[$LoginName]
			} else {
				$SmoLogin = $SmoServerObject.Logins
			}

			$SmoLogin
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Import-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName_CommandText', 'DatabaseName_InputFile')

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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($AsymmetricKeyName, 'Creating database asymmetric key.')) {
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
	SqlServerTools-Help.xml
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
		try {
			$DatabaseNameParameterSets = @('DatabaseName', 'DatabaseName-CertFile', 'DatabaseName-CertFileWithKey')
			$CertFileParameterSets = @('DatabaseName-CertFile', 'DatabaseName-CertFileWithKey', 'DatabaseObject-CertFile', 'DatabaseObject-CertFileWithKey')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}

			if ($DatabaseObject.Parent.ConnectionContext.LoginSecure) {
				if ($PSBoundParameters.ContainsKey('CertificatePath')) {
					if (([System.Uri]$CertificatePath.FullName).IsUnc) {
						Write-Warning -Message 'The certificate path is a UNC path. UNC paths may require Kerberos Constrained Delegation to access the file from the SQL Server instance.'
					}
				}

				if ($PSBoundParameters.ContainsKey('PrivateKeyPath')) {
					if (([System.Uri]$PrivateKeyPath.FullName).IsUnc) {
						Write-Warning -Message 'The private key path is a UNC path. UNC paths may require Kerberos Constrained Delegation to access the file from the SQL Server instance.'
					}
				}
			}
		}
		catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($CertificateName, 'Creating database certificate.')) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.FileGroupType]$FileGroupType = [Microsoft.SqlServer.Management.Smo.FileGroupType]::RowsFileGroup
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

				$FileGroupObject.FileGroupType = $FileGroupType

				$FileGroupObject.Create()

				$FileGroupObject
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

function New-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
		[ValidatePathExists('Leaf')]
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($SymmetricKeyName, 'Creating database symmetric key.')) {
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
	SqlServerTools-Help.xml
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
		[ValidatePassword()]
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

			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function New-SmoSqlLogin {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_SqlLogin'
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
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer_SqlLogin'
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
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_SqlLogin'
		)]
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer_SqlLogin'
		)]
		[ValidatePassword()]
		[System.Security.SecureString]$Password,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_SqlLogin'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer_SqlLogin'
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
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_SqlLogin'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer_SqlLogin'
		)]
		[byte[]][TransformSidByteArray()]$Sid,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_SqlLogin'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer_SqlLogin'
		)]
		[bool]$PasswordExpirationEnabled = $true,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_SqlLogin'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer_SqlLogin'
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
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'ServerInstance_SqlLogin'
		)]
		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'SmoServer_SqlLogin'
		)]
		[bool]$MustChangePassword = $false
	)

	begin {
		try {
			if ($LoginType -NotIn ('SqlLogin', 'WindowsGroup', 'WindowsUser')) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Login type not supported.'),
					'1',
					[System.Management.Automation.ErrorCategory]::NotImplemented,
					$LoginType
				)
			}

			if ($LoginType -eq 'SqlLogin') {
				if (-not $PSBoundParameters.ContainsKey('Password')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Password is required for SQL logins.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidArgument,
						$LoginType
					)
				}
			}

			$ServerInstanceParameterSets = @('ServerInstance', 'ServerInstance_SqlLogin')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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

			if ($LoginType -eq 'SqlLogin') {
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
			}

			if ($PSCmdlet.ShouldProcess($SmoServerObject.name, "Creating login $LoginName.")) {
				if ($LoginType -eq 'SqlLogin') {
					$SmoLogin.Create($Password, $LoginCreateOptions)
				} else {
					$SmoLogin.Create()
				}

				if ($LoginDisabled) {
					$SmoLogin.Disable()
				}

				$SmoLogin
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Open-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
	SqlServerTools-Help.xml
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

function Remove-SmoCredential {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($AsymmetricKeyName, 'Removing database Asymmetric key.')) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseDataFile {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DataFileName
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$FileGroupObject = $DatabaseObject.FileGroups[$FileGroupName]

			if ($null -eq $FileGroupObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('File group not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$FileGroupName
				)
			}

			$DataFileObject = $FileGroupObject.Files[$DataFileName]

			if ($null -eq $DataFileObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Data file not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DataFileName
				)
			}

			if ($PSCmdlet.ShouldProcess($DataFileName, 'Removing database datafile.')) {
				$DataFileObject.Drop()
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

function Remove-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Remove-SmoDatabaseFileGroup {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
		[string]$FileGroupName
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$FileGroupObject = $DatabaseObject.FileGroups[$FileGroupName]

			if ($null -eq $FileGroupObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('File group not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$FileGroupName
				)
			}

			if ($PSCmdlet.ShouldProcess($FileGroupName, 'Removing database file group.')) {
				$FileGroupObject.Drop()
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

function Remove-SmoDatabaseMasterKey {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($SymmetricKeyName, 'Remove database symmetric key encryption.')) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if (Test-Path -Path Variable:\OldPath) {
				$LogFileObject.FileName = $OldPath

				$DatabaseObject.Alter()
			}

			throw $_
		}
		finally {
			$DatabaseObject.SetOnline()

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Restore-SmoDatabase {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType(
		[string],
		[SqlServerTools.Restore]
	)]

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
		[Microsoft.SqlServer.Management.SMO.RestoreActionType]$RestoreActionType,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string[]]$BackupFile,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string[]]$DatabasePage,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string[]]$FileGroup,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string[]]$LogicalFile,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.RelocateFile[]]$RelocateFile,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$NoRecovery,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.IO.FileInfo]$StandByFile,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$ReplaceDatabase,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$RestrictedUser,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$BackupSetFileNumber,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$MediaName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateSet(512, 1024, 2048, 4096, 8192, 16384, 32768, 65536)]
		[int]$BlockSize,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$BufferCount,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateScript({ $_ % 65536 -eq 0 })]
		[ValidateRange(65536, 4194304)]
		[int]$MaxTransferSize,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Checksum,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$KeepReplication,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$KeepTemporalRetention,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.DateTime]$ToPointInTime,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$StopAtMarkName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.DateTime]$StopAtMarkAfterDate,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$StopBeforeMarkName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.DateTime]$StopBeforeMarkAfterDate,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$ScriptRestore
	)

	begin {
		Try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSBoundParameters.ContainsKey('DatabasePages')) {
				if ($RestoreActionType -notin @('OnlinePage')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('DatabasePages not valid with RestoreActionType.  DatabasePages can be used with OnlinePage restore action.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('FileGroup')) {
				if ($RestoreActionType -notin @('Files', 'Log', 'OnlineFiles', 'OnlinePage')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('FileGroup not valid with RestoreActionType.  FileGroup can be used with Files, Log, OnlineFiles, OnlinePage restore actions.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('KeepReplication')) {
				if ($RestoreActionType -notin @('Database', 'Files', 'Log')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('KeepReplication not valid with RestoreActionType.  KeepReplication can be used with Database, Files, Log restore actions.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('KeepTemporalRetention')) {
				if ($RestoreActionType -notin @('Database', 'Files', 'Log', 'OnlineFiles')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('KeepTemporalRetention not valid with RestoreActionType.  KeepTemporalRetention can be used with Database, Files, Log, OnlineFiles restore actions.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('RelocateFile')) {
				if ($RestoreActionType -notin @('Database', 'Files', 'OnlineFiles')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('RelocateFile not valid with RestoreActionType.  RelocateFile can be used with Database, Files, OnlineFiles restore actions.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('ReplaceDatabase')) {
				if ($RestoreActionType -notin @('Database', 'Files')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('ReplaceDatabase not valid with RestoreActionType.  ReplaceDatabase can be used with Database, Files restore actions.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('StandByFile')) {
				if ($RestoreActionType -notin @('Database', 'Log')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('StandByFile not valid with RestoreActionType.  StandByFile can be used with Database, Log restore actions.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('StopAtMarkAfterDate')) {
				if ($RestoreActionType -notin @('Log')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('StopAtMarkAfterDate not valid with RestoreActionType.  StopAtMarkAfterDate can be used with Log restore action.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('StopAtMarkName')) {
				if ($RestoreActionType -notin @('Log')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('StopAtMarkName not valid with RestoreActionType.  StopAtMarkName can be used with Log restore action.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('StopBeforeMarkAfterDate')) {
				if ($RestoreActionType -notin @('Log')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('StopBeforeMarkAfterDate not valid with RestoreActionType.  StopBeforeMarkAfterDate can be used with Log restore action.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('StopBeforeMarkName')) {
				if ($RestoreActionType -notin @('Log')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('StopBeforeMarkName not valid with RestoreActionType.  StopBeforeMarkName can be used with Log restore action.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSBoundParameters.ContainsKey('ToPointInTime')) {
				if ($RestoreActionType -notin @('Log')) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('ToPointInTime not valid with RestoreActionType.  ToPointInTime can be used with Log restore action.'),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidOperation,
						$RestoreActionType
					)
				}
			}

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}

			if ($RestoreActionType -in @('OnlineFiles', 'OnlinePage')) {
				if ($DatabaseName -notin $SmoServerObject.Databases.Name) {
					throw [System.Management.Automation.ErrorRecord]::New(
						[Exception]::New('Database does not exist.'),
						'1',
						[System.Management.Automation.ErrorCategory]::ObjectNotFound,
						$DatabaseName
					)
				}
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
					if ($DatabaseObject -is [Microsoft.SqlServer.Management.Smo.Database]) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}

		$InformationEventHandler = [Microsoft.SqlServer.Management.Common.ServerMessageEventHandler] {
			# $SmoRestore = $args[0]
			$ServerMessageEventArgs =$args[1]

			if ($ServerMessageEventArgs.Error.Number -eq 4035) {
				$RegExPattern = "(?i)Processed (?<Pages>\d+) pages for database '(?<Database>[^']+)', file '(?<LogicalFile>[^']+)' on file (?<FileNumber>\d+)\."

				$RegEx = [regex]::New($RegExPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
				$RegExMatches = $RegEx.Matches($ServerMessageEventArgs.Error.Message)

				$BackupLogicalFile = [SqlServerTools.BackupLogicalFile]::New()

				$BackupLogicalFile.LogicalFileName = $RegExMatches.Groups.Where({$_.Name -eq 'LogicalFile'}).Value
				$BackupLogicalFile.Pages = $RegExMatches.Groups.Where({$_.Name -eq 'Pages'}).Value

				$script:BackupLogicalFileList.Add($BackupLogicalFile)
			} else {
				Write-Information "$($ServerMessageEventArgs.Error.Number) - $($ServerMessageEventArgs.Error.Message)"
			}
		}

		$PercentCompleteEventHandler = [Microsoft.SqlServer.Management.Smo.PercentCompleteEventHandler] {
			$SmoRestore = $args[0]
			$ServerMessageEventArgs =$args[1]

			$ProgressParameters = @{
				'Id' = 0
				'Activity' = 'SQL Restore Progress'
				'Status' = "Restore $($SmoRestore.Database) - $($ServerMessageEventArgs.Message)"
				'CurrentOperation' = "Database: $($SmoRestore.Database)"
				'PercentComplete' = $ServerMessageEventArgs.Percent
			}

			Write-Progress @ProgressParameters
		}

		$ServerMessageEventHandler = [Microsoft.SqlServer.Management.Common.ServerMessageEventHandler] {
			$SmoRestore = $args[0]
			$ServerMessageEventArgs =$args[1]

			if ($ServerMessageEventArgs.Error.Number -eq 3014) {
				$RegExPattern = '(?<Start>\sprocessed\s)(?<Pages>\d{1,})\spages\sin\s(?<Seconds>(\d{1,}(\.\d{1,})?))\sseconds\s\((?<MBPerSecond>(\d{1,}(\.\d{1,})?)).*'

				$RegEx = [regex]::New($RegExPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
				$RegExMatches = $RegEx.Matches($ServerMessageEventArgs.Error.Message)

				$Restore = [SqlServerTools.Restore]::New()

				$Restore.DatabaseName = $SmoRestore.Database
				$Restore.RestoreType = $SmoRestore.Action
				$Restore.Pages = $RegExMatches.Groups.Where({$_.Name -eq 'Pages'}).Value
				$Restore.Seconds = $RegExMatches.Groups.Where({$_.Name -eq 'Seconds'}).Value
				$Restore.MBPerSecond = $RegExMatches.Groups.Where({$_.Name -eq 'MBPerSecond'}).Value
				$Restore.LogicalFiles = $script:BackupLogicalFileList

				$script:Output = $Restore
			} else {
				Write-Error "$($ServerMessageEventArgs.Error.Number) - $($ServerMessageEventArgs.Error.Message)"

				$script:Output = $null
			}
		}
	}

	process {
		try {
			$script:BackupLogicalFileList = [System.Collections.Generic.List[SqlServerTools.BackupLogicalFile]]::New()

			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			$SmoRestore.Database = $DatabaseName
			$SmoRestore.Action = $RestoreActionType

			$SmoRestore.KeepReplication = $KeepReplication
			$SmoRestore.KeepTemporalRetention = $KeepTemporalRetention
			$SmoRestore.NoRecovery = $NoRecovery
			$SmoRestore.PercentCompleteNotification = 5
			$SmoRestore.RestrictedUser = $RestrictedUser

			foreach ($File in $BackupFile) {
				$SmoBackupDeviceItem = [Microsoft.SqlServer.Management.SMO.BackupDeviceItem]::New($File, [Microsoft.SqlServer.Management.SMO.DeviceType]::File)

				$SmoRestore.Devices.Add($SmoBackupDeviceItem)
			}

			if ($PSBoundParameters.ContainsKey('BackupSetFileNumber')) {
				$SmoRestore.FileNumber = $BackupSetFileNumber
			}

			if ($PSBoundParameters.ContainsKey('BlockSize')) {
				$SmoRestore.BlockSize = $BlockSize
			}

			if ($PSBoundParameters.ContainsKey('BufferCount')) {
				$SmoRestore.BufferCount = $BufferCount
			}

			if ($PSBoundParameters.ContainsKey('Checksum')) {
				$SmoRestore.Checksum = $Checksum
			} else {
				$SmoRestore.Checksum = [bool]$SmoServer.Configuration.DefaultBackupChecksum.RunValue
			}

			if ($PSBoundParameters.ContainsKey('MaxTransferSize')) {
				$SmoRestore.MaxTransferSize = $MaxTransferSize
			}
			else {
				$SmoRestore.MaxTransferSize = 1048576
			}

			if ($PSBoundParameters.ContainsKey('MediaName')) {
				$SmoRestore.MediaName = $MediaName
			}

			if ($PSBoundParameters.ContainsKey('StandByFile')) {
				$SmoRestore.StandbyFile = $StandByFile
			}

			switch ($RestoreActionType) {
				'Database' {
					if ($PSBoundParameters.ContainsKey('RelocateFiles')) {
						foreach ($File in $RelocateFile) {
							$RelocateFileFile = [Microsoft.SqlServer.Management.Smo.RelocateFile]::New()

							$RelocateFileFile.LogicalFileName = $File.LogicalName
							$RelocateFileFile.PhysicalFileName = $file.PhysicalName

							[void]$SmoRestore.RelocateFiles.Add($RelocateFileFile)
						}
					} else {
						$FileList = Get-SmoBackupFileList -SmoServerObject $SmoServerObject -DatabaseBackupPath $BackupFile[0]

						foreach ($File in $FileList) {
							switch ($File.Type) {
								'D' {
									$Folder = $SmoServerObject.DefaultFile

									if ($File.FileGroupId -eq 1) {
										$Extension = '.mdf'
									} else {
										$Extension = '.ndf'
									}

									if ($File.FileId -eq 1) {
										$NewFileName = [string]::Format('{0}_{1}{2}', $DatabaseName, $File.FileGroupName, $Extension)
									} else {
										$NewFileName = [string]::Format('{0}_{1}{2}{3}', $DatabaseName, $File.FileGroupName, $File.FileId, $Extension)
									}
								}
								'L' {
									$Folder = $SmoServerObject.DefaultLog
									$NewFileName = [string]::Format('{0}_log.ldf', $DatabaseName, $File.FileGroupName)
								}
								Default {
									throw [System.Management.Automation.ErrorRecord]::New(
										[Exception]::New('File type not supported.'),
										'1',
										[System.Management.Automation.ErrorCategory]::NotImplemented,
										$File.Type
									)
								}
							}

							$RelocateFileFile = [Microsoft.SqlServer.Management.Smo.RelocateFile]::New()

							$RelocateFileFile.LogicalFileName = $File.LogicalName
							$RelocateFileFile.PhysicalFileName = [System.IO.Path]::Combine($Folder, $NewFileName)

							[void]$SmoRestore.RelocateFiles.Add($RelocateFileFile)
						}
					}

					$SmoRestore.ReplaceDatabase = $ReplaceDatabase
				}
				'Files' {
					if ($PSBoundParameters.ContainsKey('FileGroup')) {
						foreach ($Item in $FileGroup) {
							[void]$($SmoBackup.DatabaseFileGroups.Add($Item))
						}
					}

					if ($PSBoundParameters.ContainsKey('LogicalFile')) {
						foreach ($Item in $LogicalFile) {
							[void]$($SmoBackup.DatabaseFiles.Add($Item))
						}
					}

					$SmoRestore.ReplaceDatabase = $ReplaceDatabase
				}
				'Log' {
					if ($PSBoundParameters.ContainsKey('ToPointInTime')) {
						$SmoRestore.ToPointInTime = $ToPointInTime
					}

					if ($PSCmdlet.ParameterSetName -eq 'Restore-StopAtMarkName') {
						$SmoRestore.StopAtMarkName = $StopAtMarkName

						if ($PSBoundParameters.ContainsKey('StopAtMarkAfterDate')) {
							$SmoRestore.StopAtMarkAfterDate = $StopAtMarkAfterDate
						}
					}

					if ($PSCmdlet.ParameterSetName -eq 'Restore-StopBeforeMarkName') {
						$SmoRestore.StopBeforeMarkName = $StopBeforeMarkName

						if ($PSBoundParameters.ContainsKey('StopBeforeMarkAfterDate')) {
							$SmoRestore.StopBeforeMarkAfterDate = $StopBeforeMarkAfterDate
						}
					}
				}
				'OnlineFiles' {
					if ($PSBoundParameters.ContainsKey('FileGroup')) {
						foreach ($Item in $FileGroup) {
							[void]$($SmoBackup.DatabaseFileGroups.Add($Item))
						}
					}

					if ($PSBoundParameters.ContainsKey('LogicalFile')) {
						foreach ($Item in $LogicalFile) {
							[void]$($SmoBackup.DatabaseFiles.Add($Item))
						}
					}

					$SmoRestore.NoRecovery = $NoRecovery
				}
				'OnlinePage' {
					if ($PSBoundParameters.ContainsKey('DatabasePage')) {
						foreach ($Item in $DatabasePage) {
							$SmoSuspectPage =[Microsoft.SqlServer.Management.Smo.SuspectPage]::New($Item.Split(':')[0], $Item.Split(':')[1])

							$SmoRestore.DatabasePages.Add($SmoSuspectPage)
						}
					} else {
						$SuspectPageTable = $SmoRestore.ReadSuspectPageTable($SmoServerObject)

						$SuspectPages = $SuspectPageTable.where({$_.database_id -eq $SmoServerObject.Databases[$DatabaseName].Id -and $_.event_type -in @(1, 2, 3)})

						if ($SuspectPages.Count -eq 0) {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('No suspect pages found.'),
								'1',
								[System.Management.Automation.ErrorCategory]::InvalidResult,
								$null
							)
						}

						foreach ($SuspectPage in $SuspectPages) {
							$SmoSuspectPage =[Microsoft.SqlServer.Management.Smo.SuspectPage]::New($SuspectPage.FileId, $SuspectPage.PageId)

							$SmoRestore.DatabasePages.Add($SmoSuspectPage)
						}
					}

					# $PageRestorePlanner = [Microsoft.SqlServer.Management.Smo.PageRestorePlanner]::New($SmoServerObject.Databases[$DatabaseName])
					# $PageRestorePlanner.SqlRestore($SmoServerObject, $SmoRestore)
				}
			}

			$SmoRestore.add_PercentComplete($PercentCompleteEventHandler)
			$SmoRestore.add_Information($InformationEventHandler)
			$SmoRestore.add_Complete($ServerMessageEventHandler)

			if ($ScriptRestore) {
				if ($PSCmdlet.ShouldProcess($DatabaseName, "Script $RestoreActionType restore")) {
					$SmoRestore.Script($SmoServerObject)
				}
			} else {
				if ($PSCmdlet.ShouldProcess($DatabaseName, "$RestoreActionType restore")) {
					$SmoRestore.SqlRestore($SmoServerObject)

					$script:Output
				}
			}
		}
		catch {
			throw $_
		}
		finally {
			$SmoRestore.remove_PercentComplete($PercentCompleteEventHandler)
			$SmoRestore.remove_Information($InformationEventHandler)
			$SmoRestore.remove_Complete($ServerMessageEventHandler)

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($AsymmetricKeyName, 'Updating database Asymmetric key.')) {
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

			if ($PSCmdlet.ShouldProcess($CertificateName, 'Updating database certificate.')) {
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

function Set-SmoDatabaseDataFile {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$DataFileName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		$NewDataFileName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[int]$Growth,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.FileGrowthType]$GrowthType,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[int]$MaxSize
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$FileGroupObject = $DatabaseObject.FileGroups[$FileGroupName]

			if ($null -eq $FileGroupObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('File group not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$FileGroupName
				)
			}

			$DataFileObject = $FileGroupObject.Files[$DataFileName]

			if ($null -eq $DataFileObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Data file not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$DataFileName
				)
			}

			if ($PSBoundParameters.ContainsKey('NewDataFileName')) {
				$DataFileObject.Rename($NewDataFileName)
			}

			if ($PSBoundParameters.ContainsKey('Growth')) {
				$DataFileObject.Growth = $Growth
			}

			if ($PSBoundParameters.ContainsKey('GrowthType')) {
				$DataFileObject.GrowthType = $GrowthType
			}

			if ($PSBoundParameters.ContainsKey('MaxSize')) {
				$DataFileObject.MaxSize = $MaxSize
			}

			if ($PSCmdlet.ShouldProcess($DataFileName, 'Setting database datafile properties.')) {
				$DataFileObject.Alter()
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
			}
		}
	}

	end {
	}
}

function Set-SmoDatabaseFileGroup {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
		[string]$FileGroupName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$NewFileGroupName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$AutogrowAllFiles,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$IsDefault,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[bool]$ReadOnly
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$FileGroupObject = $DatabaseObject.FileGroups[$FileGroupName]

			if ($null -eq $FileGroupObject) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('File group does not exist.'),
					'1',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$FileGroupName
				)
			}

			if ($PSBoundParameters.ContainsKey('NewFileGroupName')) {
				$FileGroupObject.Rename($NewFileGroupName)
			}

			if ($PSBoundParameters.ContainsKey('AutogrowAllFiles')) {
				$FileGroupObject.AutogrowAllFiles = $AutogrowAllFiles
			}

			if ($PSBoundParameters.ContainsKey('IsDefault')) {
				$FileGroupObject.IsDefault = $IsDefault
			}

			if ($PSBoundParameters.ContainsKey('ReadOnly')) {
				$FileGroupObject.ReadOnly = $ReadOnly
			}

			if ($PSCmdlet.ShouldProcess($FileGroupName, 'Set file group properties.')) {
				$FileGroupObject.Alter()

				$FileGroupObject
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

function Set-SmoDatabaseObjectPermission {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
					'BrokerService' {
						$ClassObject = $DatabaseObject.ServiceBroker.Services[$ObjectName]
					}
					'Certificate' {
						$ClassObject = $DatabaseObject.Certificates[$ObjectName]
					}
					'ExtendedStoredProcedure' {
						$ClassObject = $DatabaseObject.ExtendedStoredProcedures[$ObjectName]
					}
					'MessageType' {
						$ClassObject = $DatabaseObject.ServiceBroker.MessageTypes[$ObjectName]
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
					'ServiceContract' {
						$ClassObject = $DatabaseObject.ServiceBroker.ServiceContracts[$ObjectName]
					}
					'ServiceQueue' {
						$ClassObject = $DatabaseObject.ServiceBroker.Queues[$ObjectName]
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
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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

function Set-SmoDatabaseQueryStore {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.QueryStoreOperationMode]$QueryStoreOperationMode,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.QueryStoreCaptureMode]$QueryCaptureMode,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$MaxPlansPerQuery,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1024, 10240)]
		[int]$MaxStorageSizeInMB,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$StaleQueryThresholdInDays,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.QueryStoreSizeBasedCleanupMode]$SizeBasedCleanupMode,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$StatisticsCollectionIntervalInMinutes,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$DataFlushIntervalInSeconds,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.QueryStoreWaitStatsCaptureMode]$WaitStatsCaptureMode,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1,168)]
		[int]$CapturePolicyStaleThresholdInHrs,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$CapturePolicyExecutionCount,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$CapturePolicyTotalCompileCpuTimeInMS,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$CapturePolicyTotalExecutionCpuTimeInMS
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$QueryStoreOptions = $DatabaseObject.QueryStoreOptions

			if ($QueryStoreOptions.QueryCaptureMode -ne [Microsoft.SqlServer.Management.Smo.QueryStoreCaptureMode]::Custom) {
				if (-not $PSBoundParameters.ContainsKey('QueryCaptureMode')) {
					if ($PSBoundParameters.ContainsKey('CapturePolicyExecutionCount') -or $PSBoundParameters.ContainsKey('CapturePolicyStaleThresholdInHrs') -or $PSBoundParameters.ContainsKey('CapturePolicyTotalCompileCpuTimeInMS') -or $PSBoundParameters.ContainsKey('CapturePolicyTotalExecutionCpuTimeInMS') -or $PSBoundParameters.ContainsKey('StaleQueryThresholdInDays')) {
						throw [System.Management.Automation.ErrorRecord]::New(
							[Exception]::New('QueryStoreCaptureMode must be set to Custom to set CapturePolicyExecutionCount, CapturePolicyStaleThresholdInHrs, CapturePolicyTotalCompileCpuTimeInMS, CapturePolicyTotalExecutionCpuTimeInMS, or StaleQueryThresholdInDays.'),
							'1',
							[System.Management.Automation.ErrorCategory]::InvalidArgument,
							$QueryStoreOptions.QueryCaptureMode
						)
					}
				} elseif ($PSBoundParameters.ContainsKey('QueryCaptureMode')) {
					if ($QueryCaptureMode -ne [Microsoft.SqlServer.Management.Smo.QueryStoreCaptureMode]::Custom) {
						if ($PSBoundParameters.ContainsKey('CapturePolicyExecutionCount') -or $PSBoundParameters.ContainsKey('CapturePolicyStaleThresholdInHrs') -or $PSBoundParameters.ContainsKey('CapturePolicyTotalCompileCpuTimeInMS') -or $PSBoundParameters.ContainsKey('CapturePolicyTotalExecutionCpuTimeInMS') -or $PSBoundParameters.ContainsKey('StaleQueryThresholdInDays')) {
							throw [System.Management.Automation.ErrorRecord]::New(
								[Exception]::New('QueryStoreCaptureMode must be set to Custom to set CapturePolicyExecutionCount, CapturePolicyStaleThresholdInHrs, CapturePolicyTotalCompileCpuTimeInMS, CapturePolicyTotalExecutionCpuTimeInMS, or StaleQueryThresholdInDays.'),
								'1',
								[System.Management.Automation.ErrorCategory]::InvalidArgument,
								$QueryCaptureMode
							)
						}
					}
				}
			}

			foreach ($Parameter in $PSBoundParameters.GetEnumerator()) {
				if ($Parameter.Key -eq 'QueryStoreOperationMode') {
					$QueryStoreOptions.DesiredState = $Parameter.Value
				} elseif ($Parameter.Key -notin @('ServerInstance', 'DatabaseName', 'DatabaseObject')) {
					$QueryStoreOptions.$($Parameter.Key) = $Parameter.Value
				}
			}

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, 'Enabling Query Store')) {
				$QueryStoreOptions.Alter()
				$QueryStoreOptions.Refresh()
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

function Set-SmoDatabaseRole {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
		[ValidatePassword()]
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Set-SmoSqlLogin {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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
		[ValidatePassword()]
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
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				if (Test-Path -Path Variable:\SmoServerObject) {
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

			if ($PSCmdlet.ShouldProcess($LoginName, 'Alter login.')) {
				$SmoLogin.Alter()
				$SmoLogin.Refresh()

				$SmoLogin
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Test-SmoBackup {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([bool])]

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
		[string[]]$BackupFile,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.RelocateFile[]]$RelocateFile,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[string]$MediaName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[switch]$Checksum
	)

	begin {
		Try {
			$ServerInstanceParameterSets = @('ServerInstance')

			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if (Test-Path -Path Variable:\DatabaseObject) {
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
			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			$SmoRestore.PercentCompleteNotification = 5

			foreach ($File in $BackupFile) {
				$SmoBackupDeviceItem = [Microsoft.SqlServer.Management.SMO.BackupDeviceItem]::New($File, [Microsoft.SqlServer.Management.SMO.DeviceType]::File)

				$SmoRestore.Devices.Add($SmoBackupDeviceItem)
			}

			if ($PSBoundParameters.ContainsKey('BackupSetFileNumber')) {
				$SmoRestore.FileNumber = $BackupSetFileNumber
			}

			if ($PSBoundParameters.ContainsKey('Checksum')) {
				$SmoRestore.Checksum = $Checksum
			} else {
				$SmoRestore.Checksum = [bool]$SmoServer.Configuration.DefaultBackupChecksum.RunValue
			}

			if ($PSBoundParameters.ContainsKey('MediaName')) {
				$SmoRestore.MediaName = $MediaName
			}

			if ($PSCmdlet.ShouldProcess(@($BackupFile)[0], 'Verify backup file')) {
				$SmoRestore.SqlVerify($SmoServerObject)
			}
		}
		catch {
			throw $_
		}
		finally {
			if ($PSCmdlet.ParameterSetName -in $ServerInstanceParameterSets) {
				Disconnect-SmoServer -SmoServerObject $SmoServerObject
			}
		}
	}

	end {
	}
}

function Update-SmoSqlLoginPassword {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium'
	)]

	[OutputType([void])]

	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1, 128)]
		[Alias('SqlServer')]
		[string]$ServerInstance,

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
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidatePassword()]
		[System.Security.SecureString]$NewPassword
	)

	begin {
	}

	process {
		try {
			$SqlConnectionInfo = [Microsoft.SqlServer.Management.Common.SqlConnectionInfo]::New()
			$SqlConnectionInfo.ServerName = $ServerInstance
			$SqlConnectionInfo.AuthenticationType = [Microsoft.SqlServer.Management.Common.SqlConnectionInfo+AuthenticationMethod]::SqlPassword
			$SqlConnectionInfo.UserName = $LoginName
			$SqlConnectionInfo.SecurePassword = $Password

			$ServerConnection = [Microsoft.SqlServer.Management.Common.ServerConnection]::New($SqlConnectionInfo)
			$SmoServer = [Microsoft.SqlServer.Management.Smo.Server]::New($ServerConnection)

			if ($PSCmdlet.ShouldProcess($LoginName, 'Update login password.')) {
				$SmoServer.ChangePassword($Password, $NewPassword)
			}
		}
		catch {
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
	SqlServerTools-Help.xml
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
		[Alias('InitialCatalog')]
		[string]$DatabaseName,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false,
			ParameterSetName = 'IntegratedSecurity'
		)]
		[Alias('TrustedConnection')]
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
		[Alias('EncryptConnection')]
		[SqlConnectionEncryption]$ConnectionEncryption = [SqlConnectionEncryption]::Optional,

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
		[bool]$Pooling = $true,

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
		[Alias('ConnectionLifetime')]
		[int]$LoadBalanceTimeout = 600,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateLength(1,128)]
		[string]$WorkstationID = [System.Net.Dns]::GetHostName()
	)

	begin {
		if ($TrustServerCertificate) {
			if ($ConnectionEncryption -eq 'Strict') {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('TrustServerCertificate is not valid when ConnectionEncryption is Strict.'),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidOperation,
					$PSCmdlet.ParameterSetName
				)
			}
		}
	}

	process {
		try {
			$SqlConnectionStringBuilder = [Microsoft.Data.SqlClient.SqlConnectionStringBuilder]::New()

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

			$SqlConnectionStringBuilder['Pooling'] = $Pooling

			if ($PSBoundParameters.ContainsKey('MinPoolSize')) {
				$SqlConnectionStringBuilder['Min Pool Size'] = $MinPoolSize
			}

			if ($PSBoundParameters.ContainsKey('MaxPoolSize')) {
				$SqlConnectionStringBuilder['Max Pool Size'] = $MaxPoolSize
			}

			if ($PSBoundParameters.ContainsKey('MultipleActiveResultSets')) {
				$SqlConnectionStringBuilder['MultipleActiveResultSets'] = $MultipleActiveResultSets
			}

			if ($PSBoundParameters.ContainsKey('ConnectionTimeout')) {
				$SqlConnectionStringBuilder['Connect Timeout'] = $ConnectionTimeout
			}

			[Microsoft.Data.SqlClient.SqlConnectionEncryptOption]$SqlConnectionEncryptOption = $ConnectionEncryption.ToString()

			$SqlConnectionStringBuilder['Encrypt'] = $SqlConnectionEncryptOption.ToString()

			if ($PSBoundParameters.ContainsKey('HostNameInCertificate')) {
				$SqlConnectionStringBuilder['Host Name In Certificate'] = $HostNameInCertificate
			}

			if ($PSBoundParameters.ContainsKey('TrustServerCertificate')) {
				$SqlConnectionStringBuilder['Trust Server Certificate'] = $TrustServerCertificate
			}

			if ($PSBoundParameters.ContainsKey('LoadBalanceTimeout')) {
				$SqlConnectionStringBuilder['Load Balance Timeout'] = $LoadBalanceTimeout
			}

			if ($PSBoundParameters.ContainsKey('PacketSize')) {
				$SqlConnectionStringBuilder['Packet Size'] = $PacketSize
			}

			$SqlConnectionStringBuilder['Application Name'] = $ApplicationName
			$SqlConnectionStringBuilder['Workstation ID'] = $WorkstationID

			if ($PSBoundParameters.ContainsKey('ApplicationIntent')) {
				$SqlConnectionStringBuilder['Application Intent'] = $ApplicationIntent
			}

			if ($PSBoundParameters.ContainsKey('MultiSubnetFailover')) {
				$SqlConnectionStringBuilder['Multi Subnet Failover'] = $MultiSubnetFailover
			}

			if ($PSBoundParameters.ContainsKey('ConnectRetryCount')) {
				$SqlConnectionStringBuilder['Connect Retry Count'] = $ConnectRetryCount
			}

			if ($PSBoundParameters.ContainsKey('ConnectRetryInterval')) {
				$SqlConnectionStringBuilder['Connect Retry Interval'] = $ConnectRetryInterval
			}

			if ($PSBoundParameters.ContainsKey('CommandTimeout')) {
				$SqlConnectionStringBuilder['Command Timeout'] = $CommandTimeout
			}

			if ($PSBoundParameters.ContainsKey('IPAddressPreference')) {
				$SqlConnectionStringBuilder['IP Address Preference'] = $IPAddressPreference
			}

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
	SqlServerTools-Help.xml
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
			$SqlRetryLogicOption = [Microsoft.Data.SqlClient.SqlRetryLogicOption]::New()
			$SqlRetryLogicOption.NumberOfTries = 5
			$SqlRetryLogicOption.DeltaTime = [System.TimeSpan]::FromSeconds(1)
			$SqlRetryLogicOption.MaxTimeInterval = [System.TimeSpan]::FromSeconds(20)

			$RetryProvider = [Microsoft.Data.SqlClient.SqlConfigurableRetryFactory]::CreateExponentialRetryProvider($SqlRetryLogicOption)

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
			$SqlConnection.RetryLogicProvider = $RetryProvider

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
	SqlServerTools-Help.xml
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				if ($(Test-Path -Path Variable:SqlConnection)) {
					if ($SqlConnection -is [Microsoft.Data.SqlClient.SqlConnection]) {
						Disconnect-SqlServerInstance -SqlConnection $SqlConnection
					}
				}
			}

			throw $_
		}

		$TableDirectFormatString = 'SELECT * FROM [{0}].[{1}];'

		$FillErrorEventHandler = [System.Data.FillErrorEventHandler]{
			param(
				$EventSender,
				$FillErrorEventArgs
			)

			foreach ($ErrorObject in $FillErrorEventArgs.Errors) {
				$PSCmdlet.WriteError(
					$ErrorObject
				)

				foreach ($Property in $ErrorObject.PSObject.Properties) {
					Write-Error "   $($Property.Name): $($Property.Value)"
				}
			}

			$FillErrorEventArgs.Continue = $true
		}

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

				$SqlDataAdapter.add_FillError($FillErrorEventHandler)

				$OutputDataset = [System.Data.DataSet]::New()
				$OutputDataset.DataSetName = $DataSetName
				$OutputDataset.ExtendedProperties['SqlCommand'] = $SqlCommandText
				$OutputDataset.ExtendedProperties['SqlConnection'] = $SqlConnection

				if ($PSCmdlet.ShouldProcess($DataSetName, 'Get SQL dataset')) {
					[void]$SqlDataAdapter.Fill($OutputDataset, $DataTableName)

					if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			$SqlDataAdapter.remove_FillError($FillErrorEventHandler)

			if (Test-Path -Path Variable:\SqlCommand) {
				$SqlCommand.Dispose()
			}

			if (Test-Path -Path Variable:\SqlDataAdapter) {
				$SqlDataAdapter.Dispose()
			}

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
				Disconnect-SqlServerInstance -SqlConnection $SqlConnection
			}
		}
	}

	end {
	}
}

function Invoke-SqlClientBulkCopy {
	<#
	.EXTERNALHELP
	SqlServerTools-Help.xml
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

		$EventHandler = {
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

			if ($Script:TotalRows -eq 0) {
				Write-Verbose 'No rows to copy in data table. Exiting bulk copy operation.'

				return
			}

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

			$SqlBulkCopy.add_SqlRowsCopied($EventHandler)

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

			$SqlBulkCopy.remove_SqlRowsCopied($EventHandler)

			if (Test-Path -Path Variable:\SqlBulkCopy) {
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
	SqlServerTools-Help.xml
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
			$DatabaseNameParameterSets = @('DatabaseName')

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
			if (Test-Path -Path Variable:\SqlCommand) {
				$SqlCommand.Dispose()
			}

			if ($PSCmdlet.ParameterSetName -in $DatabaseNameParameterSets) {
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
	SqlServerTools-Help.xml
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
	SqlServerTools-Help.xml
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
				$PSCmdlet.WriteError(
					[System.Management.Automation.ErrorRecord]::New(
						$SqlRowUpdatedEventArgs.Errors,
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidResult,
						$SqlRowUpdatedEventArgs.StatementType
					)
				)
			}
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

			$SqlDataAdapter.ContinueUpdateOnError = $true

			if ($PSCmdlet.ShouldProcess($DataSet.ExtendedProperties['SqlConnection'].Database, 'Save dataset')) {
				[void]$SqlDataAdapter.Update($DataSet, $DataSetTableName)
			}

			foreach ($DataRow in $DataSet.Tables[$DataSetTableName].GetErrors()) {
				$Output.Errors++

				switch ($DataRow.RowState) {
					'Added' {
						$Output.InsertedRows--
					}
					'Modified' {
						$Output.UpdatedRows--
					}
					'Deleted' {
						$Output.DeletedRows--
					}
					Default {}
				}

				$PSCmdlet.WriteError(
					[System.Management.Automation.ErrorRecord]::New(
						[Exception]::New("Row error: $($DataRow.RowError)"),
						'1',
						[System.Management.Automation.ErrorCategory]::InvalidResult,
						$DataRow
					)
				)
			}

			$Output
		}
		catch {
			throw $_
		}
		finally {
			Write-Progress -Id 1 -Activity 'Import SQL Data.' -Completed

			$SqlDataAdapter.remove_RowUpdating($SqlRowUpdatingEventHandler)
			$SqlDataAdapter.remove_RowUpdated($SqlRowUpdatedEventHandler)

			if (Test-Path -Path Variable:\SqlCommandBuilder) {
				$SqlCommandBuilder.Dispose()
			}

			if (-not $PSBoundParameters.ContainsKey('SqlDataAdapter')) {
				if (Test-Path -Path Variable:\SqlDataAdapter) {
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

# SIG # Begin signature block
# MIInywYJKoZIhvcNAQcCoIInvDCCJ7gCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDSUB/Oo8RYYZ8a
# 3KvEp83nzAgycJERWqEHYxLnYQYCBKCCINswggWNMIIEdaADAgECAhAOmxiO+dAt
# 5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNV
# BAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBa
# Fw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lD
# ZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
# ggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3E
# MB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKy
# unWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsF
# xl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU1
# 5zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJB
# MtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObUR
# WBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6
# nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxB
# YKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5S
# UUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+x
# q4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIB
# NjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwP
# TzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMC
# AYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0
# aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENB
# LmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0Nc
# Vec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnov
# Lbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65Zy
# oUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFW
# juyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPF
# mCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9z
# twGpn1eqXijiuZQwgga0MIIEnKADAgECAhANx6xXBf8hmS5AQyIMOkmGMA0GCSqG
# SIb3DQEBCwUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMx
# GTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRy
# dXN0ZWQgUm9vdCBHNDAeFw0yNTA1MDcwMDAwMDBaFw0zODAxMTQyMzU5NTlaMGkx
# CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4
# RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYg
# MjAyNSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC0eDHTCphB
# cr48RsAcrHXbo0ZodLRRF51NrY0NlLWZloMsVO1DahGPNRcybEKq+RuwOnPhof6p
# vF4uGjwjqNjfEvUi6wuim5bap+0lgloM2zX4kftn5B1IpYzTqpyFQ/4Bt0mAxAHe
# HYNnQxqXmRinvuNgxVBdJkf77S2uPoCj7GH8BLuxBG5AvftBdsOECS1UkxBvMgEd
# gkFiDNYiOTx4OtiFcMSkqTtF2hfQz3zQSku2Ws3IfDReb6e3mmdglTcaarps0wjU
# jsZvkgFkriK9tUKJm/s80FiocSk1VYLZlDwFt+cVFBURJg6zMUjZa/zbCclF83bR
# VFLeGkuAhHiGPMvSGmhgaTzVyhYn4p0+8y9oHRaQT/aofEnS5xLrfxnGpTXiUOeS
# LsJygoLPp66bkDX1ZlAeSpQl92QOMeRxykvq6gbylsXQskBBBnGy3tW/AMOMCZIV
# NSaz7BX8VtYGqLt9MmeOreGPRdtBx3yGOP+rx3rKWDEJlIqLXvJWnY0v5ydPpOjL
# 6s36czwzsucuoKs7Yk/ehb//Wx+5kMqIMRvUBDx6z1ev+7psNOdgJMoiwOrUG2Zd
# SoQbU2rMkpLiQ6bGRinZbI4OLu9BMIFm1UUl9VnePs6BaaeEWvjJSjNm2qA+sdFU
# eEY0qVjPKOWug/G6X5uAiynM7Bu2ayBjUwIDAQABo4IBXTCCAVkwEgYDVR0TAQH/
# BAgwBgEB/wIBADAdBgNVHQ4EFgQU729TSunkBnx6yuKQVvYv1Ensy04wHwYDVR0j
# BBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1Ud
# JQQMMAoGCCsGAQUFBwMIMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0
# cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8E
# PDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVz
# dGVkUm9vdEc0LmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEw
# DQYJKoZIhvcNAQELBQADggIBABfO+xaAHP4HPRF2cTC9vgvItTSmf83Qh8WIGjB/
# T8ObXAZz8OjuhUxjaaFdleMM0lBryPTQM2qEJPe36zwbSI/mS83afsl3YTj+IQhQ
# E7jU/kXjjytJgnn0hvrV6hqWGd3rLAUt6vJy9lMDPjTLxLgXf9r5nWMQwr8Myb9r
# EVKChHyfpzee5kH0F8HABBgr0UdqirZ7bowe9Vj2AIMD8liyrukZ2iA/wdG2th9y
# 1IsA0QF8dTXqvcnTmpfeQh35k5zOCPmSNq1UH410ANVko43+Cdmu4y81hjajV/gx
# dEkMx1NKU4uHQcKfZxAvBAKqMVuqte69M9J6A47OvgRaPs+2ykgcGV00TYr2Lr3t
# y9qIijanrUR3anzEwlvzZiiyfTPjLbnFRsjsYg39OlV8cipDoq7+qNNjqFzeGxcy
# tL5TTLL4ZaoBdqbhOhZ3ZRDUphPvSRmMThi0vw9vODRzW6AxnJll38F0cuJG7uEB
# YTptMSbhdhGQDpOXgpIUsWTjd6xpR6oaQf/DJbg3s6KCLPAlZ66RzIg9sC+NJpud
# /v4+7RWsWCiKi9EOLLHfMR2ZyJ/+xhCx9yHbxtl5TPau1j/1MIDpMPx0LckTetiS
# uEtQvLsNz3Qbp7wGWqbIiOWCnb5WqxL3/BAPvIXKUjPSxyZsq8WhbaM2tszWkPZP
# ubdcMIIGuTCCBKGgAwIBAgIRAJmjgAomVTtlq9xuhKaz6jkwDQYJKoZIhvcNAQEM
# BQAwgYAxCzAJBgNVBAYTAlBMMSIwIAYDVQQKExlVbml6ZXRvIFRlY2hub2xvZ2ll
# cyBTLkEuMScwJQYDVQQLEx5DZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkx
# JDAiBgNVBAMTG0NlcnR1bSBUcnVzdGVkIE5ldHdvcmsgQ0EgMjAeFw0yMTA1MTkw
# NTMyMThaFw0zNjA1MTgwNTMyMThaMFYxCzAJBgNVBAYTAlBMMSEwHwYDVQQKExhB
# c3NlY28gRGF0YSBTeXN0ZW1zIFMuQS4xJDAiBgNVBAMTG0NlcnR1bSBDb2RlIFNp
# Z25pbmcgMjAyMSBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJ0j
# zwQwIzvBRiznM3M+Y116dbq+XE26vest+L7k5n5TeJkgH4Cyk74IL9uP61olRsxs
# U/WBAElTMNQI/HsE0uCJ3VPLO1UufnY0qDHG7yCnJOvoSNbIbMpT+Cci75scCx7U
# sKK1fcJo4TXetu4du2vEXa09Tx/bndCBfp47zJNsamzUyD7J1rcNxOw5g6FJg0Im
# Iv7nCeNn3B6gZG28WAwe0mDqLrvU49chyKIc7gvCjan3GH+2eP4mYJASflBTQ3HO
# s6JGdriSMVoD1lzBJobtYDF4L/GhlLEXWgrVQ9m0pW37KuwYqpY42grp/kSYE4BU
# QrbLgBMNKRvfhQPskDfZ/5GbTCyvlqPN+0OEDmYGKlVkOMenDO/xtMrMINRJS5SY
# +jWCi8PRHAVxO0xdx8m2bWL4/ZQ1dp0/JhUpHEpABMc3eKax8GI1F03mSJVV6o/n
# mmKqDE6TK34eTAgDiBuZJzeEPyR7rq30yOVw2DvetlmWssewAhX+cnSaaBKMEj9O
# 2GgYkPJ16Q5Da1APYO6n/6wpCm1qUOW6Ln1J6tVImDyAB5Xs3+JriasaiJ7P5KpX
# eiVV/HIsW3ej85A6cGaOEpQA2gotiUqZSkoQUjQ9+hPxDVb/Lqz0tMjp6RuLSKAR
# sVQgETwoNQZ8jCeKwSQHDkpwFndfCceZ/OfCUqjxAgMBAAGjggFVMIIBUTAPBgNV
# HRMBAf8EBTADAQH/MB0GA1UdDgQWBBTddF1MANt7n6B0yrFu9zzAMsBwzTAfBgNV
# HSMEGDAWgBS2oVQ5AsOgP46KvPrU+Bym0ToO/TAOBgNVHQ8BAf8EBAMCAQYwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwMAYDVR0fBCkwJzAloCOgIYYfaHR0cDovL2NybC5j
# ZXJ0dW0ucGwvY3RuY2EyLmNybDBsBggrBgEFBQcBAQRgMF4wKAYIKwYBBQUHMAGG
# HGh0dHA6Ly9zdWJjYS5vY3NwLWNlcnR1bS5jb20wMgYIKwYBBQUHMAKGJmh0dHA6
# Ly9yZXBvc2l0b3J5LmNlcnR1bS5wbC9jdG5jYTIuY2VyMDkGA1UdIAQyMDAwLgYE
# VR0gADAmMCQGCCsGAQUFBwIBFhhodHRwOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJ
# KoZIhvcNAQEMBQADggIBAHWIWA/lj1AomlOfEOxD/PQ7bcmahmJ9l0Q4SZC+j/v0
# 9CD2csX8Yl7pmJQETIMEcy0VErSZePdC/eAvSxhd7488x/Cat4ke+AUZZDtfCd8y
# HZgikGuS8mePCHyAiU2VSXgoQ1MrkMuqxg8S1FALDtHqnizYS1bIMOv8znyJjZQE
# Sp9RT+6NH024/IqTRsRwSLrYkbFq4VjNn/KV3Xd8dpmyQiirZdrONoPSlCRxCIi5
# 4vQcqKiFLpeBm5S0IoDtLoIe21kSw5tAnWPazS6sgN2oXvFpcVVpMcq0C4x/CLSN
# e0XckmmGsl9z4UUguAJtf+5gE8GVsEg/ge3jHGTYaZ/MyfujE8hOmKBAUkVa7NMx
# RSB1EdPFpNIpEn/pSHuSL+kWN/2xQBJaDFPr1AX0qLgkXmcEi6PFnaw5T17UdIIn
# A58rTu3mefNuzUtse4AgYmxEmJDodf8NbVcU6VdjWtz0e58WFZT7tST6EWQmx/Oo
# HPelE77lojq7lpsjhDCzhhp4kfsfszxf9g2hoCtltXhCX6NqsqwTT7xe8LgMkH4h
# Vy8L1h2pqGLT2aNCx7h/F95/QvsTeGGjY7dssMzq/rSshFQKLZ8lPb8hFTmiGDJN
# yHga5hZ59IGynk08mHhBFM/0MLeBzlAQq1utNjQprztZ5vv/NJy8ua9AGbwkMWkO
# MIIG4DCCBMigAwIBAgIQQ7s0QZ8qUnHOP66HyvajHjANBgkqhkiG9w0BAQsFADBW
# MQswCQYDVQQGEwJQTDEhMB8GA1UEChMYQXNzZWNvIERhdGEgU3lzdGVtcyBTLkEu
# MSQwIgYDVQQDExtDZXJ0dW0gQ29kZSBTaWduaW5nIDIwMjEgQ0EwHhcNMjYwOTEy
# MjEzNTQ3WhcNMjcwOTEyMjEzNTQ2WjCBhTELMAkGA1UEBhMCVVMxFzAVBgNVBAgM
# DlNvdXRoIENhcm9saW5hMREwDwYDVQQHDAhOZXdiZXJyeTEeMBwGA1UECgwVT3Bl
# biBTb3VyY2UgRGV2ZWxvcGVyMSowKAYDVQQDDCFPcGVuIFNvdXJjZSBEZXZlbG9w
# ZXIgUm9iZXJ0IEVkZXIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC6
# 72ybkWUB620cgb49nkhI4VvtWKABeSD8277f0Jww+/5fKUxoX2vC77QjmaSXU+I9
# LB2YTj8yCSTDVlxIwJoS7KgsIN9P2EC6ehJe9FRI0n2Rt33/VlRY8kuSh2XsIVGg
# i6Y3RooWVjVmYCAOXuV5zrqjGY1P72nrSIekxcGCTo1Y0nmRwsECCIYn7b3ZM065
# u9b3AtYf3oI4grblWhtY0kbuHNCSeDjpp+qExQgeIs6OpFACJSDASFiDnF8+L+bB
# V+UtUcFbvlu0WpQyblXw9vdN7BEIdqZ/1fxyhjHxqpSuOoTqoZcyDjilXtnMOfWp
# gfgdKPFRc6NHwrmxUyNLAYHOsqBC+bMxamurB1qCJ/16lFbW/YWJRrJsaeA2WaPw
# 8ulkUnZUoP9JgyVE1nwZbhZOgE3YwlVLmBBsAKsRiyJWBYqG1VdaMpfzLYJVNTc8
# 4F/90uC2BvIoafcFfNyc8dIpdd7Ni17JmYuD0+/u1gqUi3p+Qdlk/y+Vgsb1x+0z
# kaMA6CzjFA83szdzwRLFDDnaUOVngyRR8+JLnSNuEw9nNM3G5WWRGBDOkLbwq+NO
# H1gWWAaJJYOlTARrg7ea2JHLl66CBJaaledp2u8hBl1Y5yQTpIkVYx0VPt1Oa7Nq
# kOkXlNjmmlYsZm5pe3fSTBPx5YdUOeIl1sAWXGH/+QIDAQABo4IBeDCCAXQwDAYD
# VR0TAQH/BAIwADA9BgNVHR8ENjA0MDKgMKAuhixodHRwOi8vY2NzY2EyMDIxLmNy
# bC5jZXJ0dW0ucGwvY2NzY2EyMDIxLmNybDBzBggrBgEFBQcBAQRnMGUwLAYIKwYB
# BQUHMAGGIGh0dHA6Ly9jY3NjYTIwMjEub2NzcC1jZXJ0dW0uY29tMDUGCCsGAQUF
# BzAChilodHRwOi8vcmVwb3NpdG9yeS5jZXJ0dW0ucGwvY2NzY2EyMDIxLmNlcjAf
# BgNVHSMEGDAWgBTddF1MANt7n6B0yrFu9zzAMsBwzTAdBgNVHQ4EFgQUCdHvF5Qw
# xL78QY6vfJNPC89uTWEwSwYDVR0gBEQwQjAIBgZngQwBBAEwNgYLKoRoAYb2dwIF
# AQQwJzAlBggrBgEFBQcCARYZaHR0cHM6Ly93d3cuY2VydHVtLnBsL0NQUzATBgNV
# HSUEDDAKBggrBgEFBQcDAzAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQAD
# ggIBADGvhUwApFlOiMwxr4muEgH+EK8xGwyw7qZGQZYdHQZV7E6ev+4i0u2ywMbF
# H0XcYpaB4xubprYIGbltJhIXoIM+BmIB6mgzgAtKMJBIWMECnACZKPAWPJ5vp3Xu
# GLCg0gwQGZEKJInwEFLzplH3G5g8hTO8KSLmWLVWoWHTTA3WI4LgTf/XRs3QYqur
# bB1gWRWa+vx8J/4I6znbpnpRDxy/jCYh9qtv21Dk3BovIPnfaj50JOWJhWeongQ6
# Dgd4/FZhM/U1Fj/g1W7WDMal9q43MABwmrHPbxrIEK1V5vXwAhK1m9eSaZ8bqbeA
# SId0wOYzIyEziquoO5TCdf/lSi8nD4BIm2E+h738pLQXWvr6tYWyvqaUN0uk5f27
# NsXlVRYp8EUZPP83BJMaQJFgTsYPMeZejAndk3nuqPVGeCL6WW90M7eK5sPbTAmW
# WrSnYFx4pgnMR3X3s14074ytJ3o3ycKa0bxjhMcoCTfMDmV7jUUhATpW8iZ2/E4b
# +0s7DmbN37VsBngsj04vMyVxhcNLSwdFDTQEgkEwHccChlw0anfoZJ7Xui4x5RSr
# j3rOyyrf7mFYIpsbDYjVxBo5/JVJuu5h2+BRxY9MLoSMknm391tCI7aVC/XTl/zW
# rX1kJeCx0nYBnZnmjWCRrCXWOX5V8QaLAnK/R6durGeXnlo3MIIG7TCCBNWgAwIB
# AgIQCE/cM09+RU7bww+P+ZIYNTANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJV
# UzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRy
# dXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0ExMB4X
# DTI2MDgwNTAwMDAwMFoXDTM3MTEwNDIzNTk1OVowYzELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBTSEEyNTYg
# UlNBNDA5NiBUaW1lc3RhbXAgUmVzcG9uZGVyIDIwMjYgMTCCAiIwDQYJKoZIhvcN
# AQEBBQADggIPADCCAgoCggIBALZ7pvLJ/s1K+NSbTGWz/TjGMPh8CQ6RucZCLv5a
# nHzWJjF/NWJrFIhy24fcpKXlgRiky4WAawDfU3YP0BMxt9l3Dm5oCG5Z69AqEN1k
# gHg2epx+l+lZBcmJCcN0ASURML5uFIS80sZsDwO3BSkUxDjLJhBI+qiZP3aixAC/
# qEGLjsBNlLol9VZ7pfGEXiMlneJIC5/YKuizVzNFKZZEeoy/0B8Zm+nzKBgSWG52
# lCO1w+nCg6XpCtklTJXeIg283hw7TmmsZXR+SMbjbrEOvZ3fP2VxIgeR28Y90ZSt
# d3F9VuA5RVynb/whITPAo9b75Zr4Ta6Mj3URm26QZYMn/FnbuTegcoRcFEZ9FOqM
# 5T6MTdtr/n74lIT/ug0eeOzmZ6QTFg33otX+bFRsIolvykE1jive4PuESaT8zzVe
# FWDAMDtozNgLctkGD1ZjkEyZtJrLl5ya0m5doH/ScpaZCZVl6pNUOCybMc/kxC6E
# AmSJY24L0yYKD1Nkddsnb/ItVKi/2nXpQNMu1PT5prW83vV8d67WowuUs0HdY4H8
# AMLGvdL/WHEj3ZnqMqAQQP9u3Ai9t+5eQ02GDwy0ODjdzi0xlp70W+ow63/0++YD
# EX1M0iwgUHwbrJvfpklkZQvw3+kv3vUPItdwroczk9icflf55W1zOEKAcJVAIXpc
# MCU9AgMBAAGjggGVMIIBkTAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBQUyWOKMC7U
# SvtulPPm40B+9ezN4jAfBgNVHSMEGDAWgBTvb1NK6eQGfHrK4pBW9i/USezLTjAO
# BgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwgZUGCCsGAQUF
# BwEBBIGIMIGFMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20w
# XQYIKwYBBQUHMAKGUWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2Vy
# dFRydXN0ZWRHNFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEyNTYyMDI1Q0ExLmNydDBf
# BgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRUcnVzdGVkRzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2MjAyNUNBMS5jcmww
# IAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUA
# A4ICAQCNxTphHp1SCt+ZrAmAfn0oQLFr0mLywSLaDXQIENoyKqxrFbJblzCVP/pk
# XmwXOdrOpWygLzlT12os5ipDCy35RBCg2UMeApEtrfGhz45F4Wt4WGdNdIbRWt3Y
# TYJmpR+b7lr4d7Uwn+H600u4D7RnOGf8Wj4UNgAdZkfHhHv1mx9EVh71SJelcEN/
# oORSjXzdjfw1iZH9d8Nh/thn6hH23d+VsPAr6GAYyzSA02nXD1nYLI7Ijmiv+xLC
# iYC41DSFYL3GhTiy0PxpawPtGRyaBVGzq+UiTfM8pD7KVyF5aQyWP4KhVGUUTnmm
# /RlYJoW3TiXA/+t0YcT2oRVBm3JETjajHug2AL+v5jhtKVnd3D0rbHXEu27o+Q8p
# 4sEWPMqKDB+qbceb6T/6WcwTwXmQ9lOCLLYcsQeSWmvKqzpAec9etE14jOQAzLKW
# dE3w/TCaKtLRaRT7LCkRYVnhA2D73FLje1O5b3HR5eHs0NzU/+xX7NbEdcofy0W3
# Wdwd1XOqtlpg/JgwtKfZM5dqO94lbUveOiJBI+xZEbGRsMNbXmMREUTgu+Oca7Y7
# 3MPWcslIx2VhkSKSXjDbD6rgg39H5Mh7QfieAIjWagkJNt68Yfim6cjEzVSiLSeZ
# fdkr5dtFPTW6jATlWJdYeeDRGCyatf8R1hSjzSvdN8yWQPT9gzGCBkYwggZCAgEB
# MGowVjELMAkGA1UEBhMCUEwxITAfBgNVBAoTGEFzc2VjbyBEYXRhIFN5c3RlbXMg
# Uy5BLjEkMCIGA1UEAxMbQ2VydHVtIENvZGUgU2lnbmluZyAyMDIxIENBAhBDuzRB
# nypScc4/rofK9qMeMA0GCWCGSAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAI
# oAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIB
# CzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHGQcZidOeuG0/B1Thtu
# OeUDzs2RHDIdChoVdtcClKD1MA0GCSqGSIb3DQEBAQUABIICAHE3MnHXtzttR6BS
# TM1D9PRllLdjBoY/G8YftI5LQlnXauxsEoQyVjRyPvgNsdzS6uMcc7TY2b4nDz23
# 9Fz+IkkBBBuKdQ5FD06UX0Qf4sxwxrPbRVivkK3p5GK/BYNFSP/jznjpB89E+U+i
# hQ27lHnexSWl94lbuVtFCUqpgBrybRfp+w4pjByOYzvWe3KJwHOKIQ8rVw/t1Rzo
# /26PeUQSS4fG+bPHWoO5auWCzzAfqJrRHYLq+bloBh+89FPwuxyF5f5t0DT94FBo
# U9Mot3MYvMEiNzzhhXgGDLmKt4u6BSG2X/n7mwxsGjRxodljTOYif90dxKb/+oy9
# YXS0ZXgXQL/Pqza4QJbmURTgPtj8zJuL6e7S7SnMKFZ0MkNjfrLafXf9RUiI6jF/
# e/SPC3M00ZNakurncPnRDJDIJrKZUI5YYgwweBsWXr6YZQKtreQi9EkKmddEzCmM
# 53ZfxqNszUq60k/82VD9H5h9v/FRgw8HTuand2iJAtqSP6DCEAzpHRGsuwUsP/xV
# 1EgO+4hJNq74dGA/hwVWGHUwp+NI/11YScn9MGZf0BBNq8BQqeHNUS2oP6OFQN1P
# HUTjxb49jW6CsqoslBcnzGaUzMuQm/wTgPZH3pyPPWYMKj3Y7veAVDVyVcZ/xF7X
# wCu9i5OLcWjF8ayIbee4guALy/n7oYIDJjCCAyIGCSqGSIb3DQEJBjGCAxMwggMP
# AgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEw
# PwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2
# IFNIQTI1NiAyMDI1IENBMQIQCE/cM09+RU7bww+P+ZIYNTANBglghkgBZQMEAgEF
# AKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
# MTAzMTE2MzA1MFowLwYJKoZIhvcNAQkEMSIEIF0XWYEmtXFwF9ay+IS9BcnS3Ry6
# 0y/VkXKbPyvlmrPuMA0GCSqGSIb3DQEBAQUABIICAED31XpzzqDGv0qdmVzjbjH9
# WPhpHeSBrPM++3N5xTd5Mt7AoQubyhQamRsFIO/Fm3ZYFC3WVNB7X1anCub3hwms
# eOGaXMs6hy2ap5btm2degbonGL2dlU+cbGjPJaUcvCr6amMLavBUh5X8DJXU/o1n
# FRpAANjGZt1MafvmfGWhKyppNWVeEqAYk7shiryiNf+2gEKHldePKCDfFoj0+wiq
# sLBEOgBHlDhYZAqHGhC0ZLg7Bzn3uaV7LimlPgo4tAuAUqTIoZO1mTsBGBms6qnI
# x2DJK726GUb3mIGPMm4Ull6hne25ulDyu5lelc+ClGF7k2nRh5jTRGfmHX9w2kaQ
# 90mT22xwWYbNjjl/GdvSLDPoulKU5zatRDRjqF3h4i2MmLue2kJsv3hyRwQ+b8+x
# bhtHlkZT/3RWsisrgEPVOjvAOMvCfYw7mefdbkaGzGFvJthCDwPB6mPhBiXnOrfw
# bINz8L/iVl4IY5fbTIdSS2ubYJfak0BJLrJK6wZfsku1OmOvjT9cYa0TwAY6oJGl
# 23el6ne81VIAQ7Rk9DZn8u+C9WISPZuh2V9QRFyqk+hwOcHrL8qkamaaTDydBMpY
# bGfHKV6f27bOzerWOyNUuTcC0wCIljpNwb1+DwkUU+Hy5uCPhPVjH6MZ1d+rFkEq
# mrSac+1qPCENdy+iJv8R
# SIG # End signature block
