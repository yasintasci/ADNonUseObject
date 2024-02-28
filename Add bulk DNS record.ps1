$array = Import-Csv C:\temp\dnsrecord.csv

ForEach($record in $array){

       write $record.name

       Add-DnsServerResourceRecordA -ZoneName "trendyol.com" -ComputerName 10.123.40.5 -Name $record.name -IPv4Address $record.IP -TimeToLive 00:20:00

       }
