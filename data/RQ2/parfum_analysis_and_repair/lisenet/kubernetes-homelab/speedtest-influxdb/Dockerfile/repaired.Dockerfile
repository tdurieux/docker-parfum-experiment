FROM python:3-alpine

RUN pip3 install --no-cache-dir speedtest-cli influxdb

COPY python/speedtest-to-influxdb.py /usr/local/bin/speedtest-to-influxdb.py

ENTRYPOINT ["/usr/local/bin/speedtest-to-influxdb.py"]
