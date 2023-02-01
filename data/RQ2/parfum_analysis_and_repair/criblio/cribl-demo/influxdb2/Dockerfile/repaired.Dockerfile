FROM quay.io/influxdb/influxdb:v2.0.1
RUN apt update && apt install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;
COPY dbrp.sh /dbrp.sh
