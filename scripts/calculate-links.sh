#!/bin/bash

# ../scripts/calculate-links.sh ./input ../t/ ../splat-bht-scaleup.lrp

# text file with list of sites to be processed as TX
TX_SITES_FILE=$1
SITES_DIR=$(realpath $2)
OUTPUT_DIR=$(realpath .)
SPLAT_CONFIG_FILE=$(realpath $3)

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ls -1 $SITES_DIR > _tmp_sites.txt
RX_SITES_LIST=$(realpath _tmp_sites.txt)

while IFS= read -r tx_site || [ "$tx_site" ]; do

	TX_OUTPUT_DIR=$OUTPUT_DIR/$tx_site

	rm -rf $TX_OUTPUT_DIR
	mkdir $TX_OUTPUT_DIR
	cp $SPLAT_CONFIG_FILE $TX_OUTPUT_DIR/splat.lrp
	
	pushd .
	cd $TX_OUTPUT_DIR
	FILEBASE=$(realpath $(basename $tx_site))
	TX_SITE_NAME=`echo "${FILEBASE%%.*}"`

	TX_LAT=`cat $SITES_DIR/$tx_site | tr '\n' ',' | cut -f2 -d','`
	TX_EST=`cat $SITES_DIR/$tx_site | tr '\n' ',' | cut -f3 -d','`	

	while IFS= read -r line || [ "$line" ]; do
		RX_LAT=`cat $SITES_DIR/$line | tr '\n' ',' | cut -f2 -d','`
		RX_EST=`cat $SITES_DIR/$line | tr '\n' ',' | cut -f3 -d','`
		DIST=`$BASEDIR/distance.sh $TX_LAT $TX_EST $RX_LAT $RX_EST`
		# filtering out all sites further than 60 miles away
		if (( $(echo "$DIST < 60 && $DIST >0" | bc -l) )); then
			timeout 30s $BASEDIR/splat.sh $SITES_DIR/$tx_site $SITES_DIR/$line
			
			# get the other direction
			pushd .
			cd ..
			mkdir $line
			cd $line
			cp $SPLAT_CONFIG_FILE ./splat.lrp
			timeout 30s $BASEDIR/splat.sh $SITES_DIR/$line $SITES_DIR/$tx_site 
			popd
			
		fi
	done < $RX_SITES_LIST

	popd
	
done < $TX_SITES_FILE

#rm $RX_SITES_LIST
