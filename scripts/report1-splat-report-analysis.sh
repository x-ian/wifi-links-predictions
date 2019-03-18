#!/bin/bash

# find . -type f -name '*-to-*.txt' -exec ../splat-report-analysis.sh {} \;
# find . -type f -name '*-to-*.txt' -exec ../scripts/report1-splat-report-analysis.sh {} \;

# number of analysed connections (within 100 km)
#ls -1 *-to-*.txt| wc -l

# analyse LOS & fresnel zone
FILE=$1 #Ukwe_HC_\(new\)-to-*

TX=$(grep "Transmitter site: " $FILE | cut -f3 -d' ')
TX_LAT=-$(grep "Transmitter site" $FILE -A 1 | grep "location" | awk -F' ' '{print $3}')
TX_EST=$(grep "Transmitter site" $FILE -A 1 | grep "location" | awk -F' ' '{print $6}')
TX_LNG=$(echo "($TX_EST-360)*-1" | bc)
RX=$(grep "Receiver site: " $FILE | cut -f3 -d' ')
RX_LAT=-$(grep "Receiver site" $FILE -A 1 | grep "location" | awk -F' ' '{print $3}')
RX_EST=$(grep "Receiver site" $FILE -A 1 | grep "location" | awk -F' ' '{print $6}')
RX_LNG=$(echo "($RX_EST-360)*-1" | bc)

PATH_LOSS_FREE_SPACE=$(grep "Free space path loss:" $FILE | cut -f5 -d' ')
PATH_LOSS_ITWOM=$(grep "ITWOM Version 3.0 path loss:" $FILE | cut -f6 -d' ')
RX_SIGNAL_POWER=$(grep "Signal power level at " $FILE | cut -f6 -d' ')

DISTANCE=$(grep "Distance to " $FILE | head -1 | cut -f4 -d' ')

grep "No obstructions to LOS path" $FILE > /dev/null
LOS_NOTCLEAR=$?
LOS_CLEAR_HEIGHT=$(grep "must be raised to at" -A 1  $FILE | tr '\n' ' ' | sed $'s/--/\\\n/g' | grep " to clear all obstructions detected " | cut -f10 -d' ')

grep "The first Fresnel zone is clear" $FILE > /dev/null
FRESNEL_NOTCLEAR=$?
FRESNEL_CLEAR_HEIGHT=$(grep "must be raised to at" -A 1  $FILE | tr '\n' ' ' | sed $'s/--/\\\n/g' | grep "to clear the first Fresnel zone" | cut -f10 -f11 -d' ')

grep "60% of the first Fresnel zone is clear" $FILE > /dev/null
FRESNEL60_NOTCLEAR=$?
FRESNEL60_CLEAR_HEIGHT=$(grep "must be raised to at" -A 1  $FILE | tr '\n' ' ' | sed $'s/--/\\\n/g' | grep "to clear 60% of the first Fresnel zone" | cut -f10 -f11 -d' ')

echo "$FILE;$TX;$RX;$DISTANCE;$PATH_LOSS_FREE_SPACE;$PATH_LOSS_ITWOM;$RX_SIGNAL_POWER;$FRESNEL_NOTCLEAR;$FRESNEL_CLEAR_HEIGHT;$FRESNEL60_NOTCLEAR;$FRESNEL60_CLEAR_HEIGHT;$LOS_NOTCLEAR;$LOS_CLEAR_HEIGHT;$TX_LAT;$TX_LNG;$RX_LAT;$RX_LNG" >> data.csv
