# Update Extension

## Why?

Sometimes you have a bunch of files with the wrong extension, or with no extension. You might want to bulk add a specific extension, or give them one based on the kind of file it seems to be. That's what this script is for. 

## Prerequisites

None. Just run it in a Linux-like environment and it should do its thing.

## Usage

`update_extension.sh <dir> [<extension>]`

Running it will affect all files in the directory specified, but not subdirs. It will check the directory exists, and that it contains files before proceeding. If they don't, it exits and does nothing.

If you specify the optional `<extension>` parameter, it will add that extension to the files. If this isn't given, it'll attempt to derive the extension using `file` and rename each file accordingly.