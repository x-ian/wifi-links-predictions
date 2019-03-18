#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PATH=$PATH:$BASEDIR/../splat-1.4.2
SDF_PATH=$BASEDIR/../elevation-radiomobile-sdf-hd/

TX_SITE=$1 #./sites/mbabzi_hc2.qth
RX_SITE=$2 #./sites/dzenza_hc-dms.qth

TX_BASE=`basename $TX_SITE`
RX_BASE=`basename $RX_SITE`
PROFILE_FILE=`echo "${TX_BASE%%.*}-to-${RX_BASE%%.*}"`

splat-hd -t $TX_SITE -r $RX_SITE -metric -d $SDF_PATH -H $PROFILE_FILE-profile.png  
