#!/bin/bash
# @title        Task1_file_handling.sh
# @author       <Asamoah Gifty Dansobea>
# @index        <4184424>
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  <this scrip is for testing and demonstrating how linux file permissions and adminstrative rights i.e sudo work on a single file >
# @date         <September 16 2026>





usage() {
    echo "Usage: $0 <file>"
    echo "  <file>  file whose permissions will be examined and changed"
    exit "${1:-1}"
}
if [ "$#" -eq 1 ] && { [ "$1" = "-h" ] || [ "$1" = "--help" ]; }; then
    usage 0
fi
if [ "$#" -ne 1 ]; then
    echo "Error: exactly one file path is required." >&2
    usage 1
fi


# Store the first command-line argument in the file variable.
file="$1"

# Check that the supplied path is an existing regular file
# before attempting to examine or modify its permissions.
if [ ! -f "$file" ]; then
    echo "Error: file does not exist or is not a regular file: $file" >&2
    exit 1
fi

echo "File: $file"

# REPORT PERMISSIONS BEFORE CHANGES

echo "Permissions before changes:"

# Get and display symbolic permissions, for example -rw-r--r--.
if symbolic_before=$(stat -c "%A" "$file"); then
    echo "Symbolic permissions: $symbolic_before"
else
    echo "Error: failed to read symbolic permissions." >&2
    exit 1
fi

# Get and display numeric permissions, for example 644.
if numeric_before=$(stat -c "%a" "$file"); then
    echo "Numeric permissions: $numeric_before"
else
    echo "Error: failed to read numeric permissions." >&2
    exit 1
fi

# CHANGE PERMISSIONS USING NUMERIC SYNTAX

# 644 means:
# Owner  = rw-
# Group  = r--
# Others = r--
if chmod 644 "$file"; then
    echo "Success: permissions changed to 644 using numeric chmod."
else
    echo "Error: failed to change permissions to 644." >&2
    exit 1
fi

# CHANGE PERMISSIONS USING SYMBOLIC SYNTAX

# u+x means: add execute permission to the file owner.
if chmod u+x "$file"; then
    echo "Success: execute permission added for the owner using symbolic chmod."
else
    echo "Error: failed to add execute permission to the owner." >&2
    exit 1
fi

# CHECK FOR ROOT/SUDO PRIVILEGES

# id -u returns the numeric user ID of the current user.
# Root has user ID 0.
if uid=$(id -u); then
    echo "Current user ID: $uid"
else
    echo "Error: failed to determine the current user ID." >&2
    exit 1
fi

if [ "$uid" -eq 0 ]; then
    echo "Running as root. Attempting to change file ownership..."

    # Changing ownership normally requires root privileges.
    if chown root "$file"; then
        echo "Success: file ownership changed to root."
    else
        echo "Error: failed to change file ownership." >&2
        exit 1
    fi
else
    # Not being root is not a fatal error.
    # The assignment requires us to skip chown gracefully.
    echo "Info: not running as root."
    echo "Info: skipping chown because root privileges are required."
fi

# REPORT PERMISSIONS AFTER CHANGES

echo "Permissions after changes:"

# Display the final symbolic permissions.
if symbolic_after=$(stat -c "%A" "$file"); then
    echo "Symbolic permissions: $symbolic_after"
else
    echo "Error: failed to read symbolic permissions after changes." >&2
    exit 1
fi

# Display the final numeric permissions.
if numeric_after=$(stat -c "%a" "$file"); then
    echo "Numeric permissions: $numeric_after"
else
    echo "Error: failed to read numeric permissions after changes." >&2
    exit 1
fi

echo "Task completed successfully."

# Exit with 0 to indicate successful completion.
exit 0
