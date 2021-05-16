# pi-backup

## Why?

backup image of Raspberry Pi boot disk, and allow it to be shrunk down to save space. Intended to be added to crontab to run regular, schedules backups of OS and data. None of the shrinking code is mine; this uses PiShrink on the resulting image to reduce it down to the minimum size required.

When image is restored to SD card and booted, it will resize to fill the available space, depending on the size available on the device.

This is a modified version of a base script originally written by Kristofer KÃ¤llsbo 2017 www.hackviking.com
 
## Prerequisites

Checkout PiShrink from https://github.com/Drewsif/PiShrink. This script expects PiShrink to be available in a subdirectory called `PiShrink`, relative to the main script.

## Usage

`system_backup_shrink.sh <<blah> <blah> <blah>`

### crontab setup

Run backup every Sun, Wed and Friday at 03:45

```
45 3 * * 0,3,5 /path/to/system_backup_shrink.sh >> /var/log/system_backup.log 2>&1
```
