Set-StrictMode -Version Latest

#Region Enumerations
enum ApplicationIntent {
	ReadWrite;
	ReadOnly
}

enum AuthenticationMode {
	AsUser;
	SQL
}

enum DatabaseObjectClass {
	Assembly;
	AsymmetricKey;
	Certificate;
	ExtendedStoredProcedure;
	Schema;
	StoredProcedure;
	Sequences;
	SymmetricKey;
	Synonym;
	Table;
	UserDefinedFunction;
	View
}

enum DatabaseObjectPermission {
	Alter;
	Connect;
	Control;
	CreateSequence;
	Delete;
	Execute;
	Impersonate;
	Insert;
	Receive;
	References;
	Select;
	Send;
	TakeOwnership;
	Update;
	ViewChangeTracking;
	ViewDefinition
}

enum DatabasePermission {
	Alter;
	AlterAnyApplicationRole;
	AlterAnyAssembly;
	AlterAnyAsymmetricKey;
	AlterAnyCertificate;
	AlterAnyContract;
	AlterAnyDatabaseAudit;
	AlterAnyDatabaseDdlTrigger;
	AlterAnyDatabaseEventNotification;
	AlterAnyDataSpace;
	AlterAnyExternalDataSource;
	AlterAnyExternalFileFormat;
	AlterAnyFullTextCatalog;
	AlterAnyMask;
	AlterAnyMessageType;
	AlterAnyRemoteServiceBinding;
	AlterAnyRole;
	AlterAnyRoute;
	AlterAnySchema;
	AlterAnySecurityPolicy;
	AlterAnyService;
	AlterAnySymmetricKey;
	AlterAnyUser;
	Authenticate;
	BackupDatabase;
	BackupLog;
	Checkpoint;
	Connect;
	ConnectReplication;
	Control;
	CreateAggregate;
	CreateAssembly;
	CreateAsymmetricKey;
	CreateCertificate;
	CreateContract;
	CreateDatabase;
	CreateDatabaseDdlEventNotification;
	CreateDefault;
	CreateFullTextCatalog;
	CreateFunction;
	CreateMessageType;
	CreateProcedure;
	CreateQueue;
	CreateRemoteServiceBinding;
	CreateRole;
	CreateRoute;
	CreateRule;
	CreateSchema;
	CreateService;
	CreateSymmetricKey;
	CreateSynonym;
	CreateTable;
	CreateType;
	CreateView;
	CreateXmlSchemaCollection;
	Delete;
	Execute;
	Insert;
	References;
	Select;
	ShowPlan;
	SubscribeQueryNotifications;
	TakeOwnership;
	Unmask;
	Update;
	ViewDatabaseState;
	ViewDefinition
}

enum DataOutputType {
	DataSet;
	DataTable;
	DataRow
}

enum PermissionAction {
	Grant;
	Deny;
	Revoke
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

Remove-Variable -Name TypeDefinition
#EndRegion


function Add-SmoAvailabilityDatabase {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.AvailabilityDatabase])]

	PARAM(
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

				$SmoAvailabilityDatabase.Initialize()

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

	PARAM ()

	BEGIN {
		$Assemblies = @(
			'Microsoft.SqlServer.Dac.dll'
		)
	}

	PROCESS {
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

	END {
		$Error.Clear()
	}
}

function Add-SmoDatabaseDataFile {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.DataFile])]

	PARAM(
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
		[System.IO.FileInfo]$DataFilePath
	)

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Add-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Add-SmoDatabaseRoleMember {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
		try {
			if ($null -eq $DatabaseObject.Users[$RoleMemberName]) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Database user not found.'),
					'2',
					[System.Management.Automation.ErrorCategory]::ObjectNotFound,
					$RoleMemberName
				)
			}

			if ($PSCmdlet.ShouldProcess($RoleName, "Adding $RoleMemberName")) {
				$DatabaseObject.Roles[$RoleName].AddMember($RoleMemberName)
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

	END {
	}
}

