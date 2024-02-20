
/*** BigQuery GIS ***/


/** Example UseCase
I am retail merchandise store owner who wants to exapnd my business in different areas in 15 miles radius, I want to know age group of people with higher population in every area so that I can target my audience easily
**/

--NewYork city square

with
params as (
  select
  -- -73.985130 as lon,
  -- 40.758896 as lat,
  -122.3321 as lon,
  47.6062 as lat,
  15 as radius
),

zipcodes_within_distance as(
  select 
  zipcode
  from
  bigquery-public-data.utility_us.zipcode_area as zip_area,params
  where
  st_dwithin(st_geogpoint(params.lon,params.lat),st_geogpoint(zip_area.longitude,zip_area.latitude),1609 * params.radius)
  
),

stats_by_zipcode as (
  select
    zipcode,
    sum(if (gender = '' and minimum_age is null and maximum_age is null , population, 0)) as total,
    sum(if (gender = 'female' and minimum_age is null and maximum_age is null , population, 0)) as total_female,
    sum(if (gender = 'male' and minimum_age is null and maximum_age is null , population, 0)) as total_male,
    sum(if (maximum_age <= 24, population,0)) as population_0_24,
    sum(if (minimum_age >= 25 and maximum_age <= 44, population,0)) as population_25_44,
    sum(if (minimum_age >= 45 and maximum_age <= 64, population,0)) as population_45_64,
    sum(if (maximum_age >= 65, population,0)) as population_65_plus,

  from bigquery-public-data.census_bureau_usa.population_by_zip_2010 as zip_census
  where zipcode in (select zipcode from zipcodes_within_distance)

  group by zipcode

)

select s.*, st_geogfromtext(z.zipcode_geom)geo
from stats_by_zipcode s
join bigquery-public-data.utility_us.zipcode_area z
on s.zipcode = z.zipcode

