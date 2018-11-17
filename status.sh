#!/bin/sh
HOST=xxxx
ping -c1 $HOST 1>/dev/null 2>/dev/null
SUCCESS=$?

if [ $SUCCESS -eq 0 ]
then
  echo "VPN is working $(date)" >> /config/vpn.log
else
  echo "GW didn't reply $(date)" >> /config/vpn.log
  touch /config/VPNNOTWORKING.txt
fi
