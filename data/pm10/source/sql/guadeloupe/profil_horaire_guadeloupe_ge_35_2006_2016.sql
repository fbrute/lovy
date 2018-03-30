set @pm10max = 300;
set @pmfield = "pmptp";
set @pmdustmin = 35;

select hour as hour , avg_pm10 from 
    (select hour(datetime) as hour, avg(pmptp) as avg_pm10 from pm10 where date(datetime) in (select date from pm10karulov where pm10 < @pm10max group by date having avg(pm10) >= @pmdustmin) and date(datetime) between "2006-01-01" and "2016-12-31" and datetime not between "2014-02-18 15:00:00" and "2014-12-31 23:00:00" and date(datetime) not between "2010-02-11" and "2010-02-15" and @pmfield < @pm10max and hour(datetime) > 0 group by hour
        union  select hour+24, avg_pm10 from (select hour(datetime) as hour, avg(pmptp) as avg_pm10 from pm10 where date_sub(date(datetime), interval 1 day) in (select date from pm10karulov where pm10 < @pm10max group by date having avg(pm10) >= @pmdustmin ) and date_sub(date(datetime), interval 1 day) between "2006-01-01" and "2016-12-31" and date_sub(date(datetime), interval 1 day) not between "2014-02-18" and "2014-12-31" and date_sub(date(datetime), interval 1 day) not between "2010-02-11" and "2010-02-15" and @pmfield < @pm10max and hour(datetime) = 0 group by hour) as profil24 ) as profil23;

