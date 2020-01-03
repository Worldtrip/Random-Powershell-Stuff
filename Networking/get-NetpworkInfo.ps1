Function Get-NetworkConfiguration

{


    param (

        [parameter(

            ValueFromPipeline=$true, 

            ValueFromPipelineByPropertyName=$true,

            Position=0)]

        [Alias('__ServerName', 'Server', 'Computer', 'Name')]    

        [string[]]

        $ComputerName = $env:COMPUTERNAME,

        [parameter(Position=1)]

        [System.Management.Automation.PSCredential]

        $Credential

    )

    process

    {

        $WMIParameters = @{

            Class = 'Win32_NetworkAdapterConfiguration'

            Filter = "IPEnabled = 'true'"

            ComputerName = $ComputerName

        }

        

        if ($Credential -ne $Null)

        {

            $WmiParameters.Credential = $Credential

        }        

		foreach ($adapter in (Get-WmiObject @WMIParameters))

        {

            $AdapterProperties = @{

                Server = $adapter.DNSHostName

                Adapter =  $adapter.Description

                IPAddress = $adapter.IpAddress

                SubnetMask = $adapter.IPSubnet

                DefaultGateway = $adapter.DefaultIPGateway

                DNSServers = $adapter.DNSServerSearchOrder

                DNSDomain = $adapter.DNSDomain

            }
            

            New-Object PSObject -Property $AdapterProperties

        }


       } 

    }
