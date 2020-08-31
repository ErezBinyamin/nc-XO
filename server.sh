#!/bin/bash
#remove any existing fif's with these names
rm -f /tmp/in /tmp/out
#create fifos with these names
mkfifo /tmp/in		#ie the command-in stream
mkfifo /tmp/out	        #output from the given program
game=$2

cat /tmp/in | /bin/bash ${game} 2>&1 | tee -a /tmp/out | nc -l ${1:-1234} > /tmp/in &
cat /tmp/out &
while :
do
	read CMD
	echo $CMD > /tmp/in
done
