# hk-fix
Harman Kardon AVR1700 - Script to automatically fix for "BCO Update please wait" mode 

it works by scanning your current network, after pinging and waking up all devices.

looks for the Harman Kardon name of device to get the ip address, and then uploads a dummy file

# Usage

hk-fix.sh [ip_address] [port]
example: hk-fix.sh 192.168.1.60 80

in case of not having the ip address, but mac address is set on the bash code just use

hk-fix.sh
