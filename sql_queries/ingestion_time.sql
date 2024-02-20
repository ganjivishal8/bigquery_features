/***Ingestion Time Partitioning***/

create or replace table bigquery_features.biketrip_ingestion_pt (trip_id string,
)
partition by timestamp_trunc(_PARTITIONTIME,HOUR);


--Inserting partition time manually

insert into `bigquery_features.biketrip_ingestion_pt`(_PARTITIONTIME,trip_id) select TIMESTAMP("2021-04-15 08:00:00") ,trip_id from `bigquery_features.bike_trips`;


INSERT INTO
  bigquery_features.biketrip_ingestion_p (_PARTITIONTIME,
    trip_id)
SELECT
  TIMESTAMP("2017-05-01 00:01:02"),
  '123';


SELECT _PARTITIONTIME AS pt, * FROM `data-project-406509.bigquery_features.biketrip_ingestion_pt`;

