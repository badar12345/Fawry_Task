#!/bin/bash

# Function to show usage information
usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match (show non-matching lines)"
    echo "  --help Show this help message"
    exit 1
}

# Check if no arguments or --help is passed
if [ "$#" -lt 1 ]; then
    usage
fi

if [ "$1" == "--help" ]; then
    usage
fi

# Initialize option flags
show_line_numbers=false
invert_match=false

# Parse options using getopts
while getopts ":nv" opt; do
    case $opt in
        n) show_line_numbers=true ;;
        v) invert_match=true ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
    esac
done

# Shift parsed options
shift $((OPTIND-1))

# Check for remaining arguments: search_string and filename
if [ $# -lt 2 ]; then
    echo "Error: Missing search string or filename."
    usage
fi

search_string="$1"
filename="$2"

# Check if file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found."
    exit 1
fi

# Read file line by line
line_number=0
while IFS= read -r line; do
    line_number=$((line_number+1))
    
    # Perform case-insensitive matching
    if echo "$line" | grep -iq -- "$search_string"; then
        match=true
    else
        match=false
    fi

    # Decide whether to print the line based on invert_match
    if { [ "$match" = true ] && [ "$invert_match" = false ]; } || \
       { [ "$match" = false ] && [ "$invert_match" = true ]; }; then
       
        if [ "$show_line_numbers" = true ]; then
            printf "%d:%s\n" "$line_number" "$line"
        else
            printf "%s\n" "$line"
        fi
    fi

done < "$filename"
