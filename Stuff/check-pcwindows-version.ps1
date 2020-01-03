$pcs = Get-ADComputer -Filter { OperatingSystemvERSION -eq "10.0 (17763)" } -Properties OperatingSystemvERSION

foreach($pc in $pcs) { 
    Get-ADComputer $pc.Name -Properties lastlogontimestamp | 
    Select-Object @{n="Computer";e={$_.Name}}, @{Name="Lastlogon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}
}

Get-WinEvent  -Computer ltx-8y9sgc2 -FilterHashtable @{Logname='Security';ID=4672} -MaxEvents 1|
     select @{N='User';E={$_.Properties[1].Value}}

     Get-ADComputer ltx-fqc9yy1 -Properties OperatingSystemvERSION, OperatingSystem

     Get-HotFix ltx-fqc9yy1

     Get-ADComputer -Filter { OperatingSystemvERSION -eq "10.0 (17134)" } -Properties OperatingSystemvERSION)
