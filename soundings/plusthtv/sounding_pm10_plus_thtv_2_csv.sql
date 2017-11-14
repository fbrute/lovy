set @monthstart = 9;
set @monthend = 11;
select sounding1.date, pressure , thtv,  pm10 from sounding1 , (select date(datetime) as date , avg(pmptp) as pm10 from pm10 group by date) as pm10avg where sounding1.date between 2005-01-01 and '2015-12-31' and time = '12:00:00' and month(sounding1.date) between @monthstart and @monthend and sounding1.date = pm10avg.date order by date;
