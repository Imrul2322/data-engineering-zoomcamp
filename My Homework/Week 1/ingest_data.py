

import os
import pandas as pd
from sqlalchemy import create_engine
import argparse

def main(params):

    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table1_name = params.table1_name
    table2_name = params.table2_name
    url_trip = params.url_trip
    url_zone = params.url_zone
    csv1_name = 'green_tripdata.csv.gz'
    csv2_name = 'zone_lookup.csv'

    os.system(f"wget {url_trip} -O {csv1_name}")
    os.system(f"wget {url_zone} -O {csv2_name}")

    df_trip = pd.read_csv(csv1_name, compression='gzip')
    df_zone = pd.read_csv(csv2_name)

    df_trip.lpep_pickup_datetime = pd.to_datetime(df_trip.lpep_pickup_datetime)
    df_trip.lpep_dropoff_datetime = pd.to_datetime(df_trip.lpep_dropoff_datetime)

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    engine.connect()

    df_trip.to_sql(name=table1_name, con=engine, if_exists="replace")
    df_zone.to_sql(name=table2_name, con=engine, if_exists="replace")



if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Ingest parquet file to Postgres')

    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for posrgres')
    parser.add_argument('--host', help='hostname for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name for postgres')
    parser.add_argument('--table1_name', help='name of the table where we will write trip data')
    parser.add_argument('--table2_name', help='name of the table where we will write zone data')
    parser.add_argument('--url_trip', help='url of the trip file')
    parser.add_argument('--url_zone', help='url of the zone file')

    args = parser.parse_args()

    main(args)








