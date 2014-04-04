# originally Written by dm0nk 2013 and now adapted by rismoney
# Simple tool that uses the PSWindowsUpdate Library for powershell
# perfect for domain administrators who dont want to use Active Directory & WSUS to control the windows updates
# found original script @ https://github.com/dM0nk/winupdater/blob/master/update.ps1
# added PSLogging

ipmo PSWindowsUpdate
ipmo PSLogging

$logDir = "C:\@inf\winbuild\logs\"
$wsusLog = join-path $logdir "wsus-enforce-$(Get-Date -Format 'yyyy-MM-dd-HHmmss').log"

$LogFile = Add-LogFile -Path $wsusLog

#Set isthereupdate to see if there is updates.
$isthereupdate = Get-WUList -Verbose

#Run IF statement "if there is updates, Install them "
if ($isthereupdate) {
  Write-Host "I Found a update \o/ - yipee ki yay"
  #KB2694771 - KB-id of Bing Desktop Search - Exclude it- Bada Bing!
  Get-WUInstall -NotKBArticleID KB2694771 -IgnoreReboot -AcceptAll -Verbose
}
else {
  Write-Host "There are no updates for this server! - booya kasha"
}

#Is a reboot required ?
$isrebootrequired = Get-WURebootStatus
$LogFile | Disable-LogFile
