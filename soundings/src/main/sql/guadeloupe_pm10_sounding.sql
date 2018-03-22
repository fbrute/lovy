select sounding1.date, cape, cape_virt, conv_inhib, cins, pressure , temp , mixr, relhumidity, snkt as windspeed, drct as wind_direction , pm10_mean from sounding1 , (select date, avg(pm10) as pm10_mean from pm10karulov group by date) as pm10 where station_number = 78897 and sounding1.date between '2006-01-01' and '2016-12-31' and time = '12:00:00' and sounding1.date = pm10.date and pressure in (select * from standardpressures) order by date;