#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

Function Get-SP-Credentials () {
	param (
		[Parameter(Mandatory=$true)] [string] $O365User,
		[Parameter(Mandatory=$true)] [string] $KeyStore
        )
	
	
	# Set AES Key to encrypt password, this could be a generated key and stored somewhere more restrictive.
	
	$KeyCrypt = (120,80,177,104,51,125,207,56,9,193,73,130,194,179,251,82,35,70,169,109,92,180,55,125,88,209,58,166,75,92,211,116)

	#$O365User = 'andrew.brooke@suffolk.gov.uk'
	$O365PassFile = "$KeyStore$O365User.txt"

	# Prompt if passfile not present
	if (!(Test-Path -Path $O365PassFile)) {Read-Host -Prompt "Please enter password for $O365User :" -AsSecureString | ConvertFrom-SecureString -Key $KeyCrypt | Out-File $O365PassFile}
	$O365Password = Get-Content $O365PassFile | ConvertTo-SecureString -ErrorAction Stop -Key $KeyCrypt
	return $O365Credentials = New-Object System.Management.Automation.PSCredential ($O365User, $O365Password)
}
