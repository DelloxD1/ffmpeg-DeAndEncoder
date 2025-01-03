#!/bin/bash

# Check if ffmpeg and ffprobe are installed
if ! command -v ffmpeg &> /dev/null || ! command -v ffprobe &> /dev/null; then
    echo "Error: ffmpeg and/or ffprobe are not installed. Please install them and try again."
    exit 1
fi

# Check input parameters
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <Reference File> <Target File>"
    exit 1
fi

REFERENCE_FILE="$1"
TARGET_FILE="$2"

# Check if the reference file exists
if [ ! -f "$REFERENCE_FILE" ]; then
    echo "Error: The file $REFERENCE_FILE does not exist."
    exit 1
fi

# Extract parameters from the reference file
VIDEO_CODEC=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$REFERENCE_FILE")
VIDEO_BITRATE=$(ffprobe -v error -select_streams v:0 -show_entries format=bit_rate -of csv=p=0 "$REFERENCE_FILE")
VIDEO_WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$REFERENCE_FILE")
VIDEO_HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$REFERENCE_FILE")
FPS=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 "$REFERENCE_FILE" | bc)
AUDIO_CODEC=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of csv=p=0 "$REFERENCE_FILE")
AUDIO_BITRATE=${AUDIO_BITRATE:-256000}  # Increased default bitrate
AUDIO_SAMPLERATE=${AUDIO_SAMPLERATE:-48000}  # Default: 48 kHz

# Output the extracted parameters
echo "Extracted parameters for $REFERENCE_FILE:"
echo "Video Codec: $VIDEO_CODEC"
echo "Video Bitrate: $((VIDEO_BITRATE / 1000)) kbps"
echo "Resolution: ${VIDEO_WIDTH}x${VIDEO_HEIGHT}"
echo "Framerate: $FPS"
echo "Audio Codec: $AUDIO_CODEC"
echo "Audio Bitrate: $((AUDIO_BITRATE / 1000)) kbps"
echo "Audio Samplerate: $AUDIO_SAMPLERATE"

# Perform encoding with ffmpeg
ffmpeg -i "$TARGET_FILE" -c:v "$VIDEO_CODEC" -b:v "$VIDEO_BITRATE" -vf "scale=${VIDEO_WIDTH}:${VIDEO_HEIGHT},fps=$FPS" -c:a "$AUDIO_CODEC" -b:a "$AUDIO_BITRATE" -ar "$AUDIO_SAMPLERATE" -ac 2 "${TARGET_FILE%.*}_converted.${TARGET_FILE##*.}"

if [ $? -eq 0 ]; then
    echo "The file has been successfully encoded as ${TARGET_FILE%.*}_converted.${TARGET_FILE##*.}."
else
    echo "Error: Encoding failed."
    exit 1
fi
