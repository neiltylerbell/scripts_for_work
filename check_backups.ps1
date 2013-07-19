# ----------------------------------------------------------------------------- 
# Written By: Tyler Bell
# Description: Script creates html file with Backup Exec information on jobs ran in the past 24 hours. It then sends out email with that data.
################################
#
# ----------------------------------------------------------------------------- 

Param( 
  [string]$path = "C:\Users\tbell\backupReport_", 
  [array]$servers = @("server1, server2, server3") 
) 

##### Get Backup Exec Jobs
##### First we import the BEMCLI module and then check for BE jobs from past 24 hours.
#####################################
Function BackupExec-Jobs
{
 Param ([string[]]$servers)
  foreach($server in $servers) { 
			import-module "\program files\symantec\backup exec\modules\bemcli\bemcli";  Get-BEJobHistory -FromStartTime (Get-Date).AddHours(-24) | Select-Object JobName, JobStatus, JobType, StartTime, EndTime, ElapsedTime, TotalDataSizeBytes
	} #end foreach servers
} #end function


# Entry Point *** 
###################################
$backups = Backupexec-Jobs -servers $servers | ConvertTo-Html -As Table -Fragment -PreContent "<h2>Jobs in last 24 hours</h2>
 The following report was ran on $(get-date)" | Out-String

#Append current date to filename
####################################
$time = get-date -uformat "%Y-%m-%d"
$path = $path+$time+".html"

#Create header for report
#####################################
$header = "<style>"
$header = $header + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$header = $header + "TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black}"
$header = $header + "TD{border-width: 1px;padding: 5px;border-style: solid;border-color: black}"
$header = $header + "</style>"

#Save fi
$Report = ConvertTo-Html -head $header -PreContent "<h1>Backup Exec Report</h1>" -PostContent $backups | Out-String

$Report >> $path

#Send via email
$users = "tyler@appliedtrust.com", "user1", "user2", "user3"
$fromemail = "backupcheck@domain.org"
$server = "emailserver.domain.org"

send-mailmessage -from $fromemail -to $users -subject "Daily Backup Check" -BodyAsHTML -body $Report -smtpServer $server