function Add-SmoServerRoleMember {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Credential])]

	PARAM(
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

	BEGIN {
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
					Disconnect-SmoServer -SmoServerObject $SmoServerObject
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Connect-SmoServer {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'SqlInstanceName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Server])]

	PARAM (
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

	BEGIN {
	}

	PROCESS {
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
							$ServerConnection.LoginSecure = $false;
							$ServerConnection.Login = $Credential.UserName;
							$ServerConnection.SecurePassword = $Credential.Password;
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

	END {
	}
}

function Disable-SmoTransparentDatabaseEncryption {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Disconnect-SmoServer {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	PARAM (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Management.Smo.Server]$SmoServerObject
	)

	BEGIN {
	}

	PROCESS {
		try {
			[Microsoft.Data.SqlClient.SqlConnection]::ClearAllPools()

			if ($SmoServerObject.ConnectionContext.IsOpen -eq $true) {
				$SmoServerObject.ConnectionContext.Disconnect()
			}
		}
		catch {
			throw $_
		}
	}

	END {
	}
}

function Enable-SmoTransparentDatabaseEncryption {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

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
		if ($ServerInstance -in @('.', '(local)')) {
			$ServerHostName = $null
			$ServerFQDN = $null
			$DomainName = $null
			[nullable[int]]$TcpPort = $null
			$InstanceName = $null
			$SqlInstanceName = $ServerInstance
		} else {
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

function Get-SmoAvailabilityGroup {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.AvailabilityGroup])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $SmoServerObject) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	PROCESS{
		Try {
			If ($PSBoundParameters.ContainsKey('AvailabilityGroupName')) {
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

	END {
	}
}

function Get-SmoBackupFileList {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SmoRestore.FileList])]

	Param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateScript({
			if (-not $(Test-Path -LiteralPath $_ -PathType Leaf)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New("Cannot find path '$_' because it does not exist."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$_
				)
			}
			return $true
		})]
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

	BEGIN {
		try {
			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			if ($PSCmdlet.ParameterSetName -in ('ServerInstance')) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $ServerInstance
			}
		}
		catch {
			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Get-SmoBackupHeader {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([SmoRestore.BackupHeader])]

	Param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateScript({
			if (-not $(Test-Path -LiteralPath $_ -PathType Leaf)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New("Cannot find path '$_' because it does not exist."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$_
				)
			}
			return $true
		})]
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

	BEGIN {
		try {
			$SmoRestore = [Microsoft.SqlServer.Management.Smo.Restore]::New()

			if ($PSCmdlet.ParameterSetName -in ('ServerInstance')) {
				$SmoServerObject = Connect-SmoServer -ServerInstance $ServerInstance
			}
		}
		catch {
			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Get-SmoDatabaseObject {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Database])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $SmoServerObject) {
						Disconnect-SmoServer -SmoServerObject $SmoServerObject
					}
				}
			}

			throw $_
		}
	}

	PROCESS{
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

	END {
	}
}

function Invoke-SmoNonQuery {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName_CommandText'
	)]

	[OutputType([System.Void])]

	PARAM (
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
		[ValidateScript({
			if (-not $(Test-Path -LiteralPath $_ -PathType Leaf)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New("Cannot find path '$_' because it does not exist."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$_
				)
			}
			return $true
		})]
		[System.IO.FileInfo]$InputFile,

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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName_CommandText', 'DatabaseName_InputFile')) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName_CommandText', 'DatabaseName_InputFile')) {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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
						[System.Management.Automation.ErrorCategory]::NotSpecified,
						$InputFile.Name
					)
				)
			}

			throw [System.Management.Automation.ErrorRecord]::New(
				$BaseException,
				'1',
				[System.Management.Automation.ErrorCategory]::NotSpecified,
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

	END {
	}
}

