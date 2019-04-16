#!/bin/bash
# Bismark iperf multi-task wrapper
#
# author: srikanth@gatech.edu
# modified by: walter.dedonato@unina.it
# Modified for PNIU by David Johnson 20/10/2016 - djohnson@csir.co.za

# Load configuration files

. /etc/bismark/bismark.conf
. "$BROOT"/etc/bismark/bismark-active.conf

# Help screen
[ $5 ] || { echo "usage: $(basename $0) <duration> <nthreads> <dst_ip> <dst_port> <up|dw>" ; exit ; }

# Settings
DATA_DIR=/tmp/bismark/active
cmd=/usr/bin/iperf3
out="$DATA_DIR/iperf-tmp-out"
err="$DATA_DIR/iperf-err"
ifaceout="$DATA_DIR/iface-out"
port=$NETPERF_PORT

# Auxiliary functions
clean() {
	rm -f $out*
	rm -f $err*
}

check() {
	nlines=$1
	c=1
	while [ $c -le $N ]
	do
		ilines=`awk 'END{print NR}' ${out}-$c`
		errors=`awk 'END{print NR}' ${err}-$c`
		if [ $nlines -ne $ilines ] || [ $errors -gt 0 ]
		then 
			echo "-1000"
			clean
			echo 0 > $ifaceout
			exit 1
		fi
		: $((c++))
	done
}

parse() {
	nlines=1
	check $nlines
	head -$c -q "$out"* | awk '{print $5}' | awk 'BEGIN{sum=0;}{sum+=$1}END{print sum}'; 
}

clean
# Parse input parameters
T=$1
N=$2
host=$3
port=$4
dir=$5
keys=" -t$T  -fk"
case $dir in
dw) 
	keys=$keys' -R'
	netproc=2
	;;
up)
	netproc=10
	;;
esac

mkdir -p $DATA_DIR

echo 
bytecnt1=`cat /proc/net/dev | tr ":" " " | awk '/^[[:space:]]*'$WAN_IF' / {print $'$netproc'}'`


# Parallel tasks creatin loop
c=1
while [ $c -le $N ]; do
	echo $cmd $keys -p $port -c $host  
	$cmd $keys -p $port -c $host > ${out}-$c 2> ${err}-$c &
	#$cmd  -c $host -p $port $keys
	: $((c++))
done

# Wait for tasks to complete their job
wait
bytecnt2=`cat /proc/net/dev | tr ":" " " | awk '/^[[:space:]]*'$WAN_IF' / {print $'$netproc'}'`

echo $bytecnt1 $bytecnt2

# Parse measurement results and remove logs
#parse 
if [ $bytecnt2 -le $bytecnt1 ]; then
	echo 0 > $ifaceout
else
	echo $bytecnt1 $bytecnt2 | awk '{print ($2 - $1)/(125*'$T')}' > $ifaceout
fi
#clean
exit 0