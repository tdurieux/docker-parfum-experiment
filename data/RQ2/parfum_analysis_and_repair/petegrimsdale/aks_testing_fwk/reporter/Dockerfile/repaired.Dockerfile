FROM ubuntu:18.04

RUN		apt-get -y update && apt-get -y upgrade		
RUN apt-get -y --no-install-recommends install wget gnupg curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
 apt-get install --no-install-recommends -y influxdb && \
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - && \
#add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" && \
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list && \
apt-get  update && \
 apt-get install --no-install-recommends grafana -y && \
update-rc.d grafana-server defaults && \
 apt-get install --no-install-recommends influxdb-client -y && rm -rf /var/lib/apt/lists/*;


# Grafana
EXPOSE	3000

# InfluxDB Admin server
EXPOSE	8083

# InfluxDB HTTP API
EXPOSE	8086

# InfluxDB HTTPS API
EXPOSE	8084

# -------- #
#   Run!   #
# -------- #

ENTRYPOINT service influxdb start && service grafana-server start
