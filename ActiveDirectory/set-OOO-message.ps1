########################################################################### 
 # 
 # Name: Set Out of Office Message.ps1 
 # 
 # Author:      Andrew Brooke 
 # Date : 4th March 2015
 # 
 # Script to add an Out of Office message
 # 
 # 
 # VERSION HISTORY: 
 # 1.0 - Initial release - Proof of concept
 # 
 ###########################################################################

#Get Credentials to access Office 365 
$UserCredential = Get-Credential
# Connect to Office 365
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# Import Session into current Powershell session.
Import-PSSession $Session

# Get Email account to amend
Write-Host ("Enter email address to amend")
$email = Read-Host
# Get Out of Office Message
Write-Host ("Enter out of office message")
$mess = Read-Host

# Set Out of Office Message
Set-MailboxAutoReplyConfiguration -Identity $email -AutoReplyState Enabled -ExternalMessage $mess -InternalMessage $mess

# Confirm OOO message has been enabled
Get-MailboxAutoReplyConfiguration -Identity $email | select AutoReplyState

# Close Remote Session
Remove-PSSession $session

pause

