# This script is used to idenify the number of mailboxes in use by each Organisation bound by email domains
# Each user mailbox requires a license in Office 365
# Shared mailboxes do not require a license in Office 365
# These figures should be used by Infrastrucutre Services to ensure the correct number of Office 365 licenses are maintained in accordance with the head Service Management who is accountable for licensing.
# 23/09/2014
# Mark Fox


#Global
$a=Get-Date -format d-M-yyyy
$logfile_location="E:\MyReports\Mailbox Counts"
$total_count_text="Total mailbox count for"

########
# EFMS #
########

$org_name="EFMS"

# Usermailboxes
$type="usermailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@easternfms.co.uk" -and $_.recipienttypedetails -eq "RemoteUserMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 line)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


# Shared mailboxes
$type="sharedmailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@easternfms.co.uk" -and $_.recipienttypedetails -eq "RemoteSharedMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 line)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


#######
# SCC #
#######

$org_name="SCC"

#Usermailboxes
$type="usermailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@suffolk.gov.uk" -and $_.recipienttypedetails -eq "RemoteUserMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber



#Shared mailboxes
$type="sharedmailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@suffolk.gov.uk" -and $_.recipienttypedetails -eq "RemoteSharedMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber

########
# MSDC #
########

$org_name="MSDC"

#Usermailboxes
$type="usermailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@midsuffolk.gov.uk" -and $_.recipienttypedetails -eq "RemoteUserMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


#Shared mailboxes
$type="sharedmailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@midsuffolk.gov.uk" -and $_.recipienttypedetails -eq "RemoteSharedMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


#########
# BMSDC #
#########

$org_name="BMSDC"

#Usermailboxes
$type="usermailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@baberghmidsuffolk.gov.uk" -and $_.recipienttypedetails -eq "RemoteUserMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


#Shared mailboxes
$type="sharedmailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@baberghmidsuffolk.gov.uk" -and $_.recipienttypedetails -eq "RemoteSharedMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber

###########
# Babergh #
###########

$org_name="BDC"

#Usermailboxes
$type="usermailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@baberghmidsuffolk.gov.uk" -and $_.recipienttypedetails -eq "RemoteUserMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


#Shared mailboxes
$type="sharedmailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@baberghmidsuffolk.gov.uk" -and $_.recipienttypedetails -eq "RemoteSharedMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


##################
# Schools Choice #
##################

$org_name="SC"

#Usermailboxes
$type="usermailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@schoolschoice.org" -and $_.recipienttypedetails -eq "RemoteUserMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


#Shared mailboxes
$type="sharedmailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@schoolschoice.org" -and $_.recipienttypedetails -eq "RemoteSharedMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


########################
# Activities Unlimited #
########################

$org_name="AU"

#Usermailboxes
$type="usermailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@activities-unlimited.co.uk" -and $_.recipienttypedetails -eq "RemoteUserMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber


#Shared mailboxes
$type="sharedmailboxes"
$outfile="$logfile_location\$type-$org_name-$a-detail.csv"
$outfile_total="$logfile_location\$type-$org_name-total.csv"
Get-remoteMailbox -identity * -resultsize unlimited | Where {$_.primarysmtpaddress -Match "@activities-unlimited.co.uk" -and $_.recipienttypedetails -eq "RemoteSharedMailbox"} | select name, primarysmtpaddress | export-csv $outfile -NoTypeInformation
$c=(Get-Content $outfile).Count
# Account for header rows (1 lines)
$d=$c - 1
"$total_count_text $type $org_name $d on $a" | out-file $outfile_total -Append -noclobber