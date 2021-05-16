# pi-backup

## Why?

Create a backup image of a Raspberry Pi boot disk, and allow it to be shrunk to save space. Intended to be added to `crontab` to run regular, scheduled backups of OS and data. This uses `PiShrink` on the resulting image, reducing it to the minimum size required.

When an image is restored to an SD card and booted, it will resize to fill the available space, depending on the size available on the device.

This is a modified version of a backup script originally written by Kristofer Källsbo (www.hackviking.com, 2017), adding usage details, PiShrink and new configurable parameters.
 
## Prerequisites

Checkout `PiShrink` from https://github.com/Drewsif/PiShrink. This script expects PiShrink to be available in a subdirectory called `PiShrink`, relative to the main script.

## Usage

`system_backup_shrink.sh <shrink_image> <backup_path> <retention_days>`

| Parameter | Meaning | Example |
|-----------|---------|---------|
| `shrink_image` | Run `PiShrink` after taking raw image, to minimise overall image size. Default is true | Set to `false` or any non-`true` value if you don't want the image minimised. |
| `backup_path` | Path where backup image file will be stored. Default is `/mnt/backup/raw`. | `/data/backups/current` |
| `retention_days` | How many days to keep backups for. Any backups present in `backup_dir` older than this will be deleted. Default is 45 days. | `30` |

## `crontab` Setup

To run backup every Sun, Wed and Friday at 03:45, with output sent to `/var/log/system_backup.log`, add the following:

```
45 3 * * 0,3,5 /path/to/system_backup_shrink.sh >> /var/log/system_backup.log 2>&1
```

## Output

Resulting image files will be stored in `backup_dir`, and named in the format `$HOSTNAME.$(date +%Y%m%d_%H%M%S).img`

e.g. `rpi-server1.20210512_143557.img`

Files can be restored directly to a Raspberry Pi SD card, and when booted it will dynamically resize to the maximum size supported by the SD card.
