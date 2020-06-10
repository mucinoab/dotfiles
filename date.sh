#!/usr/bin/env bash

WHITE=ffffff
LIME=00ff00
GRAY=666666
YELLOW=ffff00
MAROON=cc3300

# Set delimiter to just newlines, instead of any white space
IFS=$'\n'

# text <string> <colour_name>
function text { output+=$(echo -n '{"full_text": "'${1//\"/\\\"}'", "color": "#'${2-$WHITE}'", "separator": false, "separator_block_width": 1}, ') ;}

echo -e '{ "version": 1 }\n['
while :; do
    DATE=$(date +%d/%m/%Y)
    TIME=$(date +%H:%M:%S)

    output=''
    
    text "$TIME   "
    text "$DATE " $GRAY
    echo -e "[${output%??}],"
    sleep 0.1
done
