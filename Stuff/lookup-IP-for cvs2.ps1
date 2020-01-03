##
## Lookup IP addresses in CSV File and add column with hostname
##
## Author:	 	Andrew Broke 
## Date:		22/12/2016

$datacsv = "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\F0718095 - Internet Usage\test.csv"

$data = Import-Csv $datacsv | Select-Object *,@{Name='hostname';Expression={'set'}}

foreach ($row in $data) {
        
    $ipaddress = $row.'Source address'

    try { $hostname = [System.Net.Dns]::GetHostEntry($ipaddress).HostName }
    catch { $hostname = "unabe to resolve IP address"
    }
    $row.hostname = $hostname 
    $hostname

    }

$data | Export-Csv $datacsv 