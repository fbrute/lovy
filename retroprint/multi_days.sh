#!/bin/ksh

# France-Nor Brute
# January 24, 2018
#

# check to know if a year is bissectile
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

  MDL="/Users/france-norbrute/Documents/trafin/fouyol/recherche/Hysplit4"
  #METROOT="/Volumes/TOSHIBA EXT 4/hysplit 4/HYSPLIT DONNEES"
  METROOT="/Volumes/MODIS/trafin/fouyol/recherche/data/HYSPLIT DONNEES"
  #METROOT="/Volumes/MODIS/hysplit_data"
  OUT=${MDL}/working
  #METROOT=${MDL}/working
  #OUT="."
  INC=~/lovy/retroprint
  cd $OUT

#--------------------------------------------------------------
# set model simulation variables    
#--------------------------------------------------------------
# olvl
#--------------------------------------------------------------
  #olvl=`eval printf "%04d" $2`
  echo ${#}
  if [[ ${#} -lt 3 ]]; then
    echo Please check that you provided the dates file, altitude, then result_path
    exit
  fi

  olvl=$2
  print olvl=$olvl

  result_path=$3 

  echo $result_path


#--------------------------------------------------------------
# olat & olon
#--------------------------------------------------------------
  where=${1:0:4}
  print where=$where

  if ! [[ $where = 'karu' || $where = 'mada' ]]; then
    echo Please check the name of the file wich should contain karu or mada at the beginning 
    exit
  else
    if [[ $where = 'karu' ]]; then
      olat=16.24
      olon=-61.53
    fi
    if [[ $where = 'mada' ]]; then
      #echo Please fix script with olat and olon variables for mada
      #exit
      olat=14.64
      olon=-61.02
      #olat=16.24
      #olon=-61.53
    fi

  fi

  print $1
  # produce a string with all the dates in csv file $1 to be 'profiled' to string $dates
  dates=`${INC}/Dates2String.py ${INC}/$1`
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
  # date format is yyyy-mm-dd

  #for syr in 2015; do

      #bisyear=0    # to keep track of bissectile years
      #echo please input year
      #read syr
      
      

      #print $bisyear
      #print $bisprevyear



      #if [ $syr -lt 2005] | [ $syr -gt 2016 ]; then

      #if [[ $syr -lt 2005  || $syr -gt 2013 ]]; then
      #  echo Sorry ! Year should be within 2005 and 2016.
      #  exit
      #fi


      #syr=${day:6:4}
      syr=${day:0:4}

      isbissectile $syr bisyear
      bisyear=$bis

      #smo=${day:3:2}
      smo=${day:5:2}

      #sda=${day:0:2}
      sda=${day:8:2}

      ymd=${syr:2:2}${smo}${sda} 
      #result_path=${MDL}/retros/${wheresea}_${olvl}
      #result_path=${MDL}/${where}_retros_1500_flatten
      print result_path=${result_path}
    
      #prevyear=${prevyear:2:2}

      print $syr
      print $smo
      print $sda

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

      
      #ymd=${syr:2:2}${smo}${sda} 
      if [ ! -f $result_path ]; then
        mkdir -p ${result_path}
      fi
    


      #----------------------------------------------------------
      # basic simulation loop for a day
      #----------------------------------------------------------
      # set up control file for dispersion/concentration simulation

      echo "${syr:2:2} $smo $sda $shr   " >CONTROL
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
          echo "gdas1.${cprevmonth}${nprevyear:2:2}.w${weekindex} ">>CONTROL
          (( weekindex = weekindex + 1 ))
      done
      weekindex=1
      while [ $weekindex -le $nweeks ] ; do
          echo "$MET/">>CONTROL
          echo "gdas1.${cmonth}${syr:2:2}.w${weekindex}">>CONTROL
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


      if [ -f ${result_path}/gis_shape${ymd}.dbf ]; then
        print "plot for date ${ymd} already computed"
        continue
      fi

      if [ -f tdump ];then rm tdump ;fi
      ${MDL}/exec/hyts_std    

     
       #${MDL}/exec/trajplot tdump -a5 -l24 -v1 -idefault_tplot

      # option -l24 to get a point every 24 hours

      # skip production if plot already computed
      
      # option -a5 to generate qgis_shape files
      ${MDL}/exec/trajplot tdump -a5 -l24 -v1

      #ymd=${syr:2:2}${smo}${sda} 
      gis_name_root=gis_shape${ymd}

      mv trajplot.ps plot${ymd}.ps

      # we use the option lines to generate the gis lines
      ${MDL}/exec/ascii2shp ${gis_name_root} lines < GIS_traj_ps_01.txt 

      # we need the results in a different folder for each month
      mv  plot${ymd}.ps             ${result_path}/
      mv  ${gis_name_root}.*        ${result_path}/
      #mv  CONTROL                   ${result_path}/CONTROL${ymd}
      mv tdump ${result_path}/tdump${ymd}.txt


      # mv tdump tdump_${smo}_${sda}

      #----------------------------------------------------------
      # simulation loop exit 
    done # multidays loop
