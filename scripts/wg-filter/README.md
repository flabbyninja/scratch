# wg-filter

## Why?

Accepts a ZIP file with individual Wireguard config files of the format `prefix-<2 char country><0 - 3 digits>.conf` (e.g. `vpnplace-us123.conf`).

Processes this to create a compressed ZIP containing a random set of configuration entries up to a chosen number, picked from a configured set of countries.

This allows a smaller list of endpoints to be included, preventing huge lists in the Wireguard config, while still allowing a selection of global regions and a random set of endpoint from those regions.

## Prerequisites

Runs under Python3. Doesn't require anything outside the Python Standard Library.

## Usage

`python3 main.py`

## Output

Compressed ZIP file containing selection of `.conf` files from the chosen country. This will contain a random set, up to the number specified, or the full set if number chosen is greater than those available to choose from.