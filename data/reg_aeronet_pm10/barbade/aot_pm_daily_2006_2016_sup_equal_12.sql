set @nbdays=12;
select nbdates, aot.date, aot_440_daily, pm , angstrom440_870, angstrom440_675 from 
    (select count(*) as nbdates, date, avg(aot_440) as aot_440_daily, avg(angstrom440_870) as angstrom440_870, avg(angstrom440_675) as angstrom440_675 from aotbarbade group by date having nbdates >=@nbdays) as aot, 
    (select date(date) as date, avg(pm) as pm from pmbarbade where pm >0 group by date) as pm 
where aot.date = pm.date;
