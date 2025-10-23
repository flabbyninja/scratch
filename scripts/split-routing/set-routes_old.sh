#!/bin/sh +x

# get the PIDs for everything associated with Citrix
# brackets round first char in Awk presents it from matching awk itself
# final SED matches any character then new line, and replaces with nothing
# i.e. remove trailing comma
TARGET_PID=`ps -ax | awk '/[C]itrix/{print $1}' ORS=','|sed s'/.$//'`

# list connections for targeted PIDs
# lsof -p ${TARGET_PID} | grep -E "(LISTEN|ESTABLISHED)"
echo "PIDS are ${TARGET_PID}"

# list all processes listening on TCP with PIDs, process line by line
netstat -anv -p tcp | awk '{print $9, $5}'| tail -n +2 | 

# if [ -z "$1" ] 
#     then
#         TARGET_HOST=myworkspace.gslb.barcap.com
#         echo "No host supplied. Setting default target host to ${TARGET_HOST}"
#     else
#         TARGET_HOST=$1
#         echo "Set target host to ${TARGET_HOST}"
# fi

# # lookup ip address of target host
# TARGET_HOST_IP=`dig +short ${TARGET_HOST}`
# echo "Target route IP set to ${TARGET_HOST_IP}"

# # remove existing route

# # add route to default gateway