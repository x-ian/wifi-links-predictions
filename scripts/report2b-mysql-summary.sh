#!/bin/bash

#find . -type d -name '*.qth' -exec ../scripts/report2b-mysql-summary.sh {} \;

FILE=$1
FILEBASE=`basename $FILE`
SITE=`echo "${FILEBASE%%.*}"`

MYSQL_INSTANCE=bht-scaleup
MYSQL_TABLE=data
#MYSQL_INSTANCE=evr
#MYSQL_TABLE=wifi_links_data

summary-for-one() {
mysql -u root -ppassword $MYSQL_INSTANCE -b --skip-column-names 2>/dev/null <<EOF
set @site:="$1";
select
@site,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM $MYSQL_TABLE where TX=@site and (RX like 'T-%' or RX like 'Tn-%') and rx<> @site and (fresnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as T1_FRESNEL_OK,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM $MYSQL_TABLE where TX=@site and (RX like 'T-%' or RX like 'Tn-%') and rx<> @site and (fresnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 1,1) as T2_FRESNEL_OK,
-- IF(T1_FRESNEL_OK IS NULL, CONCAT(RX, ' (', RX_SIGNAL_POWER, ')')
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ', ', FRESNEL60_CLEAR_HEIGHT, 'm)')  FROM $MYSQL_TABLE where TX=@site and (RX like 'T-%' or RX like 'Tn-%') and rx<> @site and (los_notclear<>'1' and fresnel_notclear='1' and fresnel60_notclear='1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as T3_ONLY_LOS,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM $MYSQL_TABLE where TX=@site and (RX like 'F-%' or RX like 'Fn-%') and rx<> @site and (fresnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as F1_FRESNEL_OK,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM $MYSQL_TABLE where TX=@site and (RX like 'F-%' or RX like 'Fn-%') and rx<> @site and (fresnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 1,1) as F2_FRESNEL_OK,
(SELECT CONCAT(RX, ' (', RX_SIGNAL_POWER, ')') FROM $MYSQL_TABLE where TX=@site and (RX like 'F-%' or RX like 'Fn-%') and rx<> @site and (fresnel_notclear<>'1' or fresnel60_notclear<>'1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 2,1) as F3_FRESNEL_OK,
(SELECT IF(F1_FRESNEL_OK IS NULL, CONCAT(RX, ' (', RX_SIGNAL_POWER, ', ', FRESNEL60_CLEAR_HEIGHT, 'm)'), '') FROM $MYSQL_TABLE where TX=@site and (RX like 'F-%' or RX like 'Fn-%') and rx<> @site and (los_notclear<>'1' and fresnel_notclear='1' and fresnel60_notclear='1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 0,1) as F4_ONLY_LOS,
(SELECT IF(F1_FRESNEL_OK IS NULL, CONCAT(RX, ' (', RX_SIGNAL_POWER, ', ', FRESNEL60_CLEAR_HEIGHT, 'm)'), '') FROM $MYSQL_TABLE where TX=@site and (RX like 'F-%' or RX like 'Fn-%') and rx<> @site and (los_notclear<>'1' and fresnel_notclear='1' and fresnel60_notclear='1') order by cast(RX_SIGNAL_POWER as signed) DESC limit 1,1) as F4_ONLY_LOS;

EOF
}

summary-for-one $SITE

#summary-for-one "F-Chikowa_HC"
#summary-for-one "F-Area_18_HC"
