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
        Send-MailMessage -To "andrew.brooke@suffolk.gov.uk" -From "andrew.brooke@suffolk.gov.uk" -Subject "Blue Badge Site not Working!  FwdProxy1" -Body $body
        }
    

    $output = [string] $testdate+", "+$uri+", "+$Addresses+", proxy.eadidom.com, "+$webresult.Milliseconds+" milliseconds"

    
try {
    $webresult = Measure-Command { $request = Invoke-WebRequest -Uri $uri -Proxy http://172.31.32.180:8080 -ProxyUseDefaultCredentials }
    }
    catch {
        $webresult = "Unable to download webpage - fwdproxy1"
        Send-MailMessage -To "andrew.brooke@suffolk.gov.uk" -From "andrew.brooke@suffolk.gov.uk" -Subject "Blue Badge Site not Working!  FwdProxy1" -Body $body
        }
    
    $output = $output + ", Proxy1, "+$webresult.Milliseconds+" milliseconds"

try {
    $webresult = Measure-Command { $request = Invoke-WebRequest -Uri $uri -Proxy http://172.31.32.183:8080 -ProxyUseDefaultCredentials }
    }
    catch {
        $webresult = "Unable to download webpage - fwdproxy2"
        Send-MailMessage -To "andrew.brooke@suffolk.gov.uk" -From "andrew.brooke@suffolk.gov.uk" -Subject "Blue Badge Site not Working!  FwdProxy2" -Body $body
        }

    $output = $output + ", Proxy2, "+$webresult.Milliseconds+" milliseconds"

    $output >> "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\F0640128 - Bluebadge website\bbis-webtest.log"