#!/bin/bash

# Define ANSI color escape codes
RED='\033[0;31m'    # Red color
ORANGE='\033[0;33m' # Orange color
NC='\033[0m'        # No color (reset)

# Echo the alert message with colors
echo -e "${RED}ALERT ${ORANGE}Check Ring Battery ${NC}"
