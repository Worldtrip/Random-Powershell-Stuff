##########################################################################
#
#Test-SharePointPerformance.ps1
#
#Test File upload and dowload performance to SharePoint online
#
#BLD - 01/10/2018 - Version 1 - Initial script
#AJB - 22/03/2019 - Version 1.1 - Updated to ...
#
##########################################################################

#Preset variables
. 'C:\TEMP\SharePoint-Monitoring\eUser-LowerCredentials.ps1'
$SiteCollection = "https://suffolknet-my.sharepoint.com/personal/andrew_brooke_suffolk_gov_uk"

$DocLibName = "Documents"
$TodayDate = Get-Date -Format "yyyy-MM-dd"
$WorkPath = 'C:\TEMP\SharePoint-Monitoring\output'
$Folder = $WorkPath + "\SharePoint"
$OutputFile = $WorkPath + "\Output\SharePoint_" + $TodayDate + ".csv"

#Add Proxy Settings
[system.net.webrequest]::defaultwebproxy = new-object system.net.webproxy('proxy.eadidom.com:8080')
[system.net.webrequest]::defaultwebproxy.credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
[system.net.webrequest]::defaultwebproxy.BypassProxyOnLocal = $true
$webclient=New-Object System.Net.WebClient
$webclient.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

#Delete existing text files, then generate random 10 MB file
if (Test-Path $Folder\*.txt) {Remove-Item $Folder\*.txt}
Add-Type -AssemblyName System.Web
$fn = [System.IO.Path]::Combine($Folder, 'Deleteme.txt')
$count = 10mb/128
$fs = New-Object System.IO.FileStream($fn,[System.IO.FileMode]::CreateNew)
$sw = New-Object System.IO.StreamWriter($fs,[System.Text.Encoding]::ASCII,128)
do {
   $sw.WriteLine([System.Web.Security.Membership]::GeneratePassword(126,0))
   $count--
   } while ($count -gt 0)
$sw.Close()
$fs.Close()

#Add references to SharePoint client assemblies and authenticate to Office 365 site - required for CSOM
Add-Type -Path "C:\Temp\SharePoint-Monitoring\SPO_CSOM\Microsoft.SharePointOnline.CSOM.16.1.8119.1200\lib\net45\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Temp\SharePoint-Monitoring\SPO_CSOM\Microsoft.SharePointOnline.CSOM.16.1.8119.1200\lib\net45\Microsoft.SharePoint.Client.Runtime.dll"

#Import SharePoint module and bind to site collection
Import-Module -Name Microsoft.Online.SharePoint.PowerShell
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.MemoryStream")
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteCollection)
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($O365User,$O365Password)
$Context.Credentials = $Creds

#Retrieve list
$List = $Context.Web.Lists.GetByTitle($DocLibName)
$Context.Load($List)
$Context.ExecuteQuery()

#Upload file, time and then delete
Foreach ($File in (dir $Folder -File))
{
   $FileStream = New-Object IO.FileStream($File.FullName,[System.IO.FileMode]::Open)
   $FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
   $FileCreationInfo.Overwrite = $true
   $FileCreationInfo.ContentStream = $FileStream
   $FileCreationInfo.URL = $File
   $Upload = $List.RootFolder.Files.Add($FileCreationInfo)
   $Context.Load($Upload)
   $CommandTime = Measure-Command {$Context.ExecuteQuery()}
}

#Export Timing
$TodayTime = Get-Date -Format "HH:mm:ss"
$LineOut = $TodayDate + "," + $TodayTime + "," + $CommandTime.TotalSeconds
$LineOut | Out-File $OutputFile -Encoding ascii -Append


#######################
# Store results in  SharePoint List.
$siteListUrl = "https://suffolknet.sharepoint.com/sites/ITProblemManagement"
$listName = "SharePoint"

$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteListUrl)
$context.Credentials = $creds
[Microsoft.SharePoint.Client.Web]$web = $context.Web
[Microsoft.SharePoint.Client.List]$list = $web.Lists.GetByTitle($listName)
 
$ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
$Context.Load($ListItems)
$Context.ExecuteQuery()      

[Microsoft.SharePoint.Client.ListItemCreationInformation]$itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation;
[Microsoft.SharePoint.Client.ListItem]$item = $list.AddItem($itemCreateInfo);
$item["Title"] = $TodayDate
$item["Date_x002d_Time"] = $TodayDate
$item["Uploadtime"] = $CommandTime.TotalSeconds 
   
############################
# More columns here...
############################
$item.Update();
$context.ExecuteQuery(); 