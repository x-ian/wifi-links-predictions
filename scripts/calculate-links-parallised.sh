#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

../scripts/calculate-links.sh ./_all-sites-aa ../sites/ ../splat-bht-scaleup.lrp
../scripts/calculate-links.sh ./_all-sites-ab ../sites/ ../splat-bht-scaleup.lrp 
../scripts/calculate-links.sh ./_all-sites-ac ../sites/ ../splat-bht-scaleup.lrp 
../scripts/calculate-links.sh ./_all-sites-ad ../sites/ ../splat-bht-scaleup.lrp 
../scripts/calculate-links.sh ./_all-sites-ae ../sites/ ../splat-bht-scaleup.lrp 
../scripts/calculate-links.sh ./_all-sites-af ../sites/ ../splat-bht-scaleup.lrp 
../scripts/calculate-links.sh ./_all-sites-ag ../sites/ ../splat-bht-scaleup.lrp 
../scripts/calculate-links.sh ./_all-sites-ab ../sites/ ../splat-bht-scaleup.lrp 

$BASEDIR/calculate-links.sh _tmp_sites_TTn.txt > all_TTn 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_F1.txt > all_F1 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_F2.txt > all_F2 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_Fn1.txt > all_Fn1 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_Fn2.txt > all_Fn2 2>&1 &
$BASEDIR/calculate-links.sh _tmp_sites_Fn3.txt > all_Fn3 2>&1 &
