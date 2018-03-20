#!/usr/bin/env ksh

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
  METROOT="/Volumes/MODIS/trafin/fouyol/recherche/data/HYSPLIT DONNEES"
  #METROOT="/Volumes/TOSHIBA EXT 4/hysplit 4/HYSPLIT DONNEES"
  #METROOT=${MDL}/working
  #OUT="."
  #MET=${MDL}/working
  OUT=${MDL}/working
  cd $OUT

 
#--------------------------------------------------------------
# set model simulation variables    

if [[ ${#} -lt 2 ]]; then
    echo "Please check that you provided the dates file and altitude(s)"
    exit
 fi
 
 # capture different levels
 levels=${*:2}

 for olvl in $levels; do
     echo $olvl
 done

 #olvl=$2
 #result_path=${MDL}/retros/${where}_${olvl}

 #--------------------------------------------------------------
# olat & olon
#--------------------------------------------------------------
  where=${1:0:4}
  print where=$where

  if ! [[ $where = 'karu' || $where = 'mada' || 'puer' || 'barb' ]]; then
    echo Please check the name of the file wich should contain karu or mada  or puerto_rico or barbade at the beginning 
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

 for olvl in $levels; do
     #for syr in 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016; do
     for syr in 2014; do

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

          isbissectile $syr bisyear
          bisyear=$bis
         

          syr=${syr:2:2}
          #prevyear=${prevyear:2:2}

          #print $syr
          #print $prevyear
          #print $bisyear
            


          # iterate thru the months
          set -A months jan feb mar apr may jun jul aug sep oct nov dec
          for nmonth in  0 1 2 3 4 5 6 7 8 9 10 11; do
          #for nmonth in  0 ; do

              # special case of january
              if [ $nmonth -eq 0 ] ; then
                    nprevmonth=11
                    (( nprevyear = syr - 1 ))
              else
                    (( nprevmonth = nmonth - 1 ))
                    nprevyear=$syr
              fi

              # where to get meteo files
              nprevyear=`eval printf "%02d" $nprevyear`
              METPREV=${METROOT}/20${nprevyear}
              #METPREV=${METROOT}
              MET=${METROOT}/20${syr}
              #MET=${METROOT}

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
                 
                    
              run=-240 
              ztop=10000.0

              # nprevmaxweeks can be equal to 5 or 4, but we only the last 2 weeks
              (( nmetfiles = nprevmaxweeks - 3 + nweeks ))

              #print nmetfiles=${nmetfiles}

              result_path=${MDL}/retros/${where}_${olvl}/20${syr}
              print result_path=${result_path}


            if [ ! -f $result_path ]; then
              mkdir -p ${result_path}
            fi

            #----------------------------------------------------------
            # basic simulation loop for a month

              sda=1
              #while [ sda -le 5 ] ; do 

              while [ sda -le $ndays ] ; do 

              #for sda in 01 02;do
              sdaf=`eval printf "%02d" $sda`

              #----------------------------------------------------------
                  # set up control file for dispersion/concentration simulation

                  echo "$syr $smo $sdaf $shr   " >CONTROL
                  echo "1                      ">>CONTROL
                  echo "$olat $olon $olvl      ">>CONTROL
                  echo "$run                   ">>CONTROL
                  echo "0                      ">>CONTROL
                  echo "$ztop                  ">>CONTROL
                  echo "$nmetfiles             ">>CONTROL
                  #echo "$MET/                  ">>CONTROL
                  #echo "$met1                  ">>CONTROL
                  weekindex=4
                  while [ $weekindex -le $nprevmaxweeks ] ; do
                      echo "$METPREV/                  ">>CONTROL
                      echo "gdas1.${cprevmonth}${nprevyear}.w${weekindex}                  ">>CONTROL
                      (( weekindex = weekindex + 1 ))
                  done
                  weekindex=1
                  while [ $weekindex -le $nweeks ] ; do
                      echo "$MET/                  ">>CONTROL
                      echo "gdas1.${cmonth}${syr}.w${weekindex}                  ">>CONTROL
                      (( weekindex = weekindex + 1 ))
                  done

                  echo "$OUT/                  ">>CONTROL
                  echo "tdump                  ">>CONTROL

                  print METPREV=${METPREV}
                  print MET=${MET}

                  #exit

                  #----------------------------------------------------------
                  # run the concentration simulation
                  
                                # test if results files are already computed
                  if [ ! -f ${result_path/plot${ymd}.ps} ]; then

                      if [ -f tdump ];then rm tdump; fi
                      ${MDL}/exec/hyts_std    
                      #${MDL}/exec/trajplot tdump -a5 -l24 -v1 -idefault_tplot

                      # opiton -l24 to get a point every 24 hours

                      # option -a5 to generate qgis_shape files
                      ${MDL}/exec/trajplot tdump -a5 -l24 -v1

                      ymd=${syr}${smo}${sdaf} 
                      gis_name_root=gis_shape${ymd}

                      mv trajplot.ps plot${ymd}.ps

                      # we use the option lines to generate the gis lines
                      ${MDL}/exec/ascii2shp ${gis_name_root} lines < GIS_traj_ps_01.txt 

                      # we need the results in a different folder for each month
                      mv  plot${ymd}.ps             ${result_path}/
                      mv  ${gis_name_root}.*        ${result_path}/
                      mv  CONTROL                   ${result_path}/CONTROL${ymd}
                      mv tdump                      ${result_path}/tdump${ymd}.txt
                    fi


                  # mv tdump tdump_${smo}_${sda}

                  #----------------------------------------------------------
                  # simulation loop exit 
              (( sda = sda + 1 ))
              done # month loop
          done # year loop
        done # multiyears loop
    done # multilevels loop
