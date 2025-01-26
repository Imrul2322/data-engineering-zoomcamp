DOCKER run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v c:/Users/mdimr/Documents/Datatalks/Week\ 1/nytaxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg_network \
    --name pg_database postgres:latest

docker run -it \
    -p 8080:80 \
    -e PGADMIN_DEFAULT_EMAIL='imrulkaish007@gmail.com' \
    -e PGADMIN_DEFAULT_PASSWORD='root' \
    --network=pg_network \
    --name pg_admin \
     dpage/pgadmin4


URL="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"

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



url_trip="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"
url_zone="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"