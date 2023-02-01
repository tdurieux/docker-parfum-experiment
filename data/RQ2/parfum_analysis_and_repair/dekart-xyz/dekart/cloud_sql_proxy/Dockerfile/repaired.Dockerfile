FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
RUN chmod +x cloud_sql_proxy

CMD ./cloud_sql_proxy -instances=${INSTANCE_CONNECTION_NAME}=tcp:0.0.0.0:5432