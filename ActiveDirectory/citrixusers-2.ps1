$base = "OU=Citrix XenApp Security Groups,OU=Security Groups,OU=CSD,OU=Organisations,dc=euser,dc=eroot,dc=eadidom,dc=com"

$outputpath = "U:\" ;
$today = Get-Date ;
$filename = "Citrix-Users_"+$today.day+"-"+$today.month+"-"+$today.year ;
$output = $outputpath+$filename+".txt";

#$Groupprefix = "C*" ;

Write-Host $base ;
$path = Get-Location ;
$today = Get-Date ;

$output = $path.path+"\Users_"+$today.day+"-"+$today.month+"-"+$today.year+".txt" ;

Get-Date >> $output ;

#$groups = Get-ADGroup -filter * -SearchBase $base ;

$groups = Get-ADGroup -filter * -SearchBase $base 

foreach ($group in $groups) {
	
$members = Get-ADGroupMember -Identity $group.Name -Recursive 
  "Group "+$group.Name+" ("+$members.count+")" >> $output 
  
  foreach ($member in $members) {
    $memuser = Get-ADUser $member | select GivenName,SurName ;
    ($member.name+"  "+$memuser.GivenName+" "+$memuser.SurName) >> $output
    }
    "" >> $output
}


[string[]]$recipients = "Andrew <andrew.brooke@suffolk.gov.uk>, Gail <gail.johnson@suffolk.gov.uk> " ;

   $MessageParameters = @{
        From = "Citrixusers_Script@csduk.com"
        To = $recipients 
        Subject = $filename
        Body = "See attached file"
        Attachments = $output       
        SmtpServer = "smtphub.suffolkcc.gov.uk"        
    }

    Send-MailMessage @MessageParameters  