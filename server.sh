#!/bin/bash

server() {
	# Launch some CLI game on some port
	# @param 1: game
	# @param 2: port
	game=$1
	port=${2:-1234}

	isNum='^[0-9]+$'
	if [ -z ${1+x} ]
	then
		echo "Usage: $0 <Script to host> <Port>"
		return 1
	elif [ ! -f ${game} ]
	then
		echo "[ERROR] File not found: $game"
		return 1
	elif ! bash -n ${game} &>/dev/null
	then
		echo "[ERROR] File invalid bash script: $game"
		bash -n ${game}
		return $?
	elif ! [[ $port =~ $isNum ]]
	then
		echo "[ERROR] Port is not a number: $port"
		return 1
	elif [ $port -lt 1024 ]
	then
		echo "[ERROR] Port must be >= 1024: $port"
		return 1
	fi

	# Make input/output fifos
	rm -f /tmp/in /tmp/out
	mkfifo /tmp/in		# The command-in stream
	mkfifo /tmp/out	        # Output stream from the given program

        echo "==============================================================="
	echo "Client can connect with: nc $(hostname -I | cut -d' ' -f1) $port"
        echo "==============================================================="

	# Launch server
	cat /tmp/in | /bin/bash ${game} 2>&1 | tee -a /tmp/out | nc -l ${port} > /tmp/in &
	GAME_PROC=$!
	cat /tmp/out &
	OUT_PROC=$!

	# -- MAIN LOOP --
	while :
	do
		read CMD
		[ ${CMD^^} == 'Q' ] && break
		echo $CMD > /tmp/in
	done

	kill -9 ${GAME_PROC} ${OUT_PROC}
	return 0
}

server $@
