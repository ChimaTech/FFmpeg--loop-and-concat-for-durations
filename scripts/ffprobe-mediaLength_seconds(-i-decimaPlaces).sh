#!/bin/bash

# Assign script's absolute path to a variable
scriptAbsolutePath="$(realpath $0)"

# Assign script's directory path to a variable
scriptDirectoryPath="$(dirname "${scriptAbsolutePath}")"

#import script that converts a dos-style-ended string
#to a unix-style-ended strings
winx2unix="${scriptDirectoryPath}/winx2unix(string).sh"

#Assign the target media to a variable
media=$1

# use $2 to Assign decimalPlaces
decimalPlaces=$2

#ffprobe to get the media duration in seconds
medialengthSecs="$(ffprobe -v error \
-show_entries format=duration \
-of default=noprint_wrappers=1:nokey=1 "${media}")"

#convert value to unix-style-ended string
medialengthSecs=$(bash "${winx2unix}" "${medialengthSecs}")

# Set number of decimalPlaces using $2
medialengthSecs=`printf "%.${decimalPlaces}f\n" "$(echo "scale=15;
${medialengthSecs}" | bc -l)"`

#echo the final result
echo "${medialengthSecs}"