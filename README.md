# Batch Media Renamer

A Bash script to **rename TV show episode files** into a consistent `SXXEXX` format. Supports multiple common filename formats, recursive processing, dry-run mode, logging, and undo functionality.

---

## Features

- Detects and renames episodes using formats such as:
  - `S01E02`
  - `Season 1 Episode 2`
  - `1x02` or `01X02`
  - `1.02` or `01.02`
  - `S1E2` or `S01E2`
  - `E02S01` (episode-season reversed)
  - 3-digit codes like `105` (season 1 episode 05)
- Recursively processes directories
- Supports multiple input directories
- Dry-run mode to preview changes without renaming (`-dr` flag)
- Logs all renames to a timestamped `.log` file
- Skips subtitle and image files (`.srt`, `.jpg`, `.png`, etc.)
- Ignores files with extension `.!qB`
- Undo script to revert changes using the log files

---

## Installation (optional)

1. Copy the `renamer` and `renamer-undo` scripts to a directory in your `$PATH`, e.g., `/usr/local/bin/`  
```bash
sudo cp renamer /usr/local/bin/
sudo cp renamer-undo /usr/local/bin/
sudo chmod +x /usr/local/bin/renamer /usr/local/bin/renamer-undo
```  
2. Make sure you have Bash 4.0 or newer (bash --version).

# Usage
`renamer [options] [dir1 dir2 ...]`  

If no directories are specified, the current directory is processed recursively.  
Use -dr to perform a dry-run (no files are renamed, but it logs what would be renamed).

# Examples

Rename files recursively in current directory:  
`renamer`  

Dry-run in multiple directories:  
`renamer -dr /path/to/dir1 /path/to/dir2`  

Rename files recursively in /media/shows:  
`renamer /media/shows`

# Undoing Changes
Using Batch Media Renamer generates a log file with the unix timestamp of execution.  
You can undo changes with `renamer-undo` (can be called directly if renamer-undo is in `/usr/local/bin`): `renamer-undo [logfile]`  
If no log file is provided, the most recent .log file in the current directory is used.

# Important Notes
The script uses Bash regex features, so Bash 4.0+ is required.  
Always test with -dr before running to avoid accidental renaming.

# Contributing
Feel free to open issues or submit pull requests to improve functionality or add new features!
