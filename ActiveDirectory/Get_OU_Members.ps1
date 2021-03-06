
############################################################### 
# Get_OU_Memebrs.ps1
# Version 1.1 
# Andrew Brooke - 06 / 02 / 2014 
################### 

Import-Module ActiveDirectory ; 

$base = $args[0] ;

#$base="OU=Citrix XenApp Security Groups,OU=Security Groups,OU=CSD,OU=Organisations,DC=euser,DC=eroot,DC=eadidom,DC=com" ;

Write-Host($test+" Looking at "+$base) ;

$outputpath = "c:\Users\brooaj1\Desktop\" ;
$today = Get-Date ;
$filename = "Citrix-Users_"+$today.day+"-"+$today.month+"-"+$today.year ;
$output = $outputpath+$filename+".txt";
Get-Date > $output ;

#Get-ADGroup -filter * -SearchBase 'OU=Citrix XenApp Security Groups,OU=Security Groups,OU=CSD,OU=Organisations,DC=euser,DC=eroot,DC=eadidom,DC=com' |

Get-ADGroup -filter * -SearchBase $base |


foreach {

  $users = Get-ADGroupMember -Identity $_.Name -Recursive
  "Group "+$_.Name+" ("+$users.count+")" >> $output ;
  if ($users.count -gt 0) {
	foreach ($user in $users) {
		
		if ($user.objectClass -ne 'user') { $user.name+","+$user.objectClass >> $output }

		else {
			$member = Get-ADUser $user.name ;
			$revdn="" ;
			$dn=$user.DistinguishedName.split(",") ;
			for ($x = $dn.length-6; $x -gt 0; $x--) { $revdn+=$dn[$x]+"," }
	  		$user.name+","+$member.GivenName+","+$member.Surname+","+$revdn >> $output ;
			}
		}

	}
  }

