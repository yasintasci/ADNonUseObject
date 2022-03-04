$GroupLocation ="OU=Groups,OU=***-test,DC=systeam3,DC=work"
$Groups = Import-Csv -Path C:\temp\groups.csv
foreach ( $Group in $Groups){
if ( -not (Get-ADGroup -Filter "Name -eq '$($Group.Group)'" -ErrorAction SilentlyContinue))
{
New-ADGroup -Name $Group.Group -SamAccountName $Group.SamAccountName -Description "'$($Group.Group)' Takımı için oluşturulmuş Security grubudur" -Path $GroupLocation -GroupScope Universal -GroupCategory Security

}
else
{"Group '$($Group.Group)' already exist" }


} 