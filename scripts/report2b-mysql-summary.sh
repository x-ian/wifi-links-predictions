#!/bin/bash

#find . -type d -name '*.qth' -exec ../report2b-mysql-summary.sh {} \;

FILE=$1
FILEBASE=`basename $FILE`
SITE=`echo "${FILEBASE%%.*}"`

summary-for-one() {
	
mysql -u root -ppassword bht-scaleup -b --skip-column-names 2>/dev/null <<EOF
set @site:="$1";
select
@site,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM data where TX=@site and RX like 'T%' and rx<> @site and (resnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as T1_FRESNEL_OK,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM data where TX=@site and RX like 'T%' and rx<> @site and (resnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 1,1) as T2_FRESNEL_OK,
(SELECT IF(T1_FRESNEL_OK IS NULL, CONCAT(RX, ' (', RX_SIGNAL_POWER, ')'), '') FROM data where TX=@site and RX like 'T%' and rx<> @site and (los_notclear<>'1' and resnel_notclear='1' and fresnel60_notclear='1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as T3_ONLY_LOS,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM data where TX=@site and RX like 'F%' and rx<> @site and (resnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as F1_FRESNEL_OK,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM data where TX=@site and RX like 'F%' and rx<> @site and (resnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 1,1) as F2_FRESNEL_OK,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM data where TX=@site and RX like 'F%' and rx<> @site and (resnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 2,1) as F3_FRESNEL_OK,
(SELECT IF(F1_FRESNEL_OK IS NULL, CONCAT(RX, ' (', RX_SIGNAL_POWER, ')'), '') FROM data where TX=@site and RX like 'F%' and rx<> @site and (los_notclear<>'1' and resnel_notclear='1' and fresnel60_notclear='1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as F4_ONLY_LOS,
(SELECT IF(F1_FRESNEL_OK IS NULL, CONCAT(RX, ' (', RX_SIGNAL_POWER, ')'), '') FROM data where TX=@site and RX like 'F%' and rx<> @site and (los_notclear<>'1' and resnel_notclear='1' and fresnel60_notclear='1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 1,1) as F4_ONLY_LOS;

EOF
}

summary-for-one $SITE

#summary-for-one "F-Chikowa_HC"
#summary-for-one "F-Area_18_HC"
