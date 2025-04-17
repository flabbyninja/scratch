#!/bin/sh
#
# To manually reset all to default
# route -n flush
# sudo ifconfig en0 down
# sudo ifconfig en0 up

# Config
TRAFFIC_HISTORY_DAYS=5
APP_NAME="/Library/Application Support/Citrix Receiver/Citrix Viewer.app/Contents/MacOS/Citrix Viewer"
NET_INTERFACE=en0

if [ -z "$1" ]
    then
        SUBCOMMAND="refresh"
    else
        SUBCOMMAND=$1
fi

START_TIME=$(date -j -v-$(($TRAFFIC_HISTORY_DAYS))d '+%Y-%m-%d 00:00:00')
END_TIME=$(date -j '+%Y-%m-%d 00:00:00')

# get default gateway for en0
DEFAULT_GATEWAY=`route -n get -ifscope $NET_INTERFACE default | grep gateway | awk '{print $2}'`

# Output status info
echo "Processing input IP's from Little Snitch Traffic Log using configured gateway"
echo "Activated Subcommand: $SUBCOMMAND"
echo "Default gateway for ${NET_INTERFACE} set as ${DEFAULT_GATEWAY}" 
echo "Application set to $APP_NAME"
echo "Traffic parsing previous $TRAFFIC_HISTORY_DAYS days (Start Time: $START_TIME, End Time: $END_TIME)"

# remove existing rules if they exist for these IP's
delete=0
add=0
for ip in $(littlesnitch log-traffic -b $START_TIME -e $END_TIME | grep "$APP_NAME" | cut -f 4 -d , | sort -u)
do
    route delete -net $ip $DEFAULT_GATEWAY
    delete=$((delete+1))
    if  [ -n $SUBCOMMAND ] && [ $SUBCOMMAND != "delete" ]
    then
        add=$((add+1))
        route add -net $ip $DEFAULT_GATEWAY
    fi
done

echo "IPs added: $add, IPs deleted: $delete"