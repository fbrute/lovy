select month(date) as month, hour, avg(pm10) as pm10 from pm10_catano group by month(date),hour;
