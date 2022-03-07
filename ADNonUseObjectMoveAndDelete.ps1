# SearchPath değişkeni tarama yapılması istenen OU’nun DN i olmalı

$SearchPath ="OU=Server Computers,OU=All Computers,DC=fw,DC=garanti,DC=com,DC=tr"

# MovedPath değişkeni sunucularun taşınacağı OU’nun DN i olmalı

$MovedPath = "OU=WillBeDeleted,OU=Server Computers,OU=All Computers,DC=fw,DC=garanti,DC=com,DC=tr"

 

# Lastlogon90day olarak belirttim 90 günden eskilerin taşınmasını istemiştik.

$Lastlogon90day=Get-ADComputer -SearchBase $searchpath  -Filter {serviceprincipalName -notlike "MSClusterVirtualServer*"} -property name,lastlogondate,serviceprincipalName,DistinguishedName | ? { $_.LastLogonDate -lt (get-date).AddDays(-90) } | select name,lastlogondate,DistinguishedName

 

$datestring = (Get-Date).ToString("s").Replace(":","-")

$file = "c:\temp\MovedServerList_$datestring.txt"

foreach ( $move in $Lastlogon90day)

{write-host $move.name

$disabledcomp=$move.name

Get-ADComputer -identity $move.name | Move-ADObject -TargetPath $MovedPath

Disable-ADAccount -identity "CN=$disabledcomp,OU=WillBeDeleted,OU=Server Computers,OU=All Computers,DC=fw,DC=garanti,DC=com,DC=tr"

}

$Lastlogon90day | Out-File $file

 
