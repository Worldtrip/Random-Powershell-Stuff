#$uri############################################################################# 
## 
## DNS Lookup and proxy monitoring
## Author : Andrew Brooke
## Date : 28 Jul 2016 
## Version : 1.0 
############################################################################## 
 
 
## The URI list to test 

$websites = Get-Content c:\temp\websites.txt 

$Outputreport = "<HTML><TITLE>Website Availability Report</TITLE><BODY background-color:peachpuff><font color =""#99000"" face=""Microsoft Tai le""><H2> Website Availability Report </H2></font><Table border=1 cellpadding=0 cellspacing=0><TR bgcolor=gray align=center><TD><B>URL</B></TD><TD><B>nslookup</B></TD><TD><b>Status</b><TD><B>Proxy 1 (milliseconds)</B></TD><TD><B>Proxy 2 (milliseconds)</B></TD></TR>" 

  Foreach($uri in $websites) { 
  
  try {
        $Addresses = [System.Net.Dns]::GetHostAddresses("$uri").IPAddressToString
    }
    catch { 
        $Addresses = "Unable to resolve."
    }
  $webaddress = "https://"+$uri
  try {
    $webresult1 = Measure-Command { $request = Invoke-WebRequest -Uri $webaddress -Proxy http://172.31.32.180:8080 -ProxyUseDefaultCredentials }
    }
    catch {
        $webresult1 = "Unable to download webpage - fwdproxy1"
     }

  try {
    $webresult2 = Measure-Command { $request = Invoke-WebRequest -Uri $webaddress -Proxy http://172.31.32.183:8080 -ProxyUseDefaultCredentials }
    }
  catch {
        $webresult2 = "Unable to download webpage - fwdproxy2"
    }

  
    #Prepare email body in HTML format 

    
    $Outputreport += "<TR><TD>$uri</TD><TD align=center>$Addresses</TD><td align=center>"+$request.StatusCode+"</td><TD align=center>"+$webresult1.Milliseconds+"</TD><TD align=center>"+$webresult2.Milliseconds+" </TD></TR>" 
     
 
} 

    $Outputreport += "</Table></BODY></HTML>"
 
$Outputreport | out-file C:\temp\Test-websites.htm
## Invoke-Expression C:\Scripts\Test.htm 