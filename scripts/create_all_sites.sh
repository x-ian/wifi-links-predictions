#!/bin/bash

while read -r line; do
    site=`echo $line | cut -f1 -d','`
	lat=`echo $line | cut -f2 -d','`
	lng=`echo $line | cut -f3 -d','`
	height=`echo $line | cut -f4 -d','`
	
	file=$site.qth
	echo $site > $file
	echo $lat >> $file
	echo $lng >> $file
	echo "`echo $height`m" >> $file
	
done < "all_sites.tsv"