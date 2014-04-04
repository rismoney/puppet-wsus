import-module PoshWSUS -ErrorAction SilentlyContinue

try {
  Connect-PoshWSUSServer -WsusServer localhost -port 8530
  Start-PoshWSUSSync
}
catch {
  write-output "An error occured while trying to start a PoshWSUS Sync (Fetch-WSUS) with Microsoft Update Service."
  exit 1
}
