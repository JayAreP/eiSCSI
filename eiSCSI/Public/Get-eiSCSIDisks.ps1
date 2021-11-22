function Get-eiSCSIDisks {
    param(
        [Parameter()]
        [ipaddress] $targetIP,
        [Parameter()]
        [int] $diskNumber
    )

    if ($diskNumber) {
        $eiSCSIDisks = Get-Disk -number $diskNumber
    } else {
        $eiSCSIDisks = Get-Disk 
        Write-Host -ForegroundColor yellow "-- No disk ID specified, query may take a while to run."
    }
    

    if ($targetIP) {
        $allConnections = Get-IscsiConnection | where-object {$_.TargetAddress -eq $targetIP.IPAddressToString}
    } else {
        $allConnections = Get-IscsiConnection 
        Write-Host -ForegroundColor yellow "-- No target IP specified, query may take a while to run."
    }

    $returnArray = @()

    $allTargetIPs = ($allConnections | Select-Object TargetAddress -Unique).TargetAddress

    foreach ($d in $eiSCSIDisks) {
        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name "Number" -Value $d.Number
        $o | Add-Member -MemberType NoteProperty -Name "SerialNumber" -Value $d.SerialNumber
        foreach ($i in $allTargetIPs) {
            $paths = 0
            foreach ($s in $allConnections) {
                if ($s.TargetAddress -eq $i) {                    
                    $path = $s | Get-IscsiSession | Get-Disk | Where-Object {$_.SerialNumber -eq $d.SerialNumber}
                    if ($path) {
                        $paths++
                    }
                }
            }

            $o | Add-Member -MemberType NoteProperty -Name $i -Value $paths
        }
        $returnArray += $o
    }
    return $returnArray
}