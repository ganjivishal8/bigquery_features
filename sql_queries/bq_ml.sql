
/******* BigQuery ML *******/
/**Linear Regression

Linear Regression is statistical method commonly used for predicting numerical values based on input features and understanding the linear relationship between variables.

Model Building Process

Model Training: Use SQL syntax to train a linear regression model on the dataset, specifying the target variable and input features.
Model Evaluation: Evaluate the trained model's performance using metrics such as RMSE (Root Mean Square Error) or R-squared value to assess its predictive accuracy.
Prediction: Deploy the trained model to generate predictions for new data inputs.

**/

/**Example Usecase

Predicting the trip duration time between two stations

**/

---Training Data table
create or replace table bigquery_features.biketrip_train as
select
*
from bigquery-public-data.austin_bikeshare.bikeshare_trips
where extract(year from start_time)=2016;

--Evaluation Data table
create or replace table bigquery_features.biketrip_eval as
select
*
from bigquery-public-data.austin_bikeshare.bikeshare_trips
where extract(year from start_time)=2017 and(extract(month from start_time)=01 or extract(month from start_time)=02);

--Prediction Data table
create or replace table bigquery_features.biketrip_predict as
select
*
from bigquery-public-data.austin_bikeshare.bikeshare_trips
where extract(year from start_time)=2017 and(extract(month from start_time)=03);

--Creating ML model
create or replace model bigquery_features.trip_duration_by_station_and_day
options
(model_type='linear_reg') as
select
start_station_name,end_station_name,if(extract(day from start_time)=1 or extract(day from start_time)=7,true,false) is_weekend,
duration_minutes as label
from
`bigquery_features.biketrip_train`;

--Evaluating the model
select * from ml.evaluate(MODEL bigquery_features.trip_duration_by_station_and_day,(
  select
start_station_name,end_station_name,if(extract(day from start_time)=1 or extract(day from start_time)=7,true,false) is_weekend,
duration_minutes as label
from
`bigquery_features.biketrip_eval`
));

--Predicting the values using ML model
select start_station_name,end_station_name,duration_minutes as actual_duration, predicted_label as predicted_duration, abs(duration_minutes-predicted_label) as diff_min
from ml.predict(MODEL `bigquery_features.trip_duration_by_station_and_day`,(
  select
start_time,start_station_name,end_station_name,if(extract(day from start_time)=1 or extract(day from start_time)=7,true,false) is_weekend,
duration_minutes
from
`bigquery_features.biketrip_predict`
))
order by diff_min asc
;



-- select distinct extract(month from start_time) month from bigquery-public-data.austin_bikeshare.bikeshare_trips
-- where extract(year from start_time)=2017
-- order by month asc
-- ;
