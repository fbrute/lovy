set @nbdays=12;

select nbdates, aot.date, aot_440_daily, pm25 , angstrom440_870, angstrom440_675 from 
    (select count(*) as nbdates, date, avg(aot_440) as aot_440_daily, avg(angstrom440_870) as angstrom440_870, avg(angstrom440_675) as angstrom440_675 from aotsanjuan group by date having nbdates >=@nbdays) as aot, 
    (select date(date) as date, avg(pm25) as pm25 from pm25fajardo where pm25 >0 group by date) as pm25
where aot.date = pm25.date;
