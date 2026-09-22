#!/usr/bin/env bash
# @title        Task1_file_handling.sh
# @author       <Asamoah Gifty Dansobea>
# @index        <4184424>
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  <This script is used to check arguments,director,file and write,append and display content check if original files exist and confirm deletion >
# @date         <September 16 2026>



usage () {
    echo "Usage: $0 <target_directory> directory where the file will be created"
    echo " <target_directory>"
    exit "${1:-1}"
}
 #description of what it should be
 # Show help when the user explicitly asks for it.
if [ "$#" -eq 1 ] && { [ "$1" = "-h" ] || [ "$1" = "--help" ]; }; then
    usage 0
fi

# The script requires exactly one argument.
if [ "$#" -ne 1 ]; then
    echo "Error: exactly one target directory is required." >&2
    usage 1
fi

target_dir="$1"

# Reject an empty directory name before attempting any file operations.
if [ -z "$target_dir" ]; then
    echo "Error: target directory cannot be empty." >&2
    exit 1
fi

# Ensure the target directory actually exists.
if [ ! -d "$target_dir" ]; then
    echo "Error: target directory '$target_dir' does not exist." >&2
    exit 1
fi

# Define the new file inside the target directory.
file="$target_dir/task1_file.txt"

# Do not overwrite an existing file; the task requires a new file.
if [ -e "$file" ]; then
    echo "Error: file already exists: $file" >&2
    exit 1
fi

# Create the new file.
if touch "$file"; then
    echo "Success: file created: $file"
else
    echo "Error: failed to create file: $file" >&2
    exit 1
fi

# Write the initial content to the new file.
if echo "This is the initial content of the file." > "$file"; then
    echo "Success: initial content written."
else
    echo "Error: failed to write to $file" >&2
    exit 1
fi


# Micro-pause to allow OS file indexers to release the handle
sleep 0.1

# Append additional content without replacing the existing content.
if echo "This is additional content appended to the file." >> "$file"; then
    echo "Success: additional content appended."
else
    echo "Error: failed to append to $file" >&2
    exit 1
fi

# Display the contents so the user can verify what was written.
echo "File contents:"
if cat "$file"; then
    echo "Success: file contents displayed."
else
    echo "Error: failed to read $file" >&2
    exit 1
fi

# Create a backup copy with the .bak extension.
backup_file="${file}.bak"

if cp "$file" "$backup_file"; then
    echo "Success: backup created: $backup_file"
else
    echo "Error: failed to create backup: $backup_file" >&2
    exit 1
fi

# Check again that the original file exists before attempting deletion.
if [ -e "$file" ]; then
    echo "Confirmation: original file exists and is ready for deletion."
else
    echo "Error: original file does not exist; cannot delete it." >&2
    exit 1
fi

# Ask the user for confirmation before deleting the original.
read -r -p "Delete $file? [y/N]: " answer

case "$answer" in
    y|Y)
        if rm "$file"; then
            echo "Success: original file deleted."
        else
            echo "Error: failed to delete $file" >&2
            exit 1
        fi
        ;;
    *)
        echo "Deletion cancelled."
        exit 0
        ;;
esac

echo "Task completed successfully."
exit 0
```
