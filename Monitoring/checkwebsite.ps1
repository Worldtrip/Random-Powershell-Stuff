$uri = "https://bbis.nps.gse.gov.uk/"
$path = "c:\temp"
$output = "c:\temp\monitor.txt"
while (1 -eq 1) {
$today = Get-Date ;
$result1 = Measure-Command { $request = Invoke-WebRequest -Uri $uri -ProxyUseDefaultCredentials -Proxy "http://proxy.suffolkcc.gov.uk:8080" } 
$line = [string] $today.Hour+":"+$today.Minute+":"+$today.Second+","+$uri+","+$result1.Milliseconds+","+$request.StatusCode+","+$request.RawContentLength
$line >> $output
sleep(5)
}