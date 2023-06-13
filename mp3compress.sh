#!/bin/bash

# =============================================================================
# Script Name: audio-converter.sh
# Description: This is a bash script to convert audio files to mp3 with a specified 
#              bitrate. It processes files that are in the directory, but not in 
#              further directories therein, overwriting existing audio files with the new version.
# Usage: ./audio-converter.sh [options] <directory>
# Options: -r <bitrate>   Specify the desired bitrate (default: 192k)
#          -h             Display help information
#          -mono          Output files as mono
# Examples: ./audio-converter.sh -r 256 -mono ~/Music
# =============================================================================

# Default bitrate is 192 kbps
bitrate=192k

# Default audio channels is stereo
audio_channels=2

# Parse command line options
while [ $# -gt 0 ]; do
  case "$1" in
    -r)
      bitrate="$2"k
      shift 2
      ;;
    -h)
      echo "Usage: ./audio-converter.sh [options] <directory>"
      echo "Options:"
      echo "-r <bitrate>   Specify the desired bitrate (default: 192k)"
      echo "-h             Display this help information"
      echo "-mono          Output files as mono"
      exit 0
      ;;
    -mono)
      audio_channels=1
      shift
      ;;
    *)
      if [[ -z "$directory" ]]; then
        directory="$1"
      else
        echo "Invalid option: $1" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

# Display a warning message
read -p "WARNING: This will overwrite all audio files in this directory with the mp3 $bitrate version. Continue? y/n " choice

if [ "$choice" != "y" ]; then
  echo "Aborted."
  exit 1
fi

# Check if the directory is provided as an argument
if [ -z "$directory" ]; then
  # If no directory is specified, use the current directory
  directory="."
fi

# Supported audio formats
formats=("mp3" "wav" "flac" "m4a" "wma" "ogg" "aac" "mka")

# Convert audio files
fileFound=false
for format in "${formats[@]}"; do
  up_format=$(echo "$format" | tr '[:lower:]' '[:upper:]')
  lower_format=$(echo "$format" | tr '[:upper:]' '[:lower:]')
  for file in "$directory"/*.{${lower_format},${up_format}}
  do
    if [ -f "$file" ]; then
      ffmpeg -nostdin -i "$file" -vn -codec:a libmp3lame -b:a "$bitrate" -ac "$audio_channels" -y "${file%.*}.tmp.mp3" 
      if [ $? -eq 0 ]; then
        mv "${file%.*}.tmp.mp3" "${file%.*}.mp3"
        echo "Processed: $file"
        fileFound=true
      else
        echo "Failed to process: $file"
      fi
    fi
  done
done

if [ "$fileFound" = false ]; then
  echo "No audio files found."
else
  echo "All audio files have been converted to mp3 with bitrate $bitrate."
fi
