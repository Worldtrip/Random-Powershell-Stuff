[array]$WirelessAdapters = $null
[array]$AllNetworkDrivers = Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" -ErrorAction SilentlyContinue | Where-Object {($_.Name).Substring($_.Name.Length - 4, 4) -match "[0-9]"}
[array]$ActiveConnections = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = $True" # Collect all active connections

# FIND ALL WLAN ADAPTERS AND ADD TO $WirelessAdapters
foreach ($NetworkDriver in $AllNetworkDrivers){
    if ((Get-ItemProperty $NetworkDriver.PSPath)."*MediaType" -eq 16){ $WirelessAdapters += (Get-ItemProperty $NetworkDriver.PSPath)."DriverDesc" }
}

# COMPARE ACTIVE CONNECTIONS WITH WIRELESS DRIVERS
foreach($ActiveConnection in $ActiveConnections){
    foreach($WirelessAdapter in $WirelessAdapters){
        if($ActiveConnection.Description -eq $WirelessAdapter){
           # YOU HAVE AN ACTIVE WLAN CONNECTION
           Write-Host "OMG - YOU HAVE AN ACTIVE WLAN CONNECTION!"
        }
    }
}