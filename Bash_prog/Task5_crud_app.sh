
#!/usr/bin/env bash
# @title        Task1_file_handling.sh
# @author       <Asamoah Gifty Dansobea>
# @index        <4184424>
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  <this script is used to create a to do list>
# @date         <September 16 2026>
# 1. Generate sample log data

# Task 5 - CRUD Console App
# Todo List
# Fields: ID | Task Description | Status | Due Date

DATA_FILE="$(dirname "$0")/todo_data.txt"
BACKUP_FILE="${DATA_FILE}.bak"

# Function: Initialize data file



initialize_file() {
    if [ ! -f "$DATA_FILE" ]; then
        touch "$DATA_FILE"
    fi
}

# Function: Display usage/help

show_help() {
    echo
    echo "Usage: ./Task5_crud_app.sh"
    echo
    echo "Todo List CRUD Application"
    echo
    echo "Menu options:"
    echo "  1. Add     - Add a new todo"
    echo "  2. View    - Display all todos"
    echo "  3. Search  - Search for a todo"
    echo "  4. Update  - Update an existing todo"
    echo "  5. Delete  - Delete a todo"
    echo "  6. Help    - Display this help message"
    echo "  7. Exit    - Exit the application"
    echo
}

# Function: Generate next ID

get_next_id() {
    if [ ! -s "$DATA_FILE" ]; then
        echo 1
    else
        awk -F'|' '
        BEGIN { max=0 }
        {
            if ($1 > max)
                max=$1
        }
        END {
            print max + 1
        }' "$DATA_FILE"
    fi
}

# Function: Add a todo


add_todo() {
    echo
    echo "===== ADD TODO ====="

    while true; do
        read -r -p "Enter task description: " task

        if [ -z "$task" ]; then
            echo "Error: Task description cannot be empty."
        elif [[ "$task" == *"|"* ]]; then
            echo "Error: Task description cannot contain '|'."
        else
            break
        fi
    done

    while true; do
        read -r -p "Enter due date (optional, e.g. 2026-10-01): " due_date

        if [[ "$due_date" == *"|"* ]]; then
            echo "Error: Due date cannot contain '|'."
        else
            break
        fi
    done

    id=$(get_next_id)

    echo "$id|$task|pending|$due_date" >> "$DATA_FILE"

    echo "Todo added successfully. ID: $id"
}

# Function: View/List todos


view_todos() {
    echo
    echo "===== TODO LIST ====="

    if [ ! -s "$DATA_FILE" ]; then
        echo "No todo records found."
        return 0
    fi

    printf "%-5s %-40s %-12s %-15s\n" "ID" "TASK" "STATUS" "DUE DATE"
    echo "------------------------------------------------------------------------"

    while IFS='|' read -r id task status due_date; do
        printf "%-5s %-40s %-12s %-15s\n" \
            "$id" "$task" "$status" "$due_date"
    done < "$DATA_FILE"
}

# Function: Search todos

search_todo() {
    echo
    echo "===== SEARCH TODO ====="

    while true; do
        read -r -p "Enter search term: " search_term

        if [ -z "$search_term" ]; then
            echo "Error: Search term cannot be empty."
        else
            break
        fi
    done

    found=0

    echo
    while IFS='|' read -r id task status due_date; do

        if echo "$task" | grep -qiF "$search_term"; then
            printf "ID: %s | Task: %s | Status: %s | Due Date: %s\n" \
                "$id" "$task" "$status" "$due_date"
            found=1
        fi

    done < "$DATA_FILE"

    if [ "$found" -eq 0 ]; then
        echo "No todo record found matching '$search_term'."
    fi
}

