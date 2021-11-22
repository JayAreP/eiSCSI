function Get-eiSCSISessions {
    param(
        [Parameter()]
        [ipaddress] $targetIP,
        [Parameter()]
        [switch] $update
    )

    if ($update) {
        Update-MPIOClaimedHW -Confirm:0 | Out-Null # Rescan
    }

    if ($targetIP) {
        $allConnections = Get-IscsiConnection | where-object {$_.TargetAddress -eq $targetIP.IPAddressToString}
    } else {
        $allConnections = Get-IscsiConnection 
    }

    $returnArray = @()

    $allTargetIPs = ($allConnections | Select-Object TargetAddress -Unique).TargetAddress

    foreach ($i in $allTargetIPs) {
        $o = New-Object psobject
        $o | Add-Member -MemberType NoteProperty -Name "Target IP" -Value $i
        $o | Add-Member -MemberType NoteProperty -Name "Host IP" -Value ($allConnections | Where-Object {$_.TargetAddress -eq $i} | Select-Object InitiatorAddress -Unique).InitiatorAddress
        $configured = ($allConnections | Where-Object {$_.TargetAddress -eq $i} | Get-IscsiSession | Where-Object {$_.IsDiscovered} | Measure-Object).count
        if ($configured) {
            $o | Add-Member -MemberType NoteProperty -Name "Configured Sessions" -Value $configured
        } else {
            $o | Add-Member -MemberType NoteProperty -Name "Configured Sessions" -Value 0
        }

        $connected = ($allConnections | Where-Object {$_.TargetAddress -eq $i} | Measure-Object).count
        if ($connected) {
            $o | Add-Member -MemberType NoteProperty -Name "Connected Sessions" -Value $connected
        } else {
            $o | Add-Member -MemberType NoteProperty -Name "Connected Sessions" -Value 0 
        }
        $o | Add-Member -MemberType NoteProperty -Name "Target IQN" -Value ($allConnections | Where-Object {$_.TargetAddress -eq $i} |Get-IscsiSession | Select-Object TargetNodeAddress -Unique).TargetNodeAddress

        $returnArray += $o
    }

    if ($returnArray) {
        return $returnArray | Sort-Object "Target IP" | Format-Table
    } else {
        return $null
    }
}