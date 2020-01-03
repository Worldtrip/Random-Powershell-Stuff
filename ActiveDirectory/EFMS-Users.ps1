#################################
# Script to dump AD user attributes and define role access in iTrent
# Andy Macnamara
# 23/12/2014
# Version 1.2
#################################

# Get the AD variables we want and store as variable $adDump
Import-Module ActiveDirectory

$adDump = Get-ADUser -SearchBase "OU=Users,OU=Eastern FMS,OU=Users,OU=SCC,OU=Organisations,DC=euser,DC=eroot,DC=eadidom,DC=com" -LDAPFilter "(&(SamAccountName=*)(employeeNumber=*)(!(userAccountControl:1.2.840.113556.1.4.803:=2))(!(extensionAttribute10=*))(!(department=*Special*))(!(company=*Councillors*)))" -Properties sAMAccountName, employeeNumber, mail | Select-Object sAMAccountName, employeeNumber, mail

# Connect to SQL
Import-Module SQLPS

$dataSource = "CLU-SQL076"
$user = "trentadm"
$pass = "Jaojw023nawoP"
$database = "tprod"
$connectionString = "Server=$dataSource;uid=$user;pwd=$pass;Database=$database;Integrated Security=False"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# Define our SQL query
$sqlQuery = "SELECT DISTINCT trentadm.tper_reference.reference_no AS reporting_personal_ref
             FROM trentadm.tparty_lnk reportee_position
             INNER JOIN trentadm.tper_party reportee_per_party
             ON reportee_per_party.party_id = reportee_position.party_id
             AND reportee_position.link_type_id = 'CONT'
             AND reportee_position.party_lnk_d <= GETDATE()
             AND (reportee_position.party_lnk_ed IS NULL
             OR reportee_position.party_lnk_ed >= GETDATE())
             INNER JOIN trentadm.tperson reportee_person ON reportee_per_party.person_id = reportee_person.person_id
             LEFT OUTER JOIN trentadm.tparty_lnk reporting_party_lnk ON reporting_party_lnk.party_id = reportee_position.party_id2
             AND reporting_party_lnk.link_type_id = 'POSN_POSN' AND reporting_party_lnk.party_lnk_d <= GETDATE()
             AND (reporting_party_lnk.party_lnk_ed IS NULL
             OR reporting_party_lnk.party_lnk_ed >= GETDATE())
             INNER JOIN trentadm.tparty job_title ON job_title.party_id = reportee_position.party_id
             AND reportee_position.link_type_id = 'CONT'
             AND reportee_position.party_lnk_d <= GETDATE() AND (reportee_position.party_lnk_ed IS NULL
             OR reportee_position.party_lnk_ed >= GETDATE())
             INNER JOIN trentadm.tparty_lnk reporting_party ON reporting_party.party_id2 = reporting_party_lnk.party_id2
             AND reporting_party.link_type_id = 'CONT'
             AND reporting_party.party_lnk_d <= GETDATE()
             AND (reporting_party.party_lnk_ed IS NULL
             OR reporting_party.party_lnk_ed >= GETDATE())
             INNER JOIN trentadm.tper_party reporting_per_party ON reporting_per_party.party_id = reporting_party.party_id
             AND reporting_party.link_type_id = 'CONT'
             AND reporting_party.party_lnk_d <= GETDATE() AND (reporting_party.party_lnk_ed IS NULL
             OR reporting_party.party_lnk_ed >= GETDATE())
             INNER JOIN trentadm.tperson reporting_person ON reporting_per_party.person_id = reporting_person.person_id
             INNER JOIN trentadm.tdesc title_desc ON reporting_person.title = title_desc.key_item AND title_desc.entity_nm = 'TCODE'
             INNER JOIN trentadm.tper_reference ON reporting_person.person_id = trentadm.tper_reference.person_id"

# Execute it and store the output as variable $result, and load it into a table so that we can work with it
$command = $connection.CreateCommand()
$command.CommandText=$sqlQuery
$result = $command.ExecuteReader()
$table = New-Object System.Data.DataTable
$table.Load($result)

$connection.Close()

# Put all of this stuff into an array and make it look nice
$array = @()

FOREACH ($adUser IN $adDump)
    
    {
        $adUser

        $row = New-Object Object

        $adUsername = $adUser.sAMAccountName
        $perRefNo = $adUser.employeeNumber
        $email = $adUser.mail
        $active = "T"
        $allowChange = "F"
        $requireChange = "F"
        $canExpire = "F"
        $isManager = $table.reporting_personal_ref

        $row | Add-Member -MemberType NoteProperty -Name "USER_NAME" -Value $adUsername
        $row | Add-Member -MemberType NoteProperty -Name "PER_REF_NO" -Value $perRefNo
        $row | Add-Member -MemberType NoteProperty -Name "EMAIL" -Value $email
        $row | Add-Member -MemberType NoteProperty -Name "ACTIVE" -Value $active
        $row | Add-Member -MemberType NoteProperty -Name "ALLOW_CHANGE" -Value $allowChange
        $row | Add-Member -MemberType NoteProperty -Name "REQUIRE_CHANGE" -Value $requireChange
        $row | Add-Member -MemberType NoteProperty -Name "CAN_EXPIRE" -Value $canExpire

        # This is where we determine if the user needs People Manager or just ESS
        IF ($isManager.Contains($perRefNo))
            {
                $row | Add-Member -MemberType NoteProperty -Name "ROLE_NAME" -Value "PEOPLE MANAGER - EFMS" -Force;
            }
        ELSE
            {
                $row | Add-Member -MemberType NoteProperty -Name "ROLE_NAME" -Value "TASK APPROVAL" -Force;
            }

        $array += $row
    }

# Dump the contents of the array out to CSV
$array | Export-Csv -Path "F:\PSScripts\Temp\TempEFMSUsers.csv" -NoTypeInformation

# Import the CSV and replace the annoying doube quotes (""), and export it to CSV again so that iTrent can understand the file contents
Get-Content -Path "F:\PSScripts\Temp\TempEFMSUsers.csv" | % {$_ -replace '"', ""} | Out-File -FilePath "F:\PSScripts\Output\EFMSUsers.csv" -Force