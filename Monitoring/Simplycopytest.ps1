$TotalSize = (Get-Item .\100Mbtest).Length

$WriteTest = Measure-Command { Copy-Item .\100Mbtest \\pc7-czc0367895\c$\temp }
[Math]::Round((($TotalSize * 8) / $WriteTest.TotalSeconds) / 1048576,2)

$ReadTest = Measure-Command { Copy-Item \\pc7-czc0367895\c$\temp\100Mbtest . }
[Math]::Round((($TotalSize * 8) / $ReadTest.TotalSeconds) / 1048576,2)
