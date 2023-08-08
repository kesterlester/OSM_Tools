#!/bin/bash
# Run with one of more arguments, each being the name of an image file containing EXIF data.
# Output is list of URLs that you can use to edit/view each location in OSM, etc.
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
# 
# or like this:
#
# ./geo_urls.sh TEST_IMAGES/* | xargs open

for IMAGE in "$@"
do {

# Fill variables GPS_LAT and GPS_LON with data from the image file:
read -r GPS_LAT GPS_LON < <(  
  exiftool -c "%.6f" "$IMAGE" `# Get GPS coordinates in decimal` | \
    grep 'GPS Position' | \
    sed 's/.*://g' `# Get rid of the "GPS Position : " text` | \
    tr 'NOWOSOE,' '+ - - + ' `# Turn the letters NSWE to +--+ and remove a comma we don't want.  The Os are to stop +--+ being interpreted as some kind of control sequence.` | \
    awk '{print $2 $1 " " $4 $3}' `# put signs in correct places so as to output LATITUDE followed by LONGITUDE` 
)
 
#echo Latitude and Longitude from $IMAGE are $GPS_LAT and $GPS_LON respetively.
  
GEO_URL_OSM="https://www.openstreetmap.org/edit#map=19/$GPS_LAT/$GPS_LON"
GEO_URL_GOOGLE_MAPS="https://www.google.com/maps?ll=$GPS_LAT,$GPS_LON"'&hl=en&t=m&z=19'

echo $GEO_URL_OSM
echo $GEO_URL_GOOGLE_MAPS

} done
