#!/bin/bash
timestamp () {
    date +"%Y%m%d%H%M%S"
}

echo "Stopping services"
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver

echo "Renaming existing files"
rename_timestamp=$(timestamp)
mv /c/Windows/SoftwareDistribution SoftwareDistribution.$rename_timestamp
mv /c/Windows/System32/catroot2 catroot2.$rename_timestamp

echo "Starting services"
net start wuauserv
net start cryptSvc
net start bits
net start msiserver

