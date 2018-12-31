#!/usr/bin/env bash
filename=$1
new_filename=`echo $filename | sed -e 's/ /_/g'`
mv "$filename" $new_filename