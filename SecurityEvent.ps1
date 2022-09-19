cls
$Secure = Read-Host -AsSecureString
$Encrypted = ConvertFrom-SecureString -SecureString $Secure
$Secure2 = ConvertTo-SecureString -String $Encrypted
$windowsdomain = "trendyol.work"
$windowsuser = "tech.yucelos"
$Credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $windowsdomain"\"$windowsuser, $Secure2
$servers = Import-csv C:\temp\RDSServers.txt
foreach($server in $servers){
$a=$server.name
Invoke-Command -ComputerName $a -ScriptBlock {
Function Get-LoginEvents {
 Param (
  [Parameter(
   ValueFromPipeline = $true,
   ValueFromPipelineByPropertyName = $true
  )]
  [Alias('Name')]
  [string]$ComputerName = $env:ComputerName
  ,
  [datetime]$StartTime
  ,
  [datetime]$EndTime
 )
 Begin {
  enum LogonTypes {
   Interactive = 2
   Network = 3
   Batch = 4
   Service = 5
   Unlock = 7
   NetworkClearText = 8
   NewCredentials = 9
   RemoteInteractive = 10
   CachedInteractive = 11
  }
  $filterHt = @{
   LogName = 'Security'
   ID = 4624
  }
  if ($PSBoundParameters.ContainsKey('StartTime')){
   $filterHt['StartTime'] = $StartTime
  }
  if ($PSBoundParameters.ContainsKey('EndTime')){
   $filterHt['EndTime'] = $EndTime
  }
 }
 Process {
  Get-WinEvent -ComputerName $ComputerName -FilterHashtable $filterHt | foreach-Object {
   [pscustomobject]@{
    ComputerName = $ComputerName
    UserAccount = $_.Properties.Value[5]
    UserDomain = $_.Properties.Value[6]
    LogonType = [LogonTypes]$_.Properties.Value[8]
    WorkstationName = $_.Properties.Value[11]
    SourceNetworkAddress = $_.Properties.Value[19]
    TimeStamp = $_.TimeCreated
   }
  }
 }
 End{}
}
hostname
Get-LoginEvents -StartTime (Get-Date).AddDays(-15) | where LogonType -eq 'RemoteInteractive' | ft ComputerName,Userdomain,UserAccount,TimeStamp | out-file C:\RDSuserinfo.txt -Append
} -Credential $Credentials
}
