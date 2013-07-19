# ----------------------------------------------------------------------------- 
# Written By: Tyler Bell
# Description: Script creates html file Servers uptime, disk space details and critical errors. It then sends out email with that data.
################################
# Update: 03/18/2013 - Added functionality to pull errors from event logs in past 24 hours.
# ----------------------------------------------------------------------------- 

Param( 
  [string]$path = "C:\Users\tbell\uptimeFreespace_", 
  [array]$servers = @("server1","server2","server3") 
) 
 
Function Get-UpTime 
{ Param ([string[]]$servers) 
  Foreach ($s in $servers)  
   {  
     $os = Get-WmiObject -class win32_OperatingSystem -cn $s  
     New-Object psobject -Property @{computer=$s; 
       uptime = (get-date) - $os.converttodatetime($os.lastbootuptime)} 
        } #end foreach $s     
       } #end function Get-Uptime 
 
Function Get-DiskSpace 
{ 
 Param ([string[]]$servers) 
  Foreach ($s in $servers)  
   {  
     Get-WmiObject -Class win32_volume -filter "DriveType=3" -cn $s | 
       Select-Object @{LABEL='Computer';EXPRESSION={$s}}, driveletter, Label,  
         @{LABEL='FreeSpace(GB)';EXPRESSION={"{0:N2}" -f ($_.freespace/1GB)}},
   @{LABEL='% FreeSpace';EXPRESSION={"{0:P0}" -f ($_.freespace/$_.capacity)}}
    } #end foreach $s 
} #end function Get-DiskSpace 

#####Get Application Logs
#####################################
Function Get-AppLog
{
 Param ([string[]]$servers)
	foreach($server in $servers) { 
			Get-EventLog -ComputerName $server -LogName Application -EntryType Error -After $(Get-Date).AddHours(-24) | select MachineName,TimeGenerated,EntryType,Message,EventID
	} #end foreach servers
} #end function

#####Get System Logs
#####################################
Function Get-SysLog
{
 Param ([string[]]$servers)
	foreach($server in $servers) { 
			Get-EventLog -ComputerName $server -LogName System -EntryType Error -After $(Get-Date).AddHours(-24) | select MachineName,TimeGenerated,EntryType,Message,EventID 
	} #end foreach servers
} #end function


# Entry Point *** 
###################################
$upTime = Get-UpTime -servers $servers | ConvertTo-Html -As Table -Fragment -PreContent "<h2>Server Uptime Report</h2> 
  The following report was run on $(get-date)" | Out-String 
 
$disk = Get-DiskSpace -servers $servers |  
ConvertTo-Html -As Table -Fragment -PreContent " 
  <h2>Disk Report</h2> "| Out-String   

$appLog = Get-AppLog -servers $servers | ConvertTo-Html -As Table -Fragment -PreContent "<h2>Application Logs - Critical Errors in past 24 hours</h2> " | Out-String

$sysLog = Get-SysLog -servers $servers | ConvertTo-Html -As Table -Fragment -PreContent "<h2>System Logs - Critical Errors in past 24 hours</h2> " | Out-String

#Append current date to filename
####################################
$time = get-date -uformat "%Y-%m-%d"
$path = $path+$time+".html"

#Create header for report
#####################################
$header = "<style>"
$header = $header + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$header = $header + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black}"
$header = $header + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black}"
$header = $header + "</style>"

#Save fi
$Report = ConvertTo-Html -head $header -PreContent "<h1>Server Uptime and Disk Report</h1>" -PostContent $upTime, $disk, $appLog, $sysLog | Out-String

$Report >> $path

#Send via email
$users = "tyler@appliedtrust.com", "user2", "user3"
$fromemail = "diskcheck@domain.org"
$server = "emailserver.domain.org"

send-mailmessage -from $fromemail -to $users -subject "Daily Disk Check" -BodyAsHTML -body $Report -smtpServer $server
