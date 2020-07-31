#!/bin/bash
rm -f /tmp/f
mkfifo /tmp/f
cat /tmp/f | /bin/bash game.sh 2>&1 | nc -l ${1:-1234} | tee -a /tmp/f
