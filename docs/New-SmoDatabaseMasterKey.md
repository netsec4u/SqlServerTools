---
document type: cmdlet
external help file: SqlServerTools-help.xml
HelpUri: ''
Locale: en-US
Module Name: SqlServerTools
ms.date: 07/29/2025
PlatyPS schema version: 2024-05-01
title: New-SmoDatabaseMasterKey
---

# New-SmoDatabaseMasterKey

## SYNOPSIS

Creates database master key.

## SYNTAX

### DatabaseName (Default)

```
New-SmoDatabaseMasterKey
  -ServerInstance <string>
  -DatabaseName <string>
  -EncryptionPassword <securestring>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseName-CertFile

```
New-SmoDatabaseMasterKey
  -ServerInstance <string>
  -DatabaseName <string>
  -EncryptionPassword <securestring>
  -Path <FileInfo>
  -DecryptionPassword <securestring>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject-CertFile

```
New-SmoDatabaseMasterKey
  -DatabaseObject <Database>
  -EncryptionPassword <securestring>
  -Path <FileInfo>
  -DecryptionPassword <securestring>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

### DatabaseObject

```
New-SmoDatabaseMasterKey
  -DatabaseObject <Database>
  -EncryptionPassword <securestring>
  [-WhatIf]
  [-Confirm]
  [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
  None

## DESCRIPTION

Creates database master key.

## EXAMPLES

### Example 1

New-SmoDatabaseMasterKey -ServerInstance . -DatabaseName AdventureWorks -EncryptionPassword $(Read-Host -Prompt "Enter encryption password" -AsSecureString)

Creates new database master key and encrypt with specified password.

### Example 2

New-SmoDatabaseMasterKey -ServerInstance . -DatabaseName AdventureWorks -EncryptionPassword $(Read-Host -Prompt "Enter encryption password" -AsSecureString) -Path C:\AdventureWorks.DMK -DecryptionPassword $(Read-Host -Prompt "Enter decryption password" -AsSecureString)

Creates new database master key and encrypt with specified password from file.

### Example 3

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject -EncryptionPassword $(Read-Host -Prompt "Enter encryption password" -AsSecureString) -Path C:\AdventureWorks.DMK -DecryptionPassword $(Read-Host -Prompt "Enter decryption password" -AsSecureString)

Creates new database master key and encrypt with specified password from file using the database object.

### Example 4

$DatabaseObject = Get-SmoDatabaseObject -ServerInstance . -DatabaseName AdventureWorks

New-SmoDatabaseMasterKey -DatabaseObject $DatabaseObject -EncryptionPassword $(Read-Host -Prompt "Enter encryption password" -AsSecureString)

Creates new database master key and encrypt with specified password using the database object.

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

### -DatabaseName

Name of database.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseName-CertFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

SMO database object.

```yaml
Type: Microsoft.SqlServer.Management.Smo.Database
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-CertFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### -DecryptionPassword

Specifies the decryption password from file to create master key from.

```yaml
Type: System.Security.SecureString
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-CertFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-CertFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -EncryptionPassword

Specifies the encryption password for database master key.

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

### -Path

Path to database master key to create master key from.

```yaml
Type: System.IO.FileInfo
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DatabaseObject-CertFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DatabaseName-CertFile
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
- Name: DatabaseName-CertFile
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### Microsoft.SqlServer.Management.Smo.MasterKey



## NOTES




## RELATED LINKS

None.

