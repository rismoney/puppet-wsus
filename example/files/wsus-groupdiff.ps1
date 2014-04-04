<#
.SYNOPSIS
   wsus group compare
.DESCRIPTION
   wsus-groupdiff compares a targetComputerGroup with with one or more other "checkforMissing" groups
.PARAMETER t
   targetComputerGroup
.PARAMETER c
   checkforMissing
.PARAMETER s
   servername
.PARAMETER p
   port
.NOTES
   this script was adapted by rismoney from serverfault question 463573
#>

Param(
  [parameter(Mandatory=$false,HelpMessage="targetComputerGroup")]
  [alias("t")]
  $targetcomputerGroup="",
  [parameter(Mandatory=$false,HelpMessage="checkForMissing")]
  [alias("c")]
  $checkForMissing="",
  [parameter(Mandatory=$false,HelpMessage="server")]
  [alias("s")]
  $serverName="localhost",
  [parameter(Mandatory=$false,HelpMessage="port")]
  [alias("p")]
  $port=8530,
  [parameter(Mandatory=$false)]
  [alias("h")]
  [switch]$help
)

if ($help) {
  get-help .\wsus-groupdiff.ps1
  break;
}

[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$wsus=[Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($serverName,$false,$port)
$computerGroup=$wsus.GetComputerTargetGroups()|ForEach-Object -Process {if ($_.Name -eq $targetComputerGroup) {$_}}
$UpdateScope=New-Object Microsoft.UpdateServices.Administration.UpdateScope
$UpdateScope.ApprovedStates="Any"
$updateScope.ApprovedComputerTargetGroups.Add($computerGroup)
$Approvals = $wsus.GetUpdateApprovals($UpdateScope)

#At this point we have all of the updates assigned to the $targetComputerGroup

$report= @()
write-host "Querying for all Updates approved for $targetComputerGroup"

foreach ($Approval in $approvals) {
  $record=""|Select-Object ComputerGroup,UpdateName, UpdateID
  $record.ComputerGroup=$wsus.GetComputerTargetGroup($Approval.ComputerTargetGroupID).Name
  $record.UpdateName=$wsus.GetUpdate($Approval.UpdateID).Title
  $record.UpdateID=$wsus.GetUpdate($Approval.UpdateID).ID.UpdateID
  $report +=$record
}

#Now group the results by UpdateName
$GR=$report|group -Property UpdateName

$CheckForMissing=$CheckForMissing.Split(",")

foreach ($entry in $gr) {
  $groups=@()
  foreach ($g in $entry.Group) {
    $groups += $g.ComputerGroup
  }
  foreach ($missing in $checkForMissing) {
    if ($groups -Contains $missing) {}
    else{
      New-Object PSObject -Property @{
      Name = $entry.Name
      UpdateID = $entry.Group[0].UpdateID
      GroupMissing = $missing
      }
    }
  }
}
