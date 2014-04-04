<########################################################################################

Name: WSUS Get Systems Without Sync Or Report in X days
Date: Februari 17th 2013
Author:Bjorn Houben
Adapted by: rismoney
Blog: http://blog.bjornhouben.com
Website: http://www.bjornhouben.com
Linkedin: http://nl.linkedin.com/in/bjornhouben

Purpose: Get a list of clients that haven't reported or synced in the last X days.

Assumptions:

Known issues:

Limitations:

Notes:   Inspired by : http://blogs.technet.com/b/heyscriptingguy/archive/2012/01/19/use-powershell-to-find-missing-updates-on-wsus-client-computers.aspx

Disclaimer: This script is provided AS IS without warranty of any kind. I disclaim all implied warranties including, without limitation,
      any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or
      performance of the sample scripts and documentation remains with you. In no event shall I be liable for any damages whatsoever
      (including, without limitation, damages for loss of business profits, business interruption, loss of business information,
      or other pecuniary loss) arising out of the use of or inability to use the script or documentation.

To improve:

Copyright:   I believe in sharing knowledge, so this script and its use is subject to : http://creativecommons.org/licenses/by-sa/3.0/

History:
February 17 2013:Created script
March 26 2014: Adapted script for ISE

########################################################################################>

#Define upstream server
$WSUSupstreamserver = "localhost"
$port = 8530
#Get current date
$Now = Get-Date

#Define when a file needs to be written to for the last time to be allowed to stay in the target folder.
#When setting days to 2, all files meeting the criteria AND that have not been written to in 2 days will be moved
#to the archive folder
$MaxDays = "7"

#Set the date/time to compare against (current time $now minus $MaxDays
$Maxdate = $Now.AddDays(-$Maxdays)

#Load required assemblies for working with WSUS
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")

#Connect to the WSUS Server and create the wsus object
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($WSUSupstreamserver,$False,$port)

#Get computers not contacted since
#write-host "WSUS computers not contacted since $Maxdate:"
#$wsus.GetComputersNotContactedSinceCount($Maxdate)

#Create a computer scope object
$ComputerTargetScope = New-Object Microsoft.UpdateServices.Administration.ComputerTargetScope

#Use $ComputerTargetScope | get-member to see options to limit the ComputerTargetScope

#Include clients in the $computertargetscope from downstream WSUS servers
$ComputerTargetScope.IncludeDownstreamComputerTargets = $true

#Include clients in the $computertargetscope from subgroups
$ComputerTargetScope.IncludeSubGroups = $true

#Include clients in the $computertargetscope that have synced AFTER $MaxDate
#$ComputerTargetScope.FromLastSyncTime  = $MaxDate

#Include clients in the $computertargetscope that have synced BEFORE $MaxDate
$ComputerTargetScope.ToLastSyncTime  = $MaxDate

#Include clients in the $computertargetscope that have reported AFTER $MaxDate
#$ComputerTargetScope.ToLastReportedStatusTime  = $MaxDate

#Include clients in the $computertargetscope that have reported BEFORE $MaxDate
$ComputerTargetScope.ToLastReportedStatusTime  = $MaxDate

#Include clients in the $computertargetscope whose name match the filter
#$clientnamemustcontain = "example.com"
#$ComputerTargetScope.NameIncludes = $clientnamemustcontain

#Find all clients matching the computer target scope
$wsus.GetComputerTargets($ComputerTargetScope) | select FullDomainName, RequestedTargetGroupName, LastSyncTime, LastSyncResult, LastReportedStatusTime
