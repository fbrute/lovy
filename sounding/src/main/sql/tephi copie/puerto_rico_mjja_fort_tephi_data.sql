set @station_number = 78526;

select pressure , avg(temp) as temp , avg(mixr) as mixr, avg(relhumidity) as rh from sounding2k18 as sounding1, pm10catanolov as pm10 where station_number = @station_number and sounding1.date between '2006-01-01' and '2016-12-31' and time = '12:00:00' and pressure in (select pressure from tephipressures) and sounding1.date = pm10.date and month(sounding1.date) in (5,6,7,8) and pm10.pm10 >= 80 group by pressure
