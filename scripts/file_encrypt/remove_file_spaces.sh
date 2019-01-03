#!/usr/bin/env bash
#
# Run like this to update files:
#   find . -type f -name '* *' -exec remove_file_spaces.sh {} \;
filename=$1
new_filename=`echo $filename | sed -e 's/ /_/g'`
mv "$filename" $new_filename