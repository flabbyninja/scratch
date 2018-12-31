# File Encrypt

## Why?

Secure an entire directory of files, individually, using GPG. This wraps the process in a simple script to speed things up.

## Prerequisites

This was written to run on `git-bash` in Windows 10. It should run fine in other Linux distributions or setups with little to no changes if needed.

## Usage

`file_encrypt.sh <dir>`

Running will prompt for and validate the password matches, validate the directory exists and has files, then encrypt all files in there with the same key using GPG symmetrical encryption. Any files that are already GPG encrypted will be skipped and remain unchanged.

Original files are backed up in the parent of `<dir>` in a `.tgz` file. This is unsecured and should typically be removed once the encryption is validated. This gives a fallback in case something unexpected happens.

If you want to check, you can verify file types after execution with:

```
for file in `find . -type f`
do
    echo "${file}: $(file -b $file)"
done
```