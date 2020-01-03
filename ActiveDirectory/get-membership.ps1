get-aduser brooaj1 -property MemberOf | % {$_.MemberOf | Get-AdGroup | select Name | sort name}
(get-aduser brooaj1 -property MemberOf).MemberOf
