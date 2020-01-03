############################################################################## 
## 
## Test file transfer speedds from Ipswich to Hollow Road
## Author : Andrew Brooke
## Date : 29 Jul 2016 
## Version : 1.0 
############################################################################## 

$testfile = "100Mb-test-file"
$dest = "\\172.17.240.58\c$\TEMP\"+$testfile
$source = "C:\TEMP\SaxonHouse\"+$testfile
#$dest = "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\F0640128 - Hollow Road\"+$testfile

$testsizeMB = (Get-Item $source).length / 1MB

$upload = (Measure-Command -Expression { Move-Item $source $dest }).TotalSeconds

$download = (Measure-Command -Expression { Move-Item $dest $source }).TotalSeconds
    
$testdate = Get-Date ;

$output = [string] $testdate+", "+$testfile+", "+$testsizeMB+", up, "+$upload+" , down, "+$download

$output >> "\\euser\csd\Data\ICT\Service Management\Problem Management\Problems\F0640128 - Hollow Road\SaxonHouse.log"
