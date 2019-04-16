#!/bin/bash

#shows traffic on the specified device

function human_readable {
	VALUE=$1
        BIGGIFIERS=( B K M G )
	CURRENT_BIGGIFIER=0
	while [ $VALUE -gt 10000 ] ;do
		VALUE=$(($VALUE/1000))
		CURRENT_BIGGIFIER=$((CURRENT_BIGGIFIER+1))	
	done
	#echo "value: $VALUE"
	#echo "biggifier: ${BIGGIFIERS[$CURRENT_BIGGIFIER]}"
	echo "$VALUE${BIGGIFIERS[$CURRENT_BIGGIFIER]}"
}

###CHECKS####

DEVICE=$1
IS_GOOD=0
for GOOD_DEVICE in `grep ":" /proc/net/dev | awk '{print $1}' | sed s/://`; do
	if [ $DEVICE = $GOOD_DEVICE ]; then
		IS_GOOD=1
		break
	fi
done
if [ $IS_GOOD -eq 0 ]; then
	echo "Device $DEVICE not found. Should be one of these:"
	grep ":" /proc/net/dev | awk '{print $1}' | sed s/://
	exit 1
fi

###REAL STUFF

RECEIVED=`grep $1 /proc/net/dev | awk '{print $2}'`
TRANSMITTED=`grep $1 /proc/net/dev | awk '{print $10}'`
TOTAL=$(($RECEIVED+$TRANSMITTED))

echo "Transmitted: `human_readable $TRANSMITTED`"
echo "Received: `human_readable $RECEIVED`"
echo "Total: `human_readable $TOTAL`"

SLP=3
echo "Sleeping $SLP to calculate speed..."
sleep $SLP

RECEIVED=`grep $1 /proc/net/dev | awk '{print $2}'`
TRANSMITTED=`grep $1 /proc/net/dev | awk '{print $10}'`
SPEED=$((($RECEIVED+$TRANSMITTED-$TOTAL)/$SLP))

echo "Current speed: `human_readable $SPEED`/s"