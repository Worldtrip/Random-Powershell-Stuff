############################################################################## 
## file transfer test
############################################################################## 

$testfile = "test-file-1MB"
# 172.16.34.34   -  PC located in Landmark House.
# 172.31.64.10   -  PC located in DataCentre 

$dest = "\\172.16.34.34\c$\Ping-test\"+$testfile
$source = "C:\Ping-test\"+$testfile

$testsizeMB = (Get-Item $source).length / 1MB

$upload = (Measure-Command -Expression { Move-Item $source $dest }).TotalSeconds

$download = (Measure-Command -Expression { Move-Item $dest $source }).TotalSeconds
    
$testdate = Get-Date ;

$outputup = [string] $testdate+", "+$testsizeMB+"Mb, "+$source+" -> "+$dest+", "+$upload
$outputup >> "C:\Ping-test\transfer-up.log"

$outputdown = [string] $testdate+", "+$testsizeMB+"Mb, "+$dest+" -> "+$source+", "+$download
$outputdown >> "C:\Ping-test\transfer-down.log"