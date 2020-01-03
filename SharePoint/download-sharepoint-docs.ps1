import-module microsoft.online.sharepoint.powershell
function downloadDocs($siteURL, $credentials)
{
 # Create a client context connection
 $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
 $ctx.Credentials = $credentials

 $list = $ctx.Web.Lists.GetByTitle('Shared Document')
 $destinationPath = "e:\downloa"

 # Connect to the list and query for all items
 $camlQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
 $camlQuery.ViewXml = '<View><Query><Where></Where></Query></View>'
 $items = $list.GetItems($camlQuery)
 $ctx.Load($items)
 $ctx.ExecuteQuery()
write-host "Found " $items.Count " items"

 # Assuming we want to download all documents
 foreach ($item in $items)
 { 
 Write-Host "Saving " $item["FileRef"]
 $fileRef = $item["FileRef"]
 $fileInfo = [Microsoft.SharePoint.Client.File]::OpenBinaryDirect($ctx,$fileRef.ToString())
 $new = $destinationPath + "\" + $item["FileLeafRef"]

 [byte]$byte = ""
 $list = New-Object System.Collections.Generic.List[byte]
# Read in each file
 try {
 while(($byte = $fileInfo.Stream.ReadByte()) -ne -1)
 { 
 $list.Add($byte)
 }
 } catch [Exception] {
 #return $_.Exception.Message
 }

 [System.IO.File]::WriteAllBytes($new, $list.ToArray());
 $fileInfo.Dispose() 
 }
}
$siteUrl = “https://anchal.sharepoint.com/”
$username ="user@tenant.onmicrosoft.com"
$password = Read-Host -Prompt "Enter password" -AsSecureString
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $password)
downloadDocs $siteURL $credentials