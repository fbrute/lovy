#!/usr/bin/sh

#-------------------------------------------------------------
# set default directory structure if not passed through

  MDL="/home/kwabena/Documents/trafin/lovy/hysplit/hysplit.v5.2.0_UbuntuOS20.04.3LTS"
  MET="/media/kwabena/MODIS/hysplit_data/2005"
  OUT="/media/kwabena/MODIS/hymarch22/test"
  cd "${OUT}"

#--------------------------------------------------------------
# set model simulation variables    

  syr=05
  smo=08
  shr=12
     
  olat=16.24
  olon=-61.53
  olvl=1500.0
        
  run=-240
  ztop=10000.0
  met1="gdas1.aug05.w4"
  met2="gdas1.aug05.w5"


#----------------------------------------------------------
# basic simulation loop

  #for sda in 03 04 05 06 07 08 09 10 11 12 13 14 15 \
  for sda in 28 29 30 31 
  do

	#----------------------------------------------------------
	# set up control file for dispersion/concentration simulation

	  echo "$syr $smo $sda $shr    " >CONTROL
	  echo "1                      ">>CONTROL
	  echo "$olat $olon $olvl      ">>CONTROL
	  echo "$run                   ">>CONTROL
	  echo "0                      ">>CONTROL
	  echo "$ztop                  ">>CONTROL
	  echo "2                      ">>CONTROL
	  echo "$MET/                  ">>CONTROL
	  echo "$met1                  ">>CONTROL
	  echo "$MET/                  ">>CONTROL
	  echo "$met2                  ">>CONTROL
	  echo "$OUT/                  ">>CONTROL
	  echo "tdump                  ">>CONTROL

	#----------------------------------------------------------
	# run the concentration simulation

	  if [ -f tdump ];then rm tdump; fi
	  ${MDL}/exec/hyts_std    
	  ${MDL}/exec/trajplot tdump
	  mv trajplot.ps plot${syr}{smo}${sda}.ps
	# mv tdump tdump_${smo}_${sda}

	#----------------------------------------------------------
	# simulation loop exit 

  done
