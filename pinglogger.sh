#!/bin/bash
# This is a latency loggin tool It will ping and record the ms only.
#
# Next I want to log the ms with Date and Time, then append to a csv file every minute.

CSV_FILE="tailscale_latency_8to5.csv"

# This command here will send 1 ping then awk out the line containing icmp_seq=1 then get the 7th field.
# Finally it will remove the time= with sed.
LATENCY=$(ping -c 1 192.168.1.246 | awk '/icmp_seq=1/ { print $7 }' | sed 's/time=//')

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
