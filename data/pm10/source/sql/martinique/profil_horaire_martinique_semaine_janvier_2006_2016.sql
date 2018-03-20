set @pm10max = 300;

select hour as hour , avg_pm10 from 
    (select hour, avg(pm10) as avg_pm10 from pm10madalovhoraire where date between "2006-01-01" and "2016-12-31" and date not between "2010-02-11" and "2010-02-15" and dayname(date) in ("Monday", "Tuesday" , "Wednesday", "Thursday","Friday") and month(date) = 1 and pm10 < 300 and hour > 0 group by hour 
        union  select hour+24, avg_pm10 from (select hour, avg(pm10) as avg_pm10 from pm10madalovhoraire where date_sub(date, interval 1 day) between "2006-01-01" and "2016-12-31" and date_sub(date, interval 1 day) not between "2010-02-11" and "2010-02-15" and dayname(date_sub(date,interval 1 day)) in ("Monday", "Tuesday" , "Wednesday", "Thursday","Friday") and month(date) = 1 and pm10 < 300 and hour = 0 group by hour) as profil24 ) as profil23;

