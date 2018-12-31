# File Encrypt

## Why?

To secure entire directories of files using GPG, letting  each file remain individually usable and able to be sent on its own. This just wraps the process up in a simple script to help do that.

## Prerequisites

This was written to run ong `git-bash` in Windows 10, as that's where I needed it. It should run in other Linux distributions or setups with little to no changes if you need to.

## Usage

`file_encrypt.sh <dir>`

It will prompt for and validate the password, validate the directory exists and has files, then encrypt all files in there with the same key using GPG symmetrical encryption, providing they have not already been encrypted.

Original files are backed up in the parent of `<dir>` in a `.tgz` file. This is unsecured and should typically be removed once the encryption is validated. This is a fallback only in case something unexpected happens.  