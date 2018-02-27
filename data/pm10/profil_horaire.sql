select month(date) as month, hour, avg(pm10) as pm10 from pm10madalovhoraire group by month(date),hour;
