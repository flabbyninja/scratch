#!/bin/sh
# use like this cat ips.txt |  xargs -I % route add -net % 97.9.255.253
# use like this cat ips.txt |  xargs -I % echo route add -net % 97.9.255.253
#
# Reset all to default using route -n flush
# sudo ifconfig en0 down
# sudo ifconfig en0 up

if [ -z "$1" ] 
    then
        echo "Input ip's not supplied, exiting"
        exit 1
fi

if [ -z "$2" ]
    then
        SUBCOMMAND="refresh"
    else
        SUBCOMMAND=$2
fi

NET_INTERFACE=en0
IP_FILE=$1

if [ -f "$IPFILE"]
    then
        # get default gateway for en0
        DEFAULT_GATEWAY=`route -n get -ifscope $NET_INTERFACE default | grep gateway | awk '{print $2}'`
        echo "Default gateway for ${NET_INTERFACE} set as ${DEFAULT_GATEWAY}" 
        echo "Processing input IP's from ${IP_FILE} using configured gateway"

        # remove existing rules if they exist for these IP's
        cat $IP_FILE |  xargs -I % route delete -net % $DEFAULT_GATEWAY

        # add back new rules
        if [ $SUBCOMMAND != "delete" ]
            then
                cat $IP_FILE |  xargs -I % route add -net % $DEFAULT_GATEWAY
        fi
    else
         echo "File missing: ${IP_FILE}. Exiting."
fi