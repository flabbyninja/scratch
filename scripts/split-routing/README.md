# split-routing

## Why?

Support the ability to route connections from a named app via a different gateway on Mac OS. Main use case is when a VPN is active, to configure connections used by the app to bypass VPN routing, while all others route via VPN. This is useful where the VPN client doesn't support app-based split tunelling.

This script makes networking changes only to the current session. None of the changes are persisted, so will not survive a reboot. If in any doubt, just reboot and you're back to normal.

The `set-routes.sh` script will determine the default gateway for the network, and pull data from the [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html) traffic log to find what connections have been made by the app over a time period. It will then update the Mac OS route table for any valid ipv4 addresses it gets, routing those connections via the default gateway and not over the VPN.

Implementation within the script does this for a specific app, but can be quickly updated to cover any app that should behave like this.

### Note

This script updates route tables, but depending on how the app behaves, processes may remain connected through their existing routing. Disconnecting / reconnecting the network interface may be necessary to force the app to re-establish a connection, which will then use the new route. This is just how networking operates on current versions of Mac OS.

## Prerequisites

You must have [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html) turned on, with the option enabled for scripting access.

## Usage

### Configure split tunneling

`sudo set-routes.sh <operation>`

| Parameter | Meaning                                                                                             | Notes                                                                 |
| --------- | --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| `refresh` | Delete any existing routing for each discovered IP, and reset the route through the default gateway | This is the default. If no parameter is passed, this is the behaviour |
| `delete`  | Delete any existing routing for each discovered IP, setting route to what it would always have been |

### Reset networking

`sudo reset-networking.sh`

This will reset the networking route tables to default, and remove any customisation that may have been applied.

Flushes the route tables, and bring the network interface down and back up. This is run 3 times to deal with Mac OS behaviour meaning multiple runs are necessary to ensure all entries are flushed.
