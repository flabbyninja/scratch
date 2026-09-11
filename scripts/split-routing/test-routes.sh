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
INPUT_FILE=sample_log.txt

# Regexp to validate integer passed for traffic history days
re='^[1-9][0-9]*$'

# remove existing rules if they exist for these IP's
delete=0
add=0
app=0

# define list of applications to route outside the VPN
while read current_filter
do
    echo "Processing using filter: $current_filter"
    app=$((app+1))
    cat "$INPUT_FILE" | grep -E "$current_app" | cut -f 4 -d , | sort -u | while read ip
    do
        # Validate IPv4 format: four octets, each 0-255
        if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            # Additional check: each octet must be 0-255
            valid=true
            IFS='.' read -ra octets <<< "$ip"
            for octet in "${octets[@]}"; do
                if (( octet > 255 )); then
                    valid=false
                    break
                fi
            done
            if $valid; then
                echo "$ip"
            fi
        fi
    done
done <<EOF
,"/Applications/Citrix Workspace\.app/Contents/Frameworks/CitrixWorkspaceApps\.framework/Versions/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/Helpers/CitrixWorkspaceApps/Citrix Viewer\.app/Contents/MacOS/Citrix Viewer"
EOF

# Output total summary of what has been added and removed
echo "IPs added: $add, IPs deleted: $delete across $app application"
