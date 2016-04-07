use dbmeteodb;
create table pm10_2015_daily_dakar like pm10_2015;
select * from pm10_2015_daily_dakar;
truncate pm10_2015_daily_dakar;

select month(datetime) as month, avg(pmbmao) as pmbmao from pm10_2015 where pmbmao > 0 group by month(datetime) ;

select month(date) as month, avg(pm10_dakar) as pm10_dakar from pm10_2015_daily_dakar where pm10_dakar > 0 group by month(date);

select pm10_dakar.month, pm10_dakar , pm10_bmao  
from (select month(date) as month, round(avg(pm10_dakar),2) as pm10_dakar from pm10_2015_daily_dakar where pm10_dakar > 0 group by month(date) ) as pm10_dakar,
     (select month(datetime) as month, round(avg(pmbmao),2) as pm10_bmao from pm10_2015 where pmbmao > 0 group by month(datetime) ) as pm10_bmao 
where pm10_dakar.month = pm10_bmao.month;