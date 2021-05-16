#!/bin/bash
#
# Automate Raspberry Pi Backups, shrinking down using PiShrink
#
# Below you can set the default values if no command line args are sent.
# The script will name the backup files {$HOSTNAME}.{YYYYmmdd}.img
# When the script deletes backups older then the specified retention
# it will only delete files with it's own $HOSTNAME.
#

# Declare vars and set standard values
backup_path=/mnt/backup/raw
retention_days=45
pishrink=true

# Set path to find common tools for piShrink - especially when run from crontab which uses a sparse, default environment
PATH=$PATH:/usr/bin:/usr/sbin

checkRoot() {
   # Check that we are root!
   if [[ ! $(whoami) =~ "root" ]]; then
   echo ""
   echo "**********************************"
   echo "*** This needs to run as root! ***"
   echo "**********************************"
   echo ""
   exit
   fi
}

checkRoot()

# Check to see if we got command line args
if [ ! -z $1 ]; then
   backup_path=$1
fi

if [ ! -z $2 ]; then
   retention_days=$2
fi

if [ ! -z $3 ]; then
   pishrink=$3
fi

backup_file=$backup_path/$HOSTNAME.$(date +%Y%m%d_%H%M%S).img
echo $(date)
echo 'Backing up Pi filesystem to' $backup_file

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

# shrink the image
scriptdir=$(dirname $0)
echo 'Invoking PiShrink to minimise image size...'
echo "Running command: " $scriptdir/PiShrink/pishrink.sh -d $backup_file
$scriptdir/PiShrink/pishrink.sh -d $backup_file
echo 'Image shrinking complete'
