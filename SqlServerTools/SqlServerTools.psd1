@{

# Script module or binary module file associated with this manifest.
RootModule = 'SqlServerTools.psm1'

# Version number of this module.
ModuleVersion = '3.6.1.2'

# Supported PSEditions
CompatiblePSEditions = @('Core', 'Desktop')

# ID used to uniquely identify this module
GUID = '0dbb8289-ae5b-4633-afc8-dfaf0acbe06c'

# Author of this module
Author = 'Robert Eder'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2021 Robert Eder. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Module provides SQL Server Client and SQL Management Object (SMO) functions.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(
	@{ModuleName="SqlServer"; ModuleVersion="22.3.0"; GUID="97c3b589-6545-4107-a061-3fe23a4e9195"}
)

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @(
	'SqlServerTools.Types.ps1xml'
)

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @(
	'SqlServerTools.Format.ps1xml'
)

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
	'Add-SmoAvailabilityDatabase',
	'Add-SmoDatabaseAsymmetricKeyPrivateKey',
#	'Add-SmoDatabaseCertificatePrivateKey',
	'Add-SmoDatabaseDataFile',
	'Add-SmoDatabaseMasterKeyPasswordEncryption',
	'Add-SmoDatabaseMasterKeyServiceKeyEncryption',
	'Add-SmoDatabaseRoleMember',
	'Add-SmoDatabaseSymmetricKeyKeyEncryption',
	'Add-SmoServerRoleMember',
	'Close-SmoDatabaseMasterKey',
	'Close-SmoDatabaseSymmetricKey',
	'Connect-SmoServer',
	'Disable-SmoTransparentDatabaseEncryption',
	'Disconnect-SmoServer',
	'Enable-SmoTransparentDatabaseEncryption',
	'Export-SmoDatabaseCertificate',
	'Export-SmoDatabaseMasterKey',
	'Export-SmoServiceMasterKey',
	'Get-SmoAvailabilityGroup',
	'Get-SmoBackupFileList',
	'Get-SmoBackupHeader',
	'Get-SmoDatabaseAsymmetricKey',
	'Get-SmoDatabaseCertificate',
	'Get-SmoDatabaseEncryptionKey',
	'Get-SmoDatabaseMasterKey',
	'Get-SmoDatabaseObject',
	'Get-SmoDatabaseSymmetricKey',
	'Import-SmoDatabaseMasterKey',
	'Import-SmoServiceMasterKey',
	'Invoke-SmoNonQuery',
	'New-SmoCredential',
	'New-SmoDatabaseAsymmetricKey',
	'New-SmoDatabaseCertificate',
	'New-SmoDatabaseEncryptionKey',
	'New-SmoDatabaseFileGroup',
	'New-SmoDatabaseMasterKey',
	'New-SmoDatabaseRole',
	'New-SmoDatabaseSchema',
	'New-SmoDatabaseSymmetricKey',
	'New-SmoDatabaseUser',
	'New-SmoServerRole',
	'New-SmoSqlLogin',
	'Open-SmoDatabaseMasterKey',
	'Open-SmoDatabaseSymmetricKey'
	'Remove-SmoAvailabilityDatabase',
	'Remove-SmoCredential',
	'Remove-SmoDatabaseAsymmetricKey',
	'Remove-SmoDatabaseAsymmetricKeyPrivateKey',
	'Remove-SmoDatabaseCertificate',
	'Remove-SmoDatabaseEncryptionKey',
	'Remove-SmoDatabaseMasterKey',
	'Remove-SmoDatabaseMasterKeyPasswordEncryption',
	'Remove-SmoDatabaseMasterKeyServiceKeyEncryption',
	'Remove-SmoDatabaseRole',
	'Remove-SmoDatabaseRoleMember',
	'Remove-SmoDatabaseSchema',
	'Remove-SmoDatabaseSymmetricKey',
	'Remove-SmoDatabaseSymmetricKeyKeyEncryption',
	'Remove-SmoDatabaseUser',
	'Remove-SmoServerRole',
	'Remove-SmoServerRoleMember',
	'Remove-SmoSqlLogin',
	'Rename-SmoDatabaseDataFile',
	'Rename-SmoDatabaseLogFile',
	'Reset-SmoDatabaseEncryptionKey',
	'Reset-SmoDatabaseMasterKey',
	'Reset-SmoServiceMasterKey',
	'Set-SmoCredential',
	'Set-SmoDatabaseAsymmetricKey',
	'Set-SmoDatabaseCertificate',
	'Set-SmoDatabaseEncryptionKey',
	'Set-SmoDatabaseObjectPermission',
	'Set-SmoDatabasePermission',
	'Set-SmoDatabaseRole',
	'Set-SmoDatabaseSchema',
	'Set-SmoDatabaseUser',
	'Set-SmoServerRole',
	'Set-SmoSqlLogin',
	'Build-SqlClientConnectionString',
	'Connect-SqlServerInstance',
	'Disconnect-SqlServerInstance',
	'Get-SqlClientDataSet',
	'Invoke-SqlClientBulkCopy',
	'Invoke-SqlClientNonQuery',
	'Publish-SqlDatabaseDacPac',
	'Save-SqlClientDataSet',
	'Test-SqlBrowserConnection',
	'Test-SqlConnection'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
# CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @(
	'Add-SmoDatabaseEncryptionKey'
)

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @(
	'SqlServerTools.psm1',
	'SqlServerTools.Format.ps1xml',
	'SqlServerTools.Types.ps1xml'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

	PSData = @{

		# Tags applied to this module. These help with module discovery in online galleries.
		Tags = @('SQLServerClient', 'Smo', 'SQLManagementObjects')

		# A URL to the license for this module.
		LicenseUri = 'https://raw.githubusercontent.com/netsec4u/SqlServerTools/main/LICENSE'

		# A URL to the main website for this project.
		ProjectUri = 'https://github.com/netsec4u/SqlServerTools'

		# A URL to an icon representing this module.
		# IconUri = ''

		# ReleaseNotes of this module
		ReleaseNotes = 'Release Notes

			Known Issues:
				Add-SmoDatabaseSymmetricKeyKeyEncryption - Returns an error indicating symmetric key not open despite key being open.
				Open-SmoDatabaseSymmetricKey - Does not always open symmetric key.
				Remove-SmoDatabaseSymmetricKeyKeyEncryption - Returns an error indicating symmetric key not open despite key being open.
		'

		# Prerelease string of this module
		# Prerelease = ''

		# Flag to indicate whether the module requires explicit user acceptance for install/update/save
		# RequireLicenseAcceptance = $true

		# External dependent modules of this module
		# ExternalModuleDependencies = @()
	} # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/netsec4u/SqlServerTools/blob/main/docs/SqlServerTools.md'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
