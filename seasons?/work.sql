set @area= 'Dakar';
set @year = 2012;

select * from  modtfregressions where area='Guadeloup' and year=2012 and aot_length = 440 and collection = 'c51';

delete from modtfregressions where area="Ragged_Point" and year in (2011,2012,2013,2014,2015);

SELECT n,ee from modtfregressions where area='Guadeloup' and year=2012 and algo='O' and resolution=50 and sat_origin='TERRA' and aot_length=870 and aotaround='aot1';

select * from modtfregressions where area = "Cape_San_Juan" and year=2012
order by year, area, aot_length, sat_origin desc, resolution;



delete from modtfregressions where area = "Guadeloup" and year = 2012 and aot_length=440;

truncate modtregressions;
create table save_modtfregressions_c51 like dbmeteodb.modtfregressions;

insert dbmeteodb.save_modtfregressions_c51 select * from  dbmeteodb.modtfregressions;

truncate table modtfregressions;

drop table save_modtregressions_c51;


select * from  modisL2 where area='Guadeloup' and year(date)=2012 and aot_length = 470;

select distinct aot_length from modisl2;

truncate modisL2;

select distinct year from pm10;

delete from modisL2 where area='Guadeloup' and aot_length=860 and year(date)=2012;

select distinct * from aotv1500 where area = "Ragged_Point";

truncate modtfregressions;
truncate modisl2;

select * from modisL2 where date = "2012-06-01" and area ='Guadeloup' and resolution = 100 and sat_origin='TERRA'
 and aot_length=860;

create table dbmeteodbtest.sites like dbmeteodb.sites;

insert dbmeteodbtest.sites select * from dbmeteodb.sites;

select * from modisL2 where area = "Guadeloup" ;
describe modisL2;

describe modtfregressions;

delete from modisl2 where area = "Guadeloup" and year(date)=2015 and aot_length=470;

select date, time, julian_day, aot_1640 from aotv1500 where area = "Capo_Verde" and year(date) = 2012 order by date, time;

delete from modisL2 where area = "Dakar" and year(date)=2015;

select * from sites;
delete from modisL2 where area='Ragged_Point' and year(date) in (2011,2012,2013,2014,2015);

select date, time, aot_440 from aotv1500 where area = "Capo_Verde" and year(date)=2012;

select * from aotv1500 where area = "Guadeloup" and year(date) not in (2005,2006,2007,2008, 2009, 2010, 2011,2012,2015);
select aot_1640 from aotv1500 where area = "Cape_San_Juan" and year(date) = 2012 and aot_1640 != -1;
delete from aotv1500 where area = "Guadeloup" and year(date) = 2011;
select distinct date from aotv1500 where area = "Guadeloup" and year(date) = 2013;

delete from aotv1500 where area = "Guadeloup" and year(date) = 2011;


select distinct date from aotv1500 where area = "Dakar" and year(date) = 2011 and aot_500 > 0;

select * from modisL2 where sat_origin='TERRA' and area='Guadeloup' and resolution=50 and aot_length=860 and year(date)=2012;

truncate modisl2;
truncate modtfregressions;
select * from dbmeteodbtest.modisl2;
select distinct date from dbmeteodbtest.aotv1500;
describe modisl2;
select * from modisl2;

select * from dbmeteodbtest.modisl2;

select * from modisl2 where date = "2012-01-05" and area = "Guadeloup";
select * from sites;

select * from dbmeteodbtest.modisl2 where date ="2012-02-06";
select date, time, aot_500 from dbmeteodbtest.aotv1500 where date ="2012-01-15";

select * from aotv1500 where area ="Capo_Verde" and year(date) = 2012;

describe aotv1500;

select date, time from dbmeteodbtest.aotv1500 where date ="2012-03-29";
select * from dbmeteodbtest.aotv1500;