function New-SmoCredential {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Credential])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					Disconnect-SmoServer -SmoServerObject $SmoServerObject
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function New-SmoDatabaseFileGroup {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.FileGroup])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function New-SmoDatabaseRole {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.DatabaseRole])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function New-SmoDatabaseSchema {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.Schema])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function New-SmoDatabaseUser {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.User])]

	PARAM(
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

	BEGIN {
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function New-SmoServerRole {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.ServerRole])]

	PARAM(
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

	BEGIN {
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
					Disconnect-SmoServer -SmoServerObject $SmoServerObject
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function New-SmoSqlLogin {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Login])]

	PARAM(
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
		[string]$Sid,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[byte[]]$SidByteArray,

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
		[bool]$LoginDisabled = $false
	)

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance;
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
					Disconnect-SmoServer -SmoServerObject $SmoServerObject
				}
			}

			throw $_
		}
	}

	PROCESS {
		try {
			$SmoLogin = [Microsoft.SqlServer.Management.Smo.Login]::New($SmoServerObject, $LoginName)

			$SmoLogin.LoginType = $LoginType
			$SmoLogin.DefaultDatabase = $DefaultDatabase
			$SmoLogin.PasswordExpirationEnabled = $PasswordExpirationEnabled
			$SmoLogin.PasswordPolicyEnforced = $PasswordPolicyEnforced

			if ($PSBoundParameters.ContainsKey('SidByteArray')) {
				$SmoLogin.Set_SID($SidByteArray)
			} elseif ($PSBoundParameters.ContainsKey('Sid')) {
				$SidArray = $Sid -replace '^0x', '' -split '(?<=\G\w{2})(?=\w{2})'

				$ByteArray = $SidArray | ForEach-Object { [Convert]::ToByte( $_, 16 ) }

				$SmoLogin.Set_SID($ByteArray)
			}

			if ($PSCmdlet.ShouldProcess($SmoServerObject.name, "Creating login $LoginName.")) {
				$SmoLogin.Create($Password)

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

	END {
	}
}

function Remove-SmoAvailabilityDatabase {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.AvailabilityGroup])]

	PARAM(
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
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	PARAM(
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
		[string]$Name
	)

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					Disconnect-SmoServer -SmoServerObject $SmoServerObject
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Remove-SmoDatabaseEncryptionKey {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS{
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
					'Id' = 0;
					'Activity' = 'Decryption In Progress';
					'Status' = 'Decryption In Progress';
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

	END {
	}
}

function Remove-SmoDatabaseRole {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Medium',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Remove-SmoDatabaseRoleMember {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Remove-SmoDatabaseSchema {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Remove-SmoDatabaseUser {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Remove-SmoServerRole {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	PARAM(
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
		[string]$ServerRoleName
	)

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					Disconnect-SmoServer -SmoServerObject $SmoServerObject
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Remove-SmoServerRoleMember {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.SqlServer.Management.Smo.Credential])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					Disconnect-SmoServer -SmoServerObject $SmoServerObject
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Remove-SmoSqlLogin {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	PARAM(
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
		[string]$LoginName
	)

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				$SmoServerParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = 'master'
				}

				$SmoServerObject = Connect-SmoServer @SmoServerParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
				if (Test-Path -Path variable:\SmoServerObject) {
					Disconnect-SmoServer -SmoServerObject $SmoServerObject
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
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

	Param (
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

	BEGIN {
	}

	PROCESS {
		try {
			$CimSessionParameters = @{
				'Name' = 'RenameCIMDataFile';
			}

			if ($ComputerName -in [System.Net.Dns]::GetHostName(), 'localhost') {
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

				If ($PSBoundParameters.ContainsKey('Credential')) {
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
				'CimSession' = $CimSession;
				'ClassName' = 'CIM_DataFile';
				'Filter' = "Name='" + $($SourcePath.FullName.Replace('\', '\\')) + "'";
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

			Switch ($Return.ReturnValue) {
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
						[System.Management.Automation.ErrorCategory]::NotSpecified,
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
						[System.Management.Automation.ErrorCategory]::NotSpecified,
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

	END {
	}
}

function Rename-SmoDatabaseDataFile {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[OutputType([System.Void])]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[System.Diagnostics.DebuggerStepThrough()]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}

		$TestPathScriptBlock = {
			param($Path)

			Test-Path -Path $Path -PathType Leaf
		}
	}

	PROCESS {
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
				$NewPath = ([System.IO.FileInfo]([IO.Path]::Combine($ParentPath, $NewPhysicalFileName))).FullName

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
						'SourcePath' = $OldPath;
						'DestinationPath' = $NewPath;
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

	END {
	}
}

function Rename-SmoDatabaseLogFile {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}

		$TestPathScriptBlock = {
			param($Path)

			Test-Path -Path $Path -PathType Leaf
		}
	}

	PROCESS {
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
				$NewPath = ([System.IO.FileInfo]([IO.Path]::Combine($ParentPath, $NewPhysicalFileName))).FullName

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
						'SourcePath' = $OldPath;
						'DestinationPath' = $NewPath;
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

	END {
	}
}

function Set-SmoDatabaseObjectPermission {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName', 'DatabaseNameWithPermissionSet')) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Set-SmoDatabasePermission {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'High',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([System.Void])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -in ('DatabaseName', 'DatabaseNameWithPermissionSet')) {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Set-SmoDatabaseRole {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.DatabaseRole])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = $DatabaseName
				}

				$DatabaseObject = Get-SmoDatabaseObject @DatabaseObjectParameters
			}
		}
		Catch {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				if (Test-Path -Path variable:\DatabaseObject) {
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Set-SmoDatabaseSchema {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.Schema])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
		try {
			$SchemaObject = $DatabaseObject.Schemas[$SchemaName]
			$SchemaObject.Owner = $SchemaOwner

			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Creating database schema $SchemaName")) {
				$SchemaObject.Alter()

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

	END {
	}
}

function Set-SmoDatabaseUser {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'DatabaseName'
	)]

	[OutputType([Microsoft.SqlServer.Management.SMO.User])]

	PARAM(
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

	BEGIN {
		Try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$DatabaseObjectParameters = @{
					'ServerInstance' = $ServerInstance;
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
					if ($null -ne $DatabaseObject) {
						Disconnect-SmoServer -SmoServerObject $DatabaseObject.Parent
					}
				}
			}

			throw $_
		}
	}

	PROCESS {
		try {
			if ($PSCmdlet.ShouldProcess($DatabaseObject.name, "Setting database login $UserName properties.")) {
				if ($PSBoundParameters.ContainsKey('NewUserName')) {
					$UserObject.Rename($NewUserName)
				}

				if ($PSBoundParameters.ContainsKey('Password')) {
					$UserObject.ChangePassword($Password)
				}

				if ($PSBoundParameters.ContainsKey('DefaultSchema')) {
					$UserObject.DefaultSchema = $DefaultSchema
				}

				$UserObject.Alter()

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

	END {
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

	PARAM()

	BEGIN {
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

	PROCESS {
		$WindowsIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
		$WindowsPrincipal = [Security.Principal.WindowsPrincipal]::New($WindowsIdentity)

		$WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
	}

	END {

	}
}

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

	PARAM ()

	BEGIN {
	}

	PROCESS {
		try {
			[System.IO.FileInfo]$SqlClientPath = [AppDomain]::CurrentDomain.GetAssemblies().where({$_.ManifestModule.Name -eq 'Microsoft.Data.SqlClient.dll'}).Location

			if ($null -eq $SqlClientPath) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[Exception]::New('Assembly not found.'),
					'1',
					[System.Management.Automation.ErrorCategory]::NotSpecified,
					'Microsoft.Data.SqlClient'
				)
			}
		}
		catch {
			throw $_
		}
	}

	END {
	}
}

function Build-SqlClientConnectionString {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'IntegratedSecurity'
	)]

	[OutputType([System.String])]

	PARAM (
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
		[ValidateRange(1, 255)]
		[int]$ConnectRetryCount = 1,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[ValidateRange(1, 60)]
		[int]$ConnectRetryInterval = 10
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
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([Microsoft.Data.SqlClient.SqlConnection])]

	PARAM (
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

	BEGIN {
		if ($PSCmdlet.ParameterSetName -eq 'WithCredential') {
			$Credential.Password.MakeReadOnly()
		}
	}

	PROCESS {
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
					param($SqlSender, $SqlEvent)

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

	END {
	}
}

function Disconnect-SqlServerInstance {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	PARAM (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.Data.SqlClient.SqlConnection]$SqlConnection
	)

	BEGIN {
		[Microsoft.Data.SqlClient.SqlConnection]::ClearAllPools()
	}

	PROCESS {
		if ($SqlConnection.State -eq [System.Data.ConnectionState]::Open) {
			$SqlConnection.Close()
		}

		$SqlConnection.Dispose()
	}

	END {
	}
}

function Get-SqlClientDataSet {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
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
		[System.Data.DataRow]
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
		[System.Collections.Generic.List[Microsoft.Data.SqlClient.SqlParameter]][ref]$OutSqlParameter,

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
		[string]$DataSetName = 'NewDataSet',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[string]$DataTableName = 'NewDataTable',

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[DataOutputType]$OutputAs = 'DataTable'
	)

	BEGIN {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$SqlServerParameters = @{
					'ServerInstance' = $ServerInstance;
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
	}

	PROCESS {
		try {
			$SqlCommand = [Microsoft.Data.SqlClient.SqlCommand]::New()
			$SqlCommand.Connection = $SqlConnection
			$SqlCommand.CommandText = $SqlCommandText
			$SqlCommand.CommandType = $CommandType
			$SqlCommand.CommandTimeout = $CommandTimeout

			if ($PSBoundParameters.ContainsKey('SqlParameter')) {
				foreach ($ListItem in $SqlParameter) {
					$Parameter = $ListItem.PSObject.Copy()

					[void]$SqlCommand.Parameters.Add($Parameter)
				}
			}

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

	END {
	}
}

function Invoke-SqlClientBulkCopy {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
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
			ParameterSetName = 'ServerInstance'
		)]
		[ValidateLength(1, 128)]
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
		[ValidateLength(1, 128)]
		[string]$TableName,

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
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Data.DataTable]$DataTable,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.Data.SqlClient.SqlBulkCopyOptions]$SqlBulkCopyOptions = 'Default'
	)

	BEGIN {
		if ($PSCmdlet.ParameterSetName -eq 'ServerInstance') {
			$ConnectionString = Build-SqlClientConnectionString -ServerInstance $ServerInstance -DatabaseName $DatabaseName
		}
	}

	PROCESS {
		try {
			$SqlBulkCopy = [Microsoft.Data.SqlClient.SqlBulkCopy]::New($ConnectionString, $SqlBulkCopyOptions)

			$SqlBulkCopy.DestinationTableName = $TableName
			$SqlBulkCopy.BulkCopyTimeout = $QueryTimeout

			if ($PSBoundParameters.ContainsKey('BatchSize')) {
				$SqlBulkCopy.BatchSize = $BatchSize
			}

			$DataTable.Columns | ForEach-Object {
				[void]$SqlBulkCopy.ColumnMappings.Add($_.ColumnName, $_.ColumnName)
			}

			Write-Verbose 'Writing to server.'

			if ($PSCmdlet.ShouldProcess($TableName, 'Bulk insert into table')) {
				$SqlBulkCopy.WriteToServer($DataTable)
			}

			Write-Verbose 'Bulk copy complete.'
		}
		catch {
			throw $_
		}
		finally {
			if (Test-Path -Path variable:\SqlBulkCopy) {
				$SqlBulkCopy.Close()
				$SqlBulkCopy.Dispose()
			}
		}
	}

	END {
	}
}

function Invoke-SqlClientNonQuery {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
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

	BEGIN {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'DatabaseName') {
				$SqlServerParameters = @{
					'ServerInstance' = $ServerInstance;
					'DatabaseName' = $DatabaseName
				}

				$SqlConnection = Connect-SqlServerInstance @SqlServerParameters
			}
		}
		catch {
			throw $_
		}
	}

	PROCESS {
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

	END {
	}
}

