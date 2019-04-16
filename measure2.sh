#!/bin/sh
# Copy the contents of this file to the clipboard, then get a terminal open on your device and enter:  
#   $ cat > n.sh  
#  [Ctrl+V] or Right Click, Paste. Then [Ctrl+D].
#  chmod +x n.sh
#  To run: ./n.sh eth0
SLP=1 # display / sleep interval
DEVICE=$1
IS_GOOD=0
for GOOD_DEVICE in `grep \: /proc/net/dev | awk -F: '{print $1}'`; do
  if [ "$DEVICE" = $GOOD_DEVICE ]; then
    IS_GOOD=1
    break
  fi
done
if [ $IS_GOOD -eq 0 ]; then
  echo "Device not found. Should be one of these:"
  grep ":" /proc/net/dev | awk -F: '{print $1}' | sed s@\ @@g 
  exit 1
fi

while true; do
  LINE=`grep $1 /proc/net/dev | sed s/.*://`;
  RECEIVED1=`echo $LINE | awk '{print $1}'`
  TRANSMITTED1=`echo $LINE | awk '{print $9}'`
  TOTAL=$(($RECEIVED1+$TRANSMITTED1))
  sleep $SLP
  LINE=`grep $1 /proc/net/dev | sed s/.*://`;
  RECEIVED2=`echo $LINE | awk '{print $1}'`
  TRANSMITTED2=`echo $LINE | awk '{print $9}'`
  SPEED=$((($RECEIVED2+$TRANSMITTED2-$TOTAL)/$SLP))
  INSPEED=$((($RECEIVED2-$RECEIVED1)/$SLP))
  OUTSPEED=$((($TRANSMITTED2-$TRANSMITTED1)/$SLP))
  printf "In: %12i KB/s | Out: %12i KB/s | Total: %12i KB/s\n" $(($INSPEED/1024)) $(($OUTSPEED/1024)) $(($SPEED/1024)) ;
done;