#!/bin/bash
date
# This scripts fixes the problem of Harman Kardon AVR1700 reciever
# The reciever gets into BCO firmware update with no sucess
# It requires a manual upload of a dummy file, which fails but unblocks
# the reciever situation

# Your local network segement, the MAC address of the reciever
# and a filename to create an empty file
NETWORK=192.168.1.255
FAKEWARE=~/fakeware.hk
MACADDRESS=9c:64:5e:3:7a:5e

# After a while the reciever network is going to sleep, and no mac address can be detected
# So, we wake up the network, which makes the MAC Address available
echo "Waking up the network..."
ping -c 2 $NETWORK

# Create a fake firmeare file.
test -e $FAKEWARE || touch $FAKEWARE

# Detect H/K IP address by looking for the MAC Address
echo
echo "Fetching H/K IP Address"
HKIP=`arp -n -l -a | grep "$MACADDRESS"  | grep -o -E '(\d{1,3}\.)*(\d{1,3})' | head -n 1`

echo "H/K IP: $HKIP"
echo
echo "Sending dummy file to H/K (fake firmware update)..."

# Send using CURL a post of the firmware
OUTPUT=`curl -i -X POST -H 'Content-Type: multipart/form-data' -F appFirmware=@$FAKEWARE -F 'appFirmwareFile=Upload' -H 'Referer: http://$HKIP/1000/bl_firmware_update.asp?' http://$HKIP/goform/formPostHandler | grep 'GoAhead'`

echo

# Checking if we got a Server output so we assume it worked (not many option to valid unless
# we check the H/K display that error message had disappeared
if [[ $OUTPUT == Server* ]]; then
  echo "Sweet, check your H/K display, seems like its fixed"
else
  echo "Something didn't work as expected, review previous details NETWORK, IP, FILE"
  echo "last output"
  echo $OUTPUT
fi

echo
