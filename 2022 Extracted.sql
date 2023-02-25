/* All Data is gathered off CitiBike NYC website and is for research purposes only
https://ride.citibikenyc.com/system-data */
--==================================================================================================


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

--==================================================================================================
/* Querys below create tables and pull from locally stored zip files downloaded from CitiBike website 
Goal is to create one large raw data table to be used in conjunction with previous years of data 

--DATABASE creation process--
--create table change cb_MONTH_YYYY_NYC
--import csv files from citibike
--took headers from CSV file, transposed in excel, 
--pasted code, added data type manually
--saved new month table as cb_MON_YYYY_cleaned
--unioned all tables into a single 2022 table = cb_2022_ALL */


--==================================================================================================
/* Create 12 tables for each month in NYC  */
			
			
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

--==================================================================================================
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

--==================================================================================================
/*Create all tables with 2022 downloaded jersey city citybike data */

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

--==================================================================================================
/* Union all data from jersey city and NYC */

create table nyc_raw_data_2022 as 
select *
from public.all_nyc_raw_data_2022
union all
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

--result = 31,585,406 rows affected

--==================================================================================================
/* Query the number of rides per month */

SELECT DATE_PART('month', started_at) AS date_Month, COUNT (*)
FROM public.nyc_raw_data_2022
GROUP BY 1
order by 1 
limit 1;
