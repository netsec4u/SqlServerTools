# SqlServerTools

## Description

This module contains functions to leverage the .NET Sql Client and SQL Management Object (SMO).  Originally created to provide SQL Server support beyond what SqlPS provided.  More recently, it has transition to compliment the SqlServer module.  It is not a replacement for the SqlServer module.  One key feature of this module is it promotes session reuse for both SMO and SQL Client.  

## Support

This module has extensively been used within PowerShell on Windows connected to SQL Server 2012 to 2022 on Windows.  Limited testing has been performed within a PowerShell running on non-Windows operating systems or SQL Server on Linux.  Most functions should work as expected; however, I expect some issues to exist for functions that interact with the file system, such as Add-SmoDatabaseDataFile.
