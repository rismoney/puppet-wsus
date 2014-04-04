import-module PSWindowsupdate -ErrorAction SilentlyContinue

try {
  restart-service wuauserv
  wuauclt /resetauthorization /detectnow
  $serviceid = (Get-WUServiceManager | ? {$_.isdefaultauservice -eq $true}).serviceid
  # Get-WUList is not pipelineable with serviceid
  Get-WUList -ServiceID $serviceid
}
catch {
  write-output "An error occured while trying to reset authorization and communicate to WSUS server"
  exit 1
}
