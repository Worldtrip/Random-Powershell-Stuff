############################################################################## 
## 
## Test file transfer speeds from Ipswich to Hollow Road
## Author : Andrew Brooke
## Date : 29 Jul 2016 
## Version : 1.0 
############################################################################## 

$testfile = "100Mb-test-file"
#$testfile = "data.BIN"
#$dest = "\\172.18.76.142\c$\TEMP\"+$testfile
$dest = "\\172.18.76.148\c$\TEMP\"+$testfile
$source = "C:\TEMP\Hollow-Road\"+$testfile
#$dest = "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\F0640128 - Hollow Road\"+$testfile

$testsizeMB = (Get-Item $source).length / 1MB

$upload = (Measure-Command -Expression { Move-Item $source $dest }).TotalSeconds

$download = (Measure-Command -Expression { Move-Item $dest $source }).TotalSeconds
    
$testdate = Get-Date ;

$output = [string] $testdate+", "+$testfile+", "+$testsizeMB+", up, "+$upload+" , down, "+$download

$output >> "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\F0640128 - Hollow Road\F0640128.log"
