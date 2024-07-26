Describe 'SQL Server Tools' {
	Context 'Add-SmoAvailabilityDatabase' {

	}

	Context 'Add-SmoCoreAssembly' {

	}

	Context 'Add-SmoDatabaseDataFile' {

	}

	Context 'Add-SmoDatabaseEncryptionKey' {

	}

	Context 'Add-SmoDatabaseRoleMember' {

	}

	Context 'Add-SmoServerRoleMember' {

	}
<#
	Context 'Add-SmoWindowsAssembly' {
		InModuleScope {

		}
	}
#>
	Context 'Connect-SmoServer' {

	}

	Context 'Disable-SmoTransparentDatabaseEncryption' {

	}

	Context 'Disconnect-SmoServer' {

	}

	Context 'Enable-SmoTransparentDatabaseEncryption' {

	}

	Context 'Format-SqlInstanceName' {
		It 'Local instance' {
			InModuleScope SQLServerTools {
				$DesiredResult = [PsCustomObject][Ordered]@{
					'ServerHostName' = $null
					'ServerFQDN' = $null
					'DomainName' = $null
					'TcpPort' = $null
					'SqlInstance' = $null
					'SqlInstanceName' = '(local)'
				}

				$Result = Format-SqlInstanceName -ServerInstance '(local)'

				Compare-Object -ReferenceObject $DesiredResult -DifferenceObject $Result | Should -Be $null
			}
		}
<#
		It 'Named instance' {
			InModuleScope SQLServerTools {
				#New-MockObject -Type 'System.Net.Dns' -Methods @{ GetHostByName = { param($ServerHostName) 'demo.contoso.com' } }
				Mock [System.Net.Dns]::GetHostByName { 'demo.contoso.com' }

				$DesiredResult = [PsCustomObject][Ordered]@{
					'ServerHostName' = 'demo'
					'ServerFQDN' = 'demo.contoso.com'
					'DomainName' = 'contoso.com'
					'TcpPort' = $null
					'SqlInstance' = 'MSSQLInstance'
					'SqlInstanceName' = 'demo.contoso.com\MSSQLInstance'
				}

				$Result = Format-SqlInstanceName -ServerInstance 'demo.contoso.com\MSSQLInstance'

				Compare-Object -ReferenceObject $DesiredResult -DifferenceObject $Result | Should -Be $null
			}
		}
#>
	}

	Context 'Get-SmoAvailabilityGroup' {

	}

	Context 'Get-SmoBackupFileList' {

	}

	Context 'Get-SmoBackupHeader' {

	}

	Context 'Get-SmoDatabaseObject' {

	}

	Context 'Invoke-SmoNonQuery' {

	}

	Context 'New-SmoCredential' {

	}

	Context 'New-SmoDatabaseFileGroup' {

	}

	Context 'New-SmoDatabaseRole' {

	}

	Context 'New-SmoDatabaseSchema' {

	}

	Context 'New-SmoDatabaseUser' {

	}

	Context 'New-SmoServerRole' {

	}

	Context 'New-SmoSqlLogin' {

	}

	Context 'Remove-SmoAvailabilityDatabase' {

	}

	Context 'Remove-SmoCredential' {

	}

	Context 'Remove-SmoDatabaseEncryptionKey' {

	}

	Context 'Remove-SmoDatabaseRole' {

	}

	Context 'Remove-SmoDatabaseRoleMember' {

	}

	Context 'Remove-SmoDatabaseSchema' {

	}

	Context 'Remove-SmoDatabaseUser' {

	}

	Context 'Remove-SmoServerRole' {

	}

	Context 'Remove-SmoServerRoleMember' {

	}

	Context 'Remove-SmoSqlLogin' {

	}
<#
	Context 'Rename-CIMFile' {
		InModuleScope {

		}
	}
#>
	Context 'Rename-SmoDatabaseDataFile' {

	}

	Context 'Rename-SmoDatabaseLogFile' {

	}

	Context 'Set-SmoDatabaseObjectPermission' {

	}

	Context 'Set-SmoDatabasePermission' {

	}

	Context 'Set-SmoDatabaseRole' {

	}

	Context 'Set-SmoDatabaseSchema' {

	}

	Context 'Set-SmoDatabaseUser' {

	}

	Context 'Test-RunAsAdministrator' {
		It 'Returns boolean' {
			InModuleScope SQLServerTools {
				Test-RunAsAdministrator | Should -BeOfType Boolean
			}
		}
	}
<#
	Context 'Add-SqlClientCoreAssembly' {
		InModuleScope {

		}
	}
#>
	Context 'Build-SqlClientConnectionString' {
		BeforeAll {
			$SqlClientConnectionStringParameters = @{
				'ServerInstance' = 'SqlInstance'
				'DatabaseName' = 'AdventureWorks'
			}
		}

		It 'Integrated Security' {
			$SqlClientConnectionString = Build-SqlClientConnectionString @SqlClientConnectionStringParameters

			{ [Microsoft.Data.SqlClient.SqlConnectionStringBuilder]::New($SqlClientConnectionString) } | Should -Not -Throw
		}

		It 'With Credentials' {
			$SecureString = ConvertTo-SecureString "MyPlainTextPassword" -AsPlainText -Force
			$PSCredential = [System.Management.Automation.PSCredential]::New("username", $SecureString)

			$SqlClientConnectionStringParameters.Add('Credential', $PSCredential)

			$SqlClientConnectionString = Build-SqlClientConnectionString @SqlClientConnectionStringParameters

			{ [Microsoft.Data.SqlClient.SqlConnectionStringBuilder]::New($SqlClientConnectionString) } | Should -Not -Throw
		}
	}

	Context 'Connect-SqlServerInstance' {

	}

	Context 'Disconnect-SqlServerInstance' {

	}

	Context 'Get-SqlClientDataSet' {

	}

	Context 'Invoke-SqlClientBulkCopy' {

	}

	Context 'Invoke-SqlClientNonQuery' {

	}

	Context 'Publish-SqlDatabaseDacPac' {

	}

	Context 'Save-SqlClientDataSet' {

	}

	Context 'Test-SqlBrowserConnection' {

	}

	Context 'Test-SqlConnection' {

	}
}
