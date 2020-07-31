#!/bin/bash
rm -f /tmp/in /tmp/out
mkfifo /tmp/in
mkfifo /tmp/out

cat /tmp/in | /bin/bash game.sh 2>&1 | tee -a /tmp/out | nc -l ${1:-1234} > /tmp/in &
cat /tmp/out &
while :
do
	read CMD
	echo $CMD > /tmp/in
done
