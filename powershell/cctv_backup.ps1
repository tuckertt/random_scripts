
# Gather parameters and set whether mandatory or not
Param(
  [parameter(mandatory=$True)]
  [string] $destination_directory,
  [parameter(mandatory=$True)]
  [string] $origin_directory,
  [parameter(mandatory=$True)]
  [int] $folder_number,
  [parameter(mandatory=$false)]
  [string] $LogDir
  )

# If no log directory specified on command line then set
if ( !$LogDir ) {
  $LogDir = "C:\logs"
}

# Setup the logfile path and if not present create file
$LogFile = "$LogDir\CCTV_file_backup.log"
if (!(Test-Path $LogFile )) {
 New-item -path $LogDir -name CCTV_file_backup.log -type "file" -Force 
 write-host $LogDir
}

# If folder number not set then set it to 16
if (!$folder_number) {

  $folder_number = 16

}

# Function to write to log file, adding timestamp (and command line if running from there)
Function LogWrite  {
 Param ([string]$logstring)
 $timestamp = Get-date -Format "yyyy/MM/dd HH:mm:ss"
 add-content $logfile -value "$timestamp $logstring"
 write-host $logstring
}

# Start logging
LogWrite "----------------------------------------"
LogWrite "Backup run started"
LogWrite "origin folder: $origin_directory"
LogWrite "destination folder: $destination_directory"

# Find out how many folders are present in back up dir
$folders = Get-ChildItem  -Path "$destination_directory"

logWrite $folders
# Compare folders with required number and delete / cleanup oldest one if there are too many
 if ( $folders.count -ge $folder_number ) {
 
   $oldest_directory = ls $destination_directory | sort Name | select -first 1

   LogWrite "  Oldest directory is $oldest_directory"
   LogWrite "  Removing oldest directory as currently at required folder number"
# Find out how many loops the delete takes  
   $dir_del = 1
# while loop in order to make sure space is freed up before moving on  
   while ( test-path -Path "$destination_directory\$oldest_directory") {
     LogWrite "  attempt $dir_del to delete $oldest_directory
     Remove-Item -Force -Recurse "$destination_directory\$oldest_directory"
     sleep 300
     $dir_del += 1
   }

   LogWrite "  Oldest directory removed"
   $new_oldest_directory = ls $destination_directory | sort Name | select -first 1
   LogWrite "  Now the oldest directory is $new_oldest_directory"

 } else {
  
$folders = Get-ChildItem -Path "$destination_directory"

$Folder_number = $folders.count
LogWrite "Folder not deleted due to lack of folders. Folder count is: $folder_number" 
 
}

# Finds the second most recent directory (setting to run circa 1am so yesterdays folder)
$yesterdays_directory = ls $origin_directory | sort Name | select -last 3 | select -first 1

$testing = ls $origin_directory
LogWrite $testing

LogWrite "Copy of $yesterdays_directory started"

# Backs-up the directory
Copy-Item -Path "$origin_directory\$yesterdays_directory" -Recurse -Destination "$destination_directory" -Container

LogWrite "Copy finished"

sleep 60
