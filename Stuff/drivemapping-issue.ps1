
Get-ChildItem \\euser\csd\Logs\DriveMappingIssue\  |
sort LastWriteTime -Descending |
where-object {$_.lastwritetime -gt (get-date).addDays(-1)} |

Foreach-Object { 

    $a,$b,$username = $_.Name.split('-')
    
    $pcref = $a+"-"+$b
    $lastline = Get-Content \\euser\csd\Logs\DriveMappingIssue\$_ | Select-Object -Last 1
    $IP = $lastline.Split(":")
    Write-Host($pcref+" "+$username+" "+$_.lastwritetime+" "+$IP[1])

    }

## Get-EventLog -LogName Application -ComputerName LT7-j6ckyy1 -After 25/08/2016 | Where-Object { $_.Source -eq "Error" }
## 

##(Get-WmiObject -Class win32_ntdomain -ComputerName PC7-CZC3177FNY).DomainControllerName