#!/bin/bash

SPLAT_EXEC=/Users/xian/projects/baobab-scaleup-backbone/automated_analysis/splat-1.4.2/splat-hd
SDF_PATH=/Users/xian/projects/baobab-scaleup-backbone/automated_analysis/elevation-radiomobile-sdf-hd/

TX_SITE=$1 #./sites/mbabzi_hc2.qth
RX_SITE=$2 #./sites/dzenza_hc-dms.qth

TX_BASE=`basename $TX_SITE`
RX_BASE=`basename $RX_SITE`
PROFILE_FILE=`echo "${TX_BASE%%.*}-to-${RX_BASE%%.*}"`

$SPLAT_EXEC -t $TX_SITE -r $RX_SITE -metric -d $SDF_PATH -H $PROFILE_FILE-profile.png  
