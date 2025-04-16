#!/bin/sh
#
# Remove any custom routes in route table. Must run as root, so use:
# sudo <script>.sh
NET_INTERFACE=en0

echo "Resetting network route table..."

for i in {1..3}
do
    echo "Flushing routes: run " $i
    route -n flush
done

echo "Bringing $NET_INTERFACE down"
ifconfig $NET_INTERFACE down

echo "Bringing $NET_INTERFACE up"
ifconfig $NET_INTERFACE up

echo "Network reset complete"