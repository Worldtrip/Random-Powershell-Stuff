Add-PSSnapin "Quest.ActiveRoles.ADManagement" ;

$BISecurity_Groups = Get-QADGroup -SearchRoot "euser.eroot.eadidom.com/Organisations/SCC/Security Groups/BI Security Groups" ;

$outputpath = "C:\" ;
$today = Get-Date ;
$filename = "BI-Users_"+$today.day+"-"+$today.month+"-"+$today.year ;
$output = $outputpath+$filename+".txt";

Get-Date > $output ;

foreach ($BISecurity_Groups.Name in $BISecurity_Groups)
{
    "" >> $output
    "Group "+$BISecurity_Groups.Name+" ("+(Get-QADGroupMember $BISecurity_Groups).count+")" >> $output ;

	$members = Get-QADGroupMember $BISecurity_Groups.Name ;
	foreach ($members.name in $members)
	{
		if ($members.Type -eq "user") {
			$user = Get-QADUser $members.name ;
			$members.name+"  "+$user.firstname+" "+$user.lastname >> $output ;
			}
	}
}

[string[]]$recipients = "Andrew <andrew.brooke@csduk.com>", "Carl <carl.rhoden@csduk.com>", "Simon <simon.sherman@csduk.com>" ;

   $MessageParameters = @{
        From = "BIusers_Script@csduk.com"
        To = $recipients 
        Subject = $filename
        Body = "See attached file"
        Attachments = $output       
        SmtpServer = "smtphub.suffolkcc.gov.uk"        
    }

    Send-MailMessage @MessageParameters   