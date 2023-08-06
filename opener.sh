#!/bin/sh
# Run with a single argument, the name of an image file containing EXIF data. Result, URLs that you can use to edit that location in OSM.
#
# e.g.
#
# ./opener.sh TEST_IMAGES/IMG_6773.jpeg 
#
# might result in 
#
# https://www.openstreetmap.org/edit#map=19/+54.673428/-2.724244
# "https://www.google.com/maps?ll=+54.673428,-2.724244&hl=en&t=m&z=19"
#
# so you might use it like this:
#
# ./opener.sh TEST_IMAGES/IMG_6773.jpeg | xargs open
#


exiftool -c "%.6f" "$1" `# Get GPS coordinates in decimal` | \
	grep 'GPS Position' | \
	awk '{print "https://www.openstreetmap.org/edit#map=19/" $5 $4 "/" $7 $6}' `# print what OSM wants except there is a stupid comma and NSEW instead of signs` | \
	sed 's/,//g' `# Get rid of a comma` | \
	tr 'NOWOSOE' '+ - - +' `# Turn the letters NSWE to +--+ The Os are to stop +--+ being interpreted as some kind of control character.`

# https://www.google.com/maps?11=51.096667,0.535556&9=51.096667,0.5355568h1=en&t=m&z=19

exiftool -c "%.6f" "$1" `# Get GPS coordinates in decimal` | \
	grep 'GPS Position' | \
	awk '{print "\"https://www.google.com/maps?ll=" $5 $4 "COMMA" $7 $6 "&hl=en&t=m&z=19\""}' `# print wh at GOOGLE wants except there is a stupid comma and NSEW instead of signs` | \
	sed 's/,//g' `# Get rid of a comma we don't need` | \
	sed 's/COMMA/,/g' `# Put in the comma we need` | \
	tr 'NOWOSOE' '+ - - +' `# Turn the letters NSWE to +--+ The Os are to stop +--+ being interpreted as some kind of control character.`
