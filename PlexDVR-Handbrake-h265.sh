#!/bin/bash

# PlexDVR-Handbrake-h265.sh
# Post-processing script for Plex DVR to convert recordings to h.265 using VideoToolbox
# Usage: This script is called by Plex DVR after a recording completes

# Log file
LOG_FILE="/Users/antoniotorres/Library/Application Support/Plex Media Server/Scripts/handbrake_log.txt"

# Input file is the first argument passed by Plex
INPUT_FILE="$1"
if [ -z "$INPUT_FILE" ]; then
    echo "$(date) - Error: No input file specified" >> "$LOG_FILE"
    exit 1
fi

# Create output filename (with _h265 and .mkv extension)
FILENAME=$(basename "$INPUT_FILE")
FILENAME_NO_EXT="${FILENAME%.*}"
OUTPUT_DIR=$(dirname "$INPUT_FILE")
OUTPUT_FILE="$OUTPUT_DIR/${FILENAME_NO_EXT}_h265.mkv"

# Log the start of conversion
echo "$(date) - Starting conversion of: $INPUT_FILE" >> "$LOG_FILE"
echo "$(date) - Output file: $OUTPUT_FILE" >> "$LOG_FILE"

# Run HandBrakeCLI with h.265 VideoToolbox settings
/usr/local/bin/HandBrakeCLI \
    --input "$INPUT_FILE" \
    --output "$OUTPUT_FILE" \
    --format mkv \
    --encoder vt_h265 \
    --quality 40 \
    --rate 30 \
    --crop 0:0:0:0 \
    --aencoder copy \
    --audio-copy-mask aac,ac3,eac3,truehd,dts,dtshd \
    --audio-fallback ca_aac \
    --verbose=1 2>> "$LOG_FILE"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "$(date) - Conversion completed successfully" >> "$LOG_FILE"
    
    # Replace original file with the new h.265 encoded file
    # First determine the new output path with original filename but .mkv extension
    ORIG_DIR=$(dirname "$INPUT_FILE")
    ORIG_FILENAME=$(basename "$INPUT_FILE")
    ORIG_FILENAME_NO_EXT="${ORIG_FILENAME%.*}"
    NEW_FILENAME="${ORIG_DIR}/${ORIG_FILENAME_NO_EXT}.mkv"
    
    # Move the converted file to replace the original (with .mkv extension)
    mv "$OUTPUT_FILE" "$NEW_FILENAME"
    
    # Remove the original file
    rm "$INPUT_FILE"
    
    echo "$(date) - Replaced original file with h.265 version (.mkv)" >> "$LOG_FILE"
    echo "$(date) - New filename: $NEW_FILENAME" >> "$LOG_FILE"
    exit 0
else
    echo "$(date) - Error: Conversion failed" >> "$LOG_FILE"
    exit 1
fi