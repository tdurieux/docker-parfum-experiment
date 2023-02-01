FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y git libpython2.7-dev libpq-dev python-psycopg2 python-pip && rm -rf /var/lib/apt/lists/*;

RUN git clone -q https://github.com/zalando/PGObserver.git

WORKDIR PGObserver/extra_features/influxdb_adapter

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python2", "export_to_influxdb.py", "-v"]
