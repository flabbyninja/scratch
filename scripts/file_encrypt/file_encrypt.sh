#!/usr/bin/env bash
#
# Encrypt directory full of files using GPG symmetric encryption, with password provided at runtime.
# Creates timestamped tgz backup of source data as a backup.
# Was written to run from git bash on Windows, so may need some tweaks for other distributions

scriptname=`basename $0`

printUsage() {
  echo "Usage: ${scriptname} <dir> <passphrase>"  
}

checkDirectoryHasFiles() {
    if [ -z "$(ls -A $1)" ]; then
        dirHasFiles=false
    else
        dirHasFiles=true
    fi
}

capturePassword() {
    read -es -p "Password:" password
    echo -e "\nok"
    read -es -p "Password:" password2
    echo -e "\nok"
    if [ "$password" == "$password2" ]; then
        passwordvalid=true
    else
        passwordvalid=false
    fi
}

createBackupArchive() {
    dir=$1
    dirlist=$2

    # Create directory with backup_datestamp
    rootbackupdirname="backup"_$dir
    backupdestination=".."
    backupdir=$rootbackupdirname"_"$(date +"%Y%m%d%H%M%S")
    fqbackupdir=$backupdestination"/"$backupdir
    
    echo "Backing up to ${fqbackupdir}"

    if [ ! -d $fqbackupdir ]; then
        mkdir $fqbackupdir
    fi

    for file in "${dirlist[@]}"
    do
        cp $file $fqbackupdir
    done

    tar zcf $backupdir.tgz $fqbackupdir
    rm -rf $fqbackupdir

    echo "Backup complete to ${fqbackupdir}.tgz"
}

doEncryption() {
    # Strip trailing slash, if present, from dir name
    dir=${1%/}
    pass=$2
    dirlist=(`find $dir -type f`)

    # Backup files
    createBackupArchive $dir $dirlist

    echo "About to encrypt directory ${dir}"

    for i in "${dirlist[@]}"
    do
        if [ "$(file -b "$i")" != "GPG symmetrically encrypted data (AES cipher)" ]; then
            gpg --batch --pinentry-mode loopback --passphrase=$pass -c $i
            if [ $? -ne 0 ]; then
                echo "gpg error processing $i: File has not been changed. Please verify status"
            else
                rm $i
                mv $i".gpg" $i
                echo "${i}: Encrypted and secured"
            fi
        else
            echo "${i} already encrypted. Skipping encryption and leaving file unchanged"
        fi
    done

    echo "Encryption of directory (${dir}) complete"
    echo "Unsecured backup files should be removed or otherwise secured"
}

# Validate parameters
if [ -z $1 ]; then
    printUsage
    echo "error: <dir> has not been provided"
    exit 1
else if [ ! -d $1 ]; then
        printUsage
        echo "error: <dir> provided does not exist"
        exit 1
    fi
fi

checkDirectoryHasFiles $1

if [ $dirHasFiles = false ]; then
    echo "error: <dir> (${1}) is empty. Nothing to process"
    exit 1
fi

capturePassword

if [ $passwordvalid = true ]; then
    echo "Passwords match. Starting encryption..."
    doEncryption $1 $password
else
    echo "Passwords did not match. Exiting..."
fi