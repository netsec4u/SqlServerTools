---
document type: cmdlet
external help file: SqlServerTools-Help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: New-SmoSqlLogin
---

# New-SmoSqlLogin

## SYNOPSIS

Create SQL login.

## SYNTAX

### ServerInstance (Default)

```
New-SmoSqlLogin
  -ServerInstance <string>
  -LoginName <string>
  -Password <securestring>
  -LoginType <LoginType>
  [-PasswordIsHashed]
  [-DefaultDatabase <string>]
  [-Sid <byte[]>]
  [-PasswordExpirationEnabled <bool>]
  [-PasswordPolicyEnforced <bool>]
  [-LoginDisabled <bool>]
  [-MustChangePassword <bool>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### SmoServer

```
New-SmoSqlLogin
  -SmoServerObject <Server>
  -LoginName <string>
  -Password <securestring>
  -LoginType <LoginType>
  [-PasswordIsHashed]
  [-DefaultDatabase <string>]
  [-Sid <byte[]>]
  [-PasswordExpirationEnabled <bool>]
  [-PasswordPolicyEnforced <bool>]
  [-LoginDisabled <bool>]
  [-MustChangePassword <bool>]
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Create SQL login.

## EXAMPLES

### Example 1

```powershell
New-SmoSqlLogin -ServerInstance MyServer -LoginName MyLogin -Password $(Read-Host -Prompt "Enter password" -AsSecureString)
```

Creates SQL login on MyServer SQL instance.

### Example 2

```powershell
$SmoServerObject = Connect-SmoServer -ServerInstance .
New-SmoSqlLogin -SmoServerObject $SmoServerObject -LoginName MyLogin -Password $(Read-Host -Prompt "Enter password" -AsSecureString)
```

Creates SQL login using SMO server object.

### Example 3

```powershell
New-SmoSqlLogin -ServerInstance MyServer -LoginName MyLogin -Password $(Read-Host -Prompt "Enter password" -AsSecureString) -Sid '0x615C96F6296B18438C6DF0304CD56CE0'
```

Creates SQL login using specified SID.

### Example 4

```powershell
$SqlLogin = Get-SqlLogin -ServerInstance SomeServer -LoginName MyLogin
New-SmoSqlLogin -ServerInstance MyServer -LoginName MyLogin -Password $(Read-Host -Prompt "Enter password" -AsSecureString) -Sid $SqlLogin.Sid
```

Create SQL login using SID retrieved from Get-SqlLogin.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -DefaultDatabase

Specifies default database for login.

```yaml
Type: System.String
DefaultValue: Master
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

### -LoginDisabled

Login disabled.

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

### -LoginName

Login name.

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

### -LoginType

Specifies type of SQL login.

```yaml
Type: Microsoft.SqlServer.Management.Smo.LoginType
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

### -MustChangePassword

Specifies user must change password on next logon.

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

### -Password

Password for login.

```yaml
Type: System.Security.SecureString
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

### -PasswordExpirationEnabled

Specifies password expiration to be enabled.

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

### -PasswordIsHashed

Specifies the password in the Password parameter is a hashed value.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -PasswordPolicyEnforced

Password policy enforced.

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

### -ServerInstance

The name of the SQL Server instance to connect to.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: ServerInstance
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Sid

Specifies Sid as a string or byte array for login.

```yaml
Type: System.Byte[]
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

### -SmoServerObject

An existing SMO Server object representing the SQL Server instance.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Server
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SmoServer
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### Microsoft.SqlServer.Management.Smo.Login



## NOTES




## RELATED LINKS

None.