select distinct aot_length from modisL2;
select * from dbmeteodbtest.modisl2 where sat_origin = 'TERRA' and collection = 'c51' 
	and area = 'TestArea' and aot_length = 550 and resolution = 100;

select date, time , aot_500, aot_440 from dbmeteodbtest.aotv1500 where date = '2012-01-14' and area = 'TestArea';

drop table if exists dbmeteodbtest.modtfregressions;

create table dbmeteodbtest.modtfregressions like dbmeteodb.modtfregressions;

select * from dbmeteodb.modtfregressions;

select * from sounding1 where date="2012-07-01";

SELECT * from modtfregressions where area='Guadeloup' and year=2012 and algo='O' 
and collection = 'c51' order by aot_length, resolution, sat_origin, aotaround;

select distinct year(date) as year from sounding1 order by year asc;


select date, time, pressure, thte, mixr from sounding1 
	where time = "12:00:00" 
		and date = "2012-06-01"
		and pressure between 700 and 850 
	order by date,pressure desc;
    
 
 # to be used with mysql to account for variables
set @year = 2012, @month = 6, @day = 1, @date = "2012-06-01" , @time = "12:00:00";

# number of points for a profile
set @nbmin = 5;

# Select data for a special date
select date, time, pressure, thte, mixr from sounding1 
	where time = "12:00:00" 
		and date = @date
		and pressure between 700 and 850 
	order by date,pressure desc;
 
select date, count(date) as nb from sounding1 
	where time = @time
		and year(date) = @year 
		and month(date) = @month 
		and pressure between 700 and 850 
	group by date
	order by date;

#counts number of pressure values per day for a given year  
select avg(nb) as moyenne, std(nb) as ecart_type , min(nb) as min , max(nb) as max from  (
					select date, count(date) as nb from sounding1 
						where time = @time 
							and year(date) = @year 
							and pressure between 700 and 850 
						group by date
						order by date
				) as nbpressures;
                
#counts number of pressure values per day for a given month  
select avg(nb) as moyenne, std(nb) as ecart_type , min(nb) as min , max(nb) as max from  (
					select date, count(date) as nb from sounding1 
						where time = @time 
							and year(date) = @year 
							and month(date) = @month 
							and pressure between 700 and 850 
						group by date
                        having nb > nbmin
						order by date
				) as nbpressures;
                #group by month(date);
                

                        
select count(nbvalues) from  (
					select date, count(date) as nbvalues from sounding1 
						where time = @time 
							and year(date) = @year 
							and month(date) = @month 
							and pressure between 700 and 850 
						group by date
						order by date
				) as nbpressures
                group by count(nbvalues);
                #order by frequence desc;
                #limit 1;

# find most common value of number of points in a profile between 700 and 850 for a year
select count(nbvalues) as frequence  from (select date, count(date) as nbvalues from sounding1 
						where time = @time 
							and year(date) = @year 
							and month(date) = @month 
							and pressure between 700 and 850 
						group by date
				) as count
order by frequence desc;
#limit 1; 

  
# Create a date with the first day of the year
select makedate(2012,1);

# Adds an interval of 5 montths to the date
select date_add(makedate(2012,1), interval(6) -1 month);

select distinct date from sounding1 where year(date) = 2012 and month(date) = 7 and time = "12:00:00" and pressure = 777;


select distinct date from sounding1 where year(date) = 2012 and month(date) = 7 and time = "12:00:00";

select max(pressure) as max_pressure , min(pressure) as min_pressure from sounding1;

describe sounding1;


select pressure, pressure / 5 as index_number, thte, mixr from sounding1 where date between "2012-06-01" and "2012-06-02" 
and time = "12:00:00";

select pressure, floor(pressure / 5) as index_number, thte, mixr from sounding1 where date between "2012-06-01" and "2012-06-02" 
and time = "12:00:00";

