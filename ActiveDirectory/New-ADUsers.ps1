Import-Module ActiveDirectory ; 

#$base = $args[0] ;
$base = "OU=BI Security Groups,OU=Security Groups,OU=SCC,OU=Organisations,dc=euser,dc=eroot,dc=eadidom,dc=com"

Write-Host $base ;
$path = Get-Location ;
$today = Get-Date ;

$output = $path.path+"\Users_"+$today.day+"-"+$today.month+"-"+$today.year ;

$groups = Get-ADGroup -filter * -SearchBase $base ;

foreach ($group in $groups) {
	
$members = Get-ADGroupMember -Identity $group.Name -Recursive 
  "Group "+$group.Name+" ("+$members.count+")"
  
  foreach ($member in $members) {
    $memuser = Get-ADUser $member | select GivenName,SurName ;
    write-Host ($memuser.GivenName+" "+$memuser.SurName) ;
    }

  if ($users.count -gt 0) {
	foreach ($user in $users) {
		
		if ($user.objectClass -ne 'user') { $user.name+","+$user.objectClass >> $output }

		else {
			$member = Get-ADUser $user.name ;
			$revdn="" ;
			$dn=$user.DistinguishedName.split(",") ;
			for ($x = $dn.length-6; $x -gt 0; $x--) { $revdn+=$dn[$x]+"," }
	  		$user.name+","+$member.GivenName+","+$member.Surname+","+$revdn >> $output ;
			Write-Host ($user.name+","+$member.GivenName+","+$member.Surname+","+$revdn) ;
			}
		}

	}
  }

  