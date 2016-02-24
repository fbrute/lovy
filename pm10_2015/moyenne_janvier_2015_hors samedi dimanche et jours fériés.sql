

select  avg(pmbmao) as pm_daily , count(*) as nbvalues from pm10_2015 
where month(datetime) = 1 and pmbmao > 0 and day(datetime) > 2 
and jour <> "Samedi"
and jour <> "Dimanche" ;
# 18.12 for 364 valeurs horaires

select avg(pmbmao) as pm_daily , count(*) as nbvalues from pm10_2015 
where month(datetime) = 1 
 and pmbmao > 0 ;
 # 18.85 for 498 valeurs horaires