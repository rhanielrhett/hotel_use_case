-- 1. Query the air quality and geolocation data
WITH air_quality_data AS (
  SELECT
    latitude,
    longitude,
    arithmetic_mean,
    aqi,
    ST_GeogPoint(longitude, latitude) AS air_quality_point
  FROM
    bigquery-public-data.epa_historical_air_quality.o3_daily_summary
  WHERE
    EXTRACT(YEAR FROM date_local) = 2018
)

-- 2. Determine the aggregating block for polulation
, block_group_geometries AS (
  SELECT
    geo_id AS blockgroup_ce,
    blockgroup_geom
  FROM
    bigquery-public-data.geo_census_blockgroups.us_blockgroups_national
)

-- 3. Create bucketing for the air quality by the locational aggregator
, air_quality_with_block_groups AS (
  SELECT
    bg.blockgroup_ce,
    CASE
      WHEN aqi <= 50 THEN '0-50'      -- Good
      WHEN aqi <= 100 AND aqi > 50 THEN '51-100'    -- Moderate
      WHEN aqi <= 150 AND aqi > 100 THEN '101-150'   -- Unhealthy for Sensitive Groups
      WHEN aqi <= 200 AND aqi > 150 THEN '151-200'    -- Unhealthy
      WHEN aqi <= 300 AND aqi > 200 THEN '201-300'   -- Very Unhealthy
      ELSE '301+'                                    -- Hazardous
    END AS aqi_bucket,
    COUNT(*) AS num_records
  FROM
    air_quality_data aq
  JOIN
    block_group_geometries bg
  ON
    ST_Intersects(aq.air_quality_point, bg.blockgroup_geom)
  GROUP BY
    bg.blockgroup_ce,
    aqi_bucket
)

-- 4. Query the population data
, population_data AS (
  SELECT
    geo_id AS blockgroup_ce,
    total_pop
  FROM
    bigquery-public-data.census_bureau_acs.blockgroup_2018_5yr
)

-- 5. Aggregate the population data by the geo_id
, aqi_population AS (
  SELECT
    aq.blockgroup_ce,
    aq.aqi_bucket,
    SUM(pop.total_pop) AS total_population
  FROM
    air_quality_with_block_groups aq
  JOIN
    population_data pop
  ON
    aq.blockgroup_ce = pop.blockgroup_ce
  GROUP BY
    aq.blockgroup_ce,
    aq.aqi_bucket
)

-- 6. Generate the final table containing the air quality buckets and population
SELECT
  aqi_bucket,
  SUM(total_population) AS total_population,
  ROUND(SUM(total_population) / SUM(SUM(total_population)) OVER () * 100, 2) AS population_percentage
FROM
  aqi_population
GROUP BY
  aqi_bucket
ORDER BY
  aqi_bucket;
