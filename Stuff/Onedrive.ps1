<#
The sample scripts are not supported under any Microsoft standard support 
program or service. The sample scripts are provided AS IS without warranty  
of any kind. Microsoft further disclaims all implied warranties including,  
without limitation, any implied warranties of merchantability or of fitness for 
a particular purpose. The entire risk arising out of the use or performance of  
the sample scripts and documentation remains with you. In no event shall 
Microsoft, its authors, or anyone else involved in the creation, production, or 
delivery of the scripts be liable for any damages whatsoever (including, 
without limitation, damages for loss of business profits, business interruption, 
loss of business information, or other pecuniary loss) arising out of the use 
of or inability to use the sample scripts or documentation, even if Microsoft 
has been advised of the possibility of such damages.
#>


#requries -Version 2.0

<#
 	.SYNOPSIS
        upload files to OneDrive for Business and create a guest link in SPO
    .DESCRIPTION
        upload files to OneDrive for Business and create a guest link in SPO
    .PARAMETER  DllPath
        This parameter specifies the ClaimsAuth.dll location. For more information about this dll file, refer to http://code.msdn.microsoft.com/Remote-Authentication-in-b7b6f43c
    .PARAMETER  FilePath
        This parameter specifies the directory storing the file to be uploaded 
    .PARAMETER  FileName
        This parameter specifies the file name of the file to be uploaded
    .PARAMETER  SiteURL
        This parameter specifies site URL or OneDrive for Business URL.
    .PARAMETER  LibraryName
        This parameter specifies library name to be uploaded.              
    .EXAMPLE
        UploadFileInOneDriveofSPO.ps1 -DllPath “c:\ClaimsAuth.dll” –filePath “c:\” –FileName “Upload.txt” - SiteURL https://tenant.sharepoint.com/sites/filelibarary - LibraryName “Library”
        Upload a local file to OneDrive for Business and create Guest Link
#>


Param
(
    [Parameter(Mandatory=$true)][ValidateScript({Test-Path $_ -PathType 'Leaf'})] 
    [string] $DllPath,
    [Parameter(Mandatory=$true)][ValidateScript({Test-Path $_ -PathType 'container'})] 
    [string] $FilePath,
    [Parameter(Mandatory=$true)]
    [string] $FileName,
    [Parameter(Mandatory=$true)]
    [string] $SiteURL,
    [Parameter(Mandatory=$true)]
    [string] $LibraryName
)

