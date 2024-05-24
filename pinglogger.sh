#!/bin/bash
# This is a latency loggin tool It will ping and record the ms only.
#
# Next I want to log the ms with Date and Time, then append to a csv file every minute.

# This command here will send 1 ping then awk out the line containing icmp_seq=1 then get the 7th field.
# Finally it will remove the time= with sed.
ping -c 1 192.168.1.246 | awk '/icmp_seq=1/ { print $7 }' | sed 's/time=//'
