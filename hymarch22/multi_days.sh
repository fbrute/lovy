#!/bin/ksh

# France-Nor Brute
# March, 2022
#
# genereate bts from a selection of dates and locations

# check to know if a year is bissectile
# first arg is date files folder($1), becomes a scenario. The scenario is a represented by a folder with dates file(s)
# second is altitude ($2)
# third is the date format ($3)
# mode is test or production ($4)
#
# we launch this script from Thinknpad-E15-linux/home/kwabena/Documents/trafin/lovy/hymarch22
# This works but takes around 20 hours
# Since the bts are saved since 2018, we just have to get them and place them in the appropriate folders
# So we move on to : multi_days.py

function isbissectile {
    case $1 in
               2004|2008|2012|2016)
                        # check if year is bissectile
                        bis=1
                        #print bissectile
                        ;;
                      *)
                        bis=0
                        #print not bissectile
                        ;;
    esac

    eval "$2=$bis"

}
#-------------------------------------------------------------
# set default directory structure if not passed through
#-------------------------------------------------------------
# where the hyspilit model is stored
MDL="/media/kwabena/MODIS/hysplit_model/hysplit.v5.2.0_UbuntuOS20.04.3LTS"
if ! [[ -d "$MDL" ]]; then
  echo "The hysplt model folder has not been found!"
  exit
fi
# where the GDAS1 files are stored
METROOT="/media/kwabena/MODIS/hysplit_data"
if ! [[ -d "$METROOT" ]]; then
  echo "The hysplt data folder has not been found!"
  exit
fi
# # Folder from which we work, directly on the external drive MODIS
OUT="/media/kwabena/MODIS/hymarch22"
# result_path="/media/kwabena/MODIS/hysplit_data/retros_mars_2018/$1"
if ! [[ -d "$OUT" ]]; then
  echo "The out folder has not been found!"
  exit
fi

INC="/home/kwabena/Documents/trafin/lovy/retros/src/retroprint/main/python"
PROJECTHOME="/home/kwabena/Documents/trafin/lovy/hymarch22"
if ! [[ -d "$INC" ]]; then
  echo "The python hosting dates2string.py tool has not been found!"
  exit
fi

if ! [[ -d "$PROJECTHOME" ]]; then
  echo "The project home ${PROJECTHOME} has not been found!"
  exit
fi
cd $OUT

# ASCDATA.CFG seems to be mandatory now
if [ ! -f ASCDATA.CFG ]; then
    echo "-90.0  -180.0"     >ASCDATA.CFG
    echo "1.0     1.0"      >>ASCDATA.CFG
    echo "180     360"      >>ASCDATA.CFG
    echo "2"                >>ASCDATA.CFG
    echo "0.2"              >>ASCDATA.CFG
    echo "'$MDL/bdyfiles/'" >>ASCDATA.CFG
