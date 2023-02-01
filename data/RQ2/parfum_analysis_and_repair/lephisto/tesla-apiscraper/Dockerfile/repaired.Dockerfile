# Dockerfile for standalone usage
FROM debian:stretch-slim

RUN apt-get -y update

# Install Python
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gnupg2 && rm -rf /var/lib/apt/lists/*;

# Install Influx
RUN curl -f -sL https://repos.influxdata.com/influxdb.key | apt-key add -
RUN echo "deb https://repos.influxdata.com/debian stretch stable" | tee /etc/apt/sources.list.d/influxdb.list
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install influxdb && rm -rf /var/lib/apt/lists/*;

# Install Grafana
RUN curl -f https://packages.grafana.com/gpg.key | apt-key add -
RUN echo "deb https://packages.grafana.com/oss/deb stable main" | tee /etc/apt/sources.list.d/grafana.list
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install grafana && rm -rf /var/lib/apt/lists/*;

# Install Node
RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Grafana addons
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
WORKDIR /var/lib/grafana/plugins
RUN git clone https://github.com/lephisto/grafana-trackmap-panel
WORKDIR /var/lib/grafana/plugins/grafana-trackmap-panel
RUN git checkout v2.0.4-teslascraper
RUN npm install && npm cache clean --force;
RUN npm audit fix
RUN npm run build
RUN grafana-cli plugins install natel-discrete-panel

# Install Tesla API Scraper
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
WORKDIR /
RUN git clone https://github.com/lephisto/tesla-apiscraper
RUN pip3 install --no-cache-dir influxdb

RUN git clone https://github.com/tkrajina/srtm.py
WORKDIR srtm.py
RUN python3 ./setup.py install
WORKDIR /

# Configure it
WORKDIR tesla-apiscraper
RUN git checkout v2019.5
RUN cp config.py.dist config.py

# Create temp files for dashboard API calls
RUN echo '{"dashboard":' > /tmp/TeslaMetricsV2.json
RUN cat ./grafana-dashboards/TeslaMetricsV2.json >> /tmp/TeslaMetricsV2.json
RUN echo '}' >> /tmp/TeslaMetricsV2.json
RUN sed -i 's/\${DS_TESLA}/InfluxDB/g' /tmp/TeslaMetricsV2.json

# Install Grafana data source and dashboards
RUN service grafana-server start ; sleep 5 && \
  curl -f -v -H 'Content-Type: application/json' -d @./grafana-datasources/influxdb.json https://admin:admin@localhost:3000/api/datasources && \
  curl -f -v -H 'Content-Type: application/json' -d @/tmp/TeslaMetricsV2.json https://admin:admin@localhost:3000/api/dashboards/db && \
  service grafana-server stop

RUN sed -i "s/a_influxpass = '<influxdbpassword>'/a_influx_pass = None/g" /tesla-apiscraper/config.py
RUN sed -i "s/a_influxuser = 'tesla'/a_influx_user = None/g" /tesla-apiscraper/config.py

# Define our startup script
RUN echo "#!/bin/bash" > /start.sh
RUN echo "sed -i \"s/<email>/\${TESLA_USERNAME}/g\" /tesla-apiscraper/config.py" >> /start.sh
RUN echo "sed -i \"s/<password>/\${TESLA_PASSWORD}/g\" /tesla-apiscraper/config.py" >> /start.sh
RUN echo "service influxdb start" >> /start.sh
RUN echo "influx -execute \"create database tesla\"" >>/start.sh
RUN echo "service grafana-server start" >> /start.sh
RUN echo "python3 /tesla-apiscraper/apiscraper.py" >> /start.sh
RUN chmod +x /start.sh

# Persist Influx Data
VOLUME ["/var/lib/influxdb"]

# Run it
EXPOSE 3000
EXPOSE 8023
CMD /start.sh
