#!/bin/bash

# awk -F ';' '$2 != prev { close(handle); prev = $2; handle = "file_" $2; } { print >handle }' data.csv

#find . -type f -name 'file_*' -exec ../scripts/report3-kml-good-links.sh {} kml \;

OUTFILE=$1
WHERE=$2

# all tower links
# where (tx like 'T-%' or tx like 'Tn-%') and (rx like 'T-%' or rx like 'Tn-%') and cast(RX_SIGNAL_POWER as signed) > -100 and (fresnel_notclear<>'1' or fresnel60_notclear<>'1') 

# just mbangombe
# where (tx = 'T-Mbangombe') and cast(RX_SIGNAL_POWER as signed) > -100 and (fresnel_notclear<>'1' or fresnel60_notclear<>'1' or los_notclear<>'1') 

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
	
	
	
mysql -u root -ppassword bht-scaleup -b --raw --skip-column-names   >> $OUTFILE <<EOF
-- (select rx, rx_lat, rx_lng from data $2)
-- union
-- (select distinct(tx), max(tx_lat), max(tx_lng) from data $2 )

select 
concat('
	<Placemark>
		<name>', d.rx, '</name>
		<Point>
		<extrude>1</extrude>
			<coordinates>
				',d.rx_lng, ',', d.rx_lat, ',0
			</coordinates>
		</Point>
	</Placemark>')
				
from 
((select distinct(rx), max(rx_lat) as rx_lat, max(rx_lng) as rx_lng from data $2 group by rx)
 ) as d;
EOF
	
mysql -u root -ppassword bht-scaleup -b --raw --skip-column-names   >> $OUTFILE <<EOF
select 
concat('
	<Placemark>
		<name>', tx, ' to ', rx, ': ', rx_signal_power, IF(fresnel_notclear<>'1' or fresnel60_notclear<>'1', ' (fresnel60 clear)', ' (only LOS'),'</name>
		<styleUrl>', IF(fresnel_notclear<>'1' or fresnel60_notclear<>'1', '#msn_ylw-pushpin', '#m_ylw-pushpin'),'</styleUrl>
		<LineString>
			<tessellate>1</tessellate>
			<coordinates>
				',tx_lng, ',', tx_lat, ',0 ', rx_lng, ',', rx_lat, ',0
			</coordinates>
		</LineString>
	</Placemark>')
				
from data 
 $2
order by tx, cast(RX_SIGNAL_POWER as signed) DESC
;
EOF

echo "</Folder>
</Document>
</kml>" >>$OUTFILE
