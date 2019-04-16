!/bin/bash
int=30
int="wlp2s0"
e1=`cat /sys/class/net/$int/statistics/tx_bytes`
sleep $int
e2=`cat /sys/class/net/$int/statistics/tx_bytes` 
echo $(((e2-e1)/$int)) bps