function Publish-SqlDatabaseDacPac {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'ServerInstance'
	)]

	[OutputType([System.Void])]

	PARAM (
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
		[ValidateScript({
			if (-not $(Test-Path -LiteralPath $_ -PathType Leaf)) {
				throw [System.Management.Automation.ErrorRecord]::New(
					[System.ArgumentException]::New("Cannot find path '$_' because it does not exist."),
					'1',
					[System.Management.Automation.ErrorCategory]::InvalidArgument,
					$_
				)
			}
			return $true
		})]
		[System.IO.FileInfo]$DacPacPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.SqlServer.Dac.DacDeployOptions]$DeployOptions
	)

	BEGIN {
		if ($PSBoundParameters.ContainsKey('FailoverPartnerServerInstance')) {
			$ConnectionString = Build-SqlClientConnectionString -ServerInstance $ServerInstance -DatabaseName $DatabaseName -IntegratedSecurity $true
		}
	}

	PROCESS {
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

	END {
	}
}

function Save-SqlClientDataSet {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $true,
		ConfirmImpact = 'Low'
	)]

	[OutputType([System.Void])]

	PARAM (
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[System.Data.DataSet]$DataSet,

		[Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelineByPropertyName = $false
		)]
		[Microsoft.Data.SqlClient.SqlDataAdapter]$SqlDataAdapter
	)

	BEGIN {
	}

	PROCESS {
		try {
			if (-not $PSBoundParameters.ContainsKey('SqlDataAdapter')) {
				$SqlCommandBuilder = [Microsoft.Data.SqlClient.SqlCommandBuilder]::New($SqlDataAdapter)

				$SqlDataAdapter = [Microsoft.Data.SqlClient.SqlDataAdapter]::New($DataSet.ExtendedProperties['SqlCommand'], $DataSet.ExtendedProperties['SqlConnection'])

				$SqlDataAdapter.UpdateCommand = $SqlCommandBuilder.GetUpdateCommand()
				$SqlDataAdapter.InsertCommand = $SqlCommandBuilder.GetInsertCommand()
				$SqlDataAdapter.DeleteCommand = $SqlCommandBuilder.GetDeleteCommand()
			}

			if ($PSCmdlet.ShouldProcess($DataSet.ExtendedProperties['SqlConnection'].Database, 'Save dataset')) {
				[void]$SqlDataAdapter.Update($DataSet)
			}
		}
		catch {
			throw $_
		}
		finally {
			if (Test-Path -Path variable:\SqlCommandBuilder) {
				$SqlCommandBuilder.Dispose()
			}

			if (Test-Path -Path variable:\SqlDataAdapter) {
				$SqlDataAdapter.Dispose()
			}
		}
	}

	END {
	}
}

