#!/bin/bash

dry_run=false
dirs=()

# Parse arguments
for arg in "$@"; do
  if [ "$arg" = "-dr" ]; then
    dry_run=true
  else
    dirs+=("$arg")
  fi
done

# Default to current directory if none specified
if [ ${#dirs[@]} -eq 0 ]; then
  dirs+=("$(pwd)")
fi

log_file="$(date +%s).log"

pad() {
  printf "%02d" "$1"
}

process_directory() {
  local base_dir="$1"

  if [ ! -d "$base_dir" ]; then
    echo "Skipping invalid directory: $base_dir"
    return
  fi

  echo "Recursively processing: $base_dir"

  find "$base_dir" -type f ! -name "*.!qB" | while IFS= read -r filepath; do
    filename=$(basename "$filepath")
    dirpath=$(dirname "$filepath")
    extension="${filename##*.}"
    new_name=""

    # Match S01E02
    if [[ $filename =~ (S[0-9]{2}E[0-9]{2}) ]]; then
      new_name="${BASH_REMATCH[1]}.$extension"

    # Match Season 1 Episode 2 (with spaces, dots, underscores or dashes)
    elif [[ $filename =~ [Ss]eason[[:space:]_.-]*([0-9]{1,2})[[:space:]_.-]*[Ee]pisode[[:space:]_.-]*([0-9]{1,2}) ]]; then
      s=$(pad "${BASH_REMATCH[1]}")
      e=$(pad "${BASH_REMATCH[2]}")
      new_name="S${s}E${e}.$extension"

    # Match 1x02 or 01X02
    elif [[ $filename =~ ([0-9]{1,2})[xX]([0-9]{1,2}) ]]; then
      s=$(pad "${BASH_REMATCH[1]}")
      e=$(pad "${BASH_REMATCH[2]}")
      new_name="S${s}E${e}.$extension"

    # Match 1.02 or 01.02
    elif [[ $filename =~ \b([0-9]{1,2})\.([0-9]{1,2})\b ]]; then
      s=$(pad "${BASH_REMATCH[1]}")
      e=$(pad "${BASH_REMATCH[2]}")
      new_name="S${s}E${e}.$extension"

    # Match S1E2 or S01E2
    elif [[ $filename =~ [Ss]([0-9]{1,2})[Ee]([0-9]{1,2}) ]]; then
      s=$(pad "${BASH_REMATCH[1]}")
      e=$(pad "${BASH_REMATCH[2]}")
      new_name="S${s}E${e}.$extension"

    # Match E02S01 (reverse order)
    elif [[ $filename =~ [Ee]([0-9]{1,2})[Ss]([0-9]{1,2}) ]]; then
      e=$(pad "${BASH_REMATCH[1]}")
      s=$(pad "${BASH_REMATCH[2]}")
      new_name="S${s}E${e}.$extension"

    # Match 3-digit episode code like 105 (season 1 episode 05)
    elif [[ $filename =~ \b([0-9]{3})\b ]]; then
      full="${BASH_REMATCH[1]}"
      s=$(pad "${full:0:1}")
      e=$(pad "${full:1:2}")
      new_name="S${s}E${e}.$extension"
    fi

    if [ -n "$new_name" ] && [ "$filename" != "$new_name" ]; then
      old_path="$filepath"
      new_path="$dirpath/$new_name"

      if $dry_run; then
        echo "[DRY RUN] Would rename: '$old_path' -> '$new_path'"
      else
        echo "Renaming: '$old_path' -> '$new_path'"
        mv -- "$old_path" "$new_path"
        echo "$old_path -> $new_path" >> "$log_file"
      fi
    fi
  done

  echo "Done with $base_dir"
  echo
}

for dir in "${dirs[@]}"; do
  process_directory "$dir"
done

if ! $dry_run; then
  echo "Rename log saved to: $log_file"
fi
