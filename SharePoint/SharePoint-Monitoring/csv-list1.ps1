Add-Type -Path 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'
Add-Type -Path "C:\Temp\SharePoint-Monitoring\SPO_CSOM\Microsoft.SharePointOnline.CSOM.16.1.8119.1200\lib\net45\Microsoft.SharePoint.Client.dll"
$csv = import-csv -Path "C:\Temp\Problems.csv"
$siteUrl = "https://suffolknet.sharepoint.com/sites/ITProblemManagement"
$listName = "List-Create2"
$userName  = "andrew.brooke@suffolk.gov.uk"
 
$password = Read-Host -Prompt "Enter password" -AsSecureString
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userName, $password)
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credentials
[Microsoft.SharePoint.Client.Web]$web = $context.Web
[Microsoft.SharePoint.Client.List]$list = $web.Lists.GetByTitle($listName)
 
$ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
$Context.Load($ListItems)
$Context.ExecuteQuery()      
 
write-host "Total Number of List Items found to Delete:"$ListItems.Count
 
    if ($ListItems.Count -gt 0)
    {
        #Loop through each item and delete
        For ($i = $ListItems.Count-1; $i -ge 0; $i--)
        {
            $ListItems[$i].DeleteObject()
        }
        $Context.ExecuteQuery()
         
        Write-Host "All Existing List Items deleted Successfully!"
    }


foreach ($row in $csv) {
    [Microsoft.SharePoint.Client.ListItemCreationInformation]$itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation;
    [Microsoft.SharePoint.Client.ListItem]$item = $list.AddItem($itemCreateInfo);
    $item["Title"] = $row.Product;
    $item["Price"] = $row.Price;
    $item["Payment_Type"] = $row.Payment_Type;
    $item["Name"] = $row.Name;
    ############################
    # More columns here...
    ############################
    $item.Update();
    $context.ExecuteQuery();    
   
}
 
Write-Host "All CSV Items Imported Successfully"