/* All Data is gathered off CitiBike NYC website and is for research purposes only
https://ride.citibikenyc.com/system-data */

select count distinct(*)
from citibike_2019

--looks at the popularity of the most common routes
select distinct(concat(start_station_id,end_station_id)), count (*)
from citibike_2019
group by 1
order by 2 desc

select concat(start_station_id, end_station_id) route_clf , start_station_id, end_station_id, count(*)
from public.capitalbikeshare_2016
group by 1,2, 3
-- ordering by count of trips taking that route
order by 4 desc
-- limiting to top 100 routes taken
limit 100;

select *
from(
	select *, (start_time - bike_dropped_of_at) duration_before_ride
	from(
		select *,
		lag(end_time, 1) over(partition by bikeid) as bike_dropped_of_at,
		lag(end_station_id, 1) over(partition by bikeid) as bike_station_dropped_off_at
		from(
			select dvt.trip_id, dvt.bikeid, dvt.start_time, dvt.end_time, dvt.start_station_id,
					dvt.end_station_id, dvss.id as start_station_reference_id,  dvse.id as end_station_reference_id,
					dvss.latitude as start_latitude, dvss.longitude as start_longitude, dvss.name as start_name, 
					dvss.docks as start_docks, 
					dvse.latitude as end_latitude, dvse.longitude as end_longitude, dvse.name as end_name, 
					dvse.docks as end_docks
			from public.divvybikes_2016 dvt
			left join public.divvy_stations dvss
			on dvt.start_station_id = dvss.id
			left join public.divvy_stations dvse
			on dvt.end_station_id = dvse.id
			--where bikeid = 872 -- take out filter when ready to party
			order by bikeid, start_time
) t1 -- create exact view, joining reference material dvt == divvy trips dvss == reference stations start dvse == reference stations end
) t2 -- lag both end time and end station to next trip also filtering for start station == end station from last record
	where start_station_id = bike_station_dropped_off_at
) t3 -- checking for positive interval
where duration_before_ride >= '00:00:00'
limit 100

--look at subscriber v customer % change over time

select distinct(concat(start_station_id,end_station_id)), count (*)
from citibike_2016
group by 1
order by 2 desc

select concat(start_station_id, end_station_id) route_clf , start_station_id, end_station_id, count(*)
from public.capitalbikeshare_2016
group by 1,2, 3
order by 4 desc
-- limiting to top 100 routes taken
limit 100;

select count(*)
from citibike_2016;

--calculate percentage change in ridership 2016-2019
select round(("2017"-"2016")/"2016",2) "16/17_change",
	round(("2018"-"2017")/"2017",2) "17/18_change",
	round(("2019"-"2018")/"2018",2) "18/19_change"
from
(
select count(*) as "2016", 
	(select count(*)::numeric from citibike_2017) as "2017",
	(select count(*)::numeric from citibike_2018) as "2018",
	(select count(*)::numeric from citibike_2019) as "2019"
from citibike_2016
) t1

/* Querys below create tables and pull from locally stored zip files downloaded from CitiBike website 
Goal is to create two large raw data table to be used in conjunction with 2019 data

--DATABASE creation process--
--create table change cb_MONTH_YYYY_jc
--import csv files from citibike
--took headers from CSV file, transposed in excel, 
--pasted code, added data type manually
--saved new month table as cb_MON_YYYY_cleaned
--unioned all tables into a single 2022 table = cb_2022_ALL */

--===================================
--Create all tables (import from files)


--create jan table		
create table cb_jan_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_jan_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202201-citibike-tripdata.csv' delimiter ',' csv header

--create feb table 
create table cb_feb_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_feb_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202202-citibike-tripdata.csv' delimiter ',' csv header

create table cb_mar_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_mar_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202203-citibike-tripdata.csv' delimiter ',' csv header

create table cb_apr_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_apr_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202204-citibike-tripdata.csv' delimiter ',' csv header

create table cb_may_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_may_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202205-citibike-tripdata.csv' delimiter ',' csv header


create table cb_jun_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_jun_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202206-citbike-tripdata.csv' delimiter ',' csv header

create table cb_jul_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_jul_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202207-citbike-tripdata.csv' delimiter ',' csv header

create table cb_aug_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_aug_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202208-citibike-tripdata.csv' delimiter ',' csv header


