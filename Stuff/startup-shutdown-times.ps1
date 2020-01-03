Get-EventLog -LogName System -After 25/07/2016 -Source "Microsoft-Windows-Kernel-General" | 
Where-Object { $_.EventId -eq 12 -or $_.EventId -eq 13; } | 
Select-Object TimeGenerated | 
Sort-Object TimeGenerated | Format-Table -Autosize;
