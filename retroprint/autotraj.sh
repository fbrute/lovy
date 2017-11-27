#!/bin/ksh

#-------------------------------------------------------------
# set default directory structure if not passed through

  MDL="/Users/france-norbrute/Documents/trafin/fouyol/recherche/Hysplit4"
  #OUT="."
  OUT=${MDL}/working
  MET=${MDL}/working
  cd $OUT

#--------------------------------------------------------------
# set model simulation variables    

  syr=12
  smo=10
  shr=12
     
  olat=16.5
  olon=-61.0
  olvl=10.0
        
  run=-240 
  ztop=10000.0

  met1="gdas1.sep12.w4"
  met2="gdas1.sep12.w5"

  met3="gdas1.oct12.w1"
  met4="gdas1.oct12.w2"
  met5="gdas1.oct12.w3"
  met6="gdas1.oct12.w4"
  met7="gdas1.oct12.w5"

  result_path=${MDL}/results/${syr}_${smo}
  mkdir -p ${result_path}


#----------------------------------------------------------
# basic simulation loop

  #for sda in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 \
      #16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31; do
  for sda in 01 02;do

#----------------------------------------------------------
# set up control file for dispersion/concentration simulation

  echo "$syr $smo $sda $shr    " >CONTROL
  echo "1                      ">>CONTROL
  echo "$olat $olon $olvl      ">>CONTROL
  echo "$run                   ">>CONTROL
  echo "0                      ">>CONTROL
  echo "$ztop                  ">>CONTROL
  echo "7                      ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$met1                  ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$met2                  ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$met3                  ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$met4                  ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$met5                  ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$met6                  ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$met7                  ">>CONTROL
  echo "$OUT/                  ">>CONTROL
  echo "tdump                  ">>CONTROL

#----------------------------------------------------------
# run the concentration simulation

  if [ -f tdump ];then rm tdump; fi
  ${MDL}/exec/hyts_std    
  ${MDL}/exec/trajplot tdump -a5 -idefault_tplot

  ymd=${syr}${smo}${sda} 
  gis_name_root=gis_shape${ymd}

  mv trajplot.ps plot${ymd}.ps

  ${MDL}/exec/ascii2shp ${gis_name_root} lines < GIS_traj_ps_01.txt 

  # we need the results in a different folder for each month
  mv  plot${ymd}.ps             ${result_path}/
  mv  ${gis_name_root}.*        ${result_path}/


# mv tdump tdump_${smo}_${sda}

#----------------------------------------------------------
# simulation loop exit 

  done
