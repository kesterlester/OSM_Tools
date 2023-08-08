#!/bin/bash
# Run with a single argument, the name of an image file containing EXIF data. Result, URLs that you can use to edit that location in OSM.
#
# e.g.
#
# ./geo_urls.sh TEST_IMAGES/IMG_6773.jpeg 
#
# might result in 
#
# https://www.openstreetmap.org/edit#map=19/+54.673428/-2.724244
# https://www.google.com/maps?ll=+54.673428,-2.724244&hl=en&t=m&z=19
#
# so you might use it like this:
#
# open `./geo_urls.sh TEST_IMAGES/IMG_6773.jpeg`

IMAGE="$1"

read -r GPS_LAT GPS_LON < <(  
  exiftool -c "%.6f" "$IMAGE" `# Get GPS coordinates in decimal` | \
    grep 'GPS Position' | \
    sed 's/.*://g' `# Get rid of the "GPS Position : " text` | \
    tr 'NOWOSOE,' '+ - - + ' `# Turn the letters NSWE to +--+ and remove a comma we don't want.  The Os are to stop +--+ being interpreted as some kind of control sequence.` | \
    awk '{print $2 $1 " " $4 $3}' `# put signs in correct places so as to output LATITUDE followed by LONGITUDE` 
)

#echo Latitude and Longitude from $IMAGE are $GPS_LAT MOO $GPS_LON

GEO_URL_OSM="https://www.openstreetmap.org/edit#map=19/$GPS_LAT/$GPS_LON"
GEO_URL_GOOGLE_MAPS="https://www.google.com/maps?ll=$GPS_LAT,$GPS_LON"'&hl=en&t=m&z=19'

echo $GEO_URL_OSM
echo $GEO_URL_GOOGLE_MAPS


