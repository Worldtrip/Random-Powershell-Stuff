
while ($true) {
                        
        $pingtest = "172.16.31.57"  # PingTest = Address to be pinged 
        
        $timeout = 1000     # Timeout - The amount of time in milliseconds it will wait for a response before timing out.
                
        $delay = 1000        # Delay - The amount of time in Milliseconds to wait between returned pings before continueing 

        $testdate = Get-Date -Format yyyMMdd
        $outfolder =  "C:\Ping-test\"
        $outfile = $outfolder+$pingtest+"-"+$testdate+".txt" 

        $ping = New-Object System.Net.NetworkInformation.Ping
        [string] $date = Get-Date
        $result = $ping.Send($pingtest, $timeout)
        if ($result.Status -eq "TimedOut") {
            "Failed "+$pingtest
            $date+" "+$pingtest+" "+$result.Status >> $outfile
            }
        else {
            "Pinged "+$pingtest+" "+$result.RoundtripTime+"ms"
            $date+" "+$pingtest+" "+$result.RoundtripTime+"ms" >> $outfile
            Start-Sleep -Milliseconds $delay
        }
        
}       
