$path = "\\euser.eroot.eadidom.com\csd\Logs\DriveMappingIssue\"
$file =  "LT7-D399WZ1-lawsj2.txt"
$pattern = "(\d+\.\d+\.\d+\.\d+)"
$ipaddresses = Get-Content $path$file | Select-String -Pattern $pattern 
foreach ($ipaddress in $ipaddresses) {
    
    $ip = $ipaddress -replace "IPv4 Address. . . . . . . . . . . :"
    $ip.ToString()
    $addresses += $ip.ToString()
        
    }