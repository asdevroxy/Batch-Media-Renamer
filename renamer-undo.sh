#!/bin/bash

# Help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: renamer-undo [logfile]"
  echo "If no logfile is provided, the most recent *.log in the current directory is used."
  exit 0
fi

# Find log file
if [ -n "$1" ]; then
  log_file="$1"
else
  log_file=$(ls -t *.log 2>/dev/null | head -n 1)
fi

# Check if log exists
if [ ! -f "$log_file" ]; then
  echo "No log file found: '$log_file'"
  exit 1
fi

echo "Using log file: $log_file"

# Process log lines
while IFS= read -r line; do
  old="${line%% -> *}"
  new="${line##* -> }"

  if [ -e "$new" ]; then
    echo "Undo: '$new' -> '$old'"
    mv -- "$new" "$old"
  else
    echo "Skipped (missing): '$new'"
  fi
done < "$log_file"
