$pat = "c:\temp\SPOPerformance.csv"
$endDate = "20 May 2019 20:50:00"
$urls = "https://suffolknet.sharepoint.com/sites/myscc/pages/default.aspx"

$array = @()
$tim = Get-Date
while($tim -lt $endDate)
{
    foreach($url in $urls)
    {
        $ie = New-Object -comobject "InternetExplorer.Application"
        $ie.visible = $true
        $timein = Get-Date
        $ie.navigate($url)
        
        while ($ie.Busy -eq $true -or $ie.ReadyState -ne 4 -or $ie.document.IHTMLDocument3_getElementByID("O365_MainLink_Settings").readystate -ne "complete") 
        {Start-Sleep -Seconds 1}

        $timeout = Get-Date
        $array += New-Object PSObject -Property @{Url = $url;TimeIn = $timein;TimeOut = $timeout; Duration= $timeout - $timein}
        Write-Host ($timeout - $timein)  $url 

        $ie.Quit()
    }
    start-sleep -seconds 30
    $tim = Get-Date
}

$array | Export-Csv -Path $pat