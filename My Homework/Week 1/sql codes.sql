SELECT * FROM public.green_taxi_trips;

--Q3: Count Records
SELECT COUNT(*) FROM green_taxi_trips
WHERE DATE(lpep_pickup_datetime) = '2019-10-18'
AND DATE(lpep_dropoff_datetime) = '2019-10-18';

--Q4: Longest trip
SELECT DATE(lpep_pickup_datetime), MAX(trip_distance)
FROM green_taxi_trips
GROUP BY 1
ORDER BY 2 DESC;

-- Q5: biggest pickup zones
SELECT zones."Zone" AS pickup_zone, SUM(trips."total_amount")
FROM green_taxi_trips trips
JOIN zone_table zones ON trips."PULocationID" = zones."LocationID"
WHERE DATE(trips.lpep_pickup_datetime) = '2019-10-18'
GROUP BY 1
ORDER BY 2 DESC;

-- Q6. Largest Tip
WITH Temp AS (
SELECT zones."Zone" AS pickup_zone, zones1."Zone" AS dropoff_zone, trips.tip_amount
FROM green_taxi_trips trips
JOIN zone_table zones ON trips."PULocationID" = zones."LocationID"
JOIN zone_table zones1 ON trips."DOLocationID" = zones1."LocationID"
WHERE (EXTRACT(MONTH FROM trips.lpep_pickup_datetime) = 10
AND EXTRACT(YEAR FROM trips.lpep_pickup_datetime) = 2019))

SELECT dropoff_zone, tip_amount AS total_tip FROM Temp 
WHERE pickup_zone = 'East Harlem North'
ORDER BY 2 DESC;