--Integer Range partitioning

select id,text,score,creation_date from bigquery-public-data.stackoverflow.comments;

select max(id) from bigquery-public-data.stackoverflow.comments; --130390264

select min(id) from bigquery-public-data.stackoverflow.comments; --10

--Create partitioned table

create or replace table bigquery_features.stackoverflow_comments_p (id INT64,text STRING,score INT64,creation_date TIMESTAMP)
partition by RANGE_BUCKET(id, GENERATE_ARRAY(0, 130390264 , 100000));

--Insert Data into partitioned table

insert into bigquery_features.stackoverflow_comments_p select id,text,score,creation_date 
from bigquery-public-data.stackoverflow.comments;


--Query non-partioned table
--This query will process 14.73 GB when run

select id,text,score,creation_date from bigquery-public-data.stackoverflow.comments
where id between 1000 and 100000;


--Query Partitioned table
--This query will process 16.69 MB when run

select id,text,score,creation_date from bigquery_features.stackoverflow_comments_p
where id between 1000 and 100000;






