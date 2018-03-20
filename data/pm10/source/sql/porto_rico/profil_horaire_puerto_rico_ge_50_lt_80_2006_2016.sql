set @pm10max = 300;

select hour as hour , avg_pm10 from 
    (select hour, avg(pm10) as avg_pm10 from pm10_catano where date in (select date from pm10_catano where pm10 < @pm10max group by date having avg(pm10) >= 50 and avg(pm10) < 80)  and date between "2006-01-01" and "2016-12-31" and pm10 < 300 and hour > 0 group by hour  
        union  select hour+24, avg_pm10 from (select hour, avg(pm10) as avg_pm10 from pm10_catano where date_sub(date, interval 1 day) in (select date from pm10_catano where pm10 < @pm10max group by date having avg(pm10) >= 50 and avg(pm10) < 80) and date between "2006-01-01" and "2016-12-31" and pm10 < @pm10max and hour = 0 group by hour) as profil24 ) as profil23;
