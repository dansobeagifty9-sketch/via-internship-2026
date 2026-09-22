#!/bin/bash
#!/bin/bash
#!/usr/bin/env bash
# @title        Task1_file_handling.sh
# @author       <Asamoah Gifty Dansobea>
# @index        <4184424>
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  <this script is used to return codes and handle errors>
# @date         <September 16 2026>
# 1. Generate sample log data

# Task 4 - Return Codes & Error Handling
#
# Exit code scheme:
# 0 = All checks passed
# 1 = Host is unreachable
# 2 = Not enough free disk space
# 3 = File does not exist or is not readable
# 4 = Required command/tool is not installed


# Create a temporary file

TEMP_FILE=$(mktemp)


# Cleanup function
# Removes the temporary file before the script exits

cleanup() {
    rm -f "$TEMP_FILE"
    echo "Temporary files cleaned up."
}

# Run cleanup whenever the script exits, whether successful,
# failed, or interrupted with Ctrl+C
trap cleanup EXIT INT


# Helper function to check the result of the previous command
check_status() {
    status=$?
    message="$1"
    error_code="$2"

    if [ "$status" -eq 0 ]; then
        echo "[PASS] $message"
    else
        echo "[FAIL] $message"
        echo "Exiting with code $error_code"
        exit "$error_code"
    fi
}


# CHECK 1: Check whether a host is reachable

HOST="google.com"

ping -c 1 -W 2 "$HOST" > /dev/null 2>&1

check_status $? "Host $HOST is reachable" 1


#CHECK 2: Check whether enough disk space is available

MIN_FREE=10

FREE_SPACE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

FREE_PERCENT=$((100 - FREE_SPACE))

if [ "$FREE_PERCENT" -ge "$MIN_FREE" ]; then
    DISK_STATUS=0
else
    DISK_STATUS=1
fi

check_status "$DISK_STATUS" \
    "At least ${MIN_FREE}% free disk space is available" 2


# CHECK 3: Check whether a file exists and is readable

CONFIG_FILE="/etc/hosts"

if [ -f "$CONFIG_FILE" ] && [ -r "$CONFIG_FILE" ]; then
    FILE_STATUS=0
else
    FILE_STATUS=1
fi

check_status "$FILE_STATUS" \
    "File $CONFIG_FILE exists and is readable" 3


# CHECK 4: Check whether a required command is installed

COMMAND="curl"

command -v "$COMMAND" > /dev/null 2>&1

check_status $? "Command '$COMMAND' is installed" 4


# All checks passed

echo "----------------------------------------"
echo "[SUCCESS] All checks passed."
echo "Exiting with code 0."

exit 0