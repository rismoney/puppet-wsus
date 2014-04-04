#warning this is destructive
$title = 'What should I do?'
$prompt = 'Should I [A]bort or [D]estroy Approvals?'
$abort = New-Object System.Management.Automation.Host.ChoiceDescription '&Abort','Aborts the operation'
$destroy = New-Object System.Management.Automation.Host.ChoiceDescription '&Destory','Destroys approvals'
$options = [System.Management.Automation.Host.ChoiceDescription[]] ($abort,$destroy)

$choice = $host.ui.PromptForChoice($title,$prompt,$options,0)

if ($choice -eq 1) {
  import-module poshwsus
  connect-poshwsusserver localhost -port 8530

  $approvals = Get-PoshWSUSUpdateApproval

  foreach ($approval in $approvals) {
    $tg = $approval.targetgroup
    $kb = $approval.updatekb
    if ($tg -ne "All Computers") {
      Approve-PoshWSUSUpdate -Update $kb -Action NotApproved -group $tg
    }
  }
}
