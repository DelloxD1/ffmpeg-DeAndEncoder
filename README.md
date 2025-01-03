# ffmpeg-DeAndEncoder

This repository contains two bash scripts for video encoding automation using `ffmpeg` and `ffprobe`. The scripts allow users to encode videos to match the specifications of a reference video or batch process multiple files in a folder.

---

## Scripts

### 1. `ffmpeg_auto_encoder.sh`

This script encodes a target video file to match the codec, bitrate, resolution, and other parameters of a reference video.

#### **Usage**
```bash
./ffmpeg_auto_encoder.sh <Reference_File> <Target_File>
```

#### Prerequisites
- Ensure ffmpeg and ffprobe are installed on your system.
- Both files should be valid video files.
#### Functionality
- Extracts video and audio parameters from the reference file using ffprobe.
- Encodes the target file to match the extracted parameters.
- The output file is saved with a _converted suffix in the same folder as the target file.

### 2. `multiple_auto_encode.sh`
This script batch processes all video files in a specified folder to match the specifications of a reference video.

#### **Usage**
```bash
./multiple_auto_encode.sh <Reference_File> <Folder_Path>
```

#### Prerequisites
- Ensure the ffmpeg_auto_encoder.sh script is in the same directory and is executable.
- ffmpeg and ffprobe must be installed.
- Specify a valid reference file and a folder containing the files to be processed.
#### Functionality
- Iterates through all video files in the provided folder.
- Encodes each file using the ffmpeg_auto_encoder.sh script.
- Outputs the encoded files to a new folder named <Folder_Path>_converted.

## Notes
- The scripts check for the presence of required dependencies (ffmpeg and ffprobe) and handle missing dependencies gracefully.
- If a script fails to process a file, an error message will be displayed.
- Output files preserve the original format and are saved with a _converted suffix.

## Example Workflow
### Single File Encoding
```bash
./ffmpeg_auto_encoder.sh reference.mp4 target.mp4
```
### Multiple File Encoding
```bash
./multiple_auto_encode.sh reference.mp4 ./videos_to_process
```

## Troubleshooting
- Ensure the scripts have execution permissions:
```bash
chmod +x ffmpeg_auto_encoder.sh
chmod +x multiple_auto_encode.sh
```
- Verify that ffmpeg and ffprobe are installed and accessible in the system's PATH.

## License
This project is open-source and distributed under the MIT License.