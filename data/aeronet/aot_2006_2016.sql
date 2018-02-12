set @nbdays=12;
select count(*) as nbdates, date, avg(aot_440) as aot_440_daily, avg(angstrom440_870) as angstrom440_870 from aotv2k18 group by date having nbdates >=@nbdays
