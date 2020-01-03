Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$UserName= "andrew.brooke@suffolk.gov.uk"
$Password = read-host -AsSecureString "Enter your password"


$credentials= New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
$webURL="https://suffolknet.sharepoint.com/sites/RMITServiceManagement/ProblemManagement/"
#$webURL="https://dennis.sharepoint.com/sites/Team"
$ctx= New-Object Microsoft.SharePoint.Client.ClientContext($webURL)
$ctx.Credentials = $credentials
try{
	$lists = $ctx.web.Lists
	$list = $lists.GetByTitle("Problems")
	$listItems = $list.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
	$ctx.load($listItems)

	$ctx.executeQuery()
	foreach($listItem in $listItems)
	{
		Write-Host "ID - " $listItem["ID"] "Title - " $listItem["Title"] "DateTime - " $listItem["DateTime"] "Choices - " $listItem["Choices"]
	}
}
catch{
	write-host "$($_.Exception.Message)" -foregroundcolor red
}