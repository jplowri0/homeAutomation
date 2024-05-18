#!/bin/bash

# Define the file path
CSV_FILE="log_back_door_right_state.csv"

# Get the current date and time
CURRENT_DATE=$(date '+%Y-%m-%d')
CURRENT_TIME=$(date '+%H:%M:%S')

# Define the door state (0 for closed)
DOOR_STATE=1

# Check if the CSV file exists and is not empty
if [ ! -s "$CSV_FILE" ]; then
	# If the file does not exist or is empty, write the header
	echo "Date,Time,Door State" >"$CSV_FILE"
fi

# Append the current date, time, and door state to the CSV file
echo "$CURRENT_DATE,$CURRENT_TIME,$DOOR_STATE" >>"$CSV_FILE"
