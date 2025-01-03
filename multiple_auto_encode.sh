#!/bin/bash

# Check if ffmpeg_auto_encoder.sh exists and is executable
SCRIPT_PATH="./ffmpeg_auto_encoder.sh"
if [ ! -f "$SCRIPT_PATH" ] || [ ! -x "$SCRIPT_PATH" ]; then
    echo "Error: The script ffmpeg_auto_encoder.sh was not found or is not executable."
    exit 1
fi

# Check input parameters
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <Reference File> <Folder with Files to Convert>"
    exit 1
fi

REFERENCE_FILE="$1"
INPUT_FOLDER="$2"

# Check if the reference file exists
if [ ! -f "$REFERENCE_FILE" ]; then
    echo "Error: The reference file $REFERENCE_FILE does not exist."
    exit 1
fi

# Check if the input folder exists
if [ ! -d "$INPUT_FOLDER" ]; then
    echo "Error: The folder $INPUT_FOLDER does not exist."
    exit 1
fi

# Create an output directory
OUTPUT_FOLDER="${INPUT_FOLDER%/}_converted"
mkdir -p "$OUTPUT_FOLDER"
echo "The encoded files will be saved in $OUTPUT_FOLDER."

# Process all files in the folder
for FILE in "$INPUT_FOLDER"/*; do
    if [ -f "$FILE" ]; then
        BASENAME=$(basename "$FILE")
        OUTPUT_FILE="$OUTPUT_FOLDER/$BASENAME"
        echo "Converting: $FILE -> $OUTPUT_FILE"

        # Call ffmpeg_auto_encoder.sh
        "$SCRIPT_PATH" "$REFERENCE_FILE" "$FILE"
        if [ $? -eq 0 ]; then
            echo "Successfully converted: $FILE"
        else
            echo "Error converting: $FILE"
        fi
    fi
done

echo "Batch conversion completed."
