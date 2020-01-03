$Path = 'c:\Temp\PowerShellPlayTime.xlsx'
 
# Open the Excel document and pull in the 'Play' worksheet
$Excel = New-Object -Com Excel.Application
$Workbook = $Excel.Workbooks.Open($Path) 
$page = 'Play'
$ws = $Workbook.worksheets | where-object {$_.Name -eq $page}

"https://suffolknet.sharepoint.com/sites/RMITServiceManagement/ProblemManagement/Shared%20Documents/P1s-review.xlsx"