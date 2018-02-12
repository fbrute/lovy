set @nbdays=12;

select nbdates, aot.date, aot_440_daily, pm10 , angstrom440_870, angstrom440_675 from 
    (select count(*) as nbdates, date, avg(aot_440) as aot_440_daily, avg(angstrom440_870) as angstrom440_870, avg(angstrom440_675) as angstrom440_675 from aotsanjuan group by date having nbdates >=@nbdays) as aot, 
    (select date(date) as date, avg(pm10) as pm10 from pm10fajardo where pm10 >0 group by date) as pm10 
where aot.date = pm10.date;
