#!/bin/bash
rm -f /tmp/f /tmp/g
mkfifo /tmp/f
mkfifo /tmp/g

cat /tmp/f | /bin/bash game.sh 2>&1 | tee -a /tmp/g | nc -l ${1:-1234} | tee -a /tmp/f
