<#
.Synopsis
   Powershell script to extract Health status report from Office 365 portal 
.DESCRIPTION
   Powershell script to extract Health status report from Office 365 portal
   please update the where clause as per the requirement in this script I've fetched the details which are updated today and a yesterday
 
.NOTES    
    Name: Get-O365HealthStatus_Report.ps1
    Author: Deepak Vishwakarma
    Email : Deepitpro@outlook.com
    Version: 0.1 
    DateCreated: 17 September  2017
#>

#Connect-MsolService

$credential = Get-Credential
$path = "C:\" #"<Please define the path here >"
$outputFile1 = "$path\$date\O365_Health_Status_Report_$date.csv"
$jsonPayload = (@{userName=$credential.username;password=$credential.GetNetworkCredential().password;} | convertto-json).tostring()
$cookie = (invoke-restmethod -contenttype "application/json" -method Post -uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/Register" -body $jsonPayload).RegistrationCookie
$jsonPayload = (@{lastCookie=$cookie;locale="en-US";preferredEventTypes=@(0,1)} | convertto-json).tostring()
$events = (invoke-restmethod -contenttype "application/json" -method Post -uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/GetEvents" -body $jsonPayload)
$Issues = $events.Events

#This can be modified as per the requirements 
$RequiredDate = (Get-Date).AddDays(-1)
$Issuess = $Issues | Where-Object {$_.LastUpdatedTime -ige $RequiredDate}
function Get-Eventdetails
{
Param($issues)
foreach($Issue in $Issuess)
{
$props = @{Service_Name = ($Issue.AffectedServiceHealthStatus).ServiceName
Status = $Issue.Status
Start_time = $Issue.StartTime
Message =[String]($Issue.Messages).MessageText -replace "`n|`r""_"
End_Time =$Issue.EndTime
ID = $Issue.Id
Last_Updated_Time = $Issue.LastUpdatedTime
}
[pscustomobject]$props
}
}
 
Eventdetails $issues | Export-CSV $outputFile1 -NoTypeInformation
 
Write-Host "----------------------------------------------------------------------" -f White
Write-Host "Office 365 health status report featched" -f Yellow
Write-Host "----------------------------------------------------------------------" -f White