Begin
{
    $SPClientDirRegKey = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SharePoint Client Components\15.0" -PSProperty "Location" -ErrorAction:SilentlyContinue
    if ($SPClientDirRegKey -ne $null) 
    {
	    $moduleFilePath1 = $SPClientDirRegKey.'Location' + 'ISAPI\Microsoft.SharePoint.Client.dll'
        $moduleFilePath2 = $SPClientDirRegKey.'Location' + 'ISAPI\Microsoft.SharePoint.Client.Runtime.dll'
	    Import-Module $moduleFilePath1
        Import-Module $moduleFilePath2
    }
    else 
    {
	    $errorMsg = "Please install SharePoint Server 2013 Client Components SDK"
	    throw $errorMsg
        Exit
    }
    Try
    {
        Add-Type -Path $DllPath
    }
    Catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

Process
{
    [Microsoft.Sharepoint.Client.ClientContext]$ctx

    $ctx = [MSDN.Samples.ClaimsAuth.ClaimClientContext]::GetAuthenticatedContext($SiteURL)

    $authcookie = [MSDN.Samples.ClaimsAuth.ClaimClientContext]::GetAuthenticatedCookies($SiteURL, 925, 525)

    $LibraryURL = $SiteURL + "/" + $LibraryName

    $uri =$LibraryURL + "/_vti_bin/copy.asmx"
    $service = New-WebServiceProxy -Uri $uri  -Namespace SpWs
    $service.CookieContainer = new-object system.net.cookiecontainer
    $service.CookieContainer.add($authcookie)

    $filestream = [IO.file]::ReadAllBytes($filePath+"\"+$FileName)
    $fields=@()
    $results = $null 
    $destinationurl = $LibraryURL + "/" + $fileName
    $ret = $service.CopyIntoItems(" ",$destinationurl,$fields,$filestream,[ref]$results)

    if($ret -eq 0)
    {
        write-host "The file is uploaded successfully"
    }
    else
    {
        write-host "Upload request did not complete"
    }

    $destinationurl.Replace(" ","%20")
    $uri =$SiteURL + "/_vti_bin/Lists.asmx"

    $Listservice = New-WebServiceProxy -Uri $uri
    $Listservice.CookieContainer = new-object system.net.cookiecontainer
    $Listservice.CookieContainer.add($authcookie)
    $xmlDoc = new-object System.Xml.XmlDocument
    $query = $xmlDoc.CreateElement("Query")
    $viewFields = $xmlDoc.CreateElement("ViewFields")
    $queryOptions = $xmlDoc.CreateElement("QueryOptions")
    $query.set_InnerXml("FieldRef Name='Full Name'")
    $rowLimit = "5000"

    $query.InnerXml = "<IncludeAttachmentUrls>TRUE</IncludeAttachmentUrls>"
    $Listservice.url = $uri

    $listguid = $Listservice.GetList($LibraryName)
    $ListGuitString = $listguid.ID

    $Global:list = $Listservice.GetListItems($LibraryName, "", $query, $viewFields, "", $queryOptions, "")
    
    $Item = $list.data.row | Where-Object {$_.ows_FileLeafRef -like "*$FileName"}
    $ItemID = $Item.ows_ID
    Set-Variable -Name $list -Scope Global
    

    $DigiURL = $SiteURL + "/_api/contextinfo"
    $Digistrequest = [System.Net.HttpWebRequest]::Create($SiteURL)
    $Digistrequest.CookieContainer =  new-object system.net.cookiecontainer
    $Digistrequest.CookieContainer.add($authcookie)
    $Digistrequest.Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Post
    $Digistrequest.ContentType ="application/json;odata=verbose"
    $Digistrequest.ContentLength = "0"
    $DigistreResponse= $Digistrequest.GetResponse()
    $DigistrrequestStream = $DigistreResponse.GetResponseStream()
    $DigistrreadStream = New-Object System.IO.StreamReader $DigistrrequestStream
    $Digistrdata=$DigistrreadStream.ReadToEnd()
    [regex]$reg1 = "(?<=`"__REQUESTDIGEST`" value=`").+(?=`")"
    $Xrequestdigest = $reg1.Match($Digistrdata).Value

    $ListGuitStringRemoveBrace = $ListGuitString.remove(0,1)
    $ListGuitStringRemoveBrace = $ListGuitStringRemoveBrace.remove($ListGuitStringRemoveBrace.length-1)
    $WebRequestURL = $SiteURL + "/_layouts/15/aclinv.aspx?obj=" + $ListGuitString + "," + $ItemID + ",DOCUMENT&List=" + $ListGuitStringRemoveBrace  +"&command=createlink&readwrite=false"
    $ReferURL = $SiteURL + "/_layouts/15/aclinv.aspx?forSharing=1&mbypass=1&List=" + $ListGuitString + "&obj=" + $ListGuitString + "," + $ItemID + "DOCUMENT&IsDlg=1"

    $request = [System.Net.WebRequest]::Create($WebRequestURL)
    $request.CookieContainer =  new-object system.net.cookiecontainer
    $request.CookieContainer.add($authcookie)
    $request.Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Post
    $request.ContentType ="application/x-www-form-urlencoded"
    $request.ContentLength = "0"
    $request.Referer = $ReferURL
    $request.Headers.Add("x-requestdigest", $Xrequestdigest)
    $response = $request.GetResponse()
    $requestStream = $response.GetResponseStream()
    $readStream = New-Object System.IO.StreamReader $requestStream
    $data=$readStream.ReadToEnd()

    
    Write-host "This is the Guest Link:"$data
 }

End
{}