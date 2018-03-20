#!/bin/ksh

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
  METROOT="/Volumes/TOSHIBA EXT 4/hysplit 4/HYSPLIT DONNEES"
  #METROOT=${MDL}/working
  OUT="."
  #MET=${MDL}/working
  cd $OUT

#--------------------------------------------------------------
# set model simulation variables    

  bisyear=0    # to keep track of bissectile years
  echo please input year
  read syr
  
  

  #print $bisyear
  #print $bisprevyear



  #if [ $syr -lt 2005] | [ $syr -gt 2016 ]; then

  if [[ $syr -lt 2005  || $syr -gt 2016 ]]; then
    echo Sorry ! Year should be within 2005 and 2016.
    exit
  fi


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
  #for nmonth in  0 1 ; do

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
      MET=${METROOT}/20${syr}

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
         
      olat=16.24
      olon=-61.53
      olvl=3000.0
            
      run=-240 
      ztop=10000.0

      #met1="gdas1.sep12.w4"
      # nprevmaxweeks can be equal to 5 or 4, but we only the last 2 weeks
      (( nmetfiles = nprevmaxweeks - 3 + nweeks ))

      print nmetfiles=${nmetfiles}

      result_path=${MDL}/retros/20${syr}/${smo}

      print result_path=${result_path}

      mkdir -p ${result_path}


    #----------------------------------------------------------
    # basic simulation loop for a month

      sda=1
      while [ sda -le $ndays ] ; do 
      #while [ sda -le 1 ] ; do 

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


          # mv tdump tdump_${smo}_${sda}

          #----------------------------------------------------------
          # simulation loop exit 
      (( sda = sda + 1 ))
      done # month loop
  done # year loop



