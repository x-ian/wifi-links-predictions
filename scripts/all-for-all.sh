#!/bin/bash

SITES=$1

while read -r base; do

	FILE=../sites/$base

	rm -rf $base
	mkdir $base
	cd $base
	cp ../splat.lrp .
	
	FILEBASE=`basename $FILE`
	SITE=`echo "${FILEBASE%%.*}"`

	TX_LAT=`cat ../$FILE | tr '\n' ',' | cut -f2 -d','`
	TX_LONG=`cat ../$FILE | tr '\n' ',' | cut -f3 -d','`

	ls -1 ../../sites > ../_tmp_sites.txt

	while read -r line; do
		RX_LAT=`cat ../../sites/$line | tr '\n' ',' | cut -f2 -d','`
		RX_LONG=`cat ../../sites/$line | tr '\n' ',' | cut -f3 -d','`
		DIST=`../../distance.sh $TX_LAT $TX_LONG $RX_LAT $RX_LONG`
		# filtering out all sites further than 60 miles away
		if (( $(echo "$DIST < 60" |bc -l) )); then
			timeout 30s ../../splat.sh ../$FILE ../../sites/$line
		fi
	  #find ../sites -type f -exec timeout 30s ../splat.sh $FILE {} \;
	done < ../_tmp_sites.txt

	cd ..
done < $1