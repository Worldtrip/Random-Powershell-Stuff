(get-aduser pearvl -Properties MemberOf | Select-Object MemberOf).MemberOf

(get-aduser sabic1 -Properties MemberOf | Select-Object MemberOf).MemberOf

(get-aduser pearvl1 -Properties MemberOf | Select-Object MemberOf).MemberOf

(get-aduser broot4 -Properties MemberOf | Select-Object MemberOf).MemberOf

get-smbclientconfiguration

New-Object System.Net.Sockets.TCPClient -ArgumentList 'vsvr-app961.euser.eroot.eadidom.com',80