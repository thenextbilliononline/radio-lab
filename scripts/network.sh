#!/bin/bash


for run in {1..1000} 
do
# Writes network device data to a log
echo '++++++++++++++++++++++++++++++++++++++++++++++++++++++' >> network_log.txt
sudo ifconfig >> network_log.txt
echo '------------------------------------------------------' >> network_log.txt
sudo cat /proc/net/dev | xargs -L 1 echo `date +'[%s.%N]'` $1 >> network_log.txt #
sleep 0.3
done