#!/bin/sh
#
# Allows the use of a VPN while directly routing a set of IP addresses used by an application, letting them bypass the VPN. 
# Pulls back all connections made using an app over a specific number of days. This data is pulled from the Little Snitch CLI, so that needs 
# installed and enabled. Gets the default gateway for the configured network interface Routes the connection for all IP's through this
# default gateway. 
#
# set-routes.sh <num_days (default 5)> <subcommand (default refresh)>
#
#
# To manually reset all to default
# route -n flush
# sudo ifconfig en0 down
# sudo ifconfig en0 up

# Config
TRAFFIC_HISTORY_DAYS=5
APP_NAME="/Library/Application Support/Citrix Receiver/Citrix Viewer.app/Contents/MacOS/Citrix Viewer"
NET_INTERFACE=en0

# Regexp to validate integer passed for traffic history days
re='^[1-9][0-9]*$'

# Parameters

# Number of days traffic history to pull back. Default is 5
if [[ -z "$1" ]]
    then
        echo "No traffic history parameter set: using default of ${TRAFFIC_HISTORY_DAYS}"
elif [[ $1 =~ $re ]]
    then 
        TRAFFIC_HISTORY_DAYS=$1
else 
    echo "Provided traffic history parameter is not an integer (${1}): using default of ${TRAFFIC_HISTORY_DAYS}"
fi

# Subcommand for operation. Default is refresh (delete any route for IP, then add new route in)
if [[ -z "$2" ]]
    then
        SUBCOMMAND="refresh"
    else
        SUBCOMMAND=$1
fi

# Calculate start and end dates based on traffic history parameter
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
    if route delete -net $ip $DEFAULT_GATEWAY
    then
        delete=$((delete+1))
    fi
    if  [ -n $SUBCOMMAND ] && [ $SUBCOMMAND != "delete" ]
    then
        if route add -net $ip $DEFAULT_GATEWAY
        then
            add=$((add+1))
        fi
    fi
done

# Output summary of what has been added and removed
echo "IPs added: $add, IPs deleted: $delete"