create table cb_sep_2022_NYC(
ride_id text,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_sep_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202209-citibike-tripdata.csv' delimiter ',' csv header

create table cb_oct_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_oct_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202210-citibike-tripdata.csv' delimiter ',' csv header


create table cb_nov_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_nov_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202211-citibike-tripdata.csv' delimiter ',' csv header


create table cb_dec_2022_NYC(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_dec_2022_NYC (ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\202212-citibike-tripdata.csv' delimiter ',' csv header

/* Union all the tables created above */
create table all_nyc_raw_data_2022 as 
select *
from cb_jan_2022_nyc
union all
select *
from cb_feb_2022_nyc
union all
select *
from cb_mar_2022_nyc
union all
select *
from cb_apr_2022_nyc
union all
select *
from cb_may_2022_nyc
union all
select *
from cb_jun_2022_nyc
union all
select *
from cb_jul_2022_nyc
union all
select *
from cb_aug_2022_nyc
union all
select *
from cb_sep_2022_nyc
union all
select *
from cb_oct_2022_nyc
union all
select *
from cb_nov_2022_nyc
union all
select *
from cb_dec_2022_nyc

select count (*)
from public.all_nyc_raw_data_2022
--30689921 rows of data

--Datacheck count all by month
SELECT DATE_PART('month', started_at) AS date_Month, COUNT (*)
FROM public.all_nyc_raw_data_2022
GROUP BY 1
order by 1 
--=================================================================
--Create all tables with 2022 downloaded jersey city citybike data
--=================================================================

create table cb_jan_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
)

copy cb_jan_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202201-citibike-tripdata.csv' delimiter ',' csv header

create table cb_feb_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_feb_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202202-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_mar_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_mar_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202203-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_apr_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_apr_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202204-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_may_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_may_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202205-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_jun_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_jun_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202206-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_jul_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_jul_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202207-citbike-tripdata.csv' delimiter ',' csv header;

create table cb_aug_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_aug_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202208-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_sep_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_sep_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202209-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_oct_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_oct_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202210-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_nov_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_nov_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202211-citibike-tripdata.csv' delimiter ',' csv header;

create table cb_dec_2022_jc(
ride_id text PRIMARY KEY,
rideable_type text,
started_at timestamp,
ended_at timestamp,
start_station_name text,
start_station_id text,
end_station_name text,
end_station_id text,
start_lat numeric,
start_lng numeric,
end_lat numeric, 
end_lng numeric,
member_casual text
);

copy cb_dec_2022_jc(ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, 
					  end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
)
from 'C:\Users\18587\OneDrive\Desktop\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC-202212-citibike-tripdata.csv' delimiter ',' csv header;



--============================================================================
/*  create new jersey city only table*/

create table jc_raw_data_2022 as 
select *
from public.cb_jan_2022_jc
union all
select *
from public.cb_feb_2022_jc
union all
select *
from public.cb_mar_2022_jc
union all
select *
from public.cb_apr_2022_jc
union all
select *
from public.cb_may_2022_jc
union all
select *
from public.cb_jun_2022_jc
union all
select *
from public.cb_jul_2022_jc
union all
select *
from public.cb_aug_2022_jc
union all
select *
from public.cb_sep_2022_jc
union all
select *
from public.cb_oct_2022_jc
union all
select *
from public.cb_nov_2022_jc
union all
select *
from public.cb_dec_2022_jc;





--======================================================================================
/*NORMALIZE ALL DATA FROM JC_DATA_2022 TO MATCH GA SERVER */

ALTER TABLE table_name RENAME COLUMN old_name TO new_name;  --Change the column name
ALTER TABLE table_name												   --Change the column type
	ALTER COLUMN column_name [SET DATA] TYPE new_data_type;

ALTER TABLE public.jc_raw_data_2022 RENAME started_at TO start_time;
ALTER TABLE public.jc_raw_data_2022 RENAME ended_at TO stop_time;
ALTER TABLE public.jc_raw_data_2022 RENAME member_casual TO user_type;
ALTER TABLE public.jc_raw_data_2022 ADD COLUMN birth_year INT;
ALTER TABLE public.jc_raw_data_2022 ADD COLUMN gender INT;
ALTER TABLE public.jc_raw_data_2022 ADD COLUMN bike_id INT;

ALTER TABLE public.jc_raw_data_2022												   
	ALTER COLUMN start_station_id TYPE int;
	
SELECT *
FROM public.citibike_2019


--======================================================================================
--Need to re-import 2019 data from GA server
--======================================================================================

--create 2019 table
create table preunionjc_raw_data_2019(
start_time timestamp,
stop_time timestamp,
start_station_id int,
end_station_id int,
bike_id int,
user_type text,
birth_year int,
gender int
);

copy preunionjc_raw_data_2019 (start_time, stop_time, start_station_id, end_station_id, bike_id, user_type, birth_year, gender)
from 'C:\Users\18587\OneDrive\Documents\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC_CityBike_2019_Data_GA.csv' delimiter ',' csv header;

--create station table
create table preunionGA_jc_raw_data_2019(
id int,
latitude numeric,
longitude numeric,
name text,
docks int);

copy preunionGA_jc_raw_data_2019 (id, latitude, longitude, name, docks)
from 'C:\Users\18587\OneDrive\Documents\Data Analytics Immersive\Week 4\2022 Citibike Data\2022 Extracted\JC_citibike_Stations_GASERVER.csv' delimiter ',' csv header;

with 
t1 as (
	select start_station_name as list_2022_names
	from public.jc_raw_data_2022
),
t2 as (
	select name as list_2019_names
	from public.preunionga_jc_raw_data_2019
) 
select t1.list_2022_names, t2.list_2019_names
from t1,t2
order by 1,2 asc

--create jc cleaned table
/*create table jc_raw_data_2022(
start_time timestamp,
stop_time timestamp,
start_station_id int,
end_station_id int,
bike_id int,
user_type text,
birth_year int,
gender int,
id int,
latitude numeric,
longitude numeric,
name text,
docks int); */


select *
from public.preunionjc_raw_data_2019 b
	join public.preunionga_jc_raw_data_2019 a
	on b.start_station_id= a.id 
limit 100


create view all_data_2022 as
select concat(bike_id,'-',ride_id) as identifier,start_time,stop_time,start_station_name,start_lat,
	start_lng,end_station_name,end_lat,end_lng,user_type
from public.jc_raw_data_2022



create view all_data_2019 as	
select concat(c.bike_id,'-',ece.id) as identifier, c.start_time,c.stop_time, 
	ecs.name start_name, ecs.latitude start_latitude, ecs.longitude start_longitude, -- starting
	ece.name end_name, ece.latitude end_latitude, ece.longitude end_longitude,
	c.user_type-- ending
from public.preunionjc_raw_data_2019 c
	join public.preunionga_jc_raw_data_2019 ecs -- station copy 1 -- ecs
	on c.start_station_id = ecs.id
	join public.preunionga_jc_raw_data_2019 ece -- stations copy 2 -- ece
	on c.end_station_id = ece.id
																																			

--======================================================================================
--ANALYSIS
--======================================================================================

--How has total ridership changed in Jersey city in 2022?

select count(*)
from public.jc_raw_data_2022;

--895,485 total rides

--what is the breakdown of subscribers v users?

SELECT COUNT(*),
	(SELECT count(*)
	 from public.jc_raw_data_2022
	 where member_casual ilike 'member')
	 as member_num,
	 (select count(*)
	 from public.jc_raw_data_2022
	 where member_casual ilike 'casual')
	 as casual_num
from public.jc_raw_data_2022

with
t1 as (
	select count(*) as NumA
	 from public.jc_raw_data_2022
	 where member_casual ilike 'member'
),
t2 as (select count(*) as NumB
	 from public.jc_raw_data_2022
	 where member_casual ilike 'casual'
),
t3 as (
	select count(*) as numc
	from public.jc_raw_data_2022	   
				   )
SELECT numc, ROUND(T1.NumA::numeric / T3.Numc::numeric * 100,2) as MemPCT,
			ROUND(T2.Numb::numeric / T3.Numc::numeric * 100,2) as CasPCT
from t1,t2,t3

--JC 2022 out of 895,485 rides 65.75% were members and 34.25% were casual

Select end_station_name, count(*)
from public.jc_raw_data_2022
group by 1
order by 2 desc

select count (*)
from public.all_data_2019
where start_time is null