select floor(pressure / 5) as index_number, avg(thte) as thte_avg, avg(mixr) mixr_avg from sounding1 
	where year(date) = 2012 and month(date) = 6 and day(date) between 1 and 2 and time = "12:00:00"
	group by index_number;
    
select index_number * 5 as pressure , thte_avg, mixr_avg from (select floor(pressure / 5) as index_number, avg(thte) as thte_avg, avg(mixr) mixr_avg from sounding1 
	where year(date) = 2012 and month(date) = 6 and day(date) between 1 and 2 and time = "12:00:00"
	group by index_number) as meanProfiles;
    
    select index_number * 5 as pressure , thte_avg, mixr_avg from (select floor(pressure / 5) as index_number, avg(thte) as thte_avg, avg(mixr) mixr_avg from sounding1 where year(date) = 2012 and month(date) = 6 and day(date) between 1 and 2 and time = '12:00:00' group by index_number) as meanProfiles;
    
    select month, index_number * 5 as pressure , thte_avg, mixr_avg from 
    (select month(date) as month, floor(pressure / 5) as index_number, avg(thte) as thte_avg, avg(mixr) mixr_avg 
		from sounding1 where year(date) = 2012 and time = '12:00:00' group by month(date),index_number) as meanProfiles;
        

select month, index_number *  10 as pressure , thte_avg, mixr_avg from (select month(date) as month, floor(pressure / 10 ) as index_number, avg(thte) as thte_avg, avg(mixr) mixr_avg from sounding1 where year(date) between year( '2012-06-01' ) and year( '2012-06-02' ) and time = '12:00:00' group by month(date),index_number) as meanProfiles;

select month, index_number *  10 as pressure , thte_avg, mixr_avg from (select month(date) as month, floor(pressure / 10 ) as index_number, avg(thte) as thte_avg, avg(mixr) mixr_avg from sounding1 where year(date) between year( '2012-06-01' ) and year( '2012-06-02' ) and time = '12:00:00' and pressure between 20 and 1020 group by month(date),index_number) as meanProfiles;

create table ex_dates_sounding like  ex_dates;

select * from ex_dates_sounding;

select * from ex_dates_sounding where date = "2005-01-27" ;

insert into ex_dates_sounding (date) values('2012-02-07'),('2008-05-23'),('2008-05-09'),('2012-08-19'),('2010-09-28'),('2011-11-03'),
	('2007-06-14'),('2005-01-27'),('2009-06-05'),('2013-05-15'),('2005-06-12'),('2005-09-06'),('2005-09-25'),('2008-08-02'),('2015-06-12');

select * from ex_dates_sounding order by date;

select date(datetime) as date, avg(pmptp) as pmptp from pm10 where year(datetime) = 2012 and month(datetime) = 1 
	group by date;


select distinct date from sounding1 where year(date) = 2005 and month(date) = 1 and date not in (select date from ex_dates_sounding);

select distinct date from sounding1 where pressure = 850 and time = "12:00:00" and year(date) = 2012 and month(date) = 6 order by date;

describe sounding1;

describe pm10;

select index_number *  25 as pressure , temp, mixr, relhumidity, windspeed from (select floor(pressure / 25 ) as index_number, avg(temp) as temp, avg(mixr) as mixr, avg(relhumidity) as relhumidity , avg(snkt) as windspeed from sounding1 where date = (select date from pm10 group by date having avg(pmptp) >= 35) and date not in (select date from ex_dates_sounding) and year(date) between year( 2005-01-01 ) and year( 2015-12-31 ) and month(date) in (1,2,12) and time = '12:00:00' and pressure between 50 and 1020 group by index_number) as meanProfiles;


select sounding1.date, pressure , temp , mixr, relhumidity, snkt as windspeed , pm10 from sounding1 , (select date(datetime) as date , avg(pmptp) as pm10 from pm10 group by date) as pm10avg where sounding1.date between 2005-01-01 and '2015-12-31' and sounding1.date = pm10avg.date order by date;