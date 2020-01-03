$datacsv = "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\F0718095 - Internet Usage\20161214_0815-1015.csv"

$data = Import-Csv $datacsv | Select-Object *,@{Name='hostname';Expresssion={'dd'}}

foreach ($row in $data) {
        
    $ipaddress = $row.'Source address'

    try { $hostname = [System.Net.Dns]::GetHostByAddress($ipaddress).IPAddressToString }
    catch { $hostname = "unabe to resolve IP address"
    }

    $hostname

    }

#$data | Export-Csv $datacsv 


