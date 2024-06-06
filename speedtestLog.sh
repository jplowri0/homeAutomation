#!/bin/bash

# Extracting the Mbut/s from the speedtest txt file.

CSV_FILE="log_speedtest.csv"

DOWNLOAD=$(awk '/^Download/ { print $2 }' speedtest.txt)
UPLOAD=$(awk '/^Upload/ { print $2 }' speedtest.txt)
PING=$(awk '/.*Comvergence.*/ { print $7 }' speedtest.txt)
IP=$(awk '/.*TPG.*/ { print $5 }' speedtest.txt)
IPreduced=$(echo "$IP" | sed 's/[^0-9.]/ /g' | awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) print $i}')

# Get the current date and time
CURRENT_DATE=$(date '+%Y-%m-%d')
CURRENT_TIME=$(date '+%H:%M:%S')

# Check if the CSV file exists and is not empty
if [ ! -s "$CSV_FILE" ]; then
	# If the file does not exist or is empty, write the header
	echo "Date,Time,Download,Upload,Ping,IP" >"$CSV_FILE"
fi

# Append the current date, time, and door state to the CSV file
echo "$CURRENT_DATE,$CURRENT_TIME,$DOWNLOAD,$UPLOAD,$PING,$IPreduced" >>"$CSV_FILE"
