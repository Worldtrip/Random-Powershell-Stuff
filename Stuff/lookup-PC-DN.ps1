##
## Read hostname in CSV File and add column with DN
##
## Author:	 	Andrew Broke 
## Date:		30/11/2017

$datacsv = "\\euser.eroot.eadidom.com\csd\Data\ICT\Service Management\Problem Management\Problems\GPO-PC-details.csv"

$data = Import-Csv $datacsv | Select-Object *,@{Name='DN';Expression={'set'}}

foreach ($row in $data) {
        
    $device = $row.'Device Name'

    try {[string] $DN = Get-ADComputer $device}
    catch { $DN = "" }

    
    $row.DN = $DN 
    
    $device

    }

$data | Export-Csv $datacsv 