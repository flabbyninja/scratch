#!/bin/sh
# Encrypt directory full of files using GPG symmetric encryption, with password provided at runtime.
# Creates timestamped tgz backup of source data as a backup.

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
    read -p "Password:" -es password
    echo -e "\nok"
    read -p "Password:" -es password2
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
    rootdirame="backup"
    backupdir=$rootdirname"_"$(date +"%Y%m%d%H%M%S")
    fqbackupdir=$dir"/"$backupdir
    backupdestination=".."
    echo "Backing up to ${fqbackupdir}"

    if [ ! -d $fqbackupdir ]; then
        mkdir $fqbackupdir
    fi

    for file in "${dirlist[@]}"
    do
        cp $file $fqbackupdir
    done

    tar zcvf $fqbackupdir.tgz $backupdir
    rm -rf $fqbackupdir
}

doEncryption() {
    dir=$1
    pass=$2
    dirlist=(`find $dir -type f`)

    # Backup files
    createBackupArchive $dir $dirlist

    echo "About to encrypt directory ${dir}"

    for i in "${dirlist[@]}"
    do
        if [ "$(file -b "$i")" != "GPG symmetrically encrypted data (AES cipher)" ]; then
            gpg --batch --pinentry-mode loopback --passphrase=$pass -c $i
            rm $i
            mv $i".gpg" $i
        else
            echo "${i} already encrypted. Skipping encryption step and leaving file unchanged"
        fi
    done
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