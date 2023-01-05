#/bin/bash

for filename in *; do
    res=`exiv2 -ps "$filename" 2>&1`
    if [[ "$res" == *"No Exif data found in the file"* ]]; then
        cmd=$(printf '%s%q%s%q' "exiv2 -ea- " "$1" " | exiv2 -ia- " "$filename")
        echo $cmd
        eval $cmd
    fi
done