---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: Set-SmoDatabaseCertificate
---

# Set-SmoDatabaseCertificate

## SYNOPSIS

Sets database certificate properties.

## SYNTAX

### DatabaseName (Default)

```
Set-SmoDatabaseCertificate
  -ServerInstance <string>
  -DatabaseName <string>
  -CertificateName <string>
  -PrivateKeyPassword <securestring>
  -NewPrivateKeyPassword <securestring>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
Set-SmoDatabaseCertificate
  -DatabaseObject <Database>
  -CertificateName <string>
  -PrivateKeyPassword <securestring>
  -NewPrivateKeyPassword <securestring>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Sets database certificate properties.

## EXAMPLES

### Example 1

Set-SmoDatabaseCertificate -ServerInstance . -DatabaseName AdventureWorks -CertificateName MyCert -PrivateKeyPassword $(Read-Host -Prompt "Enter private key password" -AsSecureString) -NewPrivateKeyPassword $(Read-Host -Prompt "Enter new private key password" -AsSecureString)

Sets private key password for MyCert certificate in the AdventureWorks database.

### Example 2

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

Set-SmoDatabaseCertificate -DatabaseObject $DatabaseObject -CertificateName MyCert -PrivateKeyPassword $(Read-Host -Prompt "Enter private key password" -AsSecureString) -NewPrivateKeyPassword $(Read-Host -Prompt "Enter new private key password" -AsSecureString)

Sets private key password for MyCert certificate using the database object.

## PARAMETERS

### -CertificateName

Specifies the name of the certificate.

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

### -DatabaseName

Name of database.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatabaseObject

SMO database object

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NewPrivateKeyPassword

Specifies new private key password.

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

### -PrivateKeyPassword

Specifies current private key password.

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

### -ServerInstance

SQL Server host name and instance name.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- SqlServer
ParameterSets:
- Name: DatabaseName
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

### System.Void



## NOTES




## RELATED LINKS

None.

