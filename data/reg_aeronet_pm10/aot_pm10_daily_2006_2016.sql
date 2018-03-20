set @nbdays=12;

select nbdates, aot.date, aot_440_daily, pm10 , angstrom440_870, vitesse_vent_metre_par_sec, direction_vent from 

    (select count(*) as nbdates, date, avg(aot_440) as aot_440_daily, avg(angstrom440_870) as angstrom440_870, avg(angstrom440_675) as angstrom440_675 
        from aotv2k18 group by date having nbdates >=@nbdays) as aot, 

    (select date(datetime) as date, avg(pmptp) as pm10 from pm10 where pmptp >0 group by date) as pm10,

    (select date(dateheure) as date, avg(vitvent) as vitesse_vent_metre_par_sec , avg(dirvent) as direction_vent from wind14 
    group by date(dateheure)) as wind 

where aot.date = pm10.date
    and aot.date = wind.date;
