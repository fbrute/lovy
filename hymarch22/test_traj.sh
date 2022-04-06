#!/bin/sh

#-------------------------------------------------------------
# set default directory structure if not passed through

  WEB=""
  if [ -f /usr/bin/firefox ];then WEB="/usr/bin";fi
  if [ -f /usr/local/bin/firefox ];then WEB="/usr/local/bin";fi
  MDL="${HOME}/hysplit"
  OUT="${MDL}/working"
  MET="${HOME}/hysplit/working"
  cd $OUT

  if [ ! -f ASCDATA.CFG ]; then
     echo "-90.0  -180.0"     >ASCDATA.CFG
     echo "1.0     1.0"      >>ASCDATA.CFG
     echo "180     360"      >>ASCDATA.CFG
     echo "2"                >>ASCDATA.CFG
     echo "0.2"              >>ASCDATA.CFG
     echo "'$MDL/bdyfiles/'" >>ASCDATA.CFG
  fi
  echo "### $0 ###"

#--------------------------------------------------------------
# set model simulation variables    

  syr=95
  smo=10
  sda=16
  shr=00
     
  olat=40.0
  olon=-90.0
  lvl1=10.0
  lvl2=500.0
  lvl3=1000.0
        
  run=12
  ztop=10000.0
  data="oct1618.BIN"

#----------------------------------------------------------
# set up control file for dispersion/concentration simulation

  echo "$syr $smo $sda $shr    " >CONTROL
  echo "3                      ">>CONTROL
  echo "$olat $olon $lvl1      ">>CONTROL
  echo "$olat $olon $lvl2      ">>CONTROL
  echo "$olat $olon $lvl3      ">>CONTROL
  echo "$run                   ">>CONTROL
  echo "0                      ">>CONTROL
  echo "$ztop                  ">>CONTROL
  echo "1                      ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$data                  ">>CONTROL
  echo "$OUT/                  ">>CONTROL
  echo "tdump                  ">>CONTROL

#----------------------------------------------------------
# run the simulation

  rm -f tdump
  rm -f SETUP.CFG

  ${MDL}/exec/hyts_std    

  echo "'TITLE&','### $0 ###&'"  >LABELS.CFG
  ${MDL}/exec/trajplot +g1 -itdump -z80 -j${MDL}/graphics/arlmap
  if [[ "$OSTYPE" == "darwin"* ]]; then
     open trajplot.html    
  else
     ${WEB}/firefox trajplot.html &
  fi
