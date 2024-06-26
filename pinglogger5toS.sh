#!/bin/bash
# This is a latency loggin tool It will ping and record the ms only.
#
# Next I want to log the ms with Date and Time, then append to a csv file every minute.

# Define the colours
# ANSI escape code for yellow
YELLOW="\033[0;33m"
# ANSI escape code for green
GREEN="\033[0;32m"
# ANSI escape code for red
RED="\033[0;31m"
# ANSI escape code to reset color
RESET_COLOR="\033[0m"

# Infinite Loop
while true; do
	HOST="192.168.1.246"
	# Checking if the host is down or not.
	PING=$(ping -c 1 "$HOST" | awk '/100%/ { print $8 }')
	# Now if a host is down it will contin 100% string.
	if [ "$PING" = "loss," ]; then
		clear
		echo -e "[${RED}X${RESET_COLOR}] Synology ${RED}DOWN${RESET_COLOR}"
	else
		CSV_FILE="log_latency_5toSyn.csv"

		# This command here will send 1 ping then awk out the line containing icmp_seq=1 then get the 7th field.
		# Finally it will remove the time= with sed.
		LATENCY=$(ping -c 1 "$HOST" | awk '/icmp_seq=1/ { print $7 }' | sed 's/time=//')

		# Get the current date and time
		CURRENT_DATE=$(date '+%Y-%m-%d')
		CURRENT_TIME=$(date '+%H:%M:%S')

		# Check if the CSV file exists and is not empty
		if [ ! -s "$CSV_FILE" ]; then
			# If the file does not exist or is empty, write the header
			echo "Date,Time,Latency" >"$CSV_FILE"
		fi

		# Append the current date, time, and door state to the CSV file
		echo "$CURRENT_DATE,$CURRENT_TIME,$LATENCY" >>"$CSV_FILE"
		clear
		echo -e "[${GREEN}^${RESET_COLOR}] Synology ${GREEN}UP${RESET_COLOR}"
	fi
	sleep 120
done
