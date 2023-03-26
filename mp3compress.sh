#!/bin/bash

# Default bitrate is 192 kbps
bitrate=192k

# Parse command line options
while getopts "r:" opt; do
  case $opt in
    r)
      bitrate="$OPTARG"k
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Display a warning message
read -p "WARNING: This will recursively overwrite all mp3 files in this directory with the $bitrate version. Continue? y/n " choice

if [ "$choice" != "y" ]; then
  echo "Aborted."
  exit 1
fi

# Check if the directory is provided as an argument
if [ -z "$1" ]; then
  # If no directory is specified, use the current directory
  directory="."
else
  # Use the specified directory
  directory="$1"
fi

# Find and convert mp3 files
find "$directory" -type f -iname "*.mp3" -exec sh -c 'ffmpeg -i "$1" -vn -codec:a libmp3lame -b:a '"$bitrate"' -y "${1%.mp3}.tmp.mp3" && mv "${1%.mp3}.tmp.mp3" "$1" && echo "Processed: $1"' _ {} \;

echo "All mp3 files have been converted to $bitrate." 
