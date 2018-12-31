
# Windows Update Reset

## Resets Windows Update related services if things stop working

If Windows updates are stuck in pending or fail download, this script:

* stops core services
* renames `SoftwareDistribution` and `catroot2` folder
* restarts core services

To execute, run from an admin level Git `bash` shell, then execute Windows Update troubleshooter to rebuild service catalog from known good source.