#################################
# Script to check the 'Non-Trent Password Checking' box for users
# Andy Macnamara
# 16/12/2014
# Version 1.2
#################################

# Get the AD variables we want and store as variable $adDump
Import-Module ActiveDirectory
$adDump = Get-ADUser -SearchBase "OU=Users,OU=Eastern FMS,OU=Users,OU=SCC,OU=Organisations,DC=euser,DC=eroot,DC=eadidom,DC=com" -LDAPFilter "(&(SamAccountName=*)(employeeNumber=*)(!(userAccountControl:1.2.840.113556.1.4.803:=2))(!(extensionAttribute10=*))(!(department=*Special*))(!(company=*Councillors*)))" -Properties sAMAccountName | Select-Object sAMAccountName

# Connect to SQL
Import-Module SQLPS

$dataSource = "CLU-SQL076"
$user = "trentadm"
$pass = "Jaojw023nawoP"
$database = "tprod"
$connectionString = "Server=$dataSource;uid=$user;pwd=$pass;Database=$database;Integrated Security=False"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$command = New-Object System.Data.SqlClient.SqlCommand
$command.Connection = $connection


# Define our SQL query as part of the loop $array
$array = @()

FOREACH ($adUser IN $adDump)

    {

        $connection.Open()

        $adUser

        $adUsername = $adUser.sAMAccountName

        $sqlQuery = "IF NOT EXISTS (SELECT 1 FROM TRENTADM.TUSER_PREF WHERE USER_NM = '$adUsername' AND PREF_ID = '3RD_PTY_PASS' AND '$adUsername' NOT IN (SELECT USER_NM FROM TUSER)) INSERT INTO TUSER_PREF VALUES ('$adUsername','3RD_PTY_PASS','T','','','BATCH');"

        $command.CommandText = $sqlQuery

        $command.ExecuteReader()

        $connection.Close()

    }