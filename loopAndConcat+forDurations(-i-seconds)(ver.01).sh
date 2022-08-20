#!/bin/bash

# Description:
#+ loops the srcMedia and concatenates the loops 
#+ into a single media of specified targetDuration.
#+ It copies the streams of the srcMedia into the loops.
#+ It is similar to using the command:
#+ `ffmpeg -stream_loop -1 -i "srcMedia" -t targetDuration -c copy "output"`


# INPUTS: (x) srcMedia
#+        (x) targetDuration

#OUTPUT: media

#OUTPUT FORMAT: media-T${targetDuration}.extention

# HOW TO RUN example: bash "thisScript" "vid.mp4" 123

# Assign script's absolute path to a variable
scriptAbsolutePath="$(realpath $0)"

# Assign script's directory path to a variable
scriptDirectoryPath="$(dirname "${scriptAbsolutePath}")"

externalScriptsFolder="scripts"

# Import external shell script
getMediaDuration="${scriptDirectoryPath}/${externalScriptsFolder}/ffprobe-mediaLength_seconds(-i-decimaPlaces).sh"

#xxxxxxxx

scriptFullName="${0##*/}"
scriptName="${scriptFullName%.*}"

tempFolder="tempFolder-${scriptName}"
mkdir "${tempFolder}"

# xxxxxxxx


srcMedia="$1"

srcMediaFullName="${1##*/}"
srcMediaName="${srcMediaFullName%.*}"
extn="${srcMediaFullName##*.}"

srcMediaDuration="$(bash "${getMediaDuration}" "${srcMedia}" 3)"


# set targetDuration in secs
targetDuration="$2"

list="listFor${targetDuration}s.txt"

# Delete previous $list, if it exits
if [[ -f "${list}" ]]; then

    rm -rf "${list}" 

fi


# Calculate the no. of splits required for the targetDuration
numbOfSplitsForTargDuration=`printf "%.10f\n" "$(echo "scale=15;
${targetDuration} / ${srcMediaDuration}" | bc -l)"`

# Take the integer portion of the numbOfSplitsForTargDuration
numbOfSplitsForTargDurationInteger="${numbOfSplitsForTargDuration%.*}"

# Take the fractional portion of the numbOfSplitsForTargDuration
numbOfSplitsForTargDurationFraction=`printf "%.10f\n" "$(echo "scale=10;
${numbOfSplitsForTargDuration} - ${numbOfSplitsForTargDurationInteger}" | bc -l)"`

# Calculate the duration of the split needed to make up ...
# for the fractional porion (i.e. numbOfSplitsForTargDurationFraction)
makeUpMediaDuration=`printf "%.3f\n" "$(echo "scale=6;
${srcMediaDuration} * ${numbOfSplitsForTargDurationFraction}" | bc -l)"`

# Assign the fullpath of the make-up media
makeUpMediaFullPath="${tempFolder}/temp${targetDuration}-T${makeUpMediaDuration}.${extn}"


# Create the make-up media using ffmpeg
ffmpeg -i "$1" -t ${makeUpMediaDuration} -c copy -y "${makeUpMediaFullPath}"


# Create the list of splits (recursively)
currentNumbOfSplits=0
until [ ${currentNumbOfSplits} -eq "${numbOfSplitsForTargDurationInteger}" ]
    do
    
    printf "file '%s'\n" "$1" >> "${list}"; 
    
    currentNumbOfSplits=$((currentNumbOfSplits+1))
    
    done
    
    # Append the make-up split to the list
    printf "file '%s'\n" "$PWD/${makeUpMediaFullPath}" >> "${list}"; 
    
    
outputFullName="${srcMediaName}-T${targetDuration}+encoding++inProgress.${extn}"
    
    # Concatenate video from the list to get the targetDuration
    ffmpeg -f concat -safe 0 -i "${list}" -c copy -y "${outputFullName}"
    
    outputDuration="$(bash "${getMediaDuration}" "${outputFullName}" 0)"
    
newOutputFullName="${srcMediaName}-T${outputDuration}.${extn}"

mv "${outputFullName}" "${newOutputFullName}"


# delete tempFolder
rm -rf "${tempFolder}"

rm -rf "${list}" # delete the loops' list


# test