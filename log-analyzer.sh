#!/bin/bash

# ==============================================================================
# Tool Name: log-analyzer
# Description: Analyzes web server access logs and outputs top IPs, paths, 
#              status codes, and user agents.
# Usage: log-analyzer <log-file>
# ==============================================================================

# 1. Validate arguments
if [ $# -eq 0 ]; then
    echo "Error: No log file provided."
    echo "Usage: log-analyzer <log-file>"
    exit 1
fi

LOG_FILE="$1"

# 2. Check if the file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' does not exist."
    exit 1
fi

echo "========================================================"
echo "          ACCESS LOG ANALYSIS REPORT                    "
echo "========================================================"
printf "Source file: %s\n\n" "$LOG_FILE"

# 3. Top 5 IP Addresses
echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | \
    awk '{print $2 " - " $1 " requests"}'
echo ""

# 4. Top 5 Most Requested Paths
echo "Top 5 most requested paths:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | \
    awk '{print $2 " - " $1 " requests"}'
echo ""

# 5. Top 5 Response Status Codes
echo "Top 5 response status codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | \
    awk '{print $2 " - " $1 " requests"}'
echo ""

# 6. Top 5 User Agents
echo "Top 5 user agents:"
awk -F'"' '{print $4}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | \
    awk '{count=$1; $1=""; sub(/^ */, ""); print $0 " - " count " requests"}'
echo ""
echo "========================================================"
echo "                   ANALYSIS COMPLETE                    "
echo "========================================================"
