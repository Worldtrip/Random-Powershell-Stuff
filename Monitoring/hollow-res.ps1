for (;;) { 


$testdate = Get-Date ; 


$WriteTest = Measure-Command { Copy-Item .\test.txt \\172.18.76.141\c$\TEMP\ } 

$ReadTest = Measure-Command { Copy-Item \\172.18.76.141\c$\TEMP\test.txt . }             


$TotalSize = (Get-ChildItem Test.txt -ErrorAction Stop).Length 



$WriteMbps = [Math]::Round((($TotalSize * 8) / $WriteTest.TotalSeconds) / 1048576,2) 

$ReadMbps = [Math]::Round((($TotalSize * 8) / $ReadTest.TotalSeconds) / 1048576,2) 


$output = [string] $testdate+", Ips-Hol,"+$WriteMbps+", Hol-Ipw,"+$ReadMbps+","+$TotalSize+","+$WriteTest.TotalSeconds+"seconds up, "+$ReadTest.TotalSeconds+"seconds down" 


$output >> "c:\TEMP\Network\ABLaptop to Greg Laptop Hollow Road test.log" 


$testdate 

Start-Sleep 600 



}  


(Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2003*' } -Properties OperatingSystem, LastLogon).LastLogon | %{if([datetime]$_.year -eq 417){$_}}
