#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$BASEDIR/calculate-links.sh _tmp_sites_TTn.txt > all_TTn 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_F1.txt > all_F1 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_F2.txt > all_F2 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_Fn1.txt > all_Fn1 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_Fn2.txt > all_Fn2 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_Fn3.txt > all_Fn3 2>&1 &
