########################################################################### 
 # 
 # Name: Set Calendar Permissions.ps1 
 # 
 # Author:      Andrew Brooke 
 # Date : 17th September 2015
 # 
 # Script to add an permissions to users calendar
 # 
 # 
 # VERSION HISTORY: 
 # 1.0 - Initial release 
 # 
 ###########################################################################

#Get Credentials to access Office 365 
$UserCredential = Get-Credential
# Connect to Office 365
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# Import Session into current Powershell session.
Import-PSSession $Session

# Get Email account to amend
Write-Host ("Enter email address of calendar to amend")
$email = Read-Host
# Who need access
Write-Host ("Who needs Access")
$whoacc = Read-Host
# Who need access
Write-Host ("What Access? (Reviewer, Editor ..etc)")
$whatacc = Read-Host
Set-MailboxFolderPermission -Identity $email:\Calendar -User $whoacc -AccessRights $whatacc






Set-MailboxFolderPermission -Identity andrew.brooke@suffolk.gov.uk:\Calendar -User keith.lankester@suffolk.gov.uk -AccessRights Reviewer
