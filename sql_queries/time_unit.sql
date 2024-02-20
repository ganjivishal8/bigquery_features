/************ Time Unit Partitioning ***********/

select min(start_time),max(start_time) from bigquery_features.bike_trips;

-- 2013-12-12 16:48:46 UTC , 2023-12-31 23:50:25 UTC

select date_trunc(start_time,DAY) as year,count(*) from bigquery_features.bike_trips
group by 1 order by 1;

select date_trunc(start_time,MONTH) as year,count(*) from bigquery_features.bike_trips
group by 1 order by 1;

select date_trunc(start_time,YEAR) as year,count(*) from bigquery_features.bike_trips
group by 1 order by 1;

--Creating a partitioned table

create or replace table bigquery_features.biketrips_time_p
(trip_id string,
subscriber_type string,
bike_id string,
bike_type string,
start_time timestamp,
start_station_id int64,
start_station_name string,
end_station_id string,
end_station_name string,
duration_minutes int64
)
partition by timestamp_trunc(start_time,MONTH);

--Insert data into partitioned tables

insert into `bigquery_features.biketrips_time_p` select * from `bigquery_features.bike_trips`;


--Query non partitioned table

select * from `bigquery_features.bike_trips`
where start_time > '2020-12-01 00:00:00 UTC';

--Query partitioned table
select * from `bigquery_features.biketrips_time_p`
where start_time > '2020-12-01 00:00:00 UTC';

