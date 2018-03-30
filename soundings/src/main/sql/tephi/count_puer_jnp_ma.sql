set @station_number = 78526;

select count(pressure) from sounding2k18 as sounding1, pm10catanolov as pm10 where station_number = @station_number and sounding1.date between '2006-01-01' and '2016-12-31' and time = '12:00:00' and pressure =1000 and sounding1.date = pm10.date and month(sounding1.date) in (3,4) and pm10.pm10 < 28;
