############################################################################## 
## 
## Test file transfer speedds from Ipswich to Hollow Road
## Author : Andrew Brooke
## Date : 29 Jul 2016 
## Version : 1.0 
############################################################################## 

$testfile = "C:\TEMP\Hollow-Road\100Mb-large-test-file"
$testsizeMB = (Get-Item $testfile).length / 1MB
$Outputreport = ""
##$Outputreport = "<HTML><TITLE>Hollow Road File Transfer Report</TITLE><BODY background-color:peachpuff><font color =""#99000"" face=""Microsoft Tai le""><H2>Hollow Road File Transfer Report</H2></font>"
##$Outputreport += "<h3>Testfile: "+$testfile+" ( "+$testsizeMB+" )"
##$Outputreport += "<Table border=1 cellpadding=0 cellspacing=0><TR bgcolor=gray align=center><TD><B>Test</B></TD><TD><B>Date / Time</B></TD><TD><b>Upload Time (Seconds)</b><TD><B>Date / Time</B></TD><TD><B>Download Time (Seconds)</B></TD></TR>" 



    $testdateup = Get-Date
    $upload = Measure-Command -Expression { Move-Item C:\TEMP\Hollow-Road\100Mb-large-test-file \\172.18.76.148\c$\TEMP\ }
    $testdatedown = Get-Date
    $download = Measure-Command -Expression { Move-Item \\172.18.76.148\c$\TEMP\100Mb-large-test-file C:\TEMP\Hollow-Road\100Mb-large-test-file  }
    #$Outputreport += "<TR><TD> Ipswich - Hollow Road </TD><TD align=center> $testdateup </TD><td align=center>"+$upload.seconds+" </td><TD align=center >"+$testdatedown+" </TD><TD align=center>"+$download.Seconds+" </TD></TR>" 
    
    
    $Outputreport += $testdateup+", "+$testdatedown
    

    #$Outputreport += "</Table></BODY></HTML>"
    $Outputreport >> "C:\TEMP\Hollow-Road\HollowRoad-test.csv"
    #$Outputreport | out-file C:\TEMP\Hollow-Road\HollowRoad-test.htm
    #Start-Sleep 10
