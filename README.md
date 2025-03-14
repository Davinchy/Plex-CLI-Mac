# Plex DVR HandBrake Post-Processing Script

## Overview
This script automates the conversion of Plex DVR recordings to the more efficient H.265/HEVC format using Apple VideoToolbox hardware acceleration. It processes recordings after they are completed, replacing the original files with smaller, more efficiently encoded MKV files.

## Features
- Converts recordings to H.265/HEVC using Apple VideoToolbox hardware acceleration
- Outputs files in MKV container format
- Maintains original audio tracks
- Preserves original filename (changes extension to .mkv)
- Creates detailed logs of the conversion process
- Designed for macOS with Apple Silicon processors

## Setup Instructions

1. Ensure HandBrakeCLI is installed on your system. If not, install it via Homebrew:
   ```
   brew install handbrake
   ```

2. Make the script executable (if not already):
   ```
   chmod +x "/Users/YOURUSERNAME/Library/Application Support/Plex Media Server/Scripts/PlexDVR-Handbrake-h265.sh"
   ```

3. In Plex Media Server:
   - Go to Settings > DVR > Post-Processing
   - Add this script's path in the post-processing script field:
     ```
     /Users/YOURUSERNAME/Library/Application Support/Plex Media Server/Scripts/PlexDVR-Handbrake-h265.sh
     ```

## Customization Options

### Video Quality
The current setting (`--quality 40`) produces high-quality video with good compression. Lower values result in higher quality but larger files:
- For higher quality: Use values between 20-35
- For more compression: Use values between 45-60

To modify, change the `--quality` value in the HandBrakeCLI command.

### Frame Rate
The script currently maintains up to 30fps with the `--rate 30` setting. To change:
- For higher frame rate: Change to `--rate 60`
- To maintain original rate: Remove the `--rate` parameter

### Output Format
The script currently outputs MKV files. To change to MP4:
- Change `--format mkv` to `--format mp4`
- Update the file extension in the script from `.mkv` to `.mp4`

### Temporary Files
By default, the script creates temporary files with "_h265" in the filename. To change this naming scheme, modify the `OUTPUT_FILE` variable.

### Audio Settings
The script preserves original audio tracks. To change:
- Modify the `--aencoder` and `--audio-copy-mask` parameters

## Logging
The script logs all operations to:
```
/Users/YOURUSERNAME/Library/Application Support/Plex Media Server/Scripts/handbrake_log.txt
```

You can change the log location by modifying the `LOG_FILE` variable.

## Troubleshooting
- Check the log file for error messages
- Ensure HandBrakeCLI is installed and executable
- Verify the script has appropriate permissions
- Make sure your system has enough storage space

## Performance Notes
- On Apple Silicon Macs, encoding using VideoToolbox is very efficient
- Encoding time depends on video length, quality settings, and your Mac's processing power
- The script removes the original file after successful conversion to save space