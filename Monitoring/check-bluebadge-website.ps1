$uri = "bbis.nps.gse.gov.uk"
$PSEmailServer = "smtphub.suffolkcc.gov.uk"
$body = "https://bbis.nps.gse.gov.uk/ Not working!!!"

$testdate = Get-Date ;

try {
        $Addresses = [System.Net.Dns]::GetHostAddresses("$uri").IPAddressToString
    }
    catch { 
        $Addresses = "Server IP cannot resolve."
    }

try {
    $webresult = Measure-Command { $request = Invoke-WebRequest -Uri $uri -Proxy http://proxy.eadidom.com:8080 -ProxyUseDefaultCredentials }
    }
    catch {
        $webresult = "Unable to download webpage - New Proxy1"
         }
    

    $output = [string] $testdate+", "+$uri+", "+$Addresses+", proxy.eadidom.com, "+$webresult.Milliseconds+" milliseconds"

    

    $webresult = Measure-Command { $request = Invoke-WebRequest -Uri $uri -Proxy http://172.31.32.180:8080 -ProxyUseDefaultCredentials }
    $output = $output + ", Proxy1, "+$webresult.Milliseconds+" milliseconds"
    $webresult = Measure-Command { $request = Invoke-WebRequest -Uri $uri -Proxy http://172.31.32.183:8080 -ProxyUseDefaultCredentials }
    $output = $output + ", Proxy2, "+$webresult.Milliseconds+" milliseconds"

    $output >> "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\F0640128 - Bluebadge website\bbis-webtest.log"



    
