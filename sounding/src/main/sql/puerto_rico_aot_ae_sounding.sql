select sounding2k18.date, cape, cape_virt, conv_inhib, cins, pressure , temp , mixr, relhumidity, snkt as windspeed, drct as wind_direction , aot_440 , ae from sounding2k18 , (select date, avg(aot_440) as aot_440 , avg(angstrom440_870) as ae from aotsanjuan group by date) as aot where station_number = 78526 and sounding2k18.date between '2006-01-01' and '2016-12-31' and time = '12:00:00' and sounding2k18.date = aot.date and pressure in (select * from StandardPressures) order by date;