fi
#--------------------------------------------------------------
# set model simulation variables    
#--------------------------------------------------------------
# olvl
#--------------------------------------------------------------
#olvl=`eval printf "%04d" $2`
#echo ${#}
# check the number of arguments
if [[ ${#} -lt 4 ]]; then
  echo 'Please check that you provided the scenario folder name, altitude, date format (ymd or mdy) and mode (test|prod)'
  exit
fi
# Validate the mode
mode=$4
if ! [[ $mode = 'prod' ||  $mode = 'test' ]]; then
  echo 'The mode should be prod or test'
  exit
fi

olvl=$2
print olvl=$olvl

if ! [[ $olvl = 1500 ]]; then
  echo 'level is not 1500m !!'
  exit
fi

date_format=$3
mode=$4

if [[ $mode = 'prod' ]]; then
  scenario_folder=$OUT/scenarios/$1
  if ! [[ -d $scenario_folder ]]; then 
    echo 'the scenario folder (mode prod) does not exist !!'
    echo $scenario_folder
    exit
  fi
else
  if [[ $mode = 'test' ]]; then
    scenario_folder=$OUT/tests/scenarios/$1
    if ! [[ -d $scenario_folder ]]; then 
      echo 'the scenario folder (mode test) does not exist !!'
      echo $scenario_folder
      exit
    fi
  fi
fi

echo "scenario_folder=${scenario_folder}"
echo OUT=$OUT

files=`ls ${scenario_folder}`
echo files=$files

for file in $files; do
  print file=$file
  #--------------------------------------------------------------
  # loop thru the files in the scenario folder 
  #--------------------------------------------------------------
  where=${file:0:4}
  print where=$where

  if ! [[ $where = 'karu' || $where = 'mada' || 'puer' || 'barb' ]]; then
    echo Please check the name of the file wich should contain karu or mada  or puer or barb at the beginning 
    exit
  else

    if [[ $where = 'puer' ]]; then
      olat=18.38
      olon=-65.62
    fi

    if [[ $where = 'karu' ]]; then
      olat=16.24
      olon=-61.53
    fi

    if [[ $where = 'mada' ]]; then
      olat=14.64
      olon=-61.02
    fi

    if [[ $where = 'barb' ]]; then
      olat=13.15
      olon=-59.42
    fi
  fi

  print "The station is ${where}"
  #print $1
  # produce a string with all the dates in csv file $1 to be 'profiled' to string $dates
  #dates=`${INC}/Dates2String.py ${PROJECTHOME}/$1`
  #dates=`${INC}/Dates2String.py ${PROJECTHOME}/$1`
  dates=`${INC}/Dates2String.py $scenario_folder/$file`
  #smo=`eval printf "%02d" $smo`
  #print dates=$dates
  print $dates

  #var="this is my var" 
  #echo "${var#${var%??}}"
  #echo "${var#${var%??}}"

  # wheresea gets the basename of the files that will be utilized in the results folder name 
  # (where = karu | mada, sea = beginning of season)
  (( endofsea =  ${#1} - 4 ))
  print "endofsea=$endofsea"

  wheresea=${1:0:$endofsea}
  print wheresea=$wheresea

  print "${#1}="
  print ${#1}

  #offset=3 
  #echo ${var} | cut -c ${offset}- 

  print olat=$olat

  print olon=$olon
    
  #for day in 01/01/2008; do
  for day in $dates; do
    # be careful with date format
    # date format is dd/mm/yyyy

    if [[ $date_format = 'dmy' ]]; then
      sda=${day:0:2}
      smo=${day:3:2}
      syr=${day:6:4}
    fi

    if [[ $date_format = 'ymd' ]]; then
      sda=${day:8:2}
      smo=${day:5:2}
      syr=${day:0:4}
    fi

    #ymd="${syr:2:2}${smo}${sda}"
    print sda=$sda
    print smo=$smo
    print syr=$syr

    isbissectile $syr bisyear
    bisyear=$bis

    #result_path=${MDL}/retros/${wheresea}_${olvl}
    #result_path=/media/kwabena/MODIS/hymarch22/results/$1
    print result_path=${result_path}

    #prevyear=${prevyear:2:2}

    #print $prevyear
    print $bisyear

    # iterate thru the months
    set -A months jan feb mar apr may jun jul aug sep oct nov dec
    (( nmonth = smo - 1 ))

    # special case of january
    if [ $nmonth -eq 0 ] ; then
          nprevmonth=11
          (( nprevyear = syr - 1 ))
    else
          (( nprevmonth = nmonth - 1 ))
          nprevyear=$syr
    fi
    
    print $nmonth
    print $nprevyear
    print $nprevmonth

    # where to get meteo files
    nprevyear=`eval printf "%02d" $nprevyear`
    METPREV=${METROOT}/20${nprevyear:2:2}
    #METPREV=${METROOT}
    MET=${METROOT}/20${syr:2:2}
    #MET=${METROOT}
    
    print METPREV=$METPREV
    print MET=$MET

    cmonth=${months[$nmonth]}
    cprevmonth=${months[$nprevmonth]}

    echo cmonth=${cmonth}

    echo prevmonth=${cprevmonth}

    #special case for bissectile year and february for the number of weeks of data needed
    if [ $nprevmonth -eq 1 ] ; then
        if [ $bisyear -eq 1 ] ; then
            nprevmaxweeks=5
        else
            nprevmaxweeks=4
        fi

    else  
            nprevmaxweeks=5
    fi

    if [ $nmonth -eq 1 ] ; then
        if [ $bisyear -eq 1 ] ; then
            nweeks=5
            ndays=29
        else
            nweeks=4
            ndays=28
        fi
    else
        nweeks=5
        case $nmonth in
          0|2|4|6|7|9|11)
                  ndays=31 
                  ;;
          3|5|8|10)
                  ndays=30 
                  ;;
                *)
                  #print not bissectile
                  ;;
        esac
    fi

    print syr=${syr}
    
    print current year bissectile=${bisyear}

    print nprevyear=${nprevyear}

    print nprevmaxweeks=${nprevmaxweeks}
    print nweeks=${nweeks}

    print ndays=${ndays}


    print nmonth=${nmonth}
    (( smo = nmonth + 1 ))
    smo=`eval printf "%02d" $smo`

    print nprevyear=${nprevyear}

    print smo=${smo}
    shr=12
        
    #olat=16.24
    #olon=-61.53
    #olvl=3000.0
          
    run=-240 
    ztop=10000.0

    #met1="gdas1.sep12.w4"
    # nprevmaxweeks can be equal to 5 or 4, but we only the last 2 weeks
    (( nmetfiles = nprevmaxweeks - 3 + nweeks ))

    print nmetfiles=${nmetfiles}

    #result_path=${MDL}/retros/${wheresea}_${olvl}

    
    ymd=${syr}${smo}${sda} 
    print ymd=$ymd

    # if [ ! -f $result_path ]; then
    #   mkdir -p ${result_path}
    # fi



    #----------------------------------------------------------
    # basic simulation loop for a day
    #----------------------------------------------------------
    # set up control file for dispersion/concentration simulation

    echo "$syr $smo $sda $shr   " >CONTROL
    echo "1                      ">>CONTROL
    echo "$olat $olon ${olvl:0:4}      ">>CONTROL
    echo "$run                   ">>CONTROL
    echo "0                      ">>CONTROL
    echo "$ztop                  ">>CONTROL
    echo "$nmetfiles             ">>CONTROL
    #echo "$MET/                  ">>CONTROL
    #echo "$met1                  ">>CONTROL
    weekindex=4
    while [ $weekindex -le $nprevmaxweeks ] ; do
        echo "$METPREV/">>CONTROL
        echo "gdas1.${cprevmonth}${nprevyear}.w${weekindex} ">>CONTROL
        (( weekindex = weekindex + 1 ))
    done
    weekindex=1
    while [ $weekindex -le $nweeks ] ; do
        echo "$MET/">>CONTROL
        echo "gdas1.${cmonth}${syr}.w${weekindex}">>CONTROL
        (( weekindex = weekindex + 1 ))
    done

    echo "$OUT/                  ">>CONTROL
    echo "tdump                  ">>CONTROL

    print METPREV=${METPREV}
    print MET=${MET}

    #exit

    #----------------------------------------------------------
    # run the simulation

    #if [ -f ${result_path}/tdump${ymd}.txt ]; then
    #  print "tdump for date ${ymd} already computed"
    #  continue
    #else


    if [ -f ${result_path}/gis_shape${where}${ymd}.dbf ]; then
      print "plot for date ${ymd} already computed"
      continue
    fi

    if [ -f tdump ];then rm tdump ;fi
    ${MDL}/exec/hyts_std    

    
      #${MDL}/exec/trajplot tdump -a5 -l24 -v1 -idefault_tplot

    # option -l24 to get a point every 24 hours

    # skip production if plot already computed
    
    # option -a5 to generate qgis_shape files
    #${MDL}/exec/trajplot tdump -a5 -l24 -v1
    print  wd=`pwd` 
    ${MDL}/exec/trajplot tdump -a5 -l24 -v1

    #ymd=${syr:2:2}${smo}${sda} 
    gis_name_root=gis_shape_${where}_${ymd}

    mv trajplot.ps plot_${where}_${ymd}.ps

    # we use the option lines to generate the gis lines
    ${MDL}/exec/ascii2shp ${gis_name_root} lines < GIS_traj_ps_01.txt 

    # we need the results in a different folder for each month
    mv  plot_${where}_${ymd}.ps             ${result_path}/
    mv  ${gis_name_root}.*        ${result_path}/
    mv  CONTROL                   ${result_path}/CONTROL_${where}_${ymd}
    mv tdump                      ${result_path}/tdump_${where}_${ymd}.txt


    # mv tdump tdump_${smo}_${sda}

    #----------------------------------------------------------
    # simulation loop exit 
  done # multidays loop
done # for file in files