#!/bin/bash

# ../scripts/report4-kml-sites-mysql.sh all-sites.kml
# ../scripts/report4-kml-sites-mysql.sh f-sites.kml " where tx like 'F-%'"
# ../scripts/report4-kml-sites-mysql.sh fn-sites.kml " where tx like 'Fn-%'"
# ../scripts/report4-kml-sites-mysql.sh tn-sites.kml " where tx like 'Tn-%'"
# ../scripts/report4-kml-sites-mysql.sh t-sites.kml " where tx like 'T-%'"

OUTFILE=$1
WHERE=$2

echo '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>' >$OUTFILE
echo "<name>$1</name>" >>$OUTFILE
echo '<Folder>' >>$OUTFILE
echo "	<name>$1</name>" >>$OUTFILE
echo '	<open>1</open>
' >>$OUTFILE

mysql -u root -ppassword bht-scaleup -b --raw --skip-column-names   >> $OUTFILE <<EOF
select
concat('
	<Placemark>
		<name>', d.tx, '</name>
		<Point>
		<extrude>1</extrude>
			<coordinates>
				',d.tx_lng, ',', d.tx_lat, ',0
			</coordinates>
		</Point>
	</Placemark>')
from 
(select distinct(tx), max(tx_lat) as tx_lat, max(tx_lng) as tx_lng 
from data
 $2
group by tx order by tx) as d
EOF

echo "</Folder>
</Document>
</kml>" >>$OUTFILE
