#!/bin/sh
#
# Remove any custom routes in route table. Must run as root, so use:
# sudo <script>.sh
NET_INTERFACE=en0
DEFAULT_SLEEP_PERIOD=3

echo "Resetting network route table... (sleep set to $DEFAULT_SLEEP_PERIOD)"

for i in {1..5}
do
    echo "Flushing routes: run " $i
    route -n flush
    sleep $DEFAULT_SLEEP_PERIOD
done

echo "Bringing $NET_INTERFACE down"
ifconfig $NET_INTERFACE down

sleep $DEFAULT_SLEEP_PERIOD

echo "Bringing $NET_INTERFACE up"
ifconfig $NET_INTERFACE up

echo "Network reset complete"
