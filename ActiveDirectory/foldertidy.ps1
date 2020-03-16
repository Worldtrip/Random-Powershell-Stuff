# Clear out unwanted old files
#
$folder = "c:\temp\deleteme"
$daystokeep = 5
$delete = (Get-Date).Adddays(-$daystokeep)
#Get-ChildItem -Path $folder | Where-Object {$_.CreationTime -lt $} | Remove-Item -Force
Get-ChildItem -Path $folder | Where-Object {$_.CreationTime -lt $delete} 