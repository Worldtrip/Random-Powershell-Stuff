$uri = "https://tricostar.suffolk.local"

$testdate = Get-Date ;


try {
    $webresult = Measure-Command { $request = Invoke-WebRequest -Uri $uri  }
    }
    catch {
        $webresult = "Unable to download webpage"
         }
    

    $output = [string] $testdate+", "+$uri+", "+$webresult.Milliseconds+" milliseconds"

    
    $output >> "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\Tricostar-webtest.log"
