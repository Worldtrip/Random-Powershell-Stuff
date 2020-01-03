Get-ADOrganizationalUnit -Filter * -SearchBase "dc=euser,dc=eroot,dc=eadidom,dc=com" 
| Sort {-join ($_.distinguishedname[($_.distinguishedname.length-1)..0])} | Select *name | ft -auto

