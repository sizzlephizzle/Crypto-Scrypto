#!/bin/bash

# Save to your home path, ensure your daemon and CLI files are saved in /usr/bin
# Add to crontab -e as
# */5 * * * * timeout 270 bash /home/<Your username>/check.sh

COIN=stelo
CLI="-cli"
ETEST=$($COIN$CLI masternode list-conf | grep status | awk '{print substr($0,length($0)-16,16)}')
EXP="WATCHDOG_EXPIRED"
HTEST=$($COIN$CLI masternode list-conf | grep status | awk '{print substr($0,length($0)-7,7)}')
HOPE="ENABLED"

NODE=$($COIN$CLI masternode start-all | grep result | awk '{print substr($0,length($0)-11,10)}')
RES="successful"

if [[ $HTEST == $HOPE ]]
then
echo "Not Enabled"
 if [[ $ETEST == $EXP ]]
 then
 echo "Not Expired, node restart required"
 $COIN$CLI stop & sleep 5 && $COIN"d"
  while [[ $NODE == $RES ]]
  do sleep 30 && $COIN$CLI masternode start-all && sleep 3
  done
 echo "Node Restarted" >> /tmp/$COIN.log
 echo "Node Restarted" | wall
 fi
fi

