Add-PSSnapin "Quest.ActiveRoles.ADManagement" ;

$CitrixSecurity_Groups = Get-QADGroup -SearchRoot "euser.eroot.eadidom.com/Organisations/CSD/Security Groups/Citrix XenApp Security Groups" ;

$outputpath = "C:\" ;
$today = Get-Date ;
$filename = "Citrix-Users_"+$today.day+"-"+$today.month+"-"+$today.year ;
$output = $outputpath+$filename+".txt";

Get-Date > $output ;

foreach ($CitrixSecurity_Groups.Name in $CitrixSecurity_Groups)
{
    "" >> $output
    "Group "+$CitrixSecurity_Groups.Name+" ("+(Get-QADGroupMember $CitrixSecurity_Groups).count+")" >> $output ;

	$members = Get-QADGroupMember $CitrixSecurity_Groups.Name ;
	foreach ($members.name in $members)
	{
		if ($members.Type -eq "user") {
			$user = Get-QADUser $members.name ;
			$members.name+"  "+$user.firstname+" "+$user.lastname >> $output ;
			}
	}
}

[string[]]$recipients = "Andrew <andrew.brooke@csduk.com>", "Mark <mark.leathers@csduk.com>", "Gail <gail.johnson@csduk.com>" ;

   $MessageParameters = @{
        From = "Citrixusers_Script@csduk.com"
        To = $recipients 
        Subject = $filename
        Body = "See attached file"
        Attachments = $output       
        SmtpServer = "smtphub.suffolkcc.gov.uk"        
    }

    Send-MailMessage @MessageParameters   