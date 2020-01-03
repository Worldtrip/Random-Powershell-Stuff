$output = "\\euser.eroot.eadidom.com\csd\Data\ICT\Service Management\Problem Management\Problems\F0429879 - Drive Mapping\analysis3.csv"

$files = (Get-ChildItem \\euser.eroot.eadidom.com\csd\Logs\DriveMappingIssue).Name

$path = "\\euser.eroot.eadidom.com\csd\Logs\DriveMappingIssue\"

$outputline = "UserId, PC Reference, Logon Script, Occurances, IP Addresses"

$outputline >> $output

foreach ($file in $files) {

    $user1=($file.Split("-")[2])
    $user=($user1.Split(".")[0])

    $computer = ($file.Split("-")[0])+"-"+($file.Split("-")[1])

    $occurances = Get-Content $path$file | Measure-Object -Line
    $occurances = ($occurances.Lines / 2)+1
    $occurances = [math]::Round($occurances)


    $loginscript = try { (Get-ADUser $user -Properties ScriptPath).ScriptPath }
    catch { $loginscript = " unable to look up AD" }

# Count occurrences
    $path = "\\euser.eroot.eadidom.com\csd\Logs\DriveMappingIssue\"
    #$file =  "LT7-D399WZ1-lawsj2.txt"
    $pattern = "Computer"
    $occurances = Get-Content $path$file | Select-String -Pattern $pattern 

# Extract IP Addresses
    $pattern = "(\d+\.\d+\.\d+\.\d+)"
    $ipaddresses = Get-Content $path$file | Select-String -Pattern $pattern 
    $addresses = ""
    foreach ($ipaddress in $ipaddresses) {
    
        $ip = $ipaddress -replace "IPv4 Address. . . . . . . . . . . :"
        $addresses += $ip.ToString()
        
    }
    
    $outputline = $user+", "+$computer+", "+$loginscript+", "+$occurances.Matches.Count+", "+$addresses

    $outputline >> $output

}