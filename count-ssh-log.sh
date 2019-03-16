#!/bin/bash

logfile="/var/log/auth.log"
searchterm="Failed"

# Get date of first line
firstline=$(head -n 1 "$logfile")
date=$(echo $firstline | cut -d' ' -f1-2)
echo "$date"

# Search and parse
numberofhits=$(grep "$searchterm" "$logfile" | wc -l)

echo "$numberofhits since $date"
