#!/bin/bash

# https://ethertubes.com/bash-snippet-calculating-the-distance-between-2-coordinates/

deg2rad () {
        bc -l <<< "$1 * 0.0174532925"
}

rad2deg () {
        bc -l <<< "$1 * 57.2957795"
}

acos () {
        pi="3.141592653589793"
        bc -l <<<"$pi / 2 - a($1 / sqrt(1 - $1 * $1))"
}

distance () {
        lat_1="$1"
        lon_1="$2"
        lat_2="$3"
        lon_2="$4"
        delta_lat=`bc <<<"$lat_2 - $lat_1"`
        delta_lon=`bc <<<"$lon_2 - $lon_1"`
        lat_1="`deg2rad $lat_1`"
        lon_1="`deg2rad $lon_1`"
        lat_2="`deg2rad $lat_2`"
        lon_2="`deg2rad $lon_2`"
        delta_lat="`deg2rad $delta_lat`"
        delta_lon="`deg2rad $delta_lon`"

        distance=`bc -l <<< "s($lat_1) * s($lat_2) + c($lat_1) * c($lat_2) * c($delta_lon)"`
        distance=`acos $distance`
        distance="`rad2deg $distance`"
        distance=`bc -l <<< "$distance * 60 * 1.15078"`
        distance=`bc <<<"scale=4; $distance / 1"`
        echo $distance
}

# Keywest, FL to Cuba
#distance 23.1371608596929 -81.68746948242188 24.540793898068767 -81.76849365234375
#distance -13.87591667 326.2529444 -13.928031 326.328934
distance $1 $2 $3 $4