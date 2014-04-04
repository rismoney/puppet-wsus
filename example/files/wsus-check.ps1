import-module PSWindowsupdate -ErrorAction SilentlyContinue

try {
  Get-WUList
}
catch {
  write-output "An error occured while trying to communicate to WSUS server"
  exit 1
}
