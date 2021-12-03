# Easy iSCSI Services Connection Module (eiSCSI)
This module is a wrapper for the native iSCSI and MPIO powershell modules, created to help ease the management connections and sessions to iSCSI Targets. 

### Installation 
Manually install
```powershell
Import-Module ./path/eiSCSI/eiSCSI.psd1
```

Or install via the PowerShell Gallery
```powershell
Find-Module eiSCSI | Install-Module -confirm:0
```

Or, run the provided InstalleiSCSI.ps1 script. 
```powershell
Unblock-File .\InstalleiSCSI.ps1
.\InstalleiSCSI.ps1
```
Which gives you a simple install menu. 
```powershell
------
1. C:\Users\user\Documents\PowerShell\Modules
2. C:\Program Files\PowerShell\Modules
3. c:\program files\powershell\7\Modules
4. C:\Program Files (x86)\WindowsPowerShell\Modules
5. C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
------
Select Install location:
```

### Example usage: 



You can then use the functions in the module manifest to perform the desired operations. 
```Powershell
# Get existing iscsi sessions
Get-eiSCSISessions

Target IP   Host IP   Configured Sessions Connected Sessions Target IQN
--------   -------   ------------------- ------------------ --------
10.12.0.21 10.12.1.6                   4                  4 iqn.2009-01.com.kaminario:storage.k2.1077801
```

```Powershell
# Connect sessions to target
Connect-eiSCSITarget -targetIP 10.12.0.20 -sessionCount 4

Target IP   Host IP   Configured Sessions Connected Sessions Target IQN
--------   -------   ------------------- ------------------ --------
10.12.0.21 10.12.1.6                   4                  4 iqn.2009-01.com.kaminario:storage.k2.1077801
10.12.0.20 10.12.1.6                   4                  4 iqn.2009-01.com.kaminario:storage.k2.1077801
```

```Powershell
# Disconnect all sessions from target
Disconnect-eiSCSITarget -targetIP 10.12.0.21

Target IP   Host IP   Configured Sessions Connected Sessions Target IQN
--------   -------   ------------------- ------------------ --------
10.12.0.20 10.12.1.6                   4                  4 iqn.2009-01.com.kaminario:storage.k2.1077801
```

```Powershell
# Show the hard connection status for each disk being serviced. 
Get-eiSCSIDisks

Number SerialNumber 10.12.0.20 10.12.0.21
------ ------------ ---------- ----------
     2 1072290000            4          4
     3 107229000d            4          4
     4 107229000e            4          4
     5 107229000f            4          4
```