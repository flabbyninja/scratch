#!/bin/bash
#
# Automate Raspberry Pi Backups, shrinking down using PiShrink
#
# Below you can set the default values if no command line args are sent.
# The script will name the backup files {$HOSTNAME}.{YYYYmmdd}.img
# When the script deletes backups older then the specified retention
# it will only delete files with it's own $HOSTNAME.

# Declare vars and set standard values
shrink_image=true
backup_path=/mnt/backup/raw
retention_days=45

# Set path to find common tools for piShrink - especially when run from crontab which uses a sparse, default environment
PATH=$PATH:/usr/bin:/usr/sbin

display_usage() { 
	echo -e "\nUsage: $0 [shrink_image] [backup_path] [retention_days]\n" 
}

checkRoot() {
	if [[ "$EUID" -ne 0 ]]; then 
		echo -e "\nError: This script must be run as root!\n" 
		exit 1
	fi 
}

# if more than 3 arguments supplied, display usage 
if [  $# -gt 3 ] 
then 
   echo -e "\nError: This script must have maximum of 3 parameters\n" 
   display_usage
   exit 1
fi 

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
   display_usage
   echo -e "Default values are shrink_image="$shrink_image, "backup_path="$backup_path ", retention_days="$retention_days"\n"
   exit 0
fi

# Validate we're running as the root user
checkRoot

# Process command line arguments
if [ ! -z $1 ]; then
   shrink_image=$1
fi

if [ ! -z $2 ]; then
   backup_path=$2
fi

if [ ! -z $3 ]; then
   retention_days=$3
fi

backup_file=$backup_path/$HOSTNAME.$(date +%Y%m%d_%H%M%S).img

echo $(date)
echo 'Backing up Pi filesystem to' $backup_file", keeping "$retention_days" days of backups, and shrink is "$shrink_image

# Create trigger to force file system consistency check if image is restored
touch /boot/forcefsck

# Perform backup
echo 'Starting raw image using dd...'
dd if=/dev/mmcblk0 of=$backup_file bs=1M
echo 'Raw imaging complete'

# Remove fsck trigger
rm /boot/forcefsck

# Delete old backups
find $backup_path/$HOSTNAME.*.img -mtime +$retention_days -type f -delete

runPiShrink() {
   echo "Running command: " $piscriptdir/PiShrink/pishrink.sh -d $backup_file
   $piscriptdir/PiShrink/pishrink.sh -d $backup_file
}

# shrink the image
if [[ $shrink_image == "true" ]]
then
   piscriptdir=$(dirname $0)
   echo 'Invoking PiShrink to minimise image size...'
   if ! runPiShrink; then
      echo 'Error shrinking image'
   else
      echo 'Image shrinking complete'
   fi
else 
   echo "Image shrinking not enabled - skipping"
fi

echo "Image backup complete"
