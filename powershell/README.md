Powershell scripts

**CCTV_backup.ps1**
A script to backup a folder ( primarily CCTV recordings ) from a local drive to a different drive ( use case is a samba share ( ctdb ) ). DCS-100 CCTV software names the directory with the date. Folder is set to the second most recent ( scheduled task runs at 1am to take yesterdays recordings and back them up. By default logs some evidence of having run in c:\logsCCTV_file_backup.log

Parameters:
 -destination_directory =>  drive space / folder to copy yesterdays directory to
 -origin_directory => drive space / folder to copy from
 -folder_number => number of folders at the top level to keep
optional:
 -logdir => specifies a different folder for logs than c:\logs

command line run: 
cctv_backup.ps1 -destination_directory  z:\ -origin_directory D:\Scheduled_backup -folder_number 15


Scheduled task configuration ( mapped drive not automatically atached so targeting directly):
-File "D:\cctv_backup.ps1" -destination_directory  \\169.254.0.1\gluster-cctv -origin_directory D:\Scheduled_backup -folder_number 15

NB:
 - While loop used in order to make sure the previous directory isn't there before adding a new one however it could be the sleep giving the delete time to work,
need to check logs to see if it loops.
 - Not using disk space check partially as didn't fancy mounting the drive share in the script.