function Test-SqlBrowserConnection {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'Hostname'
	)]

	[OutputType([System.Boolean])]

	Param(
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

	Begin {
		$ASCIIEncoding = [System.Text.ASCIIEncoding]::New()
		[byte[]]$UDPPacket = 0x02,0x00	#,0x00
	}

	Process {
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

			If ($Response) {
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

	END {
	}
}

function Test-SqlConnection {
	<#
	.EXTERNALHELP
	SQLServerTools-help.xml
	#>

	[System.Diagnostics.DebuggerStepThrough()]

	[CmdletBinding(
		PositionalBinding = $false,
		SupportsShouldProcess = $false,
		ConfirmImpact = 'Low',
		DefaultParameterSetName = 'Hostname'
	)]

	[OutputType([System.Boolean])]

	Param(
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

	BEGIN {
		try {
			$TcpClient = [System.Net.Sockets.TcpClient]::New()
			$TcpClient.SendTimeout = $ConnectionTimeout

			$SqlConnection = [Microsoft.Data.SqlClient.SqlConnection]::New()

			$ConnectionStringParameters = @{
				'DatabaseName' = 'master';
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

	PROCESS {
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

	END {
	}
}


try {
	Add-SqlClientAssembly
	Add-SmoAssembly
}
catch {
	throw $_
}
