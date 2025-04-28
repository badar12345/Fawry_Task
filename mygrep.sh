#!/bin/bash

# mygrep.sh - A simple grep-like script

# Function to show usage
usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n   Show line numbers"
    echo "  -v   Invert match (show non-matching lines)"
    echo "  --help  Show this help message"
    exit 1
}

# Check if no arguments or --help is passed
if [[ $# -lt 1 || $1 == "--help" ]]; then
    usage
fi

# Initialize options
show_line_numbers=false
invert_match=false

# Parse options
while [[ "$1" =~ ^- ]]; do
    case "$1" in
        *n*) show_line_numbers=true ;;
        *v*) invert_match=true ;;
        --help) usage ;;
        *) echo "Invalid option: $1"; usage ;;
    esac
    shift
done

# Now $1 should be search string and $2 should be filename
search_string="$1"
file="$2"

# Validate input
if [[ -z "$search_string" || -z "$file" ]]; then
    echo "Error: Missing search string or filename."
    usage
fi

if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Build the grep command
grep_command="grep -i"

if $invert_match; then
    grep_command="$grep_command -v"
fi

if $show_line_numbers; then
    grep_command="$grep_command -n"
fi

# Execute the grep command
$grep_command -- "$search_string" "$file"
