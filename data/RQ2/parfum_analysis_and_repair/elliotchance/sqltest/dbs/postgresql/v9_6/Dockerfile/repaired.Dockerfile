FROM postgres:9.6

RUN apt-get update && apt-get install --no-install-recommends -y python-psycopg2 python-pip libyaml-dev libpython2.7-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyyaml
