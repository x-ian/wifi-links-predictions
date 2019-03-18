#!/bin/bash

# find . -type d -name '*.qth' -exec ../report2-mysql-summary.sh {} \;

FILE=$1
FILEBASE=`basename $FILE`
SITE=`echo "${FILEBASE%%.*}"`

summary-for-one() {
	
mysql -u root -ppassword bht-scaleup -b --skip-column-names <<EOF
set @site:="$1";
select
@site,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '') FROM data 
where TX=@site and RX like 'T%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as "T1-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '') FROM data
where TX=@site and RX like 'T%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 1,1) as "T2-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '') FROM data
where TX=@site and RX like 'T%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 2,1) AS "T3-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '') FROM data
where TX=@site and RX like 'T%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 3,1) AS "T4-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '') FROM data
where TX=@site and RX like 'T%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 4,1) AS "T5-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,

(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '')  FROM data
where TX=@site and RX like 'F%' AND RX <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) AS "F1-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '')  FROM data
where TX=@site and RX like 'F%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 1,1) AS "F2-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '')  FROM data
where TX=@site and RX like 'F%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 2,1) AS "F3-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '')  FROM data
where TX=@site and RX like 'F%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 3,1) AS "F4-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT"
,
(SELECT CONCAT(RX, ';', DISTANCE, ';', RX_SIGNAL_POWER  , ';', LOS_CLEAR_HEIGHT, ';', FRESNEL60_CLEAR_HEIGHT, ';', FRESNEL_CLEAR_HEIGHT, '')  FROM data
where TX=@site and RX like 'F%' and rx <> @site and los_notclear <> '1' and cast(RX_SIGNAL_POWER as signed) > -105 order by  cast(RX_SIGNAL_POWER as signed) DESC limit 4,1) AS "F5-RX;DISTANCE;RX_SIGNAL_POWER;LOS_CLEAR_HEIGHT;FRESNEL60_CLEAR_HEIGHT;FRESNEL_CLEAR_HEIGHT";

EOF
}

summary-for-one $SITE

#summary-for-one "F-Chikowa_HC"
#summary-for-one "F-Area_18_HC"
