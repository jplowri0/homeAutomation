#!/bin/bash

# Define the file path
FILE_PATH="logs/side.csv"

# Get the current date and time in the format YYYY-MM-DD-HH-MM-SS
CURRENT_DATETIME=$(date '+%Y-%m-%d-%H-%M-%S')

# Define the message to append
MESSAGE="$CURRENT_DATETIME Door State: Closed"

# Append the message to the file
echo "$MESSAGE" >> "$FILE_PATH"
