#!/bin/bash

#find . -type f -name 'file_*' -exec ../scripts/report3-kml-good-links.sh {} \;

FILE=$1
OUTFILE=$FILE.kml

# echo "$FILE;$TX;$RX;$DISTANCE;$PATH_LOSS_FREE_SPACE;$PATH_LOSS_ITWOM;$RX_SIGNAL_POWER;$FRESNEL_NOTCLEAR;$FRESNEL_CLEAR_HEIGHT;$FRESNEL60_NOTCLEAR;$FRESNEL60_CLEAR_HEIGHT;$LOS_NOTCLEAR;$LOS_CLEAR_HEIGHT;$TX_LAT;$TX_LNG;$RX_LAT;$RX_LNG" >> data.csv

echo '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>' >$OUTFILE
echo "<name>$1</name>" >>$OUTFILE
echo '<Style id="s_ylw-pushpin_hl">
	<IconStyle>
		<scale>1.3</scale>
		<Icon>
			<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
		</Icon>
		<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
	</IconStyle>
	<LineStyle>
		<color>ff1a0ffc</color>
	</LineStyle>
</Style>
<StyleMap id="msn_ylw-pushpin">
	<Pair>
		<key>normal</key>
		<styleUrl>#sn_ylw-pushpin</styleUrl>
	</Pair>
	<Pair>
		<key>highlight</key>
		<styleUrl>#sh_ylw-pushpin</styleUrl>
	</Pair>
</StyleMap>
<StyleMap id="m_ylw-pushpin">
	<Pair>
		<key>normal</key>
		<styleUrl>#s_ylw-pushpin</styleUrl>
	</Pair>
	<Pair>
		<key>highlight</key>
		<styleUrl>#s_ylw-pushpin_hl</styleUrl>
	</Pair>
</StyleMap>
<Style id="sn_ylw-pushpin">
	<IconStyle>
		<scale>1.1</scale>
		<Icon>
			<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
		</Icon>
		<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
	</IconStyle>
	<BalloonStyle>
	</BalloonStyle>
	<LineStyle>
		<color>ff13ff2a</color>
	</LineStyle>
</Style>
<Style id="sh_ylw-pushpin">
	<IconStyle>
		<scale>1.3</scale>
		<Icon>
			<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
		</Icon>
		<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
	</IconStyle>
	<BalloonStyle>
	</BalloonStyle>
	<LineStyle>
		<color>ff13ff2a</color>
	</LineStyle>
</Style>
<Style id="s_ylw-pushpin">
	<IconStyle>
		<scale>1.1</scale>
		<Icon>
			<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
		</Icon>
		<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
	</IconStyle>
	<LineStyle>
		<color>ff1a0ffc</color>
	</LineStyle>
</Style>
<Folder>' >>$OUTFILE
echo "	<name>$1</name>" >>$OUTFILE
echo '	<open>1</open>
' >>$OUTFILE
	
while read line
do
	TX=$(echo $line | cut -f2 -d';')
	TX_LAT=$(echo $line | cut -f14 -d';')
	TX_LNG=$(echo $line | cut -f15 -d';')
	RX=$(echo $line | cut -f3 -d';')
	RX_LAT=$(echo $line | cut -f16 -d';')
	RX_LNG=$(echo $line | cut -f17 -d';')

	PATH_LOSS_FREE_SPACE=$(echo $line | cut -f5 -d';')
	PATH_LOSS_ITWOM=$(echo $line | cut -f6 -d';')
	RX_SIGNAL_POWER=$(echo $line | cut -f7 -d';')

	LOS_NOTCLEAR=$(echo $line | cut -f12 -d';')
	FRESNEL_NOTCLEAR=$(echo $line | cut -f8 -d';')
	FRESNEL60_NOTCLEAR=$(echo $line | cut -f10 -d';')

	if (( $(echo "$RX_SIGNAL_POWER > -100" | bc -l) )); then
		if [[ ($FRESNEL60_NOTCLEAR -eq "0") ]]; then
			# all good , color green
			echo "
	<Placemark>
		<name>$RX fresnel60+: $RX_SIGNAL_POWER</name>
		<styleUrl>#msn_ylw-pushpin</styleUrl>
		<LineString>
			<tessellate>1</tessellate>
			<coordinates>
				$TX_LNG,$TX_LAT,0 $RX_LNG,$RX_LAT,0
			</coordinates>
		</LineString>
	</Placemark>" >>$OUTFILE
		elif [[ $LOS_NOTCLEAR -eq "0" ]]; then
			# only LOS, challenging color yellow
			echo "
	<Placemark>
		<name>$RX only los: $RX_SIGNAL_POWER</name>
		<styleUrl>#m_ylw-pushpin</styleUrl>
		<LineString>
			<tessellate>1</tessellate>
			<coordinates>
				$TX_LNG,$TX_LAT,0 $RX_LNG,$RX_LAT,0
			</coordinates>
		</LineString>
	</Placemark>" >>$OUTFILE
		fi		
	fi
done < $FILE

echo "</Folder>
</Document>
</kml>" >>$OUTFILE


# awk -F ';' '$2 != prev { close(handle); prev = $2; handle = "file_" $2; } { print >handle }' data.csv