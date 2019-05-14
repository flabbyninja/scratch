#!/usr/bin/env bash
shopt -s nullglob
scriptname=`basename $0`

printUsage() {
  echo "Usage: ${scriptname} <dir>"  
}

checkDirectoryHasFiles() {
    if [ -z "$(ls -A $1)" ]; then
        dirHasFiles=false
    else
        dirHasFiles=true
    fi
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

targetDir=$1

# If no extension specified, then autoderive
if [ -z $2 ]; then
    autoderive=true
else
    autoderive=false
    target_ext=$2
    echo "Manually setting target extension to: ${target_ext}"
fi

echo "Auto-deriving file extension: ${autoderive}"
checkDirectoryHasFiles $1

if [ $dirHasFiles = false ]; then
    echo "error: <dir> (${1}) is empty. Nothing to process"
    exit 1
fi

for file in $targetDir/*
do
    if [ $autoderive =  true ]; then
        filetype=$(file -b "$file" | cut -d' ' -f1)
    else
        filetype=${target_ext}
    fi;

    mv ${file} ${file}.${filetype,,}
done