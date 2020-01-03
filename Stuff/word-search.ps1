#ERROR REPORTING ALL
Set-StrictMode -Version latest
$path     = "\\euser\csd\Data\ICT\Global\OpsCab\2016\Dec\2016-12-06"
$files    = Get-Childitem $path -Include *.docx,*.doc -Recurse | Where-Object { !($_.psiscontainer) }
$output   = "c:\temp\wordfiletry.csv"
$application = New-Object -comobject word.application
$application.visible = $False
$findtext = "VSVR-INF773"
$charactersAround = 80
$results = @{}

Function getStringMatch
{
    # Loop through all *.doc files in the $path directory
    Foreach ($file In $files)
    {
        $document = $application.documents.open($file.FullName,$false,$true)
        $range = $document.content

        If($range.Text -match ".{$($charactersAround)}$($findtext).{$($charactersAround)}"){
             $properties = @{
                File = $file.FullName
                Match = $findtext
                TextAround = $Matches[0] 
             }
             $results += New-Object -TypeName PsCustomObject -Property $properties
        }
    }

    If($results){
        $results | Export-Csv $output -NoTypeInformation
    }

    $document.close()
    $application.quit()
}

getStringMatch

import-csv $output