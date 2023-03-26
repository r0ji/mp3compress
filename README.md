# MP3 Converter Script

This is a Bash script that can be used to convert all mp3 files in a directory to a specified bitrate. The script uses ffmpeg's libmp3lame codec to perform the conversion.

## Usage

`./convert.sh [-r bitrate] [directory]`

If no directory is specified, the script will use the current directory as the default. The script will recursively find all mp3 files in the specified directory (or the default directory) and convert them to the specified bitrate (or the default bitrate of 192 kbps).

## Options

- `-r bitrate`: Set the target bitrate in kbps. Default is 192 kbps.
- `-h`: Display help message.

## Example Usage

Convert all mp3 files in the current directory to 256 kbps:

`./convert.sh -r 256`

Convert all mp3 files in the directory `/path/to/my/music` to the default bitrate:

`./convert.sh /path/to/my/music`

Display help message:

`./convert.sh -h`
