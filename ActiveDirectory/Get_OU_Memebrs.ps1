############################################################### 
# Get_OU_Memebrs.ps1
# Version 0.1 
# Andrew Brooke - 06 / 02 / 2014 
# ------------------------
# Supply the base OU for the starting point
################### 

Import-Module ActiveDirectory ; 

$base = $args[0] ;
Write-Host $base ;
$path = Get-Location ;
$today = Get-Date ;

$output = $path.path+"\Users_"+$today.day+"-"+$today.month+"-"+$today.year ;

$groups = Get-ADGroup -filter * -SearchBase $base ;

foreach ($group in $groups) {
	
$members = Get-ADGroupMember -Identity $group.Name -Recursive 
  "Group "+$group.Name+" ("+$members.count+")"
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

 
