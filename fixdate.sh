#/bin/bash

#
# Check dependencies
#
if ! command -v exiv2 &> /dev/null
then
    echo "exiv2 could not be found, please install it"
    exit 1
fi

#
# Check for command line arguments
#
if [ "$1" == "" ] || [ $# -gt 1 ]; then
    echo "Missing reference image, usage :"
    echo "$0 reference_image"
    exit 2
fi

#
# Check that the reference image exists
#
if [ ! -f "$1" ]; then
    echo "Can not find $1"
    exit 3
fi

#
# Check the reference image has EXIF data
#
res=`exiv2 -ps "$1" 2>&1`
if [[ "$res" == *"No Exif data found in the file"* ]]; then
    echo "Can not find EXIF data in $1"
    exit 4
fi

for filename in *; do
    res=`exiv2 -ps "$filename" 2>&1`
    if [[ "$res" == *"No Exif data found in the file"* ]]; then
        cmd=$(printf '%s%q%s%q' "exiv2 -ea- " "$1" " | exiv2 -ia- " "$filename")
        echo $cmd
        eval $cmd
    fi
done