set @seuil = 27;
select year(date) as year, month(date) as month, count(*) as nb_sup_equal_27 from pm10madalov where pm10>=@seuil group by year,month;
