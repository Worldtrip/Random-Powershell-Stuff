$users = get-AdGroupMember "CSD ICT Staff" -Recursive 
foreach ($user in $users) {
    $details = Get-ADUser $user -Properties thumbnailPhoto 
    if ($user.ObjectClass -eq "user") {
        if ({$details.thumbnailPhoto}) {
            $filename = "U:\team\"+$user.SamAccountName + ".jpg" ;
            $details.thumbnailPhoto | Set-Content $filename -Encoding byte ;
            }
        }
    }