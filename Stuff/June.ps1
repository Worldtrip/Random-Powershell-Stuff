Import-Module ActiveDirectory ; 

#$base = $args[0] ;
#$base = "OU=BI Security Groups,OU=Security Groups,OU=SCC,OU=Organisations,dc=euser,dc=eroot,dc=eadidom,dc=com"
$base = "OU=Citrix XenApp Security Groups,OU=Security Groups,OU=CSD,OU=Organisations,dc=euser,dc=eroot,dc=eadidom,dc=com"

$Groupprefix = "C*" ;

Write-Host $base ;
$path = Get-Location ;
$today = Get-Date ;

$output = $path.path+"\Users_"+$today.day+"-"+$today.month+"-"+$today.year ;

#$groups = Get-ADGroup -filter * -SearchBase $base ;
$groups = Get-ADGroup -filter {name -like $Groupprefix} -SearchBase $base 

foreach ($group in $groups) {
	
$members = Get-ADGroupMember -Identity $group.Name -Recursive 
  "Group "+$group.Name+" ("+$members.count+")"
  
  foreach ($member in $members) {
    $memuser = Get-ADUser $member | select GivenName,SurName ;
    write-Host ($memuser.GivenName+" "+$memuser.SurName) ;
    }
}

  