# ------------------------------------------------------------
# Function: Update a todo
# ------------------------------------------------------------
update_todo() {
    echo
    echo "===== UPDATE TODO ====="

    read -r -p "Enter ID of todo to update: " id

    if [ -z "$id" ]; then
        echo "Error: ID cannot be empty."
        return 1
    fi

    if ! grep -q "^${id}|" "$DATA_FILE"; then
        echo "Record not found: No todo with ID $id."
        return 1
    fi

    # Backup before destructive change
    if ! cp "$DATA_FILE" "$BACKUP_FILE"; then
        echo "Error: Could not create backup. Update cancelled."
        return 1
    fi

    while true; do
        read -r -p "Enter new task description: " new_task

        if [ -z "$new_task" ]; then
            echo "Error: Task description cannot be empty."
        elif [[ "$new_task" == *"|"* ]]; then
            echo "Error: Task description cannot contain '|'."
        else
            break
        fi
    done

    while true; do
        read -r -p "Enter status (pending/done): " new_status

        if [ "$new_status" != "pending" ] && [ "$new_status" != "done" ]; then
            echo "Error: Status must be 'pending' or 'done'."
        else
            break
        fi
    done

    while true; do
        read -r -p "Enter new due date (optional): " new_due_date

        if [[ "$new_due_date" == *"|"* ]]; then
            echo "Error: Due date cannot contain '|'."
        else
            break
        fi
    done

    temp_file=$(mktemp)

    while IFS='|' read -r old_id old_task old_status old_due_date; do

        if [ "$old_id" = "$id" ]; then
            echo "$id|$new_task|$new_status|$new_due_date" >> "$temp_file"
        else
            echo "$old_id|$old_task|$old_status|$old_due_date" >> "$temp_file"
        fi

    done < "$DATA_FILE"

    mv "$temp_file" "$DATA_FILE"

    echo "Todo ID $id updated successfully."
}

# Function: Delete a todo


delete_todo() {
    echo
    echo "===== DELETE TODO ====="

    read -r -p "Enter ID of todo to delete: " id

    if [ -z "$id" ]; then
        echo "Error: ID cannot be empty."
        return 1
    fi

    if ! grep -q "^${id}|" "$DATA_FILE"; then
        echo "Record not found: No todo with ID $id."
        return 1
    fi

    # Display record before deletion
    echo
    echo "Record to be deleted:"
    grep "^${id}|" "$DATA_FILE"

    echo
    read -r -p "Are you sure you want to delete this record? (y/n): " confirm

    case "$confirm" in
        y|Y)
            # Backup before destructive change
            if ! cp "$DATA_FILE" "$BACKUP_FILE"; then
                echo "Error: Could not create backup. Delete cancelled."
                return 1
            fi

            temp_file=$(mktemp)

            grep -v "^${id}|" "$DATA_FILE" > "$temp_file"

            mv "$temp_file" "$DATA_FILE"

            echo "Todo ID $id deleted successfully."
            ;;

        n|N)
            echo "Delete cancelled."
            ;;

        *)
            echo "Invalid choice. Delete cancelled."
            ;;
    esac
}

# Function: Clean up temporary files

cleanup() {
    if [ -n "$temp_file" ] && [ -f "$temp_file" ]; then
        rm -f "$temp_file"
    fi
}

trap cleanup EXIT

# Main program

initialize_file

while true; do

    echo
    echo "================================="
    echo "       TODO LIST APPLICATION"
    echo "================================="
    echo "1. Add Todo"
    echo "2. View/List Todos"
    echo "3. Search Todo"
    echo "4. Update Todo"
    echo "5. Delete Todo"
    echo "6. Help"
    echo "7. Exit"
    echo "================================="

    read -r -p "Choose an option [1-7]: " choice

    case "$choice" in

        1)
            add_todo
            ;;

        2)
            view_todos
            ;;

        3)
            search_todo
            ;;

        4)
            update_todo
            ;;

        5)
            delete_todo
            ;;

        6)
            show_help
            ;;

        7)
            echo "Exiting Todo List Application..."
            exit 0
            ;;

        *)
            echo "Invalid option. Please choose a number from 1 to 7."
            ;;

    esac

done