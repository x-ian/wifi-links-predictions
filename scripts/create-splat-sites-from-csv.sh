#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Wrong parameters."
	echo "Usage create-splat-sites-from-csv.sh <csv site locations file> <outdir dir>"
	echo ""
	exit 0
fi

ALL_SITES_CSV=$1
OUTPUT_DIR=$2

while IFS= read -r line ||  [ "$line" ]; do
    site=`echo $line | cut -f1 -d','`
	lat=`echo $line | cut -f2 -d','`
	lng=`echo $line | cut -f3 -d','`
	# SPLAT wants eastings (at least for malawi region)
	est=$(echo "(360-$lng)" | bc)
	height=`echo $line | cut -f4 -d','`
	
	file=$OUTPUT_DIR/$site.qth
	echo $site > $file
	echo $lat >> $file
	echo $est >> $file
	echo "`echo $height`m" >> $file
	
done < $ALL_SITES_CSV