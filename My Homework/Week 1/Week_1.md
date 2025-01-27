-- creating postgres database and pgadmin containers

services:
  pg-database:
    image: postgres:latest

    environment:
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=ny_taxi

    volumes:
      - ./nytaxi_postgres_data:/var/lib/postgresql/data:rw

    ports:
      - 5432:5432
  
  pg-admin:
    image: dpage/pgadmin4

    environment:
      - PGADMIN_DEFAULT_EMAIL=imrulkaish007@gmail.com
      - PGADMIN_DEFAULT_PASSWORD=root

    ports:
      - 8080:80



-- ingest data

docker build -t taxi_data_ingest:v001 .

docker run -it \
    --network=week1_default \
    taxi_data_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table1_name=green_taxi_trips \
    --table2_name=zone_table \
    --url_trip=${url_trip} \
    --url_zone=${url_zone}


-- SQL query to find answers

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