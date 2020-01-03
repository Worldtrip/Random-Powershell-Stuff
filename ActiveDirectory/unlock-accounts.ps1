[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string[]]$User,
    [switch]$Unlock,
    [switch]$ShowAll
)
Begin {
    Write-Verbose "Unlock users: $Unlock"
    Write-Verbose "Show all domains: $ShowAll"
    $Domains = (Get-ADForest).Domains
    $Results = @()
}

Process {
    ForEach ($Name in $User)
    {   Write-Verbose "Looking for $Name"
        ForEach ($Domain in $Domains)
        {   Try {
                Write-Verbose "Searching $Domain..."
                $Search = Get-ADUser $Name -Server (Get-ADDomain $Domain).PDCEmulator -Properties LockedOut -ErrorAction Stop
                $Found = $true
            }
            Catch {
                $Found = $false
                $Locked = $false
            }
            If ($Found)
            {   If ($Unlock)
                {   Write-Verbose "Unlocking $Name in $Domain..."
                    If ($Search.LockedOut)
                    {   Unlock-ADAccount $Name -Server (Get-ADDomain $Domain).PDCEmulator
                    }
                }
                $Locked = $Search.LockedOut
            }
            $Results += New-Object PSObject -Property @{
                User = $Name
                Domain = $Domain
                LockedOut = $Locked
                Found = $Found
            }
        }
    }
}

End {
    If ($ShowAll)
    {   $Results | Select User,Domain,LockedOut,Found
    }
    Else
    {   $Results | Where { $_.Found } | Select User,Domain,LockedOut,Found
    }
}