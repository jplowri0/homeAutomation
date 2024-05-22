#!/bin/bash

# List of door files
declare -A DOOR_FILES=(
	["Front door"]="log_front_door.csv"
	["Back door"]="log_back_door.csv"
	["Garage door"]="log_garage_door.csv"
)

# ANSI escape code for yellow
YELLOW="\033[0;33m"
# ANSI escape code for green
GREEN="\033[0;32m"
# ANSI escape code for red
RED="\033[0;31m"
# ANSI escape code to reset color
RESET_COLOR="\033[0m"

# Initialize previous state variables and last open date as associative arrays
declare -A PREV_STATES
declare -A LAST_OPEN_DATES

# Function to print state and last open date
print_state() {
	local door=$1
	local state=$2
	local date=$3

	if [ "$state" -eq 1 ]; then
		if [ "$date" = "CHECK" ]; then
			echo -e "\t| $door\t| ${GREEN}Open${RESET_COLOR}\t| ${YELLOW}CHECK${RESET_COLOR}\t|"
		else
			echo -e "\t| $door\t| ${GREEN}Open${RESET_COLOR}\t| $date\t|"
		fi
	else
		if [ "$date" = "CHECK" ]; then
			echo -e "\t| $door\t| ${RED}Closed${RESET_COLOR}\t| ${YELLOW}CHECK${RESET_COLOR}\t|"
		else
			echo -e "\t| $door\t| ${RED}Closed${RESET_COLOR}\t| $date\t|"
		fi
	fi
}

# Function to print table header
print_header() {
	echo -e "\t+-----------------+--------+-------------------+"
	echo -e "\t| Door            | State  | Last Open         |"
	echo -e "\t+-----------------+--------+-------------------+"
}

# Function to get last open date from the file
get_last_open_date() {
	local file=$1
	local last_open_date="N/A"
	while IFS=, read -r d t s; do
		if [ "$s" = "1" ]; then
			last_open_date="$d"
		fi
	done <"$file"

	# Check if the last open date is today
	if [ "$(date +'%Y-%m-%d')" = "$last_open_date" ]; then
		echo "CHECK"
	else
		echo "$last_open_date"
	fi
}

# Infinite loop to check the state every 10 seconds
while true; do
	# Clear the screen
	clear

	# Print the table header
	print_header

	for DOOR_NAME in "${!DOOR_FILES[@]}"; do
		FILE="${DOOR_FILES[$DOOR_NAME]}"

		if [ ! -f "$FILE" ]; then
			echo -e "\t| $DOOR_NAME\t| ${RED}Error${RESET_COLOR}\t| File not found  |"
			continue
		fi

		# Get the last state value from the last line of the file
		LAST_STATE=$(tail -n 1 "$FILE" | awk -F, '{print $3}')

		# Get the last open date for the door
		LAST_OPEN_DATES[$DOOR_NAME]=$(get_last_open_date "$FILE")

		# Initialize previous state if not already done
		if [ -z "${PREV_STATES[$DOOR_NAME]}" ]; then
			PREV_STATES[$DOOR_NAME]="$LAST_STATE"
			# Print initial state
			print_state "$DOOR_NAME" "$LAST_STATE" "${LAST_OPEN_DATES[$DOOR_NAME]}"
			continue
		fi

		# Check if the state has changed
		if [ "$LAST_STATE" != "${PREV_STATES[$DOOR_NAME]}" ]; then
			# Print the new state
			print_state "$DOOR_NAME" "$LAST_STATE" "${LAST_OPEN_DATES[$DOOR_NAME]}"

			# Update the previous state
			PREV_STATES[$DOOR_NAME]="$LAST_STATE"
		else
			# Print the current state without change
			print_state "$DOOR_NAME" "$LAST_STATE" "${LAST_OPEN_DATES[$DOOR_NAME]}"
		fi
	done

	echo -e "\t+-----------------+--------+-------------------+"

	# Wait for 10 seconds before checking again
	sleep 10
done
