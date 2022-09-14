#!/bin/ksh

# France-Nor Brute
# March, 2022
#
# genereate a bts for one date and location

# first arg is the folder project ($1)
# second arg is the station ($2)  (4 characters in [barb, karu, mada, cuba])
# third arg is the level/altitude ($3)
# fourth is the date ($4), that is supposed to be yymmdd.
# fifth is the mode, test or prod
#
# we launch this script from Thinknpad-E15-linux/home/kwabena/Documents/trafin/lovy/hymarch22
# This script is intended to be used inside a python script.
#

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
# Check number of command line parameters
if [[ ${#} -lt 5 ]]; then
  echo 'Please check that you provided the project folder, the station(where), altitude, date and mode (test or prod)'
  exit
fi

# Get command line parameters
PROJECTHOME=$1
where=$2 # station
olvl=$3
date=$4
mode=$5

syr=${date:0:2}
smo=${date:2:2}
sda=${date:4:2}

# Check level
if ! [[ $olvl = 1500 ]]; then
  echo 'level is not 1500m !!'
  echo olvl=$olvl
  exit
fi


##-------------------------------------------------------------
# set default directory structure if not passed through
#-------------------------------------------------------------
MDL="/media/kwabena/MODIS/hysplit_model/hysplit.v5.2.0_UbuntuOS20.04.3LTS"
if ! [[ -d "$MDL" ]]; then
  echo "The hysplt model folder has not been found!"
  exit
fi
# where the GDAS1 files are stored (each year is a folder within)
METROOT="/media/kwabena/MODIS/hysplit_data"
if ! [[ -d "$METROOT" ]]; then
  echo "The hysplit data folder has not been found!"
  exit
fi


# Set Project home (source folder), entered as a parameter
#PROJECTHOME="/home/kwabena/Documents/trafin/lovy/hymarch22"

if ! [[ -d "$PROJECTHOME" ]]; then
  echo "The project home ${PROJECTHOME} has not been found!"
  exit
fi



#
#--------------------------------------------------------------
# set model simulation variables
#--------------------------------------------------------------

# Get the date from arguments
if ! [[ $mode = 'prod' ||  $mode = 'test' ]]; then
  echo 'The mode should be prod or test'
  exit
fi


if [[ $mode = 'prod' ]]; then
  result_path="${METROOT}/retros_mars_2018/${where}_${olvl}/20${syr}"
  if ! [[ -d $result_path ]]; then
    echo 'the result folder (mode prod) does not exist !!'
    echo $result_path
    exit
  fi
else
  if [[ $mode = 'test' ]]; then
  result_path=$METROOT/tests/retros_mars_2018/${where}_$olvl/20$syr
    if ! [[ -d $result_path ]]; then
      echo 'the result folder (mode test) does not exist !!'
      echo 'attempting to create'
      mkdir -p $result_path
      if ! [[ -d $result_path ]]; then
        echo 'the result folder (mode test) could not be created !!'
        echo $result_path
        exit
      fi
      echo $result_path
    fi
  fi
fi

cd $result_path

if ! [[ $where = 'karu' || $where = 'mada' || $where = 'puer' || $where = 'barb' || $where = 'cuba' ]]; then
  echo Please check the name of the file wich should contain karu,mada,puer,barb or karu at the beginning
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
  if [[ $where = 'cuba' ]]; then
    olat=21.42
    olon=-77.85
  fi
fi
#ASCDATA.CFG seems to be mandatory now
if [ ! -f ASCDATA.CFG ]; then
    echo "-90.0  -180.0"     >ASCDATA.CFG
    echo "1.0     1.0"      >>ASCDATA.CFG
    echo "180     360"      >>ASCDATA.CFG
    echo "2"                >>ASCDATA.CFG
    echo "0.2"              >>ASCDATA.CFG
    echo "'$MDL/bdyfiles/'" >>ASCDATA.CFG
fi

print "The station is ${where}"
print "The level is ${olvl}"
print "The date is ${date}"
print "The mode is ${mode}"

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



print sda=${sda}
print smo=${smo}
print syr=${syr}

isbissectile $syr bisyear
bisyear=$bis

print result_path=${result_path}

print bisyear=$bisyear

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

print nmonth=$nmonth
print nprevyear=$nprevyear
print nprevmonth=$nprevmonth

# where to get meteo files
nprevyear=`eval printf "%02d" $nprevyear`
METPREV=${METROOT}/20$nprevyear
#METPREV=${METROOT}
MET=${METROOT}/20$syr
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

ymd=${syr:2:2}${smo}${sda}

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

echo "${result_path}/                  ">>CONTROL
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
  exit
fi

if [ -f tdump ];then rm tdump ;fi
${MDL}/exec/hyts_std


 #${MDL}/exec/trajplot tdump -a5 -l24 -v1 -idefault_tplot

# option -l24 to get a point every 24 hours

# option -a5 to generate qgis_shape files
#${MDL}/exec/trajplot tdump -a5 -l24 -v1
${MDL}/exec/trajplot tdump -a5 -l24 -v1

#ymd=${syr:2:2}${smo}${sda}
gis_name_root=gis_shape${date}

mv trajplot.ps plot${date}.ps

# we use the option lines to generate the gis lines
${MDL}/exec/ascii2shp ${gis_name_root} lines < GIS_traj_ps_01.txt