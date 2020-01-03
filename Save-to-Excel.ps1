# Appending a row to an existing Excel Spredsheet
#
$excelfile = 'C\:temp\ps-to-Excel.xlsx'

## Instantiate the COM object
$Excel = New-Object -ComObject Excel.Application
$ExcelWorkBook = $Excel.Workbooks.Open($excelfile)
$ExcelWorkSheet = $Excel.WorkSheets.item("sheet1")
$ExcelWorkSheet.activate()
## Find the first row where the first 7 columns are empty
$row = ($ExcelWorkSheet.UsedRange.Rows | ? { ($_.Value2 | ? {$_ -eq $null}).Count -eq 7 } | select -first 1).Row
$ExcelWorkSheet.Cells.Item($row,1) = 'COLUMN 1 Text'
$ExcelWorkSheet.Cells.Item($row,2) = 'COLUMN 2 Text'
$ExcelWorkSheet.Cells.Item($row,3) = 'COLUMN 3 Text'
$ExcelWorkSheet.Cells.Item($row,4) = 'COLUMN 4 Text'
$ExcelWorkSheet.Cells.Item($row,5) = 'COLUMN 5 Text'
 
$ExcelWorkBook.Save()
$ExcelWorkBook.Close()
$Excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel)
Stop-Process -Name EXCEL -Force