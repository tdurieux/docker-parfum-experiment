FROM alpine:3.10

WORKDIR /app
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb-1.8.10-static_linux_amd64.tar.gz
RUN tar xvfz influxdb-1.8.10-static_linux_amd64.tar.gz && rm influxdb-1.8.10-static_linux_amd64.tar.gz
RUN  ls
RUN apk add --no-cache gcc py3-psutil

RUN pip3 install --no-cache-dir flask influxdb
COPY templates ./templates
COPY main.py .
COPY start.sh .
RUN chmod +x start.sh

ENV flag "we{test}"

CMD ./